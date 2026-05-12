package kr.caresquare.pbcr.ext

import java.time.*
import java.time.format.DateTimeFormatter
import java.util.*

private val amPmFormatter = DateTimeFormatter.ofPattern("a")
private val dayOfWeekFormatter = DateTimeFormatter.ofPattern("E")
private val hourMinWithAmPmFormatter = DateTimeFormatter.ofPattern("a hh:mm")
private val hourMinWithAmPmEnteredFormatter = DateTimeFormatter.ofPattern("a\nhh:mm")
private val hourMinFormatter: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
private val hourMinSecFormatter: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss")
private val simpleYearDateFormatter = DateTimeFormatter.ofPattern("yy.MM.dd")
private val fullYearDateFormatter = DateTimeFormatter.ofPattern("yyyy.MM.dd")
private val monthDateFormatter = DateTimeFormatter.ofPattern("MM.dd")
private val monthDateWithWeekFormatter: DateTimeFormatter = DateTimeFormatter.ofPattern("MM.dd(E)")
private val yearMonthDayFormatter = DateTimeFormatter.ofPattern("yyyyMMdd")
private val yearMonthFormatter = DateTimeFormatter.ofPattern("yyyyMM")
private val dashYearMonthFormatter = DateTimeFormatter.ofPattern("yyyy-MM")
private val dashYearMonthDayFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
private val dashShortYearMonthDayFormatter = DateTimeFormatter.ofPattern("yy-MM-dd")
private val dashMonthDayFormatter = DateTimeFormatter.ofPattern("MM-dd")
private val slashMonthDayFormatter = DateTimeFormatter.ofPattern("M/d")
private val koreanYearMonthDayFormatter = DateTimeFormatter.ofPattern("yyyy년 M월 d일")
private val dashMonthDayWithWeekFormatter: DateTimeFormatter =
    DateTimeFormatter.ofPattern("MM-dd(E)")
private val enteredDateTimeFormatter: DateTimeFormatter =
    DateTimeFormatter.ofPattern("MM-dd\nHH:mm")

private val dashLongYearMonthDayFormatter: DateTimeFormatter =
    DateTimeFormatter.ofPattern("yyyy-MM-dd(E)")
private val apptDateTimeFormatter: DateTimeFormatter =
    DateTimeFormatter.ofPattern("yyyy-MM-dd(E) a hh:mm")
private val invoiceTimeFormatter: DateTimeFormatter =
    DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 a hh:mm")

fun LocalTime.toAmPmStr(): String = this.format(amPmFormatter)
fun LocalTime?.toHourMinWithAmPmStr(): String = this?.format(hourMinWithAmPmFormatter) ?: ""
fun LocalTime?.toHourMinWithAmPmEnteredStr(): String =
    this?.format(hourMinWithAmPmEnteredFormatter) ?: ""

