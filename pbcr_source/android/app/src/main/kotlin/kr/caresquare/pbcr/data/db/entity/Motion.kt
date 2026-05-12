package kr.caresquare.pbcr.data.db.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "MOTION")
data class Motion(
    @PrimaryKey
    val recordTime: Long,
    var stepCnt: Long,
    val isPosted: Boolean = false
)