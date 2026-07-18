# Logisim2.7.1 免Java中文版
如果打开软件是英文界面，依次点击左上角 File -> Preferences... -> Chinese 切换为中文

📥 GitHub下载：https://github.com/SecondCat/Logisim-Chinese-version/releases/ \
🌐 CSDN：https://blog.csdn.net/m0_59667483/article/details/125941447  \
🌐 Logisim官网：http://www.cburch.com/logisim/

✨ 主要特点\
· 免Java环境 — 内置 JRE（提取自 JDK-15.0.1），直接运行\
· 中文汉化 — 基于官方 logisim.jar 2.7.1 版本汉化\
· 双语对照 — 电路元件库同时显示中英文名称\
· 双版本可选 — zip 免安装解压即用，exe 按需安装

⚠️ 注意事项\
系统要求:	不支持 Windows 7 / Windows 8，请使用 Windows 10 及以上\
安全说明:	本项目无恶意代码。v3 版本通过 360 云分析（威胁分数 1.9），杀毒软件误报时请加入白名单\
开源协议:	遵循 GPL v2（GNU General Public License Version 2, June 1991）

📦 版本演进\
v3：使用 Python 完全重写，避免所有C语言版本的内存安全问题，并支持直接从网络磁盘启动。\
v2：修复了拖拽文件打开方式不支持跨盘打开的问题，并支持多文件多开。修复了可能导致内存越界访问的bug。\
v1：初始版本。

📌 已知问题\
国际化选项卡中的各语言选项显示为英文（不影响主要功能）

🛠️ 汉化方法（供二次开发参考）\
如果您希望自行更新或调整汉化内容，可按以下步骤操作：\
1、解包logisim.jar  \
2、按照resources目录下所有文件夹中的格式，添加中文的.properties文件，以zh命名文件夹  \
3、编辑\resources\logisim\settings.properties文件，添加字符zh  \
4、打包为logisim.jar
