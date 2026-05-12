class EproFormInfoModel {
  final String userName;
  final int menuAuthLevel;
  final String userOrganizationName;
  final List<ItemGroupModel> itemGroupList;
  final String resultValue;
  final String userId;

  EproFormInfoModel({
    required this.userName,
    required this.menuAuthLevel,
    required this.userOrganizationName,
    required this.itemGroupList,
    required this.resultValue,
    required this.userId,
  });
}

class ItemGroupModel {
  final int orderNumber;
  final int itemGroupSeq;
  final String itemGroupUid;
  final String itemGroupOid;
  final String itemGroupName;
  final String itemGroupType;
  final String repeating;
  final String comments;
  final String itemGroupHtml;
  final String extClassName;
  final String useYn;
  final String insertDate;
  final String insertId;
  final String insertIp;
  final String updateDate;
  final String updateId;
  final String updateIp;
  final List<ItemModel> itemList;

  ItemGroupModel({
    required this.orderNumber,
    required this.itemGroupSeq,
    required this.itemGroupUid,
    required this.itemGroupOid,
    required this.itemGroupName,
    required this.itemGroupType,
    required this.repeating,
    required this.comments,
    required this.itemGroupHtml,
    required this.extClassName,
    required this.useYn,
    required this.insertDate,
    required this.insertId,
    required this.insertIp,
    required this.updateDate,
    required this.updateId,
    required this.updateIp,
    required this.itemList,
  });
}

class ItemModel {
  final int itemSeq;
  final String itemUid;
  final String itemOid;
  final String itemName;
  final String itemNameLabel;
  final String dataType;
  final String inputType;
  final String? codeList;

  ItemModel({
    required this.itemSeq,
    required this.itemUid,
    required this.itemOid,
    required this.itemName,
    required this.itemNameLabel,
    required this.dataType,
    required this.inputType,
    this.codeList,
  });
}
