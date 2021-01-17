// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/models/server.dart';
import 'package:bibliography/ui/FormServer.dart';
import 'package:bibliography/ui/Search.dart';
import 'package:bibliography/ui/Setting.dart';
import 'package:bibliography/ui/entryform.dart';
import 'package:bibliography/ui/home.dart';
import 'package:bibliography/ui/Server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/counter.dart';
import 'view_model/router.dart';

void main() {

  // initialize file download
  // WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(debug: true);

  runApp(
      // Provide the model to all widgets within the app. We're using
      // ChangeNotifierProvider because that's a simple way to rebuild
      // widgets when a model changes. We could also just use
      // Provider, but then we would have to listen to Counter ourselves.
      //
      // Read Provider's docs to learn about all the available providers.
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Counter()),
      ChangeNotifierProvider(create: (context) => PageRouter())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    Server pageServer = Server();
    Home pageHome = Home();

    return Scaffold(
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
              if(router.currentPage == PageRouter.SERVER_PAGE) return FormServer();
              
              return EntryForm(null);
            }),
          );

          if (result is ServerModel) pageServer.getState().refresh();
          if (result is Biblio && result.title != '') pageHome.getState().saveBiblio(result);

        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
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
                _pageController.jumpToPage(PageRouter.HOME_PAGE);
                context.read<PageRouter>().goto(PageRouter.HOME_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.location_city_rounded),
              color: Colors.redAccent,
              onPressed: () {
                _pageController.jumpToPage(PageRouter.SERVER_PAGE);
                context.read<PageRouter>().goto(PageRouter.SERVER_PAGE);
              },
            ),
            Text(''),
            IconButton(
              icon: Icon(Icons.search_rounded),
              color: Colors.deepOrange,
              onPressed: () {
                _pageController.jumpToPage(PageRouter.SEARCH_PAGE);
                context.read<PageRouter>().goto(PageRouter.SEARCH_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.settings_rounded),
              color: Colors.indigoAccent,
              onPressed: () {
                _pageController.jumpToPage(PageRouter.SETTING_PAGE);
                context.read<PageRouter>().goto(PageRouter.SETTING_PAGE);
              },
            ),
          ],
        ),
      ),
    );
  }
}

