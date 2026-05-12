package kr.caresquare.pbcr.data.db.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kr.caresquare.pbcr.data.db.entity.Screen

@Dao
interface ScreenDao {

    @Query("SELECT * FROM SCREEN")
    suspend fun getAll(): List<Screen>

    @Query("SELECT * FROM SCREEN WHERE recordTime >= :startRange")
    suspend fun getAll(startRange: Long): List<Screen>

    @Query("SELECT * FROM SCREEN WHERE isPosted = 0")
    suspend fun getAllNotPosted(): List<Screen>

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insert(entity: Screen)

    @Query("DELETE FROM SCREEN")
    suspend fun deleteAll()

    @Query("UPDATE SCREEN SET isPosted = 1 WHERE recordTime = :recordTime")
    suspend fun updatePosted(recordTime: Long)

    @Query("DELETE FROM SCREEN WHERE recordTime <= :recordTime")
    suspend fun deleteBeforeTime(recordTime: Long)
}
