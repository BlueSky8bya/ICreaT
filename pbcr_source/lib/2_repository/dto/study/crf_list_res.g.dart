// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crf_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrfListRes _$CrfListResFromJson(Map<String, dynamic> json) => CrfListRes(
      userName: json['usernm'] as String,
      menuAuthLevel: (json['_MENU_AUTH_LVL'] as num).toInt(),
      userOrganName: json['userorgannm'] as String,
      userId: json['userid'] as String,
      isExistSubject: (json['isExistSubject'] as num).toInt(),
      crfList: (json['crfList'] as List<dynamic>)
          .map((e) => CrfItemRes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CrfListResToJson(CrfListRes instance) =>
    <String, dynamic>{
      'usernm': instance.userName,
      '_MENU_AUTH_LVL': instance.menuAuthLevel,
      'userorgannm': instance.userOrganName,
      'userid': instance.userId,
      'isExistSubject': instance.isExistSubject,
      'crfList': instance.crfList,
    };

CrfItemRes _$CrfItemResFromJson(Map<String, dynamic> json) => CrfItemRes(
      metadataName: json['METADATA_NAME'] as String,
      effectiveDate: json['EFFECTIVE_DT'] as String,
      formSeq: (json['FORM_SEQ'] as num).toInt(),
      formName: json['FORM_NAME'] as String,
      repeating: json['REPEATING'] as String,
      orderNumber: (json['ORDER_NUMBER'] as num).toInt(),
      useYn: json['USE_YN'] as String,
      formStatus: json['FORM_STATUS'] as String,
      isClinicalData: json['IS_CLINICAL_DATA'] as String,
      formVersionSeq: (json['FORM_VERSION_SEQ'] as num).toInt(),
      isRefCount: (json['IS_REF_CNT'] as num).toInt(),
      isDataExist: (json['IS_DATA_EXIST'] as num).toInt(),
      dctFormType: json['DCT_FORM_TYPE'] as String,
    );

Map<String, dynamic> _$CrfItemResToJson(CrfItemRes instance) =>
    <String, dynamic>{
      'METADATA_NAME': instance.metadataName,
      'EFFECTIVE_DT': instance.effectiveDate,
      'FORM_SEQ': instance.formSeq,
      'FORM_NAME': instance.formName,
      'REPEATING': instance.repeating,
      'ORDER_NUMBER': instance.orderNumber,
      'USE_YN': instance.useYn,
      'FORM_STATUS': instance.formStatus,
      'IS_CLINICAL_DATA': instance.isClinicalData,
      'FORM_VERSION_SEQ': instance.formVersionSeq,
      'IS_REF_CNT': instance.isRefCount,
      'IS_DATA_EXIST': instance.isDataExist,
      'DCT_FORM_TYPE': instance.dctFormType,
    };
