import 'package:json_annotation/json_annotation.dart';
import 'package:icreat_dct/0_data/model/study/crf_list_model.dart';

part 'crf_list_res.g.dart';

@JsonSerializable()
class CrfListRes {
  @JsonKey(name: 'usernm')
  final String userName;
  @JsonKey(name: '_MENU_AUTH_LVL')
  final int menuAuthLevel;
  @JsonKey(name: 'userorgannm')
  final String userOrganName;
  @JsonKey(name: 'userid')
  final String userId;
  @JsonKey(name: 'isExistSubject')
  final int isExistSubject;
  @JsonKey(name: 'crfList')
  final List<CrfItemRes> crfList;

  CrfListRes({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.userId,
    required this.isExistSubject,
    required this.crfList,
  });

  factory CrfListRes.fromJson(Map<String, dynamic> json) =>
      _$CrfListResFromJson(json);

  Map<String, dynamic> toJson() => _$CrfListResToJson(this);
}

@JsonSerializable()
class CrfItemRes {
  @JsonKey(name: 'METADATA_NAME')
  final String metadataName;
  @JsonKey(name: 'EFFECTIVE_DT')
  final String effectiveDate;
  @JsonKey(name: 'FORM_SEQ')
  final int formSeq;
  @JsonKey(name: 'FORM_NAME')
  final String formName;
  @JsonKey(name: 'REPEATING')
  final String repeating;
  @JsonKey(name: 'ORDER_NUMBER')
  final int orderNumber;
  @JsonKey(name: 'USE_YN')
  final String useYn;
  @JsonKey(name: 'FORM_STATUS')
  final String formStatus;
  @JsonKey(name: 'IS_CLINICAL_DATA')
  final String isClinicalData;
  @JsonKey(name: 'FORM_VERSION_SEQ')
  final int formVersionSeq;
  @JsonKey(name: 'IS_REF_CNT')
  final int isRefCount;
  @JsonKey(name: 'IS_DATA_EXIST')
  final int isDataExist;
  @JsonKey(name: 'DCT_FORM_TYPE')
  final String dctFormType;

  CrfItemRes({
    required this.metadataName,
    required this.effectiveDate,
    required this.formSeq,
    required this.formName,
    required this.repeating,
    required this.orderNumber,
    required this.useYn,
    required this.formStatus,
    required this.isClinicalData,
    required this.formVersionSeq,
    required this.isRefCount,
    required this.isDataExist,
    required this.dctFormType,
  });

  factory CrfItemRes.fromJson(Map<String, dynamic> json) =>
      _$CrfItemResFromJson(json);

  Map<String, dynamic> toJson() => _$CrfItemResToJson(this);
}

extension CrfListResExt on CrfListRes {
  CrfListModel toModel() => CrfListModel(
        userName: userName,
        menuAuthLevel: menuAuthLevel,
        userOrganName: userOrganName,
        userId: userId,
        isExistSubject: isExistSubject,
        crfList: crfList.map((e) => e.toModel()).toList(),
      );
}

extension CrfItemResExt on CrfItemRes {
  CrfItemModel toModel() => CrfItemModel(
        metadataName: metadataName,
        effectiveDate: effectiveDate,
        formSeq: formSeq,
        formName: formName,
        repeating: repeating,
        orderNumber: orderNumber,
        useYn: useYn,
        formStatus: formStatus,
        isClinicalData: isClinicalData,
        formVersionSeq: formVersionSeq,
        isRefCount: isRefCount,
        isDataExist: isDataExist,
        dctFormType: dctFormType,
      );
}
