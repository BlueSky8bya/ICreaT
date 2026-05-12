import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_rule.dart';
import 'package:icreat_dct/1_service/local_notification_service.dart';
import 'package:icreat_dct/3_view/components/base_view_model.dart';
import 'package:icreat_dct/4_router/route_type.dart';

class LocalNotificationListViewModel extends BaseViewModel {
  final LocalNotificationService _localNotificationService;

  LocalNotificationListViewModel(this._localNotificationService);

  // state
  final RxList<LocalNotificationRule> _localNotifications =
      <LocalNotificationRule>[].obs;
  List<LocalNotificationRule> get localNotifications =>
      _localNotifications.toList().sorted((a, b) => a.timeOfDay.compareTo(b.timeOfDay));

  final RxBool _isDeleteMode = false.obs;
  bool get isDeleteMode => _isDeleteMode.value;

  final RxSet<int> _selectedIds = <int>{}.obs;
  Set<int> get selectedIds => _selectedIds.toSet();

  @override
  void onInit() {
    super.onInit();
    _localNotificationService.initialize();
    _fetchLocalNotificationRules();
  }

  Future<void> _fetchLocalNotificationRules() async {
    final result = await _localNotificationService.getRules();

    result
      ..onFailure((e) {})
      ..onSuccess((value) {
        _localNotifications.value = value;
      });
  }

  Future<void> _cancelRule(int id) async {
    await _localNotificationService.cancelRule(id);
  }

  Future<void> _cancelRules(Set<int> ids) async {
    await Future.wait(ids.map((id) => _cancelRule(id)));

    await _fetchLocalNotificationRules();
  }

  // actions

  void navigateToAdd(BuildContext context) {
    context.pushNamed(RouteType.localNotificationAdd.name).then((value) {
      _fetchLocalNotificationRules();
    });
  }

  void toggleDeleteMode() {
    _isDeleteMode.value = !_isDeleteMode.value;
    if (!_isDeleteMode.value) {
      _selectedIds.clear();
    }
  }

  void toggleDeleteCheck(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  }

  void deleteNotification(BuildContext context) async {
    isOnProgress.value = true;
    _cancelRules(selectedIds).then((value) {
      isOnProgress.value = false;
      if (context.mounted) {
        showToast(context, msg: '알림 삭제 완료');
      }
    });
  }
}
