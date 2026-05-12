package kr.caresquare.pbcr.data


import android.content.Context

class PrefHelperKt(context: Context) {
    private var prefs = context.getSharedPreferences(
        "FlutterSharedPreferences",
        Context.MODE_PRIVATE
    )

    var uid: String
        get() = prefs.getString(PREF_KEY_USER_UID, "") ?: ""
        set(value) = prefs.edit().putString(PREF_KEY_USER_UID, value).apply()

    var nextSleepCalcDate: Long
        get() =
            prefs.getLong(PREF_KEY_NEXT_SLEEP_CALC_DATE, 0)
        set(value) = prefs.edit().putLong(PREF_KEY_NEXT_SLEEP_CALC_DATE, value).apply()

    var wakeupTime: Long
        get() =
            prefs.getLong(PREF_KEY_WAKEUP_TIME, 0)
        set(value) = prefs.edit().putLong(PREF_KEY_WAKEUP_TIME, value).apply()

    var lastCalcSleepTime: Long
        get() =
            prefs.getLong(PREF_KEY_LAST_CALC_SLEEP_TIME, 0)
        set(value) = prefs.edit().putLong(PREF_KEY_LAST_CALC_SLEEP_TIME, value).apply()

    companion object {
        private const val PREF_KEY_USER_UID = "flutter.PREF_KEY_USER_UID"
        private const val PREF_KEY_NEXT_SLEEP_CALC_DATE = "flutter.PREF_KEY_NEXT_SLEEP_CALC_DATE"
        private const val PREF_KEY_WAKEUP_TIME = "flutter.PREF_KEY_WAKEUP_TIME"
        private const val PREF_KEY_LAST_CALC_SLEEP_TIME = "flutter.PREF_KEY_LAST_CALC_SLEEP_TIME"


        private var instance: PrefHelperKt? = null

        fun getInstance(context: Context): PrefHelperKt =
            if (instance != null) instance!!
            else {
                instance = PrefHelperKt(context)
                instance!!
            }
    }
}