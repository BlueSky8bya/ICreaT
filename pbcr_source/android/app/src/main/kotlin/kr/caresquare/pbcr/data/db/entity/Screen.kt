package kr.caresquare.pbcr.data.db.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import kr.caresquare.pbcr.models.ScreenType

@Entity(tableName = "SCREEN")
data class Screen(
    @PrimaryKey
    val recordTime: Long,
    val type: String,
    val isPosted: Boolean = false
) {
    fun isOn(): Boolean = type == ScreenType.ON.value
}