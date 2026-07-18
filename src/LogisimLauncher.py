#!/usr/bin/env python3
"""
Logisim Launcher - Python rewrite with bug fixes and optimizations

Original C code bugs fixed:
  1. Buffer overflow: malloc missing +1 for null terminator
  2. Undefined behavior: NULL pointer comparison (pos1 >= pos2)
  3. Crash: GetFileAttributesA called with NULL param
  4. Memory leak: malloc'd strings never freed
  5. Debug leftover: puts(workPath) printing exe path
  6. Encoding: garbled Chinese text in MessageBox (now uses Unicode MessageBoxW)

Optimizations:
  - Uses os.path.join for safe path construction
  - Uses subprocess.Popen for process creation
  - Uses Unicode (MessageBoxW) for proper Chinese display
  - Properly validates file parameters before passing to Java
  - No memory management issues (Python handles this)
"""

import sys
import os
import subprocess
import ctypes


def get_work_dir():
    """Get the directory containing the executable (or script when unfrozen).

    When compiled with Nuitka --onefile, sys.executable correctly points to
    the original onefile binary location, not the temp extraction directory.
    This ensures relative paths (JRE, Logisim.jar) resolve correctly.
    """
    if getattr(sys, "frozen", False):
        # Compiled mode (Nuitka): sys.executable is the exe path
        return os.path.dirname(sys.executable)
    else:
        # Script mode: use the script file location
        return os.path.dirname(os.path.abspath(sys.argv[0]))


def show_error(message):
    """Display an error message box using Unicode (MessageBoxW)."""
    # MB_ICONERROR = 0x10
    ctypes.windll.user32.MessageBoxW(0, message, "LogisimLauncher", 0x10)


def validate_file(path, error_msg):
    """Check that a path exists and is a regular file (not a directory).

    Returns True if valid, False if not (and shows an error dialog).
    """
    if not os.path.isfile(path):
        show_error(error_msg)
        return False
    return True


def launch(java_path, jar_path, file_param=None):
    """Launch Logisim via javaw.exe.

    Args:
        java_path: Full path to javaw.exe
        jar_path: Full path to Logisim.jar
        file_param: Optional file to open in Logisim

    Returns:
        0 on success, 1 on failure
    """
    cmd = [java_path, "-jar", jar_path]
    if file_param:
        cmd.append(file_param)

    try:
        # DETACHED_PROCESS (0x8): new process does not inherit parent console
        # close_fds=True: do NOT inherit any file handles from parent process
        # This matches the original C code's CreateProcessA(bInheritHandles=FALSE),
        # preventing javaw from inheriting handles that would lock the jar file
        subprocess.Popen(cmd, close_fds=True, creationflags=0x8)
        return 0
    except OSError as e:
        show_error(f"Java 启动失败 (错误码: {e.errno})")
        return 1


def main():
    work_dir = get_work_dir()

    java_path = os.path.join(work_dir, "JRE", "bin", "javaw.exe")
    jar_path = os.path.join(work_dir, "Logisim.jar")

    # Validate JRE
    if not validate_file(java_path, "找不到 JRE"):
        return 1

    # Validate Logisim.jar
    if not validate_file(jar_path, "找不到 logisim.jar"):
        return 1

    # Launch with file parameters or without
    # Original C logic: if param is a valid file, pass it; otherwise treat as no-param
    if len(sys.argv) >= 2:
        for param in sys.argv[1:]:
            if os.path.isfile(param):
                launch(java_path, jar_path, param)
            else:
                show_error(f"{param} 不是有效的文件)")
    else:
        launch(java_path, jar_path)

    return 0


if __name__ == "__main__":
    sys.exit(main())
