# 조건부 문진 규칙 시스템

이 시스템은 A문항의 값이 특정 조건을 만족할 때 B문항에 영향을 주는 조건부 로직을 구현합니다.

## 🎯 주요 기능

### 1. 기본 조건부 규칙
- **조건부 필수**: 특정 조건을 만족하면 해당 문항이 필수가 됩니다
- **조건부 활성화**: 특정 조건을 만족하면 해당 문항이 활성화됩니다
- **조건부 표시**: 특정 조건을 만족하면 해당 문항이 표시됩니다
- **값 자동 클리어**: 특정 조건을 만족하면 해당 문항의 값이 자동으로 지워집니다

### 2. 확장된 검증 기능
- **Integer 타입**: 범위 검증 (min~max, 크기 비교)
- **Float 타입**: 범위 검증 + 자릿수 검증 (정수부, 소수부)
- **String 타입**: 길이 검증 (최소, 최대, 범위)

## 📋 지원하는 연산자

### 기본 연산자
- `equals`: 정확히 일치
- `not_equals`: 일치하지 않음
- `in`: 배열에 포함된 값 중 하나
- `not_in`: 배열에 포함되지 않은 값
- `is_empty`: 값이 비어있음
- `is_not_empty`: 값이 있음

### 숫자 비교 연산자 (Integer, Float)
- `between`: 범위 내 (min ≤ value ≤ max)
- `greater_than`: 초과 (value > target)
- `less_than`: 미만 (value < target)
- `greater_than_or_equal`: 이상 (value ≥ target)
- `less_than_or_equal`: 이하 (value ≤ target)

### 문자열 길이 연산자 (String)
- `min_length`: 최소 길이
- `max_length`: 최대 길이
- `length_between`: 길이 범위 (min ≤ length ≤ max)

### Float 자릿수 연산자
- `integer_digits`: 정수부 자릿수
- `decimal_digits`: 소수부 자릿수
- `digit_format`: 정수부 + 소수부 자릿수 동시 검증

## 🏗️ 구조

### 핵심 클래스
- `ConditionalRuleModel`: 개별 조건부 규칙 모델
- `ConditionalRuleManager`: 조건부 규칙 관리자
- `ConditionalRuleData`: 하드코딩된 규칙 데이터 저장소

### 파일 구조
```
lib/3_view/form/
├── 1_data/
│   ├── conditional_rule_model.dart    # 모델 클래스
│   └── conditional_rule_data.dart     # 하드코딩 데이터
├── 6_util/
│   └── conditional_rule_manager.dart  # 규칙 관리자
└── form_view_model.dart              # 통합된 뷰모델

data/
├── conditional_rules_extended_example.json  # 확장된 예시
└── CONDITIONAL_RULES_README.md              # 이 파일

test/
└── conditional_rule_test.dart               # 테스트 코드
```

## 🚀 사용법

### 1. 새로운 폼에 조건부 규칙 추가

`lib/3_view/form/1_data/conditional_rule_data.dart`에서:

```dart
static const Map<int, Map<String, dynamic>> _formRules = {
  4105: {  // 새로운 폼 번호
    "form_seq": 4105,
    "conditional_rules": [
      {
        "rule_id": "age_validation",
        "rule_type": "required",
        "trigger_item_uid": "age_input_uid",
        "trigger_condition": {
          "operator": "between",
          "value": {"min": 18, "max": 65}
        },
        "target_item_uid": "consent_uid",
        "target_action": true
      }
    ]
  }
};
```

### 2. UI에서 조건부 상태 확인

```dart
// FormViewModel 사용
bool isRequired = viewModel.isItemConditionalRequired(formSelectKey);
bool isEnabled = viewModel.isItemConditionalEnabled(formSelectKey);
bool isVisible = viewModel.isItemConditionalVisible(formSelectKey);

// UI 적용 예시
TextField(
  enabled: isEnabled,
  decoration: InputDecoration(
    labelText: isRequired ? '필수 항목 *' : '선택 항목',
  ),
)
```

### 3. 직접 관리자 사용

```dart
final manager = ConditionalRuleManager();
final rules = ConditionalRuleData.getConditionalRules(4105);

manager.initializeRules(rules);
manager.evaluateRules('age_input_uid', '25');

bool isConsentRequired = manager.isConditionalRequired('consent_uid');
```

## 📝 JSON 규칙 예시

### 기본 조건부 필수
```json
{
  "rule_id": "q1_to_q2_required",
  "rule_type": "required",
  "trigger_item_uid": "q1_item_uid",
  "trigger_condition": {
    "operator": "equals",
    "value": "1"
  },
  "target_item_uid": "q2_item_uid",
  "target_action": true
}
```

### 범위 검증
```json
{
  "rule_id": "age_range_validation",
  "rule_type": "required",
  "trigger_item_uid": "age_input_uid",
  "trigger_condition": {
    "operator": "between",
    "value": {"min": 18, "max": 65}
  },
  "target_item_uid": "adult_consent_uid",
  "target_action": true
}
```

### 길이 검증
```json
{
  "rule_id": "comment_length_validation",
  "rule_type": "enabled",
  "trigger_item_uid": "comment_uid",
  "trigger_condition": {
    "operator": "length_between",
    "value": {"min": 10, "max": 500}
  },
  "target_item_uid": "comment_confirm_uid",
  "target_action": true
}
```

