import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:icreat_dct/0_data/model/esource/esource_submission_status.dart';

class EsourceDatabaseHelper {
  static final EsourceDatabaseHelper _instance = EsourceDatabaseHelper._internal();
  static Database? _database;

  factory EsourceDatabaseHelper() => _instance;

  EsourceDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'esource_mapping.db');
    return await openDatabase(
      path,
      version: 2, // 버전 업그레이드
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE esource_mapping(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        form_seq INTEGER NOT NULL,
        study_event_seq INTEGER NOT NULL,
        uuid TEXT NOT NULL,
        visit_occurrence_id TEXT NOT NULL,
        form_name TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        status TEXT NOT NULL,
        last_checked INTEGER,
        error_message TEXT
      )
    ''');

    // 인덱스 추가
    await db.execute('CREATE INDEX idx_form_seq ON esource_mapping(form_seq)');
    await db.execute(
        'CREATE INDEX idx_study_event_form ON esource_mapping(study_event_seq, form_seq)');
    await db.execute('CREATE INDEX idx_uuid ON esource_mapping(uuid)');
    await db.execute(
        'CREATE INDEX idx_visit_form ON esource_mapping(visit_occurrence_id, form_name)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // study_event_seq 컬럼 추가
      await db.execute(
          'ALTER TABLE esource_mapping ADD COLUMN study_event_seq INTEGER NOT NULL DEFAULT 0');

      // 새로운 인덱스 추가
      await db.execute(
          'CREATE INDEX idx_study_event_form ON esource_mapping(study_event_seq, form_seq)');
    }
  }

  // 데이터 매핑 저장
  Future<int> insertMapping(EsourceSubmissionStatus mapping) async {
    final db = await database;
    return await db.insert('esource_mapping', mapping.toMap());
  }

  // studyEventSeq + formSeq 조합으로 매핑 조회 (올바른 방법)
  Future<EsourceSubmissionStatus?> getMappingByFormSeq(
    int studyEventSeq,
    int formSeq,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('esource_mapping',
      where: 'study_event_seq = ? AND form_seq = ?',
      whereArgs: [studyEventSeq, formSeq],
      orderBy: 'created_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }
    return EsourceSubmissionStatus.fromMap(maps.first);
  }

  // UUID로 매핑 조회
  Future<EsourceSubmissionStatus?> getMappingByUuid(String uuid) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('esource_mapping',
      where: 'uuid = ?',
      whereArgs: [uuid],
      orderBy: 'created_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return EsourceSubmissionStatus.fromMap(maps.first);
  }

  // ID로 상태 업데이트 (더 정확한 업데이트)
  Future<int> updateStatusById(int? id, String status, {String? errorMessage}) async {
    if (id == null) {
      return 0;
    }

    final db = await database;
    final now = DateTime.now();

    return await db.update('esource_mapping',
      {
        'status': status,
        'last_checked': now.millisecondsSinceEpoch,
        if (errorMessage != null) 'error_message': errorMessage,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 매핑 삭제
  Future<int> deleteMapping(int formSeq) async {
    final db = await database;
    return await db.delete(
      'esource_mapping',
      where: 'form_seq = ?',
      whereArgs: [formSeq],
    );
  }

  // 데이터베이스 닫기
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
