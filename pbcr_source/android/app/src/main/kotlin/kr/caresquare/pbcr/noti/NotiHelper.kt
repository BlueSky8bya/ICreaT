package kr.caresquare.pbcr.noti


import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.util.Log
import androidx.annotation.DrawableRes
import androidx.annotation.RequiresApi
import androidx.annotation.RequiresPermission
import androidx.annotation.StringRes
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import kr.caresquare.pbcr.R

class NotiHelper(private val context: Context) {
    fun getBaseNotificationBuilder(
        channelId: String,
        title: String? = null,
        body: String? = null,
        icon: Bitmap? = null,
        isNotSilent: Boolean = true,
        @DrawableRes smallIcon: Int = R.drawable.ic_icon,
        priority: Int = NotificationCompat.PRIORITY_DEFAULT
    ): NotificationCompat.Builder {
        val builder = NotificationCompat.Builder(context, channelId)
            .setColor(ContextCompat.getColor(context, R.color.colorPrimary))
            .setSmallIcon(smallIcon)
            .setPriority(priority)
            .setAutoCancel(true)

        icon?.let { builder.setLargeIcon(icon) }
        title?.let { builder.setContentTitle(title) }
        body?.let { builder.setContentText(body) }

        if (isNotSilent) builder.setDefaults(NotificationCompat.DEFAULT_ALL)

        return builder
    }

    @RequiresPermission("android.permission.POST_NOTIFICATIONS")
    fun notify(notificationId: Int, builder: NotificationCompat.Builder?) {
        builder?.let {
            with(NotificationManagerCompat.from(context)) {
                notify(notificationId, builder.build())
            }
        }
    }

    fun cancel(notificationId: Int) {
        with(NotificationManagerCompat.from(context)) { cancel(notificationId) }
    }

    companion object {
        const val NOTIFICATION_ID_FRIEND = 10008
        const val NOTIFICATION_ID_DOSE = 1003
        const val NOTIFICATION_ID_STEP = 12345
        const val NOTIFICATION_ID_HOSPITAL = 10011
        const val NOTIFICATION_ID_IMPORTANT = 10115
        const val NOTIFICATION_ID_DEFAULT = 10009

        const val NOTI_PENDING_STEP = 9
        const val NOTI_PENDING_DOSE = 3
        const val NOTI_PENDING_FRIEND = 12
        const val NOTI_PENDING_DEFAULT = 13
        const val NOTI_PENDING_HOSPITAL = 14

        fun createNotificationChannel(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val notificationManager = context.getSystemService(NotificationManager::class.java)

                createChannels(context, notificationManager)
            }
        }

        @RequiresApi(Build.VERSION_CODES.O)
        private fun createChannels(context: Context, notificationManager: NotificationManager?) {
            NotiChannel.values().forEach {
                val channel = NotificationChannel(
                    it.id,
                    context.getString(it.displayedName),
                    it.importance
                ).apply {
                    setShowBadge(it.isShowBadge)
                }
                notificationManager?.createNotificationChannel(channel)
            }
        }
    }
}