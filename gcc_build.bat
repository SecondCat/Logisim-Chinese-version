windres -i "LogisimLauncher.rc" -o "LogisimLauncher.o"
gcc -mwindows "LogisimLauncher.c" "LogisimLauncher.o" -o ".\build\LogisimLauncher.exe"

@echo off
echo �Ƿ�Ҫ���б���õĳ���5����Զ��˳�
CHOICE /T 5 /C:yn /D n /N /M "���밴[Y],���밴[N]:"
If ErrorLevel 2 goto NO
If ErrorLevel 1 goto YES
:YES
    cd ".\build"
    ".\LogisimLauncher.exe"
    cd "..\"
exit

:NO
exit