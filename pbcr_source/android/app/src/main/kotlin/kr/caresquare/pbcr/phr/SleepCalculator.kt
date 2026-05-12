package kr.caresquare.pbcr.phr

import kr.caresquare.pbcr.data.db.entity.Motion
import kr.caresquare.pbcr.data.db.entity.Screen
import kr.caresquare.pbcr.ext.toLocalDate
import kr.caresquare.pbcr.models.ScreenType
import kr.caresquare.pbcr.models.SleepTime
import java.time.LocalDate


// nextSleepCalcDate 부터 계산
class SleepCalculator {
    fun calcSleep(
        calcStartAt: Long,
        allScreenList: List<Screen>,
        allMotionList: List<Motion>
    ): Map<LocalDate, List<SleepTime>>? {
        val limitTime = calcStartAt * 1000L
        // SemiOn은 잠금화면이 켜진 시간이므로 제외
        var filteredScreenList =
            allScreenList.filter { it.type != ScreenType.SEMI_ON.value && it.recordTime > limitTime}
        // 수면 시간계산에는 화면 켜진 시간과 꺼진 시간이 둘 다 있어야한다.
        if (filteredScreenList.size < 2) return null

        val candidateSleepList = mutableListOf<SleepTime>()

        var previousScreenIsOn = filteredScreenList[0].isOn()
        var previousScreenRecordTime = filteredScreenList[0].recordTime
        filteredScreenList = filteredScreenList.drop(1)

        filteredScreenList.forEach { screen ->
            val isOn = screen.type == ScreenType.ON.value
            // 화면이 켜진 화면이고 이전 기록이 꺼진 상태면서 그 사이가 1시간 보다 길면 후보시간대로 등록
            // On -> Off 가 아니라 On이 연속, Off가 연속으로 올 수 있다.
            if (isOn && !previousScreenIsOn) {
                if ((screen.recordTime - previousScreenRecordTime) > ONE_HOUR_LONG) {
                    val startTime = (previousScreenRecordTime / 1000)
                    val endTime = (screen.recordTime / 1000)
                    val sleepTime = SleepTime(startTime = startTime, endTime = endTime)
                    val timeRangedMotionList = allMotionList.filter {
                        it.recordTime in sleepTime.startTime..sleepTime.endTime
                    }

                    // 후보 수면 기간 동안 움직인 시간 간격이 자는 시간(1시간~23시간)이면 자는 시간으로 간주
                    var tmpStartTime = sleepTime.startTime
                    timeRangedMotionList.forEach {
                        checkAndAddCandidate(candidateSleepList, tmpStartTime, it.recordTime)
                        tmpStartTime = it.recordTime
                    }
                    checkAndAddCandidate(candidateSleepList, tmpStartTime, sleepTime.endTime)
                }
            }
            if (isOn != previousScreenIsOn) {
                previousScreenRecordTime = screen.recordTime
                previousScreenIsOn = isOn
            }
        }

        return candidateSleepList.groupBy { it.endTime.toLocalDate() }
    }

    private fun checkAndAddCandidate(
        candidateSleepList: MutableList<SleepTime>,
        startTime: Long,
        endTime: Long
    ) {
        val sleepTime = SleepTime(startTime = startTime, endTime = endTime)
        val duration = sleepTime.duration
        if (duration in (ONE_HOUR_INT + 1) until MAXIMUM_SLEEP_DURATION) {
            candidateSleepList.add(sleepTime)
        }
    }

    companion object {
        private const val ONE_HOUR_INT = 3600
        private const val MAXIMUM_SLEEP_DURATION = ONE_HOUR_INT * 23
        private const val ONE_HOUR_LONG = ONE_HOUR_INT * 1000L
    }
}