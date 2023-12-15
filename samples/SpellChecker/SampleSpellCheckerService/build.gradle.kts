plugins {
    id("com.android.application") version "8.2.0"
}

android {
    namespace = "com.example.android.samplespellcheckerservice"
    compileSdk = 34

    sourceSets.configureEach {
        setRoot(".")
        java.srcDir("src")
    }

    defaultConfig {
        applicationId = "com.example.android.samplespellcheckerservice"
        minSdk = 21
        targetSdk = 21
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    buildFeatures {
        viewBinding = true
    }
}
