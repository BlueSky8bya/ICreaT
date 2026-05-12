package kr.caresquare.pbcr.phr

import android.content.Context
import android.util.Log
import androidx.lifecycle.LiveData
import com.google.gson.Gson
import kr.caresquare.pbcr.data.PrefHelperKt
import kr.caresquare.pbcr.data.db.Database
import kr.caresquare.pbcr.data.db.entity.Motion
import kr.caresquare.pbcr.data.db.entity.Screen
import kr.caresquare.pbcr.data.db.entity.SleepEntity
import kr.caresquare.pbcr.data.db.entity.StepEntity
import kr.caresquare.pbcr.ext.*
import kr.caresquare.pbcr.models.ScreenType
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.*

class PhrRepo(
        private val db: Database,
        private val prefHelper: PrefHelperKt,
        private val sleepCalculator: SleepCalculator
) {
    private val tag = this::class.java.name

    suspend fun insertScreen(type: ScreenType) =
            db.insertScreen(Screen(System.currentTimeMillis(), type.value))

    suspend fun insertMotion(step: Long) {
        val current = (System.currentTimeMillis() / 1000).toLong()
        val time = current - current % 60
        db.insertMotion(Motion(time, step))
    }

    suspend fun calcSleep() {
        Log.d(
                tag,
                "calcSleep : prefHelper.lastCalcSleepTime = ${prefHelper.lastCalcSleepTime}, prefHelper.wakeupTime = ${prefHelper.wakeupTime}"
        )
        val mapSleepTime =
                sleepCalculator.calcSleep(
                        calcStartAt = prefHelper.lastCalcSleepTime,
                        allMotionList = db.getAllMotion(),
                        allScreenList = db.getAllScreen()
                )

        Log.d(tag, "calcSleep : mapSleepTime = $mapSleepTime")
        if (mapSleepTime != null && mapSleepTime.isNotEmpty()) {
            var lastCalcTime: Long
            for (entry in mapSleepTime) {
                val date = entry.key
                val sleepList = entry.value
                sleepList.maxByOrNull { it.endTime - it.startTime }?.let {
                    lastCalcTime = it.endTime
                    db.insertSleep(
                            SleepEntity(
                                    recordDate = date.toYearMonthDayStr(),
                                    startTime = it.startTime,
                                    endTime = it.endTime
                            )
                    )
                    // 다음 계산을 위해 마지막으로 기록한 기상 시간 추가
                    prefHelper.lastCalcSleepTime = lastCalcTime
                    deleteCompleteCalcSleepData(lastCalcTime)
                }
            }
        }
    }

    fun getTodayStepCntLD(): LiveData<Long?> {
        val now = LocalDate.now()
        return db.getStepCnt(now.toStartUnixTimeStamp().toLong(), now.toEndUnixTimeStamp().toLong())
    }

    suspend fun getTodayStepCnt() =
            getStepCntForPeriod(
                    LocalDate.now().toStartUnixTimeStamp().toLong(),
                    LocalDate.now().toEndUnixTimeStamp().toLong()
            )

    suspend fun getStepCntForPeriod(from: Long, to: Long): Long {
        return db.getStepCntForPeriod(from, to) ?: 0
    }

    suspend fun getTodayStepData(): List<String> =
            getStepDataForPeriod(
                    LocalDate.now().toStartUnixTimeStamp().toLong(),
                    LocalDate.now().toEndUnixTimeStamp().toLong()
            )

    suspend fun getStepDataForPeriod(from: Long, to: Long): List<String> {
        val gson = Gson()
        return db.getStepDataForPeriod(from, to).map { gson.toJson(it) }
    }

    suspend fun addStep(cnt: Long) {
        val curStepTime = getCurrentStepTime()
        db.addStep(StepEntity(curStepTime, cnt))
    }

    suspend fun getNeedPostStepList(): List<String> {
        val gson = Gson()
        return db.getStepNotPostedList(getCurrentStepTime()).map { gson.toJson(it) }
    }

    private fun getCurrentStepTime(): Long {
        val now = LocalDateTime.now()
        val offset = TimeZone.getDefault().rawOffset / 1000
        val unix = now.toUnixTimeStamp() - offset
        val minus = unix % 600
        return (unix - minus + offset).toLong()
    }

    suspend fun updatePostedStep(untilList: List<Long>) {
        untilList.forEach { until -> db.updateStepPosted(until) }
    }

    suspend fun deleteCompleteStepData() {
        db.deletePostedStep()
    }

    suspend fun getNeedPostSleepList(): List<String> {
        val gson = Gson()
        return db.getSleepNotPostedList().map { gson.toJson(it) }
    }

    suspend fun getSleepDataForPeriod(from: Long, to: Long): List<String> {
        val gson = Gson()
        return db.getSleepDataForPeriod(from, to).map { gson.toJson(it) }
    }

    private suspend fun deleteCompleteCalcSleepData(deleteUntil: Long) {
        db.deleteMotionBeforeTime(deleteUntil)
        val screenDeleteUntil = deleteUntil * 1000L
        db.deleteScreenBeforeTime(screenDeleteUntil)
    }

    suspend fun deleteCompleteSleepData(deleteTime: Long) {
        db.deleteSleepBeforeEndTime(deleteTime)
        db.deleteMotionBeforeTime(deleteTime)
        val screenDeleteTime = deleteTime * 1000L
        db.deleteScreenBeforeTime(screenDeleteTime)
        prefHelper.nextSleepCalcDate = deleteTime.toLocalDate().plusDays(1).toStartUnixTimeStamp().toLong()
    }

    companion object {
        private var instance: PhrRepo? = null

        fun getInstance(context: Context): PhrRepo =
                if (instance != null) instance!!
                else {
                    instance =
                            PhrRepo(
                                    Database.getInstance(context),
                                    PrefHelperKt.getInstance(context),
                                    SleepCalculator()
                            )
                    instance!!
                }
    }
}
