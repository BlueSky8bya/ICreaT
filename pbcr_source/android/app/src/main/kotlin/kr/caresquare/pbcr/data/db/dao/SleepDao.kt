package kr.caresquare.pbcr.data.db.dao

import androidx.room.*
import kr.caresquare.pbcr.data.db.entity.SleepEntity

@Dao
interface SleepDao {

    @Query("SELECT * FROM SLEEP")
    suspend fun getList(): List<SleepEntity>

    @Query("SELECT * FROM SLEEP WHERE recordDate = :recordDate")
    suspend fun get(recordDate: String): SleepEntity?

    @Query("SELECT * FROM SLEEP WHERE isPosted = 0")
    suspend fun getNotPostedList(): List<SleepEntity>

    @Query("SELECT * FROM SLEEP WHERE startTime >= :from AND endTime <= :to")
    suspend fun getSleepDataForPeriod(from: Long, to: Long): List<SleepEntity>

    @Query("UPDATE SLEEP SET isPosted = 1 WHERE recordDate = :recordDate")
    suspend fun updatePost(recordDate: String)

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insert(entity: SleepEntity)

    @Query("DELETE FROM SLEEP WHERE endTime <= :deleteTime")
    suspend fun deleteSleepBeforeEndTime(deleteTime: Long)

    @Delete
    suspend fun delete(entity: SleepEntity)

    @Query("DELETE FROM SLEEP")
    suspend fun deleteAll()
}
