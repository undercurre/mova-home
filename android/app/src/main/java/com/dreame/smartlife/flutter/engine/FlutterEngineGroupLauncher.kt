package com.dreame.smartlife.flutter.engine

import android.content.Context
import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor

enum class FlutterEngineId(val id: String) {
    MAIN("main"), SUB("sub")
}

object FlutterEngineGroupLauncher {

    private lateinit var _flutterEngineGroup: FlutterEngineGroup

    private val engineGroup: FlutterEngineGroup
        get() {
            preLoadDartVM(LocalApplication.getInstance())
            return _flutterEngineGroup
        }

    fun preLoadDartVM(applicationContext: Context) {
        if (!this::_flutterEngineGroup.isInitialized) {
            LogUtil.d("sunzhibin", "preLoadDartVM: --------- startInitialization  -----")
            _flutterEngineGroup = FlutterEngineGroup(applicationContext)
            LogUtil.d("sunzhibin", "preLoadDartVM: --------- endInitialization  -----")
        }
    }

    fun createFlutterEngine(
        context: Context,
        initialRoute: String,
        dartEntrypointArgs: List<String>,
        entryPoint: String = "main"
    ): FlutterEngine {
        val engine = engineGroup.createAndRunEngine(
            FlutterEngineGroup.Options(context).apply {
                this.initialRoute = initialRoute
                this.dartEntrypoint =
                    DartExecutor.DartEntrypoint(FlutterInjector.instance().flutterLoader().findAppBundlePath(), entryPoint)
                this.dartEntrypointArgs = dartEntrypointArgs
            },
        )

        return engine
    }
}