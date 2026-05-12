import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_id.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_instance.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_payload.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_rule.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';
import 'package:icreat_dct/0_data/model/type/request_result.dart';
import 'package:icreat_dct/0_data/dto/local_notification/local_notification_instance_create_req.dart';
import 'package:icreat_dct/0_data/dto/local_notification/local_notification_rule_create_req.dart';
import 'package:icreat_dct/2_repository/local_notification_repository.dart';
import 'package:icreat_dct/6_util/logger.dart';
import 'package:icreat_dct/8_extension/date_time_ext.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

enum LocalNotificationServiceResultCode {
  success,
  maxNotiRuleCountExceeded,
}

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  final LocalNotificationRepository _notiRepo;

  LocalNotificationService(
    this._plugin,
    this._notiRepo,
  ) {
    _initializeTimeZone();
  }

  Future<void> initialize() async {
    _initializeTimeZone();
    await _initPlugin();
    await scheduleRemainingNotifications();
  }

  Future<void> _initPlugin() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(initSettings);
  }

  void _initializeTimeZone() {
    tz.initializeTimeZones();
  }

  /// 앱 실행 시 예약된 알림 규칙이 있으면 그 알림 규칙에 따라 알림을 생성한다
  Future<void> scheduleRemainingNotifications() async {
    final rules = await _notiRepo.getRules();

    for (final rule in rules) {
      await scheduleNotification(rule);
    }
  }

  /// 1개의 규칙당 최대로 존재할 수 있는 알림 갯수
  static const _maxNotificationCount = 6;

  /// 최대 알림 규칙 갯수
  /// iOS의 알림 개수 제한은 64개이다
  /// 그런데 같은 알림 그룹당 최대 5개씩 미리 생성해두어야 하므로 12개가 최대이다
  static const maxNotiRuleCount = 12;

  /// 알림 규칙 생성
  Future<RequestResult<LocalNotificationServiceResultCode>> scheduleNotiRule({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay timeOfDay,
    required List<int> weekdays,
  }) =>
      handleRequest(() async {
        final rules = await _notiRepo.getRules();

        if (rules.length >= maxNotiRuleCount) {
          return LocalNotificationServiceResultCode.maxNotiRuleCountExceeded;
        }

        final rule =
            await _notiRepo.createRule(LocalNotificationRuleCreateReq(
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate,
          timeOfDay: timeOfDay,
          weekdays: weekdays,
        ));

        await scheduleNotification(rule);

        return LocalNotificationServiceResultCode.success;
      });

  /// 알림 규칙 및 연관된 알림 인스턴스 모두 삭제
  Future<void> cancelRule(int ruleId) async {
    final List<LocalNotificationInstance> instances =
        await _notiRepo.getInstancesByRuleId(ruleId);

    for (final instance in instances) {
      try {
        await _plugin.cancel(instance.id.notiId);
      } catch (e) {
        Logger.error('알림 취소 실패: $e');
      }
    }

    await _notiRepo.deleteRule(ruleId);
    await _notiRepo.deleteInstanceByRuleId(ruleId);
  }

  Future<List<PendingNotificationRequest>> _getPendingNotifications() async =>
      await _plugin.pendingNotificationRequests();

  /// 알림 바로 생성, 이건 거의 테스트용
  Future<void> showNotification(LocalNotificationPayload payload) async {
    await _plugin.show(
      payload.id,
      payload.title,
      payload.body,
      _notificationDetails,
    );
  }

  /// 언제 실행됨?:
  /// 1. 알림 규칙 생성 시
  /// 2. 앱 켜질 때
  /// 알림 규칙에 따라 알림을 생성하고 DB에 인스턴스 저장
  /// 알림 규칙에 따라 알림을 생성할 때 어디까지 생성할지 조건은 다음과 같다.
  /// 1. endDate까지 생성한다.
  /// 2. endDate가 아니더라도 _maxNotificationCount 갯수를 초과하면 생성하지 않는다
  Future<void> scheduleNotification(LocalNotificationRule rule) async {
    final pendingNotifications = await _getPendingNotifications();
    final instances = await _notiRepo.getInstancesByRuleId(rule.id);

    await _deleteExpiredNotifications(pendingNotifications, instances);

    final pendingInstances = await _getPendingInstances(rule.id);

    int createCount = _maxNotificationCount - pendingInstances.length;

    // 시작 시간 결정
    DateTime startTime;
    if (instances.isEmpty) {
      // 첫 알림인 경우 스케줄에 지정된 startDate 또는 DateTime.now() 중 더 먼저 오는 시간을 선택
      startTime = rule.startDate.isAfter(DateTime.now())
          ? rule.startDate
          : DateTime.now();
    } else {
      // 기존 알림이 있는 경우 가장 최신 알림 시간 + 1일 부터 시작
      startTime = instances
          .reduce((a, b) => a.scheduledTime.isAfter(b.scheduledTime) ? a : b)
          .scheduledTime;
      startTime = startTime.add(const Duration(days: 1));
    }

    final nextScheduledTimes =
        _findNextScheduledTimes(rule, startTime, createCount);

    for (final nextScheduledTime in nextScheduledTimes) {
      final notificationId = LocalNotificationID(
        ruleId: rule.id,
        yyyyMMdd: nextScheduledTime.toYMD(),
      );

      await _plugin.zonedSchedule(
        notificationId.notiId,
        rule.title,
        rule.description,
        _dateTimeToTZDateTime(nextScheduledTime),
        _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exact,
      );

      await _notiRepo.createInstance(LocalNotificationInstanceCreateReq(
        id: notificationId,
        ruleId: rule.id,
        description: rule.description,
        scheduledTime: nextScheduledTime,
      ));
    }
  }

  List<DateTime> _findNextScheduledTimes(
    LocalNotificationRule rule,
    DateTime target,
    int count,
  ) {
    final nextScheduledTimes = <DateTime>[];
    // target 은 다음과 같이 초기화 될것임
    // 1. 알림 규칙 최초 생성이라 DateTime.now()
    // 2. 계속 늘리는 거라 현재까지 생성된 마지막 알림 시간

    int loopCount = 0;

    /// 알림규칙에 따라 생성 가능한 날짜인지 확인
    bool scheduledDow(DateTime date) {
      if (rule.weekdays.isEmpty) {
        return true;
      }

      if (rule.weekdays.contains(date.weekday)) {
        return true;
      }

      return false;
    }

    /// 알림은 현재 시간보다 이전이거나 같으면 생성 불가
    bool canSchedule(DateTime date) {
      final now = DateTime.now();

      if (date.isAtSameMomentAs(now)) {
        return false;
      }

      if (date.isBefore(now)) {
        return false;
      }

      return true;
    }

    DateTime startDate = target;

    while (true) {
      if (loopCount >= count) {
        break;
      }

      final nextScheduleTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        rule.timeOfDay.hour,
        rule.timeOfDay.minute,
      );

      // 현재 시간과 같으면 다음 시간으로 넘어간다
      if (!canSchedule(nextScheduleTime)) {
        startDate = startDate.add(const Duration(days: 1));
        continue;
      }

      if (scheduledDow(nextScheduleTime)) {
        nextScheduledTimes.add(nextScheduleTime);
        loopCount++;
      }
      startDate = startDate.add(const Duration(days: 1));
    }
    return nextScheduledTimes;
  }

  /// 현재 시스템에 예약된 알림 가져오기
  /// 가져올 때, DB와 싱크도 맞춰준다.
  Future<List<LocalNotificationInstance>> _getPendingInstances(
      int ruleId) async {
    final pendingNotifications = await _getPendingNotifications();
    final instances = await _notiRepo.getInstancesByRuleId(ruleId);

    await _deleteExpiredNotifications(pendingNotifications, instances);
    return await _notiRepo.getInstancesByRuleId(ruleId);
  }

  /// DB에 저장된 알림 인스턴스 중 현재 PendingNotificationRequest에 존재하지 않는 알림 인스턴스를 삭제한다.
  Future<void> _deleteExpiredNotifications(
    List<PendingNotificationRequest> pendingNotifications,
    List<LocalNotificationInstance> instances,
  ) async {
    final pendingNotificationIds =
        pendingNotifications.map((e) => e.id).toList();

    for (final instance in instances) {
      if (!pendingNotificationIds.contains(instance.id.notiId)) {
        await _notiRepo.deleteInstance(instance.id.notiId);
      }
    }
  }

  /// 알림 정보 기본 설정
  NotificationDetails get _notificationDetails {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'push_channel',
      'Push Notifications',
      channelDescription: 'Push notifications channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  /// DateTime에서 TZDateTime로 변환
  tz.TZDateTime _dateTimeToTZDateTime(DateTime dateTime) {
    final location = tz.getLocation('Asia/Seoul');
    return tz.TZDateTime.from(dateTime, location);
  }

  /// 알림 규칙 모두 가져오기
  Future<RequestResult<List<LocalNotificationRule>>> getRules() =>
      handleRequest(() async => await _notiRepo.getRules());

  /// 알림 인스턴스 모두 가져오기
  Future<RequestResult<List<LocalNotificationInstance>>> getInstances() =>
      handleRequest(() async => await _notiRepo.getAllInstances());

  /// 알림 규칙 모두 삭제
  Future<void> deleteAllRules() async {
    await _notiRepo.deleteAllRules();
  }

  /// 알림 인스턴스 모두 삭제
  Future<void> deleteAllInstances() async {
    await _notiRepo.deleteAllInstances();
  }

  // Server notification methods
  /// 서버 알림 저장
  Future<RequestResult<void>> saveServerNotifications(
      List<NotificationModel> notifications) =>
      handleRequest(() async {
        await _notiRepo.saveServerNotifications(notifications);
      });

  /// 서버 알림 목록 가져오기
  Future<RequestResult<List<NotificationModel>>> getServerNotifications() =>
      handleRequest(() async {
        return await _notiRepo.getServerNotifications();
      });

  /// 서버 알림 읽음 처리
  Future<RequestResult<void>> markServerNotificationAsRead(int id) =>
      handleRequest(() async {
        await _notiRepo.markServerNotificationAsRead(id);
      });

  /// 서버 알림 삭제
  Future<RequestResult<void>> deleteServerNotification(int id) =>
      handleRequest(() async {
        await _notiRepo.deleteServerNotification(id);
      });
}
