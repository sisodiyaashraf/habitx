allprojects {
    repositories {
        google()
        mavenCentral()
    }
    configurations.all {
        resolutionStrategy {
            force("androidx.glance:glance-appwidget:1.1.1")
            force("androidx.glance:glance:1.1.1")
            force("androidx.glance:glance-material3:1.1.1")
        }
    }
}

// 1. Define the build directory path (relative to the 'android' folder)
val rootBuildDir = File(rootProject.projectDir, "../build")

// 2. Apply the redirected build directory to all subprojects
subprojects {
    val subprojectBuildDir = File(rootBuildDir, project.name)
    project.layout.buildDirectory.value(project.layout.dir(provider { subprojectBuildDir }))
}

subprojects {
    project.evaluationDependsOn(":app")
}

// 3. Update the clean task to point to the new location
tasks.register<Delete>("clean") {
    delete(rootBuildDir)
}