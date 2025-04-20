# Logisim2.7.1 免Java中文版

🌐 GitHub下载：https://github.com/SecondCat/Logisim-Chinese-version/releases/  \
🌐 百度网盘下载：https://pan.baidu.com/s/1pf_WyPBWxgVYrfXhNPAgBA?pwd=lw3y  \
🌐 开源链接：https://github.com/SecondCat/Logisim-Chinese-version/  \
🌐 Logisim官方网址（英文）：http://www.cburch.com/logisim/

⭐ 直接打开，不需要安装Java JRE！  \
⭐ 电路元件库中英双语对照！

提供中文版的 jar 文件、免安装版本exe和安装版本exe。  \
一般情况下，您只需下载Setup安装版本。

💻 系统支持（x64）：  \
Windows11，Windows10，Windows8，Windows7

⚠注意：  \
本项目不包含恶意代码，杀毒软件报警属于误报，可加入白名单解决。您如果担心安全性问题，可自行编译LogisimLauncher.exe启动器，启动器的代码和构建方法已在GitHub开源。

请遵循GPL开源协议（GNU GENERAL PUBLIC LICENSE Version 2, June 1991）。

📖 项目说明：  \
编译脚本使用gcc编译器，需要您的环境支持gcc编译器。您也可以使用其他的C编译器手动编译。

JRE是在JDK-15.0.1中提取的环境，仅包含logisim运行所必须的文件  \
LogisimLauncher.exe 是启动器，LogisimLauncher.c是它的源代码  \
logisim.jar为汉化版本，基于原作者 Carl Burch 发布的 logisim2.7.1

附：

已知问题：
 
·国际化选项卡中各语言选项均为英文。

添加中文语言资源方法：  \
1、解包logisim.jar  \
2、按照resources目录下所有文件夹中的格式，添加中文的.properties文件，以zh命名文件夹  \
3、编辑\resources\logisim\settings.properties文件，添加字符zh  \
4、打包为logisim.jar
