import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_instance.dart';
import 'package:icreat_dct/0_data/model/local_notification/local_notification_rule.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_model.dart';
import 'package:icreat_dct/0_data/model/notififcation/notification_type.dart';
import 'package:icreat_dct/0_data/dto/local_notification/local_notification_instance_create_req.dart';
import 'package:icreat_dct/0_data/dto/local_notification/local_notification_rule_create_req.dart';
import 'package:icreat_dct/0_data/entity/local_notification/local_notification_instance_entity.dart';
import 'package:icreat_dct/0_data/entity/local_notification/local_notification_rule_entity.dart';
import 'package:icreat_dct/2_repository/local_notification_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalNotificationRepositoryImpl implements LocalNotificationRepository {
  static Database? _database;
  static const _databaseName = "notification.db";
  static const _databaseVersion = 2; // Increment version for new table

  static const _tableRules = 'notification_rules';
  static const _tableInstances = 'notification_instances';
  static const _tableServerNotifications = 'server_notifications';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableRules (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL,
        weekdays TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableInstances (
        id INTEGER PRIMARY KEY,
        rule_id INTEGER NOT NULL,
        scheduled_time TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (rule_id) REFERENCES $_tableRules (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableServerNotifications (
        id INTEGER PRIMARY KEY,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        status TEXT NOT NULL,
        visit_seq TEXT,
        visit_name TEXT,
        visit_date TEXT,
        visits_applies TEXT,
        subjects_applies TEXT,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at_local TEXT NOT NULL,
        updated_at_local TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add server notifications table
      await db.execute('''
        CREATE TABLE $_tableServerNotifications (
          id INTEGER PRIMARY KEY,
          type TEXT NOT NULL,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          created_at TEXT NOT NULL,
          status TEXT NOT NULL,
          visit_seq TEXT,
          visit_name TEXT,
          visit_date TEXT,
          visits_applies TEXT,
          subjects_applies TEXT,
          is_read INTEGER NOT NULL DEFAULT 0,
          created_at_local TEXT NOT NULL,
          updated_at_local TEXT NOT NULL
        )
      ''');
    }
  }

  @override
  Future<LocalNotificationRule> createRule(
      LocalNotificationRuleCreateReq request) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final ruleEntity = LocalNotificationRuleEntity(
      id: 0, // DB에서 자동 생성
      title: request.title,
      description: request.description,
      startDate: request.startDate,
      endDate: request.endDate,
      hour: request.timeOfDay.hour,
      minute: request.timeOfDay.minute,
      weekdays: request.weekdays,
    );

    final id = await db.insert(
      _tableRules,
      {
        ...ruleEntity.toJson(),
        'created_at': now,
        'updated_at': now,
      }..remove('id'),
    );

    return LocalNotificationRule(
      id: id,
      title: ruleEntity.title,
      description: ruleEntity.description,
      startDate: ruleEntity.startDate,
      endDate: ruleEntity.endDate,
      timeOfDay: TimeOfDay(
        hour: ruleEntity.hour,
        minute: ruleEntity.minute,
      ),
      weekdays: ruleEntity.weekdays,
    );
  }

  @override
  Future<void> deleteAllRules() async {
    final db = await database;
    await db.delete(_tableRules);
  }

  @override
  Future<void> deleteRule(int id) async {
    final db = await database;
    await db.delete(
      _tableRules,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<LocalNotificationRule>> getRules() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableRules);

    return maps.map((map) {
      final entity = LocalNotificationRuleEntity.fromJson(map);
      return LocalNotificationRule(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        startDate: entity.startDate,
        endDate: entity.endDate,
        timeOfDay: TimeOfDay(
          hour: entity.hour,
          minute: entity.minute,
        ),
        weekdays: entity.weekdays,
      );
    }).toList();
  }

  @override
  Future<void> createInstance(
      LocalNotificationInstanceCreateReq request) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final instanceEntity = LocalNotificationInstanceEntity(
      id: request.id,
      ruleId: request.ruleId,
      scheduledTime: request.scheduledTime,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await db.insert(
      _tableInstances,
      {
        ...instanceEntity.toJson(),
        'created_at': now,
        'updated_at': now,
      },
    );
  }

  @override
  Future<void> deleteInstance(int id) async {
    final db = await database;
    await db.delete(
      _tableInstances,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteInstanceByRuleId(int ruleId) async {
    final db = await database;
    await db.delete(
      _tableInstances,
      where: 'rule_id = ?',
      whereArgs: [ruleId],
    );
  }

  @override
  Future<void> deleteAllInstances() async {
    final db = await database;
    await db.delete(_tableInstances);
  }

  @override
  Future<List<LocalNotificationInstance>> getInstancesByRuleId(
      int ruleId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableInstances,
      where: 'rule_id = ?',
      whereArgs: [ruleId],
    );

    return maps.map((map) {
      final entity = LocalNotificationInstanceEntity.fromJson(map);
      return LocalNotificationInstance(
        id: entity.id,
        ruleId: entity.ruleId,
        scheduledTime: entity.scheduledTime,
      );
    }).toList();
  }

  @override
  Future<List<LocalNotificationInstance>> getAllInstances() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableInstances);

    return maps.map((map) {
      final entity = LocalNotificationInstanceEntity.fromJson(map);
      return LocalNotificationInstance(
        id: entity.id,
        ruleId: entity.ruleId,
        scheduledTime: entity.scheduledTime,
      );
    }).toList();
  }

  // Server notification methods
  @override
  Future<void> saveServerNotification(NotificationModel notification) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert(
      _tableServerNotifications,
      {
        'id': notification.id,
        'type': notification.type.toServerString(),
        'title': notification.title,
        'content': notification.content,
        'created_at': notification.createdAt.toIso8601String(),
        'status': notification.status,
        'visit_seq': notification.visitSeq,
        'visit_name': notification.visitName,
        'visit_date': notification.visitDate?.toIso8601String(),
        'visits_applies': notification.visitsApplies,
        'subjects_applies': notification.subjectsApplies,
        'is_read': notification.isRead ? 1 : 0,
        'created_at_local': now,
        'updated_at_local': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveServerNotifications(
      List<NotificationModel> notifications) async {
    final db = await database;
    final batch = db.batch();
    final now = DateTime.now().toIso8601String();

    for (final notification in notifications) {
      batch.insert(
        _tableServerNotifications,
        {
          'id': notification.id,
          'type': notification.type.toServerString(),
          'title': notification.title,
          'content': notification.content,
          'created_at': notification.createdAt.toIso8601String(),
          'status': notification.status,
          'visit_seq': notification.visitSeq,
          'visit_name': notification.visitName,
          'visit_date': notification.visitDate?.toIso8601String(),
          'visits_applies': notification.visitsApplies,
          'subjects_applies': notification.subjectsApplies,
          'is_read': notification.isRead ? 1 : 0,
          'created_at_local': now,
          'updated_at_local': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  @override
  Future<List<NotificationModel>> getServerNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableServerNotifications,
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => _mapToNotificationModel(map)).toList();
  }

  @override
  Future<NotificationModel?> getServerNotification(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableServerNotifications,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToNotificationModel(maps.first);
  }

  @override
  Future<void> updateServerNotification(NotificationModel notification) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      _tableServerNotifications,
      {
        'type': notification.type.toServerString(),
        'title': notification.title,
        'content': notification.content,
        'created_at': notification.createdAt.toIso8601String(),
        'status': notification.status,
        'visit_seq': notification.visitSeq,
        'visit_name': notification.visitName,
        'visit_date': notification.visitDate?.toIso8601String(),
        'visits_applies': notification.visitsApplies,
        'subjects_applies': notification.subjectsApplies,
        'is_read': notification.isRead ? 1 : 0,
        'updated_at_local': now,
      },
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  @override
  Future<void> deleteServerNotification(int id) async {
    final db = await database;
    await db.delete(
      _tableServerNotifications,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllServerNotifications() async {
    final db = await database;
    await db.delete(_tableServerNotifications);
  }

  @override
  Future<void> markServerNotificationAsRead(int id) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      _tableServerNotifications,
      {
        'is_read': 1,
        'updated_at_local': now,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getUnreadServerNotificationCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableServerNotifications WHERE is_read = 0',
    );
    return result.first['count'] as int;
  }

  NotificationModel _mapToNotificationModel(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      type: NotificationType.fromString(map['type'] as String),
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      status: map['status'] as String,
      visitSeq: map['visit_seq'] as String?,
      visitName: map['visit_name'] as String?,
      visitDate: map['visit_date'] != null
          ? DateTime.parse(map['visit_date'] as String)
          : null,
      visitsApplies: map['visits_applies'] as String?,
      subjectsApplies: map['subjects_applies'] as String?,
      isRead: (map['is_read'] as int) == 1,
    );
  }
}
