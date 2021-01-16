// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bibliography/ui/entryform.dart';
import 'package:bibliography/ui/home.dart';
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

  PageController _pageController = PageController();

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
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Home(),
          SecondRoute()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EntryForm(null)),
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
                _pageController.jumpToPage(PageRouter.HOME_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.redAccent,
              onPressed: () {
                _pageController.jumpToPage(PageRouter.FAVORITE_PAGE);
              },
            ),
            Text(''),
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.indigoAccent,
              onPressed: () {
                _pageController.jumpToPage(PageRouter.HOME_PAGE);
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.deepOrange,
              onPressed: () {
                _pageController.jumpToPage(PageRouter.FAVORITE_PAGE);
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
