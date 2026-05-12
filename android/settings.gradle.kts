pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // UPDATED: AGP 8.9.1 is required for SDK 36 compatibility in 2026
    id("com.android.application") version "8.9.1" apply false

    // UPDATED: Kotlin 2.1.0 is the minimum stable requirement for modern Flutter builds
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")