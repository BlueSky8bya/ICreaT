package kr.caresquare.pbcr.ext

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import androidx.annotation.DrawableRes
import androidx.core.content.ContextCompat

fun getBitmapFromVectorDrawable(context: Context, @DrawableRes drawableId: Int): Bitmap? =
    ContextCompat.getDrawable(context, drawableId)?.let { drawable ->
        Bitmap.createBitmap(
            drawable.intrinsicWidth,
            drawable.intrinsicHeight,
            Bitmap.Config.ARGB_8888
        )?.apply {
            val canvas = Canvas(this)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
        }
    }