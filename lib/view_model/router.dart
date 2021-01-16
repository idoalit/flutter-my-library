import 'package:flutter/cupertino.dart';

class PageRouter with ChangeNotifier {
  static const HOME_PAGE = 0;
  static const FAVORITE_PAGE = 1;
  static const SETTING_PAGE = 2;
  static const SEARCH_PAGE = 3;

  int currentPage = 0;

  void goto(int page) {
    currentPage = page;
    notifyListeners();
  }
}