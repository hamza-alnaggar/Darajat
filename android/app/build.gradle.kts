plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.learning_management_system"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = "27.0.12077973"

    compileOptions {
        // CORRECTED: Use Kotlin DSL property name
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.learning_management_system"
        minSdk = flutter.minSdkVersion.toInt()
        targetSdk = flutter.targetSdkVersion.toInt()
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName.toString()
        
        // Enable multidex
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Add desugaring dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    
    // Add multidex support
    implementation("androidx.multidex:multidex:2.0.1")


    
    // Add Flutter dependencies
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
    implementation("com.google.firebase:firebase-messaging:23.4.1")
}

flutter {
    source = "../.."
}