fun LocalDateTime.toHourMinWithAmPmStr(): String = this.toLocalTime().toHourMinWithAmPmStr()
fun LocalTime?.toHourMinStr(): String = this?.format(hourMinFormatter) ?: ""
fun LocalTime.toHourMinSecFormat(): String = this.format(hourMinSecFormatter)
fun LocalDateTime.toHourMinStr(): String = this.format(hourMinFormatter)
fun LocalDate.toFullYearDateFormat(): String = this.format(fullYearDateFormatter)
fun LocalDate.toSimpleYearDateFormat(): String = this.format(simpleYearDateFormatter)
fun LocalDate.toMonthDateFormat(): String = this.format(monthDateFormatter)
fun LocalDate.toYearMonthStr(): String = this.format(yearMonthFormatter)
fun LocalDate.toYearMonthDayStr(): String = this.format(yearMonthDayFormatter)
fun LocalDateTime.toDashMonthDayStr(): String = this.format(dashMonthDayFormatter)
fun LocalDate.toDashMonthDayStr(): String = this.format(dashMonthDayFormatter)
fun LocalDate.toDashMonthDayWithWeekStr(): String = this.format(dashMonthDayWithWeekFormatter)
fun LocalDate.toDashYearMonthStr(): String = this.format(dashYearMonthFormatter)
fun LocalDate.toDashYearMonthDayStr(): String = this.format(dashYearMonthDayFormatter)
fun LocalDate.toDashShortYearMonthDayStr(): String = this.format(dashShortYearMonthDayFormatter)
fun LocalDate.toDayOfWeekStr(): String = this.format(dayOfWeekFormatter)
fun LocalDateTime.toDashShortYearMonthDayStr(): String = this.format(dashShortYearMonthDayFormatter)
fun LocalDateTime.toEnteredDateTimeStr(): String = this.format(enteredDateTimeFormatter)
fun LocalDateTime.toApptDateTimeStr(): String = this.format(apptDateTimeFormatter)
fun LocalDateTime.toDashLongYearMonthDayStr(): String = this.format(dashLongYearMonthDayFormatter)
fun LocalDateTime.toInvoiceTimeStr(): String = this.format(invoiceTimeFormatter)
fun LocalDate.toDashLongYearMonthDayStr(): String = this.format(dashLongYearMonthDayFormatter)
fun LocalDate.toSlashMonthDayStr(): String = this.format(slashMonthDayFormatter)
fun LocalDate.toKoreanYearMonthDayStr(): String = this.format(koreanYearMonthDayFormatter)

fun String.toLocalDateFromYearMonthDay(): LocalDate = LocalDate.parse(this, yearMonthDayFormatter)
fun String.toLocalDateFromDashYearMonthDay(): LocalDate =
    LocalDate.parse(this, dashYearMonthDayFormatter)

fun String.toYearMonthFromYearMonth(): YearMonth = YearMonth.parse(this, yearMonthFormatter)
fun String.toLocalTimeFromHourMin(): LocalTime = LocalTime.parse(this, hourMinFormatter)
fun String.toLocalTimeFromHourMinSec(): LocalTime = LocalTime.parse(this, hourMinSecFormatter)

fun LocalDate.toStartUnixTimeStamp(): Int {
    return this.atTime(0, 0, 0, 0)
        .toEpochSecond(ZoneOffset.ofTotalSeconds(TimeZone.getDefault().rawOffset / 1000)).toInt()
}

fun LocalDate.toEndUnixTimeStamp(): Int {
    return this.atTime(23, 59, 59, 0)
        .toEpochSecond(ZoneOffset.ofTotalSeconds(TimeZone.getDefault().rawOffset / 1000)).toInt()
}

fun LocalDateTime.toUnixTimeStamp(): Int =
    this.toEpochSecond(ZoneOffset.ofTotalSeconds(TimeZone.getDefault().rawOffset / 1000)).toInt()

// Int
fun Int.toZeroPadString(len: Int): String = this.toString().padStart(len, '0')
fun List<Int>.toZeroPadString(len: Int): List<String> = this.map { it.toZeroPadString(len) }
fun Int.toLocalDate(): LocalDate = this.toLocalDateTime().toLocalDate()
fun Int.toLocalTime(): LocalTime = this.toLocalDateTime().toLocalTime()
fun Int.toLocalDateTime(): LocalDateTime =
    LocalDateTime.ofEpochSecond(
        this.toLong(),
        0,
        ZoneOffset.ofTotalSeconds(TimeZone.getDefault().rawOffset / 1000)
    )

// Long
fun Long.toLocalDate(): LocalDate = this.toLocalDateTime().toLocalDate()
fun Long.toLocalTime(): LocalTime = this.toLocalDateTime().toLocalTime()
fun Long.toLocalDateTime(): LocalDateTime =
    LocalDateTime.ofEpochSecond(
        this,
        0,
        ZoneOffset.ofTotalSeconds(TimeZone.getDefault().rawOffset / 1000)
    )

fun LocalDate.isSunday(): Boolean = this.dayOfWeek == DayOfWeek.SUNDAY
fun LocalDate.isSaturDay(): Boolean = this.dayOfWeek == DayOfWeek.SATURDAY