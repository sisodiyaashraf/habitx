package com.shalcontech.habitx

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import java.io.File
import com.shalcontech.habitx.R
import com.shalcontech.habitx.MainActivity
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class HabitWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData: SharedPreferences = context.getSharedPreferences(
            "habitx_glass_data", 
            Context.MODE_PRIVATE
        )

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.habit_widget_layout)

            // Get the mascot image path from Flutter
            val imagePath = widgetData.getString("mascot_image", null)
            if (imagePath != null) {
                // 🚀 IMPROVED: Using Uri.fromFile for absolute paths
                views.setImageViewUri(R.id.widget_image, Uri.fromFile(File(imagePath)))
            } else {
                // Fallback to daily rotating drawable from habitx1, habitx2, habitx3
                val calendar = java.util.Calendar.getInstance()
                val day = calendar.get(java.util.Calendar.DAY_OF_MONTH)
                val imageIndex = (day % 3) + 1 // 1, 2, or 3
                val resourceId = context.resources.getIdentifier(
                    "habitx$imageIndex",
                    "drawable",
                    context.packageName
                )
                if (resourceId != 0) {
                    views.setImageViewResource(R.id.widget_image, resourceId)
                }
            }

            // Setup Click Intent to open the app
            val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                context, 
                MainActivity::class.java
            )
            views.setOnClickPendingIntent(R.id.widget_root, openAppIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}