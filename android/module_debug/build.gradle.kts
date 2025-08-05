import com.android.build.gradle.internal.cxx.configure.parseCmakeCommandLine

buildscript {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
        jcenter()
    }
    val kotlin_version = "1.4.32"
    dependencies {
        classpath("io.github.didi.dokit:dokitx-plugin:3.7.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
//        classpath ("com.bytedance.btrace:rhea-gradle-plugin:1.0.2")
    }
}

plugins {
    id("com.android.library")
}
apply {
    plugin("com.didi.dokit")
}
apply(from = "./dokit.gradle")

android {
//    compileSdkVersion = 30
    compileSdkVersion(30)
    defaultConfig {
        minSdkVersion(21)
        targetSdkVersion(30)

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
//        consumerProguardFiles = "consumer-rules.pro"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}

dependencies {

    implementation("androidx.appcompat:appcompat:1.3.0")
    implementation("com.google.android.material:material:1.4.0")
    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.3")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.4.0")
    // 检测工具
    debugImplementation("com.squareup.leakcanary:leakcanary-android:2.9.1")
//    debugImplementation("com.bytedance.btrace:rhea-core:1.0.2-SNAPSHOT")
//    debugImplementation "com.bytedance.btrace:rhea-core:1.0.2"
//    debugImplementation("com.iqiyi.xcrash:xcrash-android-lib:3.1.0")
//    debugImplementation("com.github.bytedance:memory-leak-detector:0.1.8")
    debugImplementation(project(":module-common"))
    implementation("androidx.tracing:tracing-ktx:1.1.0")


    val lastversion = "3.7.1"
    //核心模块
    debugImplementation("io.github.didi.dokit:dokitx:${lastversion}") {
//        exclude group: "me.weishu"
//        exclude group: "com.android.volley"
    }
    //文件同步模块
    debugImplementation("io.github.didi.dokit:dokitx-ft:${lastversion}") {
//        exclude group: "me.weishu"
//        exclude group: "com.android.volley"
    }
    //一机多控模块
    debugImplementation("io.github.didi.dokit:dokitx-mc:${lastversion}") {
//        exclude group: "me.weishu"
//        exclude group: "com.android.volley"
    }
    //weex模块
    debugImplementation("io.github.didi.dokit:dokitx-weex:${lastversion}") {
//        exclude group: "me.weishu"
//        exclude group: "com.android.volley"
    }
    //no-op 模块
    releaseImplementation("io.github.didi.dokit:dokitx-no-op:${lastversion}")
//    debugImplementation ("com.github.tiann:epic:0.11.2")
    implementation("com.github.allenymt:PrivacySentry:0.0.7")
}

