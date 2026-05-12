// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'esource_upload_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ESourceUploadRes _$ESourceUploadResFromJson(Map<String, dynamic> json) =>
    ESourceUploadRes(
      success: json['success'] as String,
      status: json['status'] as String?,
      errMessage: json['errMessage'] as String?,
    );

Map<String, dynamic> _$ESourceUploadResToJson(ESourceUploadRes instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'errMessage': instance.errMessage,
    };