### Float 자릿수 검증
```json
{
  "rule_id": "weight_format_validation",
  "rule_type": "enabled",
  "trigger_item_uid": "weight_uid",
  "trigger_condition": {
    "operator": "digit_format",
    "value": {"integer_digits": 3, "decimal_digits": 1}
  },
  "target_item_uid": "weight_confirm_uid",
  "target_action": true
}
```

### 값 자동 클리어
```json
{
  "rule_id": "q1_no_clear_q2",
  "rule_type": "clear_value",
  "trigger_item_uid": "q1_uid",
  "trigger_condition": {
    "operator": "equals",
    "value": "2"
  },
  "target_item_uid": "q2_uid",
  "target_action": true
}
```

## 🔧 데이터 타입별 사용 예시

### Integer 타입
```dart
// 나이 18-65세 범위 검증
ConditionalRuleData.createRangeValidationTemplate(
  ruleId: 'age_validation',
  ruleType: 'required',
  triggerItemUid: 'age_uid',
  minValue: 18,
  maxValue: 65,
  targetItemUid: 'consent_uid',
);

// 키 180cm 초과 검증
ConditionalRuleData.createComparisonTemplate(
  ruleId: 'height_validation',
  ruleType: 'enabled',
  triggerItemUid: 'height_uid',
  operator: 'greater_than',
  compareValue: '180',
  targetItemUid: 'tall_survey_uid',
);
```

### Float 타입
```dart
// 체중 000.0 형식 검증
ConditionalRuleData.createDigitFormatTemplate(
  ruleId: 'weight_format',
  ruleType: 'enabled',
  triggerItemUid: 'weight_uid',
  integerDigits: 3,
  decimalDigits: 1,
  targetItemUid: 'weight_confirm_uid',
);
```

### String 타입
```dart
// 댓글 10-500자 길이 검증
ConditionalRuleData.createLengthValidationTemplate(
  ruleId: 'comment_length',
  ruleType: 'required',
  triggerItemUid: 'comment_uid',
  minLength: 10,
  maxLength: 500,
  targetItemUid: 'comment_confirm_uid',
);

// 비상연락처 최소 5자 검증
ConditionalRuleData.createSingleLengthTemplate(
  ruleId: 'contact_min_length',
  ruleType: 'required',
  triggerItemUid: 'contact_uid',
  operator: 'min_length',
  length: 5,
  targetItemUid: 'contact_confirm_uid',
);

// 값 자동 클리어 검증
ConditionalRuleData.createClearValueTemplate(
  ruleId: 'clear_on_no',
  triggerItemUid: 'q1_uid',
  triggerOperator: 'equals',
  triggerValue: '2', // "아니오"
  targetItemUid: 'q2_uid',
);
```

## 🧪 테스트

```bash
# 모든 테스트 실행
flutter test test/conditional_rule_test.dart

# 특정 테스트 그룹 실행
flutter test test/conditional_rule_test.dart --name "ConditionalRuleModel Tests"
```

## 🔮 향후 확장

### 서버 API 연동
현재는 하드코딩된 규칙을 사용하지만, 향후 서버 API로 교체 가능:

```dart
// 현재: 하드코딩
final rules = ConditionalRuleData.getConditionalRules(formSeq);

// 향후: API 호출
final rules = await ApiService.fetchConditionalRules(formSeq);
```

### 복합 조건
현재는 단일 조건만 지원하지만, 향후 AND/OR 조건 추가 가능:

```json
{
  "trigger_condition": {
    "operator": "and",
    "conditions": [
      {"operator": "greater_than", "value": "18"},
      {"operator": "less_than", "value": "65"}
    ]
  }
}
```

### 동적 규칙 생성
런타임에 규칙 추가/수정/삭제 기능 추가 가능

## 🎯 실제 사용 사례

### AES 폼 예시 (form_seq: 4102)

```dart
// 사용자 시나리오
1. Q1 "건강상의 불편함이 있습니까?" 
   - "예" 선택 → Q2 필수
   - "아니오" 선택 → Q2, Q3 값 자동 클리어

2. Q2 "불편함 종류"
   - "기타" 선택 → Q3 활성화 및 필수
   - 다른 옵션 선택 → Q3 숨김

3. Q3 "기타 설명"
   - Q2에서 "기타" 선택 시에만 입력 가능
```

### 값 클리어 동작 방식

```dart
// Q1에서 "아니오" 선택 시
{
  "rule_type": "clear_value",
  "trigger_condition": {"operator": "equals", "value": "2"}, // "아니오"
  "target_action": true // 조건 만족 시 클리어 실행
}

// 실행 결과:
// 1. 타겟 문항의 값이 빈 문자열("")로 설정
// 2. TextEditingController.clear() 호출
// 3. 사용자에게 즉시 반영
```

## 💡 주의사항

1. **성능**: 많은 규칙이 있을 때 성능에 주의
2. **순환 참조**: A→B→A 형태의 순환 참조 방지
3. **데이터 타입**: 문자열로 전달되는 값의 타입 변환 처리
4. **에러 처리**: 잘못된 규칙 정의 시 에러 처리
5. **값 클리어**: clear_value 규칙은 기존 사용자 입력을 삭제하므로 신중하게 사용

## 🤝 기여

새로운 연산자나 기능 추가 시:
1. `ConditionalRuleOperator` enum에 추가
2. `ConditionalRuleTrigger.evaluate()` 메서드에 로직 추가
3. 테스트 코드 작성
4. 문서 업데이트 