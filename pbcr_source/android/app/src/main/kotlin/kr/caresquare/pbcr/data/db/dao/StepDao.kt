package kr.caresquare.pbcr.data.db.dao

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kr.caresquare.pbcr.data.db.entity.StepEntity

@Dao
interface StepDao {

    @Query("SELECT SUM(stepCnt) FROM STEP WHERE time BETWEEN :from AND :to")
    fun getCnt(from: Long, to: Long): LiveData<Long?>

    @Query("SELECT SUM(stepCnt) FROM STEP WHERE time BETWEEN :from AND :to")
    suspend fun getStepCountForPeriod(from: Long, to: Long): Long?

    @Query("SELECT * FROM STEP WHERE time BETWEEN :from AND :to")
    suspend fun getStepDataForPeriod(from: Long, to: Long): List<StepEntity>

    @Query("SELECT * FROM STEP WHERE time < :until AND isPosted = 0")
    suspend fun getNotPostedList(until: Long): List<StepEntity>

    @Query("SELECT * FROM STEP WHERE isPosted = 0")
    suspend fun getAllNotPostedList(): List<StepEntity>

    @Query("UPDATE STEP SET isPosted = 1 WHERE time = :time")
    suspend fun updatePosted(time: Long)

    @Query("SELECT EXISTS(SELECT * FROM STEP WHERE time = :time)")
    suspend fun isExist(time: Long): Boolean

    @Query("UPDATE STEP SET stepCnt = stepCnt + :addedCnt, isPosted = 0 WHERE time = :time")
    suspend fun add(time: Long, addedCnt: Long)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(entity: StepEntity)

    @Query("DELETE FROM STEP WHERE isPosted = 1")
    suspend fun deletePostedStep()

    @Query("DELETE FROM STEP")
    suspend fun deleteAll()
}
