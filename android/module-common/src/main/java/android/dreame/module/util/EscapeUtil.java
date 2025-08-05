package android.dreame.module.util;

import static android.dreame.module.util.EscapeUtil.Finder.INDEX_NOT_FOUND;

import android.text.TextUtils;

import java.io.Serializable;

/**
 * 转义和反转义工具类Escape / Unescape<br>
 * escape采用ISO Latin字符集对指定的字符串进行编码。<br>
 * 所有的空格符、标点符号、特殊字符以及其他非ASCII字符都将被转化成%xx格式的字符编码(xx等于该字符在字符集表里面的编码的16进制数字)。
 * TODO 6.x迁移到core.text.escape包下
 *
 * @author xiaoleilu
 */

public class EscapeUtil {

    /**
     * 不转义的符号编码
     */
    private static final String NOT_ESCAPE_CHARS = "*@-_+./";
    private static final Filter<Character> JS_ESCAPE_FILTER = c -> false == (
            Character.isDigit(c)
                    || Character.isLowerCase(c)
                    || Character.isUpperCase(c)
                    || contains(NOT_ESCAPE_CHARS, c)
    );

    /**
     * 指定字符是否在字符串中出现过
     *
     * @param str        字符串
     * @param searchChar 被查找的字符
     * @return 是否包含
     * @since 3.1.2
     */
    public static boolean contains(CharSequence str, char searchChar) {
        return indexOf(str, searchChar) > -1;
    }


    /**
     * 指定范围内查找指定字符
     *
     * @param str        字符串
     * @param searchChar 被查找的字符
     * @return 位置
     */
    public static int indexOf(CharSequence str, char searchChar) {
        return indexOf(str, searchChar, 0);
    }

    /**
     * 指定范围内查找指定字符
     *
     * @param str        字符串
     * @param searchChar 被查找的字符
     * @param start      起始位置，如果小于0，从0开始查找
     * @return 位置
     */
    public static int indexOf(CharSequence str, char searchChar, int start) {
        if (str instanceof String) {
            return ((String) str).indexOf(searchChar, start);
        } else {
            return indexOf(str, searchChar, start, -1);
        }
    }

    /**
     * 指定范围内查找指定字符
     *
     * @param text       字符串
     * @param searchChar 被查找的字符
     * @param start      起始位置，如果小于0，从0开始查找
     * @param end        终止位置，如果超过str.length()则默认查找到字符串末尾
     * @return 位置
     */
    public static int indexOf(CharSequence text, char searchChar, int start, int end) {
        if (TextUtils.isEmpty(text)) {
            return INDEX_NOT_FOUND;
        }
        return new CharFinder(searchChar).setText(text).setEndIndex(end).start(start);
    }


    /**
     * Escape编码（Unicode）（等同于JS的escape()方法）<br>
     * 该方法不会对 ASCII 字母和数字进行编码，也不会对下面这些 ASCII 标点符号进行编码： * @ - _ + . / <br>
     * 其他所有的字符都会被转义序列替换。
     *
     * @param content 被转义的内容
     * @return 编码后的字符串
     */
    public static String escape(CharSequence content) {
        return escape(content, JS_ESCAPE_FILTER);
    }

    /**
     * Escape编码（Unicode）<br>
     * 该方法不会对 ASCII 字母和数字进行编码。其他所有的字符都会被转义序列替换。
     *
     * @param content 被转义的内容
     * @param filter  编码过滤器，对于过滤器中accept为false的字符不做编码
     * @return 编码后的字符串
     */
    public static String escape(CharSequence content, Filter<Character> filter) {
        if (TextUtils.isEmpty(content)) {
            return "";
        }

        final StringBuilder tmp = new StringBuilder(content.length() * 6);
        char c;
        for (int i = 0; i < content.length(); i++) {
            c = content.charAt(i);
            if (false == filter.accept(c)) {
                tmp.append(c);
            } else if (c < 256) {
                tmp.append("%");
                if (c < 16) {
                    tmp.append("0");
                }
                tmp.append(Integer.toString(c, 16));
            } else {
                tmp.append("%u");
                if(c <= 0xfff){
                    // issue#I49JU8@Gitee
                    tmp.append("0");
                }
                tmp.append(Integer.toString(c, 16));
            }
        }
        return tmp.toString();
    }


