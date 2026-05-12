class EproItemListModel {
  final String userName;
  final List<ItemModel> itemList;
  final int menuAuthLevel;
  final String userOrganizationName;
  final String resultValue;
  final String userId;

  EproItemListModel({
    required this.userName,
    required this.itemList,
    required this.menuAuthLevel,
    required this.userOrganizationName,
    required this.resultValue,
    required this.userId,
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
