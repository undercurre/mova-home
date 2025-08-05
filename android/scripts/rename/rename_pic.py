import os
import re

# 指定 Flutter 项目的根目录
project_root = '/Users/sunzhibin/Projects/AndroidProjects/mova-home/flutter_plugin'

# 遍历 assets 目录下的所有文件
def replace_image_names(directory):
  for root, dirs, files in os.walk(os.path.join(directory, 'assets')):
     for file in files:
        if file.endswith('.png') or file.endswith('.jpg') or file.endswith('.jpeg'):
            if file.startswith('mova_'):
                 break;
            # 构建新的文件名
            new_filename = f'mova_{file}'
            # 获取文件的原始路径和新路径
            old_path = os.path.join(root, file)
            new_path = os.path.join(root, new_filename)
            old_name = file[0:-4]
            new_name = new_filename[0:-4]
        
            # 重命名文件
            os.rename(old_path, new_path)
            # 遍历 Dart 源代码文件,替换图片资源名称
            replace_image_references(directory,old_name,new_name )
      


def replace_image_references(directory,old_name,new_name):
    """
    替换代码中对应的图片资源引用
    """
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".dart"):
                file_path = os.path.join(root, file)
                with open(file_path, "r") as f:
                    content = f.read()
                new_content = content.replace(old_name,new_name)
                new_content = new_content.replace('mova_'+new_name,new_name)

                if new_content != content :
                    with open(file_path, "w") as f:
                        f.write(new_content)
                    # print(f"Updated references in {file_path}  {content} {new_content}")


# 开始执行脚本
print(f"开始执行脚本")
replace_image_names(project_root)