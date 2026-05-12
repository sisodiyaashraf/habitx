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