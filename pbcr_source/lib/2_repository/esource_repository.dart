import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:icreat_dct/0_data/dto/esource/esource_upload_res.dart';
import 'package:icreat_dct/0_data/dto/esource/get_trans_proc_stat_res.dart';

class EsourceRepository {
  final Dio _dio;

  EsourceRepository(this._dio);

  Future<ESourceUploadRes> postCrfData(Map<String, dynamic> request) async {
    final response = await _dio.post(
      '/CrfDataTransfer/recieveData',
      data: request,
    );

    if (response.data is String) {
      return ESourceUploadRes.fromJson(jsonDecode(response.data));
    }

    return ESourceUploadRes.fromJson(response.data);
  }

  Future<GetTransProcStatRes?> getTransProcStat(
    String serviceUUID,
    String studyOid,
  ) async {
    final response = await _dio.post(
      '/CrfDataTransfer/getTransProcStat',
      data: {
        'serviceUUID': serviceUUID,
        'study_oid': studyOid,
      },
    );

    if (response.statusCode == 200) {
      if (response.data is String) {
        return GetTransProcStatRes.fromJson(jsonDecode(response.data));
      }
      return GetTransProcStatRes.fromJson(response.data);
    }

    return null;
  }
}
