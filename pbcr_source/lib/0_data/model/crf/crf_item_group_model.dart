import 'crf_item_model.dart';

class CRFItemGroup{
  final int itemGroupSeq;
  final String itemGroupUid;
  final String itemGroupOid;
  final String itemGroupName;
  final String itemGroupType;
  final String? comments;

  CRFItemGroup({
    required this.itemGroupSeq,
    required this.itemGroupUid,
    required this.itemGroupOid,
    required this.itemGroupName,
    required this.itemGroupType,
    this.comments
  });
}

class CRFItemGroupModel {
  final CRFItemGroup group;
  final List<CRFItemModel> itemList;

  CRFItemGroupModel({
    required this.group,
    required this.itemList,
  });
}