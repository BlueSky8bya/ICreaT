import 'package:icreat_dct/0_data/model/crf/crf_form_info_model.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_form_info_res.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_validation_editcheck.dart';
import 'package:icreat_dct/2_repository/icreat_repository.dart';

class CRFService {
  final IcreatRepository _repo;

  CRFService(
    this._repo,
  );

  Future<RequestResult<CFRFormInfoModel>> fetchCRF({
    required String formSeq,
    required String formVersionSeq,
    required String formDataSeq,
  }) =>
      handleRequest(() async {
        final resp = await _repo.fetchCRF(
          formSeq: formSeq,
          formVersionSeq: formVersionSeq,
          formDataSeq: formDataSeq,
        );
        return resp.toModel();
      });


  Future<RequestResult<ValidationEditCheckList>> fetchCRFValidation({
    required String formSeq,
    required String formVersionSeq,
  }) => handleRequest(() async {
    final resp = await _repo.fetchCrfValidation(
      formSeq: formSeq,
      formVersionSeq: formVersionSeq
    );

    return resp;
  });
}
