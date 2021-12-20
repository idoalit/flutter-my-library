// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bibliography/helpers/StatefulWrapper.dart';
import 'package:bibliography/helpers/dbhelper.dart';
import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/models/server.dart';
import 'package:bibliography/ui/Activation.dart';
import 'package:bibliography/ui/FormServer.dart';
import 'package:bibliography/ui/Help.dart';
import 'package:bibliography/ui/Search.dart';
import 'package:bibliography/ui/Setting.dart';
import 'package:bibliography/ui/Splash.dart';
import 'package:bibliography/ui/entryform.dart';
import 'package:bibliography/ui/home.dart';
import 'package:bibliography/ui/Server.dart';
import 'package:bibliography/view_model/server_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view_model/router.dart';

Future<void> main() async {

  // initialize file download
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false);

  runApp(
      // Provide the model to all widgets within the app. We're using
      // ChangeNotifierProvider because that's a simple way to rebuild
      // widgets when a model changes. We could also just use
      // Provider, but then we would have to listen to Counter ourselves.
      //
      // Read Provider's docs to learn about all the available providers.
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ServerViewModel()),
      ChangeNotifierProvider(create: (context) => PageRouter())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan Yarsi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  _StateMyHomePage _myHomePageState;

  @override
  State<StatefulWidget> createState() {
    _myHomePageState = _StateMyHomePage();
    return _myHomePageState;
  }

  getState() => _myHomePageState;
}

class _StateMyHomePage extends State<MyHomePage> {

  final PageController _pageController = PageController();
  Color _currentColor = Colors.lightGreen;

  @override
  Widget build(BuildContext context) {

    Server pageServer = Server();
    Home pageHome = Home();

    return StatefulWrapper(onInit: () async {

      final prefs = await SharedPreferences.getInstance();
      int activation = prefs.getInt('activated') ?? 0;

      // print(activation);

      // jika belum melakukan aktivasi akan diarahkan untuk melakukan aktivasi terlebih dahulu
      // if (activation < 1) {
      if(false) {

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SplashScreen();
        }));

      }

    }, child: Scaffold(
      appBar: AppBar(
        title: Consumer<PageRouter>(
          builder: (context, router, child) {

            var pageTitle = 'My Library';

            switch (router.currentPage) {
              case PageRouter.SERVER_PAGE: {
                pageTitle = 'Server';
              }
              break;
              case PageRouter.SETTING_PAGE: {
                pageTitle = 'Settings';
              }
              break;
              case PageRouter.SEARCH_PAGE: {
                pageTitle = 'Search';
              }
              break;
            }

            return Text(
              pageTitle,
              style: TextStyle(color: Colors.black54),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          pageHome,
          pageServer,
          Search(),
          Setting()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {

              var router = Provider.of<PageRouter>(context);
              if(router.currentPage == PageRouter.SERVER_PAGE) return FormServer(null);

              return EntryForm(null);
            }),
          );

          if (result is ServerModel) pageServer.getState().refresh();
          if (result is Biblio && result.title != '') {
            if (pageHome.getState() != null) {
              pageHome.getState().saveBiblio(result);
            } else {
              await DbHelper().insert(result);
              // back to home
              _pageController.jumpToPage(PageRouter.HOME_PAGE);
              context.read<PageRouter>().goto(PageRouter.HOME_PAGE);
            }
          }

        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
        backgroundColor: this._currentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.local_library_rounded),
              color: Colors.lightGreen,
              onPressed: () {
                setState(() {
                  _currentColor = Colors.lightGreen;
                });
                _pageController.jumpToPage(PageRouter.HOME_PAGE);
                context.read<PageRouter>().goto(PageRouter.HOME_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.location_city_rounded),
              color: Colors.redAccent,
              onPressed: () {
                setState(() {
                  _currentColor = Colors.redAccent;
                });
                _pageController.jumpToPage(PageRouter.SERVER_PAGE);
                context.read<PageRouter>().goto(PageRouter.SERVER_PAGE);
              },
            ),
            Text(''),
            IconButton(
              icon: Icon(Icons.search_rounded),
              color: Colors.deepOrange,
              onPressed: () {
                setState(() {
                  _currentColor = Colors.lightGreen;
                });
                _pageController.jumpToPage(PageRouter.SEARCH_PAGE);
                context.read<PageRouter>().goto(PageRouter.SEARCH_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              color: Colors.indigoAccent,
              onPressed: () {
                setState(() {
                  _currentColor = Colors.lightGreen;
                });
                // _pageController.jumpToPage(PageRouter.SETTING_PAGE);
                // context.read<PageRouter>().goto(PageRouter.SETTING_PAGE);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
              },
            ),
          ],
        ),
      ),
    ));
  }
}

