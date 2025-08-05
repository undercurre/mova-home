package android.dreame.module.util;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;

/**
 * author: sunzhibin
 * e-mail: sunzhibin@dreame.tech
 * desc: 作用描述
 * date: 2021/4/16 10:09
 * version: 1.0
 */
@RunWith(JUnit4.class)
public class CommonUtilTest {

    @Test
    public void isContainChinese() {
        String content = "~！@#￥%……&*（）——+";
        boolean containChinese = CommonUtil.isContainChinese(content);
        System.out.println("isContainChinese：" + containChinese + " content: " + content);

        content = "我的天";
        containChinese = CommonUtil.isContainChinese(content);
        System.out.println("isContainChinese：" + containChinese + " content: " + content);
    }

    @Test
    public void isVerifyPwd() {
        // 密码格式，字母大小写、数字、部分特殊字符
        String content = "!@#%*+=_/\\";
        boolean containChinese = CommonUtil.isVerifyPwd(content);
        Assert.assertFalse(containChinese);
        System.out.println("isVerifyPwd：" + containChinese + " content: " + content);

        content = "q!@#%*+=_/\\";
        containChinese = CommonUtil.isVerifyPwd(content);
        Assert.assertTrue(containChinese);
        System.out.println("isVerifyPwd：" + containChinese + " content: " + content);

        content = "a!@#%*+=_/\\";
        containChinese = CommonUtil.isVerifyPwd(content);
        Assert.assertTrue(containChinese);
        System.out.println("isVerifyPwd：" + containChinese + " content: " + content);

        content = "88888888";
        containChinese = CommonUtil.isVerifyPwd(content);
        Assert.assertFalse(containChinese);
        System.out.println("isVerifyPwd：" + containChinese + " content: " + content);

        content = "aaaaaaa";
        containChinese = CommonUtil.isVerifyPwd(content);
        Assert.assertFalse(containChinese);
        System.out.println("isVerifyPwd：" + containChinese + " content: " + content);

        content = "aaaaaaabb";
        containChinese = CommonUtil.isVerifyPwd(content);
        Assert.assertFalse(containChinese);
        System.out.println("isVerifyPwd：" + containChinese + " content: " + content);


    }

    @Test
    public void calculateContentLength() {
    }
}