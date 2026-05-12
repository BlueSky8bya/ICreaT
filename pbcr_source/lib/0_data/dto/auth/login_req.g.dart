// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginReq _$LoginReqFromJson(Map<String, dynamic> json) => LoginReq(
      projectId: json['project_id'] as String,
      subjectId: json['subject_id'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginReqToJson(LoginReq instance) => <String, dynamic>{
      'project_id': instance.projectId,
      'subject_id': instance.subjectId,
      'password': instance.password,
    };
