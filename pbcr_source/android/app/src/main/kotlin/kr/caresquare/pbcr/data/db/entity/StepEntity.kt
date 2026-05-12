package kr.caresquare.pbcr.data.db.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(
    tableName = "STEP"
)
data class StepEntity(
    @PrimaryKey
    val time: Long,
    val stepCnt: Long,
    val isPosted: Boolean = false
)