package kr.caresquare.pbcr.data.db

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverter
import androidx.room.TypeConverters
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import kr.caresquare.pbcr.data.db.dao.MotionDao
import kr.caresquare.pbcr.data.db.dao.ScreenDao
import kr.caresquare.pbcr.data.db.dao.SleepDao
import kr.caresquare.pbcr.data.db.dao.StepDao
import kr.caresquare.pbcr.data.db.entity.Motion
import kr.caresquare.pbcr.data.db.entity.Screen
import kr.caresquare.pbcr.data.db.entity.SleepEntity
import kr.caresquare.pbcr.data.db.entity.StepEntity
import java.time.LocalDate

@Database(
    entities = [StepEntity::class, SleepEntity::class, Motion::class, Screen::class],
    version = 1,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {
    abstract fun stepDao(): StepDao
    abstract fun sleepDao(): SleepDao
    abstract fun screenDao(): ScreenDao
    abstract fun motionDao(): MotionDao
}

class Converters {
    @TypeConverter
    fun toLocalDate(value: Long) = LocalDate.ofEpochDay(value)!!

    @TypeConverter
    fun fromLocalDate(value: LocalDate) = value.toEpochDay()

    @TypeConverter
    fun toStringList(value: String) =
        Gson().fromJson<List<String>>(value, object : TypeToken<List<String>>() {}.type)!!

    @TypeConverter
    fun fromStringList(value: List<String>) = Gson().toJson(value)!!
}