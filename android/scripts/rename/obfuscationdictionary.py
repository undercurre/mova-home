# coding=utf-8
import os
import pprint
import random
import io


# NEED_GENERAL_LAGNUGAE = ["i", "I", "i", "I", "l", "L"]
NEED_GENERAL_LAGNUGAE = ["o", "O", "o", "O", "0"]

LENGTH = 6000
RES_PATH = "/Users/sunzhibin/Projects/AndroidProjects/mova-home/android/app/"
FILE_NAME = "output_dict.txt"
folder = os.path.exists(RES_PATH)
if not folder:
    os.makedirs(RES_PATH)
count = 0
repeatCount = 0
list = []
while count < LENGTH:
    width = random.randint(1, 8) + 4
    i = 0
    count += 1
    # 用来区分渠道的 text ,传入 相关的 text
    temp = ""
    while i < width:
        i += 1
        temp = temp + random.choice(NEED_GENERAL_LAGNUGAE)
    print("当前字母: %s" % temp)
    if temp in list:
        repeatCount += 1
        print("重复字母: %s" % temp)
        if repeatCount == 1000:
            print("连续重复次数超过1000次 已达到最大行数 无法继续生成")
            break
    else:
        list.append(temp)
        repeatCount = 0
f = io.open(RES_PATH + FILE_NAME, "w", encoding="utf-8")
for index in range(len(list)):
    txt = list[index]
    # print("写入字母: %s" % txt)
    f.write(txt)
    f.write("\n")
f.close()
print("写入完成: %s" % list.__len__())
