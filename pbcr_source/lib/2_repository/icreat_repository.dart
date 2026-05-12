import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';

import 'package:icreat_dct/0_data/dto/common/icreat_res.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_form_info_res.dart';
import 'package:icreat_dct/0_data/dto/project/project_info_res.dart';
import 'package:icreat_dct/0_data/dto/crf/crf_validation_editcheck.dart';
import 'package:icreat_dct/1_service/secure_storage_service.dart';

import '../6_util/logger.dart';
import 'dto/epro/epro_schedule_res.dart';

class IcreatRepository {
  final Dio _dio;

  IcreatRepository(this._dio); // DioFactory.getDioClientForApi();

  Future<Response<dynamic>> dioPostWithSession({required String path, Map<String,dynamic>? data}) async {
    final sessionCookie = await SecureStorageService().getSessionToken();
    return await _dio.post(path,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Dct-Session-Id': sessionCookie,
        },
      ),
    );
  }

  Future<Response<dynamic>> dioGetWithSession({required String path, Map<String,dynamic>? query, Map<String,dynamic>? data}) async {
    final sessionCookie = await SecureStorageService().getSessionToken();
    return await _dio.get(path,
      queryParameters: query,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Dct-Session-Id': sessionCookie,
        },
      ),
    );
  }

  Future<EproScheduleRes> getScheduleList({
    required String studyNo,  // 과제 번호
    required String pid,      // 환자 번호
    required String orgCd,    // 기관 코드
    required String from,     // 시작 날짜 yyyyMMdd
    required String to,       // 종료 날짜 yyyyMMdd
  }) async {
    final response = await dioPostWithSession(
      path: '/api/selSchedule',
      data: {
        'stdy_no': studyNo,
        'pid': pid,
        'org_cd': orgCd,
        'from': from,
        'to': to,
      }
    );

    if (response.data is String) {
      return EproScheduleRes.fromJson(jsonDecode(response.data));
    }
    return EproScheduleRes.fromJson(response.data);
  }

  Future<ICreatRes> updateVisitDate({
    required String pid,                // 과제 번호
    required String studyeventDataSeq,  // Visit 일정
    required String visitDate,          // yyyy-MM-dd 형식의 날짜
  }) async {
    final response = await dioPostWithSession(
      path: '/api/updVisitDate',
      data: {
        "pid": pid,
        "studyevent_data_seq": studyeventDataSeq,
        "visit_yn": "Y",
        "visit_date": visitDate,
      },
    );

    if (response.data is String) {
      return ICreatRes.fromJson(jsonDecode(response.data));
    }
    return ICreatRes.fromJson(response.data);
  }

  Future<ProjectInfoRes> getProjectInfo(String sessionId) async {
    final response = await _dio.get('/api/study',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Dct-Session-Id': sessionId,
        },
      ),
    );

    if (response.data is String) {
      return ProjectInfoRes.fromJson(jsonDecode(response.data));
    }
    return ProjectInfoRes.fromJson(response.data);
  }

  // ----- CRF -----

  Future<CRFFormInfoRes> fetchCRF({
    required String formSeq,
    required String formVersionSeq,
    required String formDataSeq,
  }) async {
    final response = await dioPostWithSession(
      path: '/api/selItemGroupList',
      data: {
        "form_seq": formSeq,
        "form_version_seq": formVersionSeq,
        "form_data_seq": formDataSeq,
      }
    );
    if (response.data is String) {
      return CRFFormInfoRes.fromJson(jsonDecode(response.data));
    }

    Logger.debug("response.data=${response.data}");

    return CRFFormInfoRes.fromJson(response.data);
  }

  Future<ValidationEditCheckList> fetchCrfValidation({
    required String formSeq,
    required String formVersionSeq,
  }) async {
    final response = await dioGetWithSession(
      path: '/api/selCrfValidation',
      query: {
        "form_seq": formSeq,
        "form_version_seq": formVersionSeq,
      },
    );

    JSON respJSON;
    if (response.data is String) {
      respJSON = JSON.parse(response.data);
    } else if (response.data is Map || response.data is List){
      respJSON = JSON(response.data);
    } else {
      respJSON = JSON({"editCheckList": []});
    }
    return ValidationEditCheckList.fromJSON(formSeq, respJSON);
  }
}
