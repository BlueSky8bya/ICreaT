package com.gachon_HCI_Lab.user_mobile.common

/**
 * 디바이스 정보를 저장하는 싱글톤 클래스
 * _dID : 디바이스 고유 ID 워치와 블루투스 소켓 연결시 가져온다.
 * _studyId / _subjectId : iCReaT 과제/대상자 식별자.
 *   - Phase 0(엔드포인트 검증): 아래 TEST_* 하드코딩 값을 사용한다.
 *   - Phase 1(정식): QR 스캔 결과(stdy_no/subject_id)로 주입한다.
 * _battery : 디바이스 배터리 잔량 워치와 블루투스 소켓 연결시 가져온다.
 */
class DeviceInfo private constructor() {
    companion object{
        // [Phase 0] 베데스다 제공 테스트 대상자 (API_sensor_upload_guide.md §8, No.1)
        const val TEST_STUDY_ID = "C250005"
        const val TEST_SUBJECT_ID = "121-001"

        var _dID : String = ""
        var _studyId : String = TEST_STUDY_ID
        var _subjectId : String = TEST_SUBJECT_ID
        // [2026-06-29] 이유: 기본 "100"은 placeholder라 워치 미연결 시 실제와 무관한 100이 서버로 전송됨. | 목적: 빈값 sentinel로 두고, 실측 수신 전엔 업로드 보류(hasBattery 게이트). 가짜 배터리 전송 차단.
        var _battery : String = ""

        /**
         * 디바이스 정보를 초기화하는 함수
         * deviceID : 디바이스 고유 ID
         * studyId / subjectId : 과제/대상자 식별자 (미지정 시 테스트 하드코딩 값)
         * battery : 디바이스 배터리 잔량
         */
        fun init(
            deviceID: String = "",
            studyId: String = TEST_STUDY_ID,
            subjectId: String = TEST_SUBJECT_ID,
            battery: String = ""
        ) {
            _dID = deviceID
            _studyId = studyId
            _subjectId = subjectId
            _battery = battery
        }

        /**
         * 정보 setter 함수 (변수가 모두 public으로 선언되어있기 떄문에 사용하지 않아도 됨)
         */
        fun setDeviceID(deviceID: String) {
            _dID = deviceID
        }

        fun setStudyId(studyId: String) {
            _studyId = studyId
        }

        fun setSubjectId(subjectId: String) {
            _subjectId = subjectId
        }

        fun setBattery(battery: String) {
            _battery = battery
        }

        // [2026-06-29] 워치로부터 실측 배터리를 한 번이라도 받았는지. false면 업로드 보류(가짜 100 방지).
        fun hasBattery(): Boolean = _battery.isNotEmpty()
    }
}