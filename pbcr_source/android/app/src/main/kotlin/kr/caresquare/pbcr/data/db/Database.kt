package kr.caresquare.pbcr.data.db

import android.content.Context
import androidx.lifecycle.LiveData
import androidx.room.Room
import kr.caresquare.pbcr.data.db.dao.MotionDao
import kr.caresquare.pbcr.data.db.dao.ScreenDao
import kr.caresquare.pbcr.data.db.dao.SleepDao
import kr.caresquare.pbcr.data.db.dao.StepDao
import kr.caresquare.pbcr.data.db.entity.Motion
import kr.caresquare.pbcr.data.db.entity.Screen
import kr.caresquare.pbcr.data.db.entity.SleepEntity
import kr.caresquare.pbcr.data.db.entity.StepEntity

class Database
constructor(
        private val stepDao: StepDao,
        private val sleepDao: SleepDao,
        private val screenDao: ScreenDao,
        private val motionDao: MotionDao,
) {
    // --------------------------------------- Screen
    // -----------------------------------------------
    suspend fun insertScreen(entity: Screen) = screenDao.insert(entity)
    suspend fun getAllScreen(): List<Screen> = screenDao.getAll()
    suspend fun getAllScreen(startRange: Long): List<Screen> = screenDao.getAll(startRange)
    suspend fun getAllScreenNotPosted(): List<Screen> = screenDao.getAllNotPosted()
    private suspend fun deleteAllScreen() = screenDao.deleteAll()
    suspend fun updateScreenPosted(time: Long) = screenDao.updatePosted(time)
    suspend fun deleteScreenBeforeTime(recordTime: Long) =
            screenDao.deleteBeforeTime(recordTime)

    // --------------------------------------- Motion
    // -----------------------------------------------
    suspend fun insertMotion(motion: Motion) {
        if (motionDao.isExist(motion.recordTime)) motionDao.add(motion.recordTime, motion.stepCnt)
        else motionDao.insert(motion)
    }

    suspend fun getAllMotion(): List<Motion> = motionDao.getAll()
    suspend fun getAllMotion(startRange: Long): List<Motion> = motionDao.getAll(startRange)
    suspend fun getAllMotionNotPosted(): List<Motion> = motionDao.getAllNotPosted()
    suspend fun deleteMotionBeforeTime(recordTime: Long) = motionDao.deleteBeforeTime(recordTime)
    private suspend fun deleteAllMotion() = motionDao.deleteAll()
    suspend fun updateMotionPosted(time: Long) = motionDao.updatePosted(time)

    // --------------------------------------- Sleep -----------------------------------------------
    suspend fun getSleepList(): List<SleepEntity> = sleepDao.getList()
    suspend fun getSleepNotPostedList(): List<SleepEntity> = sleepDao.getNotPostedList()
    suspend fun getSleepDataForPeriod(from: Long, to: Long): List<SleepEntity> =
            sleepDao.getSleepDataForPeriod(from, to)
    suspend fun updateSleepPost(recordDate: String) = sleepDao.updatePost(recordDate)
    suspend fun getSleep(recordDate: String): SleepEntity? = sleepDao.get(recordDate)
    suspend fun insertSleep(sleepEntity: SleepEntity) = sleepDao.insert(sleepEntity)
    suspend fun deleteSleepBeforeEndTime(recordDate: Long) =
            sleepDao.deleteSleepBeforeEndTime(recordDate)
    private suspend fun deleteAllSleep() = sleepDao.deleteAll()

    // --------------------------------------- Step -----------------------------------------------
    fun getStepCnt(from: Long, to: Long): LiveData<Long?> = stepDao.getCnt(from, to)
    suspend fun addStep(entity: StepEntity) {
        if (stepDao.isExist(entity.time)) stepDao.add(entity.time, entity.stepCnt)
        else stepDao.insert(entity)
    }

    suspend fun getStepCntForPeriod(from: Long, to: Long): Long? =
            stepDao.getStepCountForPeriod(from, to)
    suspend fun getStepDataForPeriod(from: Long, to: Long): List<StepEntity> =
            stepDao.getStepDataForPeriod(from, to)
    suspend fun getStepNotPostedList(until: Long): List<StepEntity> = stepDao.getNotPostedList(until)
    suspend fun getAllStepNotPostedList(): List<StepEntity> = stepDao.getAllNotPostedList()
    suspend fun updateStepPosted(time: Long) = stepDao.updatePosted(time)
    suspend fun deletePostedStep() = stepDao.deletePostedStep()
    private suspend fun deleteAllStep() = stepDao.deleteAll()

    suspend fun deleteAllLocalData() {
        deleteAllStep()
        deleteAllScreen()
        deleteAllMotion()
        deleteAllSleep()
    }

    companion object {
        private var instance: Database? = null

        fun getInstance(context: Context): Database =
                if (instance != null) instance!!
                else {
                    val rawDb =
                            Room.databaseBuilder(
                                            context,
                                            AppDatabase::class.java,
                                            "medidot_database.db"
                                    )
                                    .build()

                    instance =
                            Database(
                                    rawDb.stepDao(),
                                    rawDb.sleepDao(),
                                    rawDb.screenDao(),
                                    rawDb.motionDao(),
                            )

                    instance!!
                }
    }
}
