package kr.caresquare.pbcr.data.db.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kr.caresquare.pbcr.data.db.entity.Motion

@Dao
interface MotionDao {

    @Query("SELECT * FROM MOTION")
    suspend fun getAll(): List<Motion>

    @Query("SELECT * FROM MOTION WHERE recordTime >= :startRange")
    suspend fun getAll(startRange: Long): List<Motion>

    @Query("SELECT * FROM MOTION WHERE isPosted = 0")
    suspend fun getAllNotPosted(): List<Motion>

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insert(entity: Motion)

    @Query("DELETE FROM MOTION")
    suspend fun deleteAll()

    @Query("DELETE FROM MOTION WHERE recordTime <= :recordTime")
    suspend fun deleteBeforeTime(recordTime: Long)

    @Query("SELECT EXISTS(SELECT * FROM MOTION WHERE recordTime = :recordTime)")
    suspend fun isExist(recordTime: Long): Boolean

    @Query("UPDATE MOTION SET stepCnt = stepCnt + :addedCnt, isPosted = 0 WHERE recordTime = :recordTime")
    suspend fun add(recordTime: Long, addedCnt: Long)

    @Query("UPDATE MOTION SET isPosted = 1 WHERE recordTime = :recordTime")
    suspend fun updatePosted(recordTime: Long)
}
