#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <windows.h>

int main(int argc, char *argv[])
{
    int runJar(char *javaPath, char *jarPath, char *param);

    char workPath[32768];
    GetModuleFileNameA(NULL, workPath, 32768);
    puts(workPath);

    char *pos1 = strrchr(workPath, '/');
    char *pos2 = strrchr(workPath, '\\');
    if (pos1 == NULL && pos2 == NULL)
    {
        MessageBoxA(NULL, "未知的工作目录！", NULL, MB_ICONERROR);
        return -1;
    }
    else if (pos1 >= pos2)
    {
        *(pos1 + 1) = '\0';
    }
    else
    {
        *(pos2 + 1) = '\0';
    }
    

    const char* javaPath = "JRE\\bin\\javaw.exe";
    const char* jarPath = "Logisim.jar";
    char *param = NULL;

    char *javaPathStr = (char *)malloc((strlen(workPath) + strlen(javaPath) + strlen("\0")) * sizeof(char));
    char *jarPathStr = (char *)malloc((strlen(workPath) + strlen(jarPath) + strlen("\0")) * sizeof(char));

    if (javaPathStr && jarPathStr)
    {
        sprintf(javaPathStr, "%s%s", workPath, javaPath);
        sprintf(jarPathStr, "%s%s", workPath, jarPath);
    }
    

    if (argc >= 2) // open parameter
    {
        for (int i = 1; i < argc; i++)
        {
            runJar(javaPathStr, jarPathStr, argv[i]);
        }
    }
    else
    {
        runJar(javaPathStr, jarPathStr, NULL);
    }
    return 0;
}

int runJar(char *javaPath, char *jarPath, char *param)
{
    DWORD attrib;
    char *cmdLineStr = NULL;
    attrib = GetFileAttributesA(javaPath);
    if (attrib == INVALID_FILE_ATTRIBUTES || (attrib & FILE_ATTRIBUTE_DIRECTORY))
    {
        MessageBoxA(NULL, "找不到 JRE!", NULL, MB_ICONERROR);
        return 1;
    }

    attrib = GetFileAttributesA(jarPath);
    if (attrib == INVALID_FILE_ATTRIBUTES || (attrib & FILE_ATTRIBUTE_DIRECTORY))
    {
        MessageBoxA(NULL, "找不到 logisim.jar !", NULL, MB_ICONERROR);
        return 1;
    }

    attrib = GetFileAttributesA(param);
    if (attrib == INVALID_FILE_ATTRIBUTES || (attrib & FILE_ATTRIBUTE_DIRECTORY))
    {
        const char *format = " -jar \"%s\"";
        cmdLineStr = (char *)malloc((strlen(jarPath) +
                                     strlen(format)) *
                                    sizeof(char));
        if (cmdLineStr != NULL)
        {
            sprintf(cmdLineStr, format, jarPath);
        }
        else
        {
            return 2;
        }
    }
    else
    {   
        // 有参数打开
        const char *format = " -jar \"%s\" \"%s\"";
        cmdLineStr = (char *)malloc((strlen(jarPath) +
                                     strlen(param) +
                                     strlen(format)) *
                                    sizeof(char));
        if (cmdLineStr != NULL)
        {
            sprintf(cmdLineStr, format, jarPath, param);
        }
        else
        {
        return 2;
        }
    }

    STARTUPINFOA si = {0};
    PROCESS_INFORMATION pi = {0};
    si.cb = sizeof(si);

    if (!CreateProcessA(
            javaPath,
            cmdLineStr,
            NULL,
            NULL,
            FALSE,
            0,
            NULL,
            NULL,
            &si,
            &pi))
    {
        char msg[256];
        snprintf(msg, sizeof(msg), "Java启动失败 (错误码: %lu)", GetLastError());
        MessageBoxA(NULL, msg, NULL, MB_ICONERROR);
    }

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return 0;
}
