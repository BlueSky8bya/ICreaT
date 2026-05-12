# iCReaT DCT - 분산형 임상연구 ePRO 앱

![Flutter](https://img.shields.io/badge/Flutter-3.6.0-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.6.0-blue.svg)
![License](https://img.shields.io/badge/License-Private-red.svg)

## 1. 프로젝트 개요

**iCReaT DCT**는 공익적 분산형 임상연구 기반 구축과제의 일환으로 개발된 연구대상자 전용 ePRO(Electronic Patient Reported Outcome) 모바일 애플리케이션입니다.

연구대상자가 스크리닝 이후 임상연구 시작 단계(D0)부터 사용하는 앱으로, 연구자가 iCReaT 웹 서비스에서 할당한 일정과 문진을 받아와서 연구대상자에게 표시하고, 응답 데이터를 eSource에 업로드하는 주요 기능을 제공합니다.

### 1.1. 주요 기능

- **ePRO 문진 시스템**: 다양한 형식(객관식, 주관식 등)의 문진 수행 및 제출
- **iCReaT 연동**: 연구자 웹 서비스에서 일정과 문진 데이터 동기화
- **eSource 업로드**: 연구대상자 응답 데이터를 안전하게 전송
- **알림 시스템**: FCM 푸시 알림 및 로컬 알림 지원
- **블루투스 장비 연동**: 혈압, 체온 등 생체 데이터 자동 측정
- **건강 데이터**: 수면, 걸음 기능 (현재 비활성화 상태)

### 1.2. 패키지 정보

- **패키지명**: `icreat_dct`
- **앱 ID**: `kr.caresquare.pbcr`
- **버전**: 1.0.15+15 // version = 1.0.15, version code = 15


## 2. 프로젝트 아키텍처

본 프로젝트는 레이어드 아키텍처 패턴을 적용하여 체계적으로 구성되어 있습니다.

### 2.1. 폴더 구조

```
lib/
├── 0_data/                    # 데이터 레이어
│   ├── model/                 # 도메인 모델
│   ├── dto/                   # 데이터 전송 객체
│   └── entity/                # 데이터베이스 엔티티
├── 1_service/                 # 서비스 레이어 (비즈니스 로직)
│   ├── fcm/                   # FCM 알림 서비스
│   ├── ble/                   # 블루투스 장비 연동
│   └── common/                # 공통 서비스
├── 2_repository/              # 데이터 레포지토리 레이어
│   ├── impl/                  # 레포지토리 구현체
│   └── interceptor/           # HTTP 인터셉터
├── 3_view/                    # 프레젠테이션 레이어 (UI)
│   ├── components/            # 재사용 가능한 UI 컴포넌트
│   ├── data/                  # View용 데이터 모델
│   ├── splash/                # 스플래시 화면
│   ├── login/                 # 로그인 화면
│   ├── navbar/                # 메인 네비게이션 바 및 하위 화면
│   └── form/                  # ePRO 문진 화면
├── 4_router/                  # 라우팅 및 네비게이션
│   └── routes/                # 라우트 정의
├── 5_channel/                 # 플랫폼 채널 (네이티브 연동)
├── 6_util/                    # 유틸리티 함수
├── 7_helper/                  # 헬퍼 클래스
├── 8_extension/               # Dart 확장 메서드
├── 9_constants/               # 상수 정의
├── core/                      # 핵심 공통 기능
├── init/                      # 앱 초기화 관련
└── theme/                     # 테마 및 스타일링
```

### 2.2. 주요 폴더별 역할

#### 0_data - 데이터 레이어

- **model**: 앱 전반에서 사용되는 도메인 모델 정의
- **dto**: API 통신용 데이터 전송 객체
- **entity**: 로컬 데이터베이스 엔티티

#### 1_service - 서비스 레이어

- **auth_service.dart**: 사용자 인증 관리
- **schedule_service.dart**: 일정 관리 및 동기화
- **crf_service.dart**: CRF(Case Report Form) 관리
- **esource_service.dart**: eSource 데이터 업로드
- **fcm/**: Firebase Cloud Messaging 알림 처리
- **ble/**: 블루투스 장비 연동 서비스
- **health_service.dart**: 건강 데이터 수집 (현재 비활성화)
- **local_notification_service.dart**: 로컬 알림 관리

#### 2_repository - 데이터 레포지토리

- **icreat_repository.dart**: iCReaT 서버 API 통신
- **esource_repository.dart**: eSource 시스템 연동
- **auth_repository.dart**: 인증 관련 데이터 처리
- **pref_repository.dart**: 로컬 설정 저장소
- **dio_factory.dart**: HTTP 클라이언트 설정

#### 3_view - UI 레이어

- **components**: 재사용 가능한 공통 UI 컴포넌트
- **splash**: 앱 시작 화면
- **login**: 사용자 로그인 인터페이스
- **navbar**: 메인 네비게이션 및 하위 화면들
  - **schedule**: 연구 일정 관리
  - **measurement**: 생체 데이터 측정 (비활성화)
- **form**: ePRO 문진 화면 및 로직

#### 4_router - 라우팅

- **init_router.dart**: 라우터 초기화
- **common_navigator.dart**: 네비게이션 헬퍼
- **route_type.dart**: 라우트 타입 정의
- **router_manager.dart**: 라우터 관리

#### 5_channel - 플랫폼 채널

- **phr_channel.dart**: 개인건강기록(PHR) 네이티브 연동

#### 6_util - 유틸리티

- **logger.dart**: 로깅 시스템
- **device_info.dart**: 디바이스 정보
- **toast_util.dart**: 토스트 메시지
- **overlay_util.dart**: 오버레이 관리

#### 7_helper - 헬퍼 클래스

- **permission_helper.dart**: 권한 관리

#### 8_extension - 확장 메서드

- Dart 기본 타입들의 확장 메서드 정의

#### 9_constants - 상수

- 앱 전반에서 사용되는 상수값 정의

#### init - 초기화

- **initialize.dart**: 앱 전체 초기화 진입점
- **init_services.dart**: 서비스 레이어 초기화
- **init_repositories.dart**: 레포지토리 초기화
- **init_fcm.dart**: FCM 초기화
- **init_api.dart**: API 클라이언트 초기화
- **init_channel.dart**: 메소드 채널 초기화
- **init_sentry.dart**: 센트리 초기화
- **init_helpers.dart**: Service 등에서 사용하는 헬퍼 클래스 초기화


## 3. 주요 기능

### 3.1. ePRO 문진 시스템

- 연구자가 할당한 다양한 형식의 문진 수행
- 객관식, 주관식, 측정값 입력 지원
- 실시간 데이터 검증 및 조건부 로직 처리
- 완료된 문진의 eSource 업로드

### 3.2. iCReaT 시스템 연동

- 연구 일정 및 문진 데이터 동기화
- 연구대상자별 맞춤형 프로토콜 적용
- 방문 일정 관리 및 상태 업데이트

### 3.3. 알림 시스템

- **FCM**: 연구자로부터의 실시간 푸시 알림
- **로컬 알림**: 사용자 설정 기반 리마인더

### 3.4. 블루투스 장비 연동

- 혈압계, 체온계 등 의료 장비 자동 연결
- 측정값 자동 수집 및 문진 폼 자동 채우기
- 수기 입력 오류 최소화


## 4. 기술 스택

### 4.1. 프론트엔드

- **UI**: Flutter/Dart
- **상태관리**: GetX
- **라우팅**: go_router
- **로컬 저장소**: sqflite, shared_preferences, flutter_secure_storage

### 4.2. 백엔드 연동

- **HTTP 클라이언트**: dio
- **API 서버**: iCReaT 시스템
- **데이터 업로드**: eSource 플랫폼

### 4.3. 알림 & 통신

- **푸시 알림**: Firebase Cloud Messaging
- **로컬 알림**: flutter_local_notifications
- **블루투스**: flutter_blue_plus

### 4.4. 데이터 & 보안

- **JSON 직렬화**: json_annotation
- **암호화**: crypto
- **에러 추적**: Sentry


## 5. 개발 환경 설정

### 5.1. 필수 요구사항

- Flutter SDK 3.27.4
- Dart SDK 3.6.2 (flutter 번들 이용 권장)
- iOS 개발 시 Xcode 14+
- Android Gradle Plugin 8.5.1

### 5.2. 설정
- 각각의 자세한 내용은 인터넷을 참고할 것

#### 5.2.1. 안드로이드 앱 서명

- 디버그용 앱 서명(keystore)
  - 파일 이름: debug.keystore
  - 파일 위치: android/debug.keystore
  - 이름과 위치를 바꾸고 싶으면 build.gradle 수정 필요
- 릴리즈용 앱 서명(keystore)
  - 파일 형식: jks
  - 매우 중요한 파일이니 잘 관리할 것 (절대 노출되면 안됨)
- JKS 파일은 디버그용과 릴리즈용을 나누어 설정

#### 5.2.2. 안드로이드 local.properties
- 위치: android/local.properties
- sdk.dir 및 flutter.sdk 경로는 알아서 수정
- flutter.buildMode 빌드시 자동 업데이트 됨
- flutter.versionName 및 flutter.versionCode는 빌드시 pubspec.yaml 내용으로 자동 업데이트 됨
  
```toml
sdk.dir=<안드로이드 SDK 경로>
flutter.sdk=<Flutter SDK 경로>
flutter.buildMode=debug
flutter.versionName=1.0.14
flutter.versionCode=14

storeFile=<릴리즈용 jks 파일 경로>
storePassword=<릴리즈용 jks 파일 패스워드>
keyAlias=<릴리즈용 jks 별칭>
keyPassword=<릴리즈용 jks 비밀키>
testKeyAlias=<디버그용 앱 서명 별칭>
```
    
#### 5.2.3. 안드로이드 구글 서비스
- 위치: android/app/google-services.json
- 필요한 내용들을 설정할 것
```json
{
  "project_info": {
    "project_number": "",
    "project_id": "",
    "storage_bucket": ""
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "",
        "android_client_info": {
          "package_name": ""
        }
      },
      "oauth_client": [],
      "api_key": [
        {
          "current_key": ""
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

#### 5.2.4. 안드로이드 프로가드
- 위치: android/app/proguard-rules.pro
- 딱히 설정할 내용이 없으면 빈 파일이어도 상관없음

#### 5.2.5. iOS 구글 서비스
- 위치: ios/Runner/GoogleService-Info.plist
- 필요한 내용들을 설정할 것 (Xcode에서 설정해도 됨)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string></string>
	<key>GCM_SENDER_ID</key>
	<string></string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string></string>
	<key>PROJECT_ID</key>
	<string></string>
	<key>STORAGE_BUCKET</key>
	<string></string>
	<key>IS_ADS_ENABLED</key>
	<false></false>
	<key>IS_ANALYTICS_ENABLED</key>
	<false></false>
	<key>IS_APPINVITE_ENABLED</key>
	<true></true>
	<key>IS_GCM_ENABLED</key>
	<true></true>
	<key>IS_SIGNIN_ENABLED</key>
	<true></true>
	<key>GOOGLE_APP_ID</key>
	<string></string>
</dict>
</plist>
```

#### 5.2.6. sentry 설정
- 위치: lib/init/init_sentry.dart
- options.dsn 위치에 등록된 접속주소 추가
- 필요없거나 다른 서비스를 사용한다면 관련 의존성과 설정을 제거할 것
```dart
Future<void> initSentry(
    DeviceInfo deviceInfo, PrefRepository prefHelper) async {
  await Sentry.init((options) {
    options.dsn = ''; // 여기에 추가
    options.environment = BuildConfig.buildVariant;
  });
  ...
}
```

#### 5.2.7. 서버 접근 주소 및 목업 활성화 여부
- 위치: lib/build_config.dart
- 필요에 따라 수정할 것
```dart
class BuildConfig {
	...
	static const enableMocking = false; // to enable dio mocking when debug mode
	...
	static final List<String> _ApiAddr = [
		'https://icreatdct.btsd.io/invoke', // release
		'http://192.168.68.59:8080/iCReaT_DCT/invoke', // test
		'http://192.168.68.59:8080/iCReaT_DCT/invoke', // debug
	];

	static String get apiBaseUrl => _ApiAddr[_idx];

	static final List<String> _esourceApiAddr = [
		'https://icreatdct.btsd.io/invoke', // release
		'http://192.168.68.59:8080/iCReaT_DCT/invoke', // test
		'http://192.168.68.59:8080/iCReaT_DCT/invoke', // debug
	];
}
```

### 5.3. 설치 및 실행

```bash
# 캐시 삭제
flutter clean

# 의존성 설치
flutter pub get

# 코드 생성 (JSON 직렬화)
flutter packages pub run build_runner build

# 앱 실행
flutter run
```

### 5.4. 환경별 빌드

```bash
# 개발 환경
flutter run dev

# 프로덕션 환경
flutter run prod --release
```

```bash
# iOS
flutter build ios --release

# 안드로이드 App Bundle
flutter build appbundle --release

# 또는 안드로이드 APK
flutter build apk --release
```

- Google Play는 Android App Bundle(AAB) 형식을 권장

## 6. 추가 디렉토리

- **assets/images/**: 앱에서 사용하는 이미지 리소스
- **assets/svgs/**: SVG 벡터 이미지
- **assets/files/**: 기타 파일 리소스
- **mock/**: DIO 목업 선언
