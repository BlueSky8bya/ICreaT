package com.gachon_HCI_Lab.user_mobile.activity

import com.journeyapps.barcodescanner.CaptureActivity

/**
 * [2026-07-09] 이유: zxing 기본 CaptureActivity는 manifest상 sensorLandscape라 스캔 화면이 가로로 돌아감.
 * 목적: 세로(portrait) 고정 스캔 화면 — manifest에서 screenOrientation="portrait"로 등록해 사용.
 */
class PortraitCaptureActivity : CaptureActivity()
