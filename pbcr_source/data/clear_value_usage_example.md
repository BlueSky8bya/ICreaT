# 값 자동 클리어 기능 사용 예시

## 🎯 문제 상황

Q1에서 "아니오"를 선택했을 때, Q2번 문항이 무조건 빈 값이어야 하는 상황

## ❌ 잘못된 접근

```dart
// target_action: false로는 비활성화만 됨 (값 클리어 안됨)
{
  "rule_type": "enabled",
  "target_action": false // 단순히 비활성화만
}
```

## ✅ 올바른 해결책

### 1. 새로운 rule_type 사용

```json
{
  "rule_id": "q1_no_clear_q2", 
  "rule_type": "clear_value",
  "trigger_item_uid": "q1_item_uid",
  "trigger_condition": {
    "operator": "equals",
    "value": "2"
  },
  "target_item_uid": "q2_item_uid",
  "target_action": true
}
```

### 2. 실제 동작 과정

1. **Q1에서 "아니오"(값: 2) 선택**
2. **조건부 규칙 평가**
   - `trigger_condition.evaluate("2")` → `true`
   - `target_action: true` → 클리어 실행
3. **자동 클리어 수행**
   - `setAnswer(q2_key, '')` 실행
   - `textController.clear()` 실행
   - 사용자 화면에서 즉시 빈 값으로 표시

### 3. 템플릿 사용

```dart
ConditionalRuleData.createClearValueTemplate(
  ruleId: 'clear_on_no',
  triggerItemUid: 'q1_uid',
  triggerOperator: 'equals', 
  triggerValue: '2', // "아니오"
  targetItemUid: 'q2_uid',
)
```

## 🔧 실제 구현 (ConditionalRuleData)

```dart
4102: {
  "conditional_rules": [
    // 기존 규칙들...
    {
      "rule_id": "aes_q1_no_clear_q2",
      "rule_type": "clear_value",
      "trigger_item_uid": "e82804af0ba741f8b966f2390c2ce466", // Q1
      "trigger_condition": {
        "operator": "equals", 
        "value": "2" // "아니오"
      },
      "target_item_uid": "d651bc5cafd0432bae06ac4bade6fc9c", // Q2
      "target_action": true
    },
    {
      "rule_id": "aes_q1_no_clear_q3", 
      "rule_type": "clear_value",
      "trigger_item_uid": "e82804af0ba741f8b966f2390c2ce466", // Q1
      "trigger_condition": {
        "operator": "equals",
        "value": "2" // "아니오" 
      },
      "target_item_uid": "62bc019dc5e4470f9627539abdbb5d74", // Q3
      "target_action": true
    }
  ]
}
```

## 📱 UI 사용법

```dart
// 값이 클리어되어야 하는지 확인
bool shouldClear = viewModel.shouldClearItemValue(formSelectKey);

// 실제로는 자동으로 처리되므로 UI에서 특별한 처리 불필요
// handleAnswer()에서 자동으로 클리어 로직 실행
```

## 🧪 테스트

```dart
test('Q1 아니오 선택 시 Q2, Q3 자동 클리어', () {
  final manager = ConditionalRuleManager();
  final rules = ConditionalRuleData.getConditionalRules(4102);
  
  var clearedItems = <String>[];
  manager.setClearValueCallback((itemUid) {
    clearedItems.add(itemUid);
  });
  
  manager.initializeRules(rules);
  
  // Q1에서 "아니오" 선택
  manager.evaluateRules('e82804af0ba741f8b966f2390c2ce466', '2');
  
  // Q2, Q3가 클리어 목록에 포함되었는지 확인
  expect(clearedItems, contains('d651bc5cafd0432bae06ac4bade6fc9c')); // Q2
  expect(clearedItems, contains('62bc019dc5e4470f9627539abdbb5d74')); // Q3
});
```

## 💡 핵심 포인트

1. **`target_action: false`는 비활성화만, 값 클리어는 안함**
2. **`rule_type: "clear_value"`가 실제 값 클리어 기능**
3. **자동으로 TextEditingController도 클리어됨**
4. **콜백을 통해 실시간으로 값 클리어 실행**

## 🚨 주의사항

- 값 클리어는 사용자 입력을 삭제하므로 신중하게 사용
- 클리어된 값은 복구되지 않음
- 필요시 값 클리어 전에 사용자 확인 프로세스 추가 고려 