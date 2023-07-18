import 'package:flutter/cupertino.dart';

class StoriesModel extends ChangeNotifier {
  late final PageController pageController;
  double _index;

  double get index => _index;

  StoriesModel(this._index) {
    pageController = PageController(initialPage: _index.toInt());
    pageController.addListener(() {
      if (pageController.page != null) {
        setIndex(pageController.page!);
      }
    });
  }

  void setIndex(double val) {
    _index = val;
    notifyListeners();
  }
}
