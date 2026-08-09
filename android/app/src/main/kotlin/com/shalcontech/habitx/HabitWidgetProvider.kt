package com.shalcontech.habitx

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import java.io.File
import com.shalcontech.habitx.R
import com.shalcontech.habitx.MainActivity
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

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

            // Populate habits list
            val habitsJsonStr = widgetData.getString("habits_json", null)
            val rows = arrayOf(
                Triple(R.id.habit_row_1, R.id.habit_name_1, R.id.habit_streak_1 to R.id.habit_check_1),
                Triple(R.id.habit_row_2, R.id.habit_name_2, R.id.habit_streak_2 to R.id.habit_check_2),
                Triple(R.id.habit_row_3, R.id.habit_name_3, R.id.habit_streak_3 to R.id.habit_check_3)
            )

            // Hide all rows by default
            rows.forEach { (rowId, _, _) ->
                views.setViewVisibility(rowId, View.GONE)
            }
            views.setViewVisibility(R.id.widget_no_habits, View.GONE)

            if (habitsJsonStr != null && habitsJsonStr.isNotEmpty()) {
                try {
                    val habitsArray = org.json.JSONArray(habitsJsonStr)
                    if (habitsArray.length() == 0) {
                        views.setViewVisibility(R.id.widget_no_habits, View.VISIBLE)
                    } else {
                        val count = minOf(habitsArray.length(), rows.size)
                        for (i in 0 until count) {
                            val habit = habitsArray.getJSONObject(i)
                            val habitId = habit.getString("id")
                            val habitName = habit.getString("name")
                            val habitStreak = habit.getInt("streak")
                            val isCompleted = habit.getBoolean("isCompleted")

                            val (rowId, nameId, streakAndCheck) = rows[i]
                            val (streakId, checkId) = streakAndCheck

                            views.setViewVisibility(rowId, View.VISIBLE)
                            views.setTextViewText(nameId, habitName)
                            views.setTextViewText(streakId, "$habitStreak 🔥")

                            if (isCompleted) {
                                views.setImageViewResource(checkId, R.drawable.ic_checkbox_checked)
                            } else {
                                views.setImageViewResource(checkId, R.drawable.ic_checkbox_blank)
                            }

                            // Setup background intent for checkmark click callback
                            val clickIntent = HomeWidgetBackgroundIntent.getBroadcast(
                                context,
                                Uri.parse("homeWidget://completeHabit?id=$habitId")
                            )
                            views.setOnClickPendingIntent(checkId, clickIntent)
                        }
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    views.setViewVisibility(R.id.widget_no_habits, View.VISIBLE)
                }
            } else {
                views.setViewVisibility(R.id.widget_no_habits, View.VISIBLE)
            }

            // Setup Click Intent to open the app (taps on header/mascot)
            val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                context, 
                MainActivity::class.java
            )
            views.setOnClickPendingIntent(R.id.widget_image, openAppIntent)
            views.setOnClickPendingIntent(R.id.widget_title, openAppIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}