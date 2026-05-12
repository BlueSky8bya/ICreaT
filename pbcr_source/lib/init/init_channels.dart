import 'package:get/get.dart';
import 'package:icreat_dct/5_channel/phr_channel.dart';

void initChannels() {
  Get.lazyPut(() => PhrChannel());
}
