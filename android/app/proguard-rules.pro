# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.kts.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# 精心配方 https://github.com/king-ma1993/AndroidProguadRules
# 指定混淆时采用的字典文件 https://blog.csdn.net/cuckoosusu/article/details/137602997
-obfuscationdictionary proguard-rules-dict.txt
-classobfuscationdictionary proguard-rules-dict.txt
-packageobfuscationdictionary proguard-rules-dict.txt
# 精心配方

# 代码混淆压缩比，在0~7之间，默认为5，一般不做修改
-optimizationpasses 5

# 混合时不使用大小写混合，混合后的类名为小写
-dontusemixedcaseclassnames

# 指定不去忽略非公共库的类
-dontskipnonpubliclibraryclasses

# 这句话能够使我们的项目混淆后产生映射文件
# 包含有类名->混淆后类名的映射关系
-verbose

# 指定不去忽略非公共库的类成员
-dontskipnonpubliclibraryclassmembers

# 不做预校验，preverify是proguard的四个步骤之一，Android不需要preverify，去掉这一步能够加快混淆速度。
-dontpreverify

# 保留Annotation不混淆
-keepattributes *Annotation*,InnerClasses

# 避免混淆泛型
-keepattributes Signature

# 抛出异常时保留代码行号
-keepattributes LineNumberTable

