import '/core/index.dart';

class HomeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static final HomeProvider _instance = HomeProvider._internal();

  HomeProvider._internal();

  factory HomeProvider() {
    return _instance;
  }

  void listeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  var curPageIdx = 0;

  void updateCurPage(int index) {
    curPageIdx = index;
    listeners();
  }
}
