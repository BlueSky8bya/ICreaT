class CrfListModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganName;
  final String userId;
  final int isExistSubject;
  final List<CrfItemModel> crfList;

  CrfListModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganName,
    required this.userId,
    required this.isExistSubject,
    required this.crfList,
  });
}

class CrfItemModel {
  final String metadataName;
  final String effectiveDate;
  final int formSeq;
  final String formName;
  final String repeating;
  final int orderNumber;
  final String useYn;
  final String formStatus;
  final String isClinicalData;
  final int formVersionSeq;
  final int isRefCount;
  final int isDataExist;
  final String dctFormType;

  CrfItemModel({
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
}
