import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:icreat_dct/6_util/listener.dart';

class FgBgService {
  final ValueListener<FGBGType> _fgbgListener = ValueListener();

  int addListener(Function(FGBGType) callback) {
    return _fgbgListener.add(callback);
  }

  void removeListener(int? id) {
    _fgbgListener.remove(id);
  }

  void onChangeFGBG(FGBGType type) {
    _fgbgListener.notify(type);
    if (type == FGBGType.foreground) {
      // SystemOverlayHelper.setLastStatusBarAndNavBar();
    }
  }
}
