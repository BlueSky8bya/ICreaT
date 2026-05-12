package kr.caresquare.pbcr.models

data class SleepTime(
    val startTime: Long,
    val endTime: Long
) {
    val duration: Long
        get() = endTime - startTime
}