import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

class AppManualViewModel extends BaseViewModel {

  late final PDFDocument manual;

  @override
  void onInit() async {
    super.onInit();
    // BaseViewModel의 초기화 완료

    manual = await PDFDocument.fromAsset('assets/files/app_manual.pdf');

    completeInit();
  }
}
