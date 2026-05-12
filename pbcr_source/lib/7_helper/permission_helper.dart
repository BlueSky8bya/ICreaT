import 'package:icreat_dct/6_util/device_info.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  Future<bool> requestHealth() async {
    if (DeviceInfo.isIOS) {
      return true;
    } else {
      var status = await Permission.activityRecognition.request();
      return status.isGranted;
    }
  }
}