-keepattributes *Annotation*,InnerClasses,Signature,EnclosingMethod # 避免混淆注解、内部类、泛型、匿名类
# 指定混淆是采用的算法，后面的参数是一个过滤器
# 这个过滤器是谷歌推荐的算法，一般不做更改
-optimizations !code/simplification/cast,!field/*,!class/merging/*

#############################################
#
# Android开发中一些需要保留的公共部分
#
#############################################
# 保留我们使用的四大组件，自定义的Application等等这些类不被混淆
# 因为这些子类都有可能被外部调用
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Fragment
-keep public class * extends androidx.activity.ComponentActivity
-keep public class * extends androidx.core.app.ComponentActivity
-keep public class * extends androidx.fragment.app.Fragment
-keep public class * extends androidx.fragment.app.FragmentActivity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference

-keep class com.google.android.material.** {*;}
-keep class androidx.** {*;}
-keep class androidx.activity.** {*;}
-keep public class * extends androidx.**
-keep interface androidx.** {*;}
-keep enum androidx.** {*;}
-dontwarn com.google.android.material.**
-dontnote com.google.android.material.**
-dontwarn androidx.**

# 保留R下面的资源
-keep class **.R$* {*;}

# 保留本地native方法不被混淆
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep class com.dreame.smartlife.tools.FFmpegCmd{
    *;
}
# 保留在Activity中的方法参数是view的方法，
# 这样以来我们在layout中写的onClick就不会被影响
-keepclassmembers class * extends android.app.Activity{
    public void *(android.view.View);
}

#保留枚举类不被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保留我们自定义控件（继承自View）不被混淆
-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    *** is*();
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# 保留Parcelable序列化类不被混淆
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# 保留Serializable序列化的类不被混淆
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# 对于带有回调函数的onXXEvent、**On*Listener的，不能被混淆
-keepclassmembers class * {
    void *(**On*Event);
    void *(**On*Listener);
}

# webView处理，项目中没有使用到webView忽略即可
-keepclassmembers class android.webkit.WebView {
    public *;
}
-keepclassmembers class * extends android.webkit.WebViewClient{
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}

#实体类不能被混淆
-keep class android.dreame.module.bean.**{*;}
-keep class android.dreame.module.dto.**{*;}
-keep class com.dreame.smartlife.entry.*{*;}
-keep class android.dreame.module.data.entry.**{*;}
-keep class android.dreame.module.exception.**{*;}
-keep class android.dreame.module.data.Result{*;}
-keep class android.dreame.module.data.network.HttpResult{*;}
-keep class com.dreame.smartlife.common.model.push.**{*;}

#RN相关
-keep class * implements com.facebook.react.bridge.JavaScriptModule { *; }
-keep class * implements com.facebook.react.bridge.NativeModule { *; }
-keep class * extends com.facebook.react.bridge.BaseJavaModule { *; }
-keep class * implements com.facebook.react.ReactPackage { *; }

-keepclassmembers,includedescriptorclasses class * { native <methods>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.UIProp <fields>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.annotations.ReactProp <methods>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.annotations.ReactPropGroup <methods>; }

#-keep class com.facebook.** { *; }
#-dontwarn com.facebook.react.**

#MQTT
-keep class org.eclipse.paho.client.mqttv3.**{*;}
-keep class com.dreame.smartlife.shadow.**{*;}

#-----------处理第三方依赖库---------

# react native相关包
-dontwarn com.facebook.**
-keep class com.facebook.** { *; }
-keep class android.dreame.module.rn.preload.** { *; }

# Retrofit混淆
-keep class retrofit2.** { *; }
# Retrofit does reflection on generic parameters. InnerClasses is required to use Signature and
# EnclosingMethod is required to use InnerClasses.
-keepattributes  EnclosingMethod

# Retrofit does reflection on method and parameter annotations.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations

# Retain service method parameters when optimizing.
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# Ignore annotation used for build tooling.
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Ignore JSR 305 annotations for embedding nullability information.
-dontwarn javax.annotation.**

# Guarded by a NoClassDefFoundError try/catch and only used when on the classpath.
-dontwarn kotlin.Unit

# Top-level functions that can only be used by Kotlin.
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*

# With R8 full mode, it sees no subtypes of Retrofit interfaces since they are created with a Proxy
# and replaces all potential values with null. Explicitly keeping the interfaces prevents this.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>

#### Okhttp3
# JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**

# A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*

# OkHttp platform used only on JVM and when Conscrypt dependency is available.
-dontwarn okhttp3.internal.platform.ConscryptPlatform
-dontwarn org.conscrypt.ConscryptHostnameVerifier

#### okio
# Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*

# Glide
-keep class com.bumptech.glide.** { *; }
-keepnames class com.bumptech.glide.** { *; }
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class * extends com.bumptech.glide.module.AppGlideModule {
 <init>(...);
}
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
-keep class com.bumptech.glide.load.data.ParcelFileDescriptorRewinder$InternalRewinder {
  *** rewind();
}

# eventbus--------------------------------start
-keepclassmembers class * {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# Only required if you use AsyncExecutor
-keepclassmembers class * extends org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}
-keep class dreame.module.event.**{*;}
-keep class org.greenrobot.eventbus.** { *; }
# eventbus---------------------------------end

# BaseRecyclerViewAdapterHelper--------------------------------start
-keep class com.chad.library.adapter.** {
*;
}
-keep public class * extends com.chad.library.adapter.base.BaseQuickAdapter
-keep public class * extends com.chad.library.adapter.base.viewholder.BaseViewHolder
-keepclassmembers  class **$** extends com.chad.library.adapter.base.viewholder.BaseViewHolder {
     <init>(...);
}
# BaseRecyclerViewAdapterHelper---------------------------------end

# UMeng sdk---------------------------------start
-dontwarn com.umeng.**
-dontwarn com.taobao.**
-dontwarn anet.channel.**
-dontwarn anetwork.channel.**
-dontwarn org.android.**
-dontwarn org.apache.thrift.**
-dontwarn com.xiaomi.**
-dontwarn com.huawei.**
-dontwarn com.meizu.**

-keep class com.taobao.** {*;}
-keep class org.android.** {*;}
-keep class anet.channel.** {*;}
-keep class anetwork.channel.** {*;}
-keep class com.umeng.** {*;}
-keep class com.xiaomi.** {*;}
-keep class com.huawei.** {*;}
-keep class com.meizu.** {*;}
-keep class org.apache.thrift.** {*;}

-keep class com.alibaba.sdk.android.**{*;}
-keep class com.ut.**{*;}
-keep class com.ta.**{*;}
-keep class com.uc.* {*;}

-keep public class **.R$*{
   public static final int *;
}
# UMeng sdk---------------------------------end

# 友盟分享---------------------------------start
-dontshrink
-dontoptimize
-dontwarn com.google.android.maps.**
-dontwarn android.webkit.WebView
-dontwarn com.umeng.**
-dontwarn com.tencent.weibo.sdk.**
-dontwarn com.facebook.**
-keep public class javax.**
-keep public class android.webkit.**
-dontwarn android.support.v4.**
-keep enum com.facebook.**
-keepattributes Exceptions

-keep public interface com.facebook.**
-keep public interface com.tencent.**
-keep public interface com.umeng.socialize.**
-keep public interface com.umeng.socialize.sensor.**
-keep public interface com.umeng.scrshot.**

-keep public class com.umeng.socialize.* {*;}

-keep class com.umeng.** {*;}
-keep class com.facebook.**
-keep class com.facebook.** {*;}
-keep class com.umeng.scrshot.**
-keep public class com.tencent.** {*;}
-keep class com.umeng.socialize.sensor.**
-keep class com.umeng.socialize.handler.**
-keep class com.umeng.socialize.handler.*
-keep class com.umeng.weixin.handler.**
-keep class com.umeng.weixin.handler.*
-keep class com.umeng.qq.handler.**
-keep class com.umeng.qq.handler.*
-keep class UMMoreHandler{*;}
-keep class com.tencent.mm.sdk.modelmsg.WXMediaMessage {*;}
-keep class com.tencent.mm.sdk.modelmsg.** implements com.tencent.mm.sdk.modelmsg.WXMediaMessage$IMediaObject {*;}
-keep class im.yixin.sdk.api.YXMessage {*;}
-keep class im.yixin.sdk.api.** implements im.yixin.sdk.api.YXMessage$YXMessageData{*;}
-keep class com.tencent.mm.sdk.** {
   *;
}
-keep class com.tencent.mm.opensdk.** {
   *;
}
-keep class com.tencent.wxop.** {
   *;
}
-keep class com.tencent.mm.sdk.** {
   *;
}

-keep class com.twitter.** { *; }

-keep class com.tencent.** {*;}
-dontwarn com.tencent.**
-keep class com.kakao.** {*;}
-dontwarn com.kakao.**
-keep public class com.umeng.com.umeng.soexample.R$*{
    public static final int *;
}
-keep public class com.linkedin.android.mobilesdk.R$*{
    public static final int *;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep class com.tencent.open.TDialog$*
-keep class com.tencent.open.TDialog$* {*;}
-keep class com.tencent.open.PKDialog
-keep class com.tencent.open.PKDialog {*;}
-keep class com.tencent.open.PKDialog$*
-keep class com.tencent.open.PKDialog$* {*;}
-keep class com.umeng.socialize.impl.ImageImpl {*;}
-keep class com.sina.** {*;}
-dontwarn com.sina.**
-keep class  com.alipay.share.sdk.** {
   *;
}

-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

-keep class com.linkedin.** { *; }
-keep class com.android.dingtalk.share.ddsharemodule.** { *; }
# 友盟分享---------------------------------end

-keep class com.blanke.xsocket.udp.client.XUdp{
    *;
}


#------------------友盟start
-dontwarn com.umeng.**
-dontwarn com.taobao.**
-dontwarn anet.channel.**
-dontwarn anetwork.channel.**
-dontwarn org.android.**
-dontwarn org.apache.thrift.**
-dontwarn com.xiaomi.**
-dontwarn com.huawei.**
-dontwarn com.meizu.**

-keep class com.taobao.** {*;}
-keep class org.android.** {*;}
-keep class anet.channel.** {*;}
-keep class com.umeng.** {*;}
-keep class com.xiaomi.** {*;}
-keep class com.huawei.** {*;}
-keep class com.meizu.** {*;}
-keep class org.apache.thrift.** {*;}

-keep class com.alibaba.sdk.android.**{*;}
-keep class com.ut.**{*;}
-keep class com.ta.**{*;}

-keep public class **.R$*{
   public static final int *;
}
#------------------------友盟end

#------------------高斯模糊start
-keep class android.support.v8.renderscript.** { *; }
-keep class androidx.renderscript.** { *; }
#------------------高斯模糊start


# hacklibrary
-keep class com.dreame.hacklibrary.**{*;}

# j2v8
-keep class com.eclipsesource.** { *; }
# toast、xxpermision
-keep class com.hjq.**{*;}
# okdownload
-keep class com.liulishuo.okdownload.** { *; }
# libphonenumber
-keep class io.michaelrocks.libphonenumber.android.** { *; }
# luban
-keep class top.zibin.luban.** { *; }
#lottie
-keep class com.airbnb.lottie.** { *; }
-keep class com.airbnb.android.react.lottie.** { *; }
 # logan
-keep class com.dianping.logan.** { *; }
 # anchors
-keep class com.effective.android.anchors.** { *; }
 # photoview
-keep class com.github.chrisbanes.photoview.** { *; }
# ucrop
-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }
# mp4parser
-keep class org.mp4parser.aspectj.** { *; }
-keep class com.googlecode.mp4parser.** { *; }

# wificonnector
-keep class com.jflavio1.wificonnector.** { *; }
# xsocket
-keep class com.blanke.xsocket.** { *; }
# swipe
-keep class com.daimajia.swipe.** { *; }
# swipe
-keep class de.hdodenhof.circleimageview.** { *; }

# rn 依赖 start
# agora
-keep class io.agora.**{*;}
# swipe
-keep class io.agora.**{*;}
# blurview
-keep class com.cmcewen.blurview.**{*;}
# blurview
-keep class com.cmcewen.blurview.**{*;}
# netinfo  viewpager webview
-keep class com.reactnativecommunity.**{*;}
# orientation
-keep class com.github.yamill.orientation.**{*;}
# safe-area-context
-keep class com.th3rdwave.safeareacontext.**{*;}
# svg
-keep class com.horcrux.svg.**{*;}
# svg
-keep class com.oblador.vectoricons.**{*;}

# rn 依赖 end

# matisse
-dontwarn com.squareup.picasso.**
-keep class com.zhihu.matisse.** { *; }

#ijkplayer
-keep class tv.danmaku.ijk.media.** {*;}
-keep class tv.danmaku.ijk.media.player.** {*;}
-keep class tv.danmaku.ijk.media.player.IjkMediaPlayer{*;}
-keep class tv.danmaku.ijk.media.player.ffmpeg.FFmpegApi{*;}

# butterknife
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewBinder { *; }

-keepclasseswithmembernames class * {
    @butterknife.* <fields>;
}

-keepclasseswithmembernames class * {
    @butterknife.* <methods>;
}

# Gson
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
# Application classes that will be serialized/deserialized over Gson 下面替换成自己的实体类
-keep class com.google.gson.** { *; }

#----------- rxjava rxandroid----------------
-dontwarn sun.misc.**
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
    long producerIndex;
    long consumerIndex;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}
-dontnote rx.internal.util.PlatformDependent

# 查漏
# BaseRecyclerViewAdapterHelper
#-keep class com.chad.library.** { *; }
#-keepnames class com.chad.library.** { *; }

-keep class com.coremedia.iso.** { *; }

-keep class com.mp4parser.** { *; }
-keep class io.reactivex.** { *; }
-keep class okio.** { *; }
-keep class it.sephiroth.android.library.easing.** { *; }
-keep class it.sephiroth.android.library.imagezoom.** { *; }
-keep class org.aspectj.** { *; }
-keep class org.intellij.lang.annotations.** { *; }
-keep class org.jetbrains.annotations.** { *; }
-keep class org.reactivestreams.** { *; }
-keep class org.repackage.** { *; }
-keep class org.webkit.androidjsc.** { *; }
-keep class org.android.netutil.** { *; }
-keep class kotlinx.android.** { *; }
-keep class kbuild.** { *; }

#小米推送
-keep class org.android.agoo.xiaomi.MiPushBroadcastReceiver {*;}
 -keep class com.dreame.mixpush.manufacturer.xiaomi.MiUiMessageReceiver {*;}
-dontwarn com.xiaomi.push.**
#华为推送
-ignorewarnings
-keepattributes *Annotation*, Exceptions, InnerClasses, Signature, SourceFile, LineNumberTable
-keep class com.hianalytics.android.** {*;}
-keep class com.huawei.updatesdk.** {*;}
-keep class com.huawei.hms.** {*;}
#魅族推送
-keep class com.meizu.cloud.** {*;}
-dontwarn com.meizu.cloud.**
#vivo推送
-dontwarn com.vivo.push.**
-keep class com.vivo.push.** {*;}
-keep class com.vivo.vms.** {*;}

#ViewBinding 反射
-keepclassmembers class * implements androidx.viewbinding.ViewBinding {
    public static ** inflate(...);
    public static ** bind(***);
 }

-keep class com.dreame.dreamecommlib.data.**

#pdfview
-keep class com.github.barteksc.**
#popupWindow
-dontwarn razerdp.basepopup.**
-keep class razerdp.basepopup.**{*;}

-keep class androidx.core.app.CoreComponentFactory { *; }

#微信
-keep class com.tencent.mm.opensdk.** {
    *;
}
-keep class com.tencent.wxop.** {
    *;
}
-keep class com.tencent.mm.sdk.** {
    *;
}

#Zendesk SDK
# Core SDK
-keep class zendesk.core.** { *; }

# Gson
-keep class sun.misc.Unsafe { *; }

# Okio
-dontwarn okio.**

# Retrofit
-dontwarn retrofit2.Platform**

# Dagger
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue

# OkHttp3: https://github.com/square/okhttp/blob/master/okhttp/src/main/resources/META-INF/proguard/okhttp3.pro
## JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**

## A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

## Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*

## OkHttp platform used only on JVM and when Conscrypt dependency is available.

# Core SDK
-keep class zendesk.core.** { *; }

# Gson
-keep class sun.misc.Unsafe { *; }

# Okio
-dontwarn okio.**

# Retrofit
-dontwarn retrofit2.Platform**

# Dagger
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue

# OkHttp3: https://github.com/square/okhttp/blob/master/okhttp/src/main/resources/META-INF/proguard/okhttp3.pro
## JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**

## A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

## Animal Sniffer compileOnly dependency to ensure APIs are compatible with older versions of Java.
-dontwarn org.codehaus.mojo.animal_sniffer.*

## OkHttp platform used only on JVM and when Conscrypt dependency is available.
-dontwarn okhttp3.internal.platform.ConscryptPlatform

# Guide Main Screen
-keep class zendesk.support.HelpCenterSettings { *; }
-keep class zendesk.support.HelpResponse { *; }
-keep class zendesk.support.ArticlesListResponse { *; }
-keep class zendesk.support.CategoryItem { *; }
-keep class zendesk.support.SectionItem { *; }
-keep class zendesk.support.ArticleItem { *; }
-keep class zendesk.support.SeeAllArticlesItem { *; }
-keep class zendesk.support.guide.HelpCenterActivity { *; }

# Guide Search Results
-keep class zendesk.support.guide.HelpSearchFragment { *; }
-keep class zendesk.support.ArticlesSearchResponse { *; }
-keep class zendesk.support.SearchArticle { *; }
-keep class zendesk.support.guide.HelpSearchRecyclerViewAdapter { *; }
-keep class zendesk.support.HelpCenterSearch { *; }
-keep class zendesk.support.Category { *; }
-keep class zendesk.support.Section { *; }
-keep class zendesk.support.Article { *; }

# Guide View Article
-keep class zendesk.support.guide.ArticleViewModel { *; }
-keep class zendesk.support.guide.ArticleConfiguration { *; }
-keep class zendesk.support.guide.ViewArticleActivity { *; }
-keep class zendesk.support.ArticleResponse { *; }
-keep class zendesk.support.ArticleVote { *; }
-keep class zendesk.support.ArticleVoteResponse { *; }
-keep class zendesk.support.ZendeskArticleVoteStorage { *; }
-keep class zendesk.support.AttachmentResponse { *; }
-keep class zendesk.support.HelpCenterAttachment { *; }

# Support Requests (Create, Update, List)
-keep class zendesk.support.request.** { *; }
-keep class zendesk.support.requestlist.** { *; }
-keep class zendesk.support.SupportSdkSettings { *; }
-keep class zendesk.support.Request { *; }
-keep class zendesk.support.CreateRequest { *; }
-keep class zendesk.support.Comment { *; }
-keep class zendesk.support.CommentResponse { *; }
-keep class zendesk.support.CommentsResponse { *; }
-keep class zendesk.support.EndUserComment { *; }
-keep class zendesk.support.ZendeskRequestStorage { *; }
-keep class zendesk.support.ZendeskRequestProvider { *; }
-keep class zendesk.support.CreateRequestWrapper { *; }
-keep class zendesk.support.UpdateRequestWrapper { *; }
-keep class zendesk.support.RequestsResponse { *; }
-keep class zendesk.support.RequestResponse { *; }

# Support Attachments
-keep class zendesk.support.UploadResponse { *; }
-keep class zendesk.support.UploadResponseWrapper { *; }
-keep class zendesk.support.ZendeskUploadProvider { *; }
-keep class zendesk.support.Attachment { *; }


-keep class com.shuyu.gsyvideoplayer.video.** { *; }
-dontwarn com.shuyu.gsyvideoplayer.video.**
-keep class com.shuyu.gsyvideoplayer.video.base.** { *; }
-dontwarn com.shuyu.gsyvideoplayer.video.base.**
-keep class com.shuyu.gsyvideoplayer.utils.** { *; }
-dontwarn com.shuyu.gsyvideoplayer.utils.**
-keep class tv.danmaku.ijk.** { *; }
-dontwarn tv.danmaku.ijk.**

-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, java.lang.Boolean);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keep class com.shockwave.**

-keep public class com.alibaba.android.arouter.routes.**{*;}
-keep public class com.alibaba.android.arouter.facade.**{*;}
-keep class * implements com.alibaba.android.arouter.facade.template.ISyringe{*;}

# 如果使用了 byType 的方式获取 Service，需添加下面规则，保护接口
-keep interface * implements com.alibaba.android.arouter.facade.template.IProvider

# 如果使用了 单类注入，即不定义接口实现 IProvider，需添加下面规则，保护实现
# -keep class * implements com.alibaba.android.arouter.facade.template.IProvider

-keep public class com.alibaba.android.arouter.routes.**{*;}
-keep public class com.alibaba.android.arouter.facade.**{*;}
-keep class * implements com.alibaba.android.arouter.facade.template.ISyringe{*;}

# 如果使用了 byType 的方式获取 Service，需添加下面规则，保护接口
-keep interface * implements com.alibaba.android.arouter.facade.template.IProvider

# 如果使用了 单类注入，即不定义接口实现 IProvider，需添加下面规则，保护实现
# -keep class * implements com.alibaba.android.arouter.facade.template.IProvider

-keep public class com.alibaba.android.arouter.routes.**{*;}
-keep public class com.alibaba.android.arouter.facade.**{*;}
-keep class * implements com.alibaba.android.arouter.facade.template.ISyringe{*;}

# 如果使用了 byType 的方式获取 Service，需添加下面规则，保护接口
-keep interface * implements com.alibaba.android.arouter.facade.template.IProvider

# 如果使用了 单类注入，即不定义接口实现 IProvider，需添加下面规则，保护实现
# -keep class * implements com.alibaba.android.arouter.facade.template.IProvider


-dontwarn com.tencent.bugly.**
-keep public class com.tencent.bugly.**{*;}

-keep class com.taobao.weex.** { *; }
-keep class io.dcloud.feature.** { *; }


## ----------------------------------
##      sobot相关
## ----------------------------------
-keep class com.sobot.** {*;}

## ----------------------------------
##      Glide相关
## ----------------------------------
-keep class com.bumptech.glide.Glide { *; }
-keep class com.bumptech.glide.request.RequestOptions {*;}
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
-dontwarn com.bumptech.glide.**

#vivo push
-dontwarn com.vivo.push.**
-keep class com.vivo.push.**{*; }
-keep class com.vivo.vms.**{*; }
-keep class com.dreame.mixpush.manufacturer.vivo.PushMessageReceiver {*;}

#oppo push
-keep class com.heytap.omas.** { *;}
-keep class com.heytap.msp.** { *;}

#ximi push
-keep class com.dreame.mixpush.manufacturer.xiaomi.MiUiMessageReceiver {*;}
# pag
-keep class org.libpag.**{*;}

-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
