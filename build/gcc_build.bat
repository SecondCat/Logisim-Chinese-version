windres -i "LogisimLauncher.rc" -o "LogisimLauncher.o"
gcc -mwindows "..\LogisimLauncher.c" "LogisimLauncher.o" -o "..\exe\LogisimLauncher.exe"
del "LogisimLauncher.o"

@echo off
echo 是否要运行编译好的程序？5秒后自动退出
CHOICE /T 5 /C:yn /D n /N /M "是请按[Y],否请按[N]:"
If ErrorLevel 2 goto NO
If ErrorLevel 1 goto YES
:YES
    cd "..\exe"
    ".\LogisimLauncher.exe"
    cd "..\build"
exit

:NO
exit