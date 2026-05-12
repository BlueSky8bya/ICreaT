package kr.caresquare.pbcr.noti

import androidx.annotation.StringRes
import androidx.core.app.NotificationManagerCompat
import kr.caresquare.pbcr.R


enum class NotiChannel(
    val id: String,
    @StringRes val displayedName: Int,
    val isShowBadge: Boolean,
    val importance: Int,
) {
    STEP(
        id = "CAREEASE_NOTIFICATION_0_STEP",
        displayedName = R.string.notification_channel_name_step,
        isShowBadge = false,
        importance = NotificationManagerCompat.IMPORTANCE_NONE
    ),
    DOWNLOAD(
        id = "CAREEASE_NOTIFICATION_100_STEP",
        displayedName = R.string.notification_channel_name_download_complete,
        isShowBadge = false,
        importance = NotificationManagerCompat.IMPORTANCE_MAX,
    ),
    IMPORTANT(
        id = "CAREEASE_NOTIFICATION_25_IMPORTANT",
        displayedName = R.string.notification_channel_name_important,
        isShowBadge = true,
        importance = NotificationManagerCompat.IMPORTANCE_MAX,
    ),


//    DOSE(
//        id = "CAREEASE_NOTIFICATION_10_DOSE",
//        displayedName = R.string.notification_channel_name_dose,
//        isShowBadge = true,
//        importance = NotificationManagerCompat.IMPORTANCE_DEFAULT
//    ),
//    HOSPITAL(
//        id = "CAREEASE_NOTIFICATION_20_NEW_HOSPITAL",
//        displayedName = R.string.notification_channel_name_hospital,
//        isShowBadge = true,
//        importance = NotificationManagerCompat.IMPORTANCE_MAX
//    ),
//    FRIEND(
//        id = "CAREEASE_NOTIFICATION_30_FRIEND",
//        displayedName = R.string.notification_channel_name_friend,
//        isShowBadge = true,
//        importance = NotificationManagerCompat.IMPORTANCE_DEFAULT
//    ),
//    DEFAULT(
//        id = "CAREEASE_NOTIFICATION_40_DEFAULT",
//        displayedName = R.string.notification_channel_name_default,
//        isShowBadge = true,
//        importance = NotificationManagerCompat.IMPORTANCE_DEFAULT
//    ),
}