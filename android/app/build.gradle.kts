plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.my_app"  // ✅ Tambahkan namespace (Wajib)
    compileSdk = 35  // Use compileSdkVersion that is compatible (update to version 33 or later if needed)

    defaultConfig {
        applicationId = "com.example.my_app"
        minSdk = 21
        targetSdk = 35  // Ensure the targetSdk is compatible with your project
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false  // Pastikan `minifyEnabled` tetap false
            isShrinkResources = false  // Nonaktifkan shrinkResources
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
}

flutter {
    source = "../.."
}
