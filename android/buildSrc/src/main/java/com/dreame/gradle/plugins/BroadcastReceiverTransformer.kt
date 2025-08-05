package com.dreame.gradle.plugins

import com.didiglobal.booster.kotlinx.asIterable
import com.didiglobal.booster.kotlinx.touch
import com.didiglobal.booster.transform.TransformContext
import com.didiglobal.booster.transform.asm.ClassTransformer
import com.google.auto.service.AutoService
import groovyjarjarasm.asm.Opcodes
import org.objectweb.asm.tree.ClassNode
import org.objectweb.asm.tree.MethodInsnNode
import org.objectweb.asm.tree.MethodNode
import java.io.PrintWriter

@AutoService(ClassTransformer::class)
class BroadcastReceiverTransformer : ClassTransformer {

    private lateinit var logger: PrintWriter


    override fun onPreTransform(context: TransformContext) {
        this.logger = getReport(context, "report.txt").touch().printWriter()
    }

    override fun onPostTransform(context: TransformContext) {
        this.logger.close()
    }

    override fun transform(
        context: TransformContext,
        klass: ClassNode,
    ): ClassNode {
        if (klass.name == "com/dreame/smartlife/shadow/ShadowBroadcastRegister"
            || klass.name.startsWith("android/support/multidex/")
            || klass.name.startsWith("androidx/multidex/")
            || klass.name.startsWith("androidx/core/")
            || klass.name.startsWith("android/content/")
            || klass.name.startsWith("android/os/")
            || klass.name.startsWith("com/android/")
            || klass.name.startsWith("android/app/")
        ) {
            return klass
        }
        klass.methods.forEach { method ->
            method.instructions?.iterator()?.asIterable()
                ?.filterIsInstance(MethodInsnNode::class.java)?.filter {
                    it.opcode == Opcodes.INVOKEVIRTUAL
                            && it.name == "registerReceiver"
                            && (it.desc == "(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;" ||
                            it.desc == "(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;")
                }?.forEach {
                    it.optimize(klass, method)
                }
        }
        return klass
    }

    private fun MethodInsnNode.optimize(klass: ClassNode, method: MethodNode) {
        println("BroadcastReceiverTransformer : optimize-------${klass.name},${method.name},${method.desc}")
        this.owner = "com/dreame/smartlife/shadow/ShadowBroadcastRegister"
        this.name = "registerReceiver"
        if (this.desc == "(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;") {
            this.desc =
                "(Landroid/content/Context;Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;"
        } else if (this.desc == "(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;") {
            this.desc =
                "(Landroid/content/Context;Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;)Landroid/content/Intent;"
        }
        this.opcode = Opcodes.INVOKESTATIC
        this.itf = false
    }
}