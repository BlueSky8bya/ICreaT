package kr.caresquare.pbcr.data.db.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "SLEEP")
data class SleepEntity(
    @PrimaryKey(autoGenerate = true)
    val uk: Long = 0,
    val recordDate: String,     // yyyyMMdd
    val startTime: Long,
    val endTime: Long,
    val isPosted: Boolean = false
)