import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:icreat_dct/1_service/secure_storage_service.dart';
import 'package:icreat_dct/1_service/project_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';

class ConsentViewModel extends BaseViewModel {

  final ProjectService _projectService;
  final Rx<bool> _isLoading = true.obs;
  late final PDFDocument? _doc;
  final Rx<String> _icfDocument = ''.obs;

  ConsentViewModel(this._projectService);

  String get icfDocument => _icfDocument.value;
  PDFDocument? get document => _doc;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() async {
    super.onInit();

    _icfDocument.value = _projectService.icfDocument;

    if(_icfDocument.value.isNotEmpty) {
      loadingIcfDocument(_icfDocument.value);
    } else {
      _doc = null;
      _isLoading.value = false;
    }

    completeInit();
  }

  Future<void> loadingIcfDocument(String docUrl) async {
    _isLoading.value = true;

    var sessionId = (await SecureStorageService().getSessionToken()) ?? '';
    _doc = await PDFDocument.fromURL(docUrl, headers: {
      'Dct-Session-Id': sessionId,
    });

    _isLoading.value = false;
  }
}