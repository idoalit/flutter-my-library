// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/counter.dart';
import 'view_model/router.dart';

void main() {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<PageRouter>(
          builder: (context, router, child) {

            var pageTitle = 'My Library';

            switch (router.currentPage) {
              case PageRouter.FAVORITE_PAGE: {
                pageTitle = 'Favorite';
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Ini index halaman ke:'),
            // Consumer looks for an ancestor Provider widget
            // and retrieves its model (Counter, in this case).
            // Then it uses that model to build widgets, and will trigger
            // rebuilds if the model is updated.
            Consumer<PageRouter>(
              builder: (context, counter, child) => Text(
                '${counter.currentPage}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
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
              icon: Icon(Icons.home),
              color: Colors.lightGreen,
              onPressed: () {
                var router = context.read<PageRouter>();
                router.goto(PageRouter.HOME_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.redAccent,
              onPressed: () {
                var router = context.read<PageRouter>();
                router.goto(PageRouter.FAVORITE_PAGE);
              },
            ),
            Text(''),
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.indigoAccent,
              onPressed: () {
                var router = context.read<PageRouter>();
                router.goto(PageRouter.SETTING_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.deepOrange,
              onPressed: () {
                var router = context.read<PageRouter>();
                router.goto(PageRouter.SEARCH_PAGE);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
