import 'package:flutter/cupertino.dart';

class StoriesModel extends ChangeNotifier {
  late final PageController pageController;
  final Duration _duration = const Duration(milliseconds: 250);
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

  void nextPage() {
    pageController.nextPage(
      duration: _duration,
      curve: Curves.linear,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: _duration,
      curve: Curves.linear,
    );
  }
}