    /**
     * Escape解码
     *
     * @param content 被转义的内容
     * @return 解码后的字符串
     */
    public static String unescape(String content) {
        if (TextUtils.isEmpty(content)) {
            return "";
        }

        StringBuilder tmp = new StringBuilder(content.length());
        int lastPos = 0;
        int pos;
        char ch;
        while (lastPos < content.length()) {
            pos = content.indexOf("%", lastPos);
            if (pos == lastPos) {
                if (content.charAt(pos + 1) == 'u') {
                    ch = (char) Integer.parseInt(content.substring(pos + 2, pos + 6), 16);
                    tmp.append(ch);
                    lastPos = pos + 6;
                } else {
                    ch = (char) Integer.parseInt(content.substring(pos + 1, pos + 3), 16);
                    tmp.append(ch);
                    lastPos = pos + 3;
                }
            } else {
                if (pos == -1) {
                    tmp.append(content.substring(lastPos));
                    lastPos = content.length();
                } else {
                    tmp.append(content, lastPos, pos);
                    lastPos = pos;
                }
            }
        }
        return tmp.toString();
    }

    /**
     * 安全的unescape文本，当文本不是被escape的时候，返回原文。
     *
     * @param content 内容
     * @return 解码后的字符串，如果解码失败返回原字符串
     */
    public static String safeUnescape(String content) {
        try {
            return unescape(content);
        } catch (Exception e) {
            // Ignore Exception
        }
        return content;
    }

    public static interface Filter<T> {
        /**
         * 是否接受对象
         *
         * @param t 检查的对象
         * @return 是否接受对象
         */
        boolean accept(T t);
    }

    public static interface Finder {

        int INDEX_NOT_FOUND = -1;

        /**
         * 返回开始位置，即起始字符位置（包含），未找到返回-1
         *
         * @param from 查找的开始位置（包含）
         * @return 起始字符位置，未找到返回-1
         */
        int start(int from);

        /**
         * 返回结束位置，即最后一个字符后的位置（不包含）
         *
         * @param start 找到的起始位置
         * @return 结束位置，未找到返回-1
         */
        int end(int start);

        /**
         * 复位查找器，用于重用对象
         * @return this
         */
        default Finder reset(){
            return this;
        }
    }

    public static abstract class TextFinder implements Finder, Serializable {
        private static final long serialVersionUID = 1L;

        protected CharSequence text;
        protected int endIndex = -1;
        protected boolean negative;

        /**
         * 设置被查找的文本
         *
         * @param text 文本
         * @return this
         */
        public TextFinder setText(CharSequence text) {
            return this;
        }

        /**
         * 设置查找的结束位置<br>
         * 如果从前向后查找，结束位置最大为text.length()<br>
         * 如果从后向前，结束位置为-1
         *
         * @param endIndex 结束位置（不包括）
         * @return this
         */
        public TextFinder setEndIndex(int endIndex) {
            this.endIndex = endIndex;
            return this;
        }

        /**
         * 设置是否反向查找，{@code true}表示从后向前查找
         *
         * @param negative 结束位置（不包括）
         * @return this
         */
        public TextFinder setNegative(boolean negative) {
            this.negative = negative;
            return this;
        }

        /**
         * 获取有效结束位置<br>
         * 如果{@link #endIndex}小于0，在反向模式下是开头（-1），正向模式是结尾（text.length()）
         *
         * @return 有效结束位置
         */
        protected int getValidEndIndex() {
            if(negative && -1 == endIndex){
                // 反向查找模式下，-1表示0前面的位置，即字符串反向末尾的位置
                return -1;
            }
            final int limit;
            if (endIndex < 0) {
                limit = endIndex + text.length() + 1;
            } else {
                limit = Math.min(endIndex, text.length());
            }
            return limit;
        }
    }

    public static class CharFinder extends TextFinder {
        private static final long serialVersionUID = 1L;

        private final char c;
        private final boolean caseInsensitive;

        /**
         * 构造，不忽略字符大小写
         *
         * @param c 被查找的字符
         */
        public CharFinder(char c) {
            this(c, false);
        }

        /**
         * 构造
         *
         * @param c               被查找的字符
         * @param caseInsensitive 是否忽略大小写
         */
        public CharFinder(char c, boolean caseInsensitive) {
            this.c = c;
            this.caseInsensitive = caseInsensitive;
        }

        @Override
        public int start(int from) {
            final int limit = getValidEndIndex();
            if(negative){
                for (int i = from; i > limit; i--) {
                    if (equals(c, text.charAt(i), caseInsensitive)) {
                        return i;
                    }
                }
            } else{
                for (int i = from; i < limit; i++) {
                    if (equals(c, text.charAt(i), caseInsensitive)) {
                        return i;
                    }
                }
            }
            return -1;
        }

        @Override
        public int end(int start) {
            if (start < 0) {
                return -1;
            }
            return start + 1;
        }

        public static boolean equals(char c1, char c2, boolean caseInsensitive) {
            if (caseInsensitive) {
                return Character.toLowerCase(c1) == Character.toLowerCase(c2);
            }
            return c1 == c2;
        }
    }

    /**
     * 比较两个字符是否相同
     *
     * @param c1              字符1
     * @param c2              字符2
     * @param caseInsensitive 是否忽略大小写
     * @return 是否相同
     * @since 4.0.3
     */

}

