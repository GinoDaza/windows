// Alt+; -> ñ, Alt+Shift+; -> Ñ  (tiny background app, no window)
// Build: x86_64-w64-mingw32-gcc -Os -s -mwindows -o ntilde.exe ntilde.c
#include <windows.h>

static void key(WORD vk, WORD scan, DWORD flags) {
    INPUT in = {0};
    in.type = INPUT_KEYBOARD;
    in.ki.wVk = vk;
    in.ki.wScan = scan;
    in.ki.dwFlags = flags;
    SendInput(1, &in, sizeof in);
}

static void type_char(WCHAR c) {
    // Ctrl tap stops Windows from opening the menu bar when Alt is released
    key(VK_CONTROL, 0, 0);
    key(VK_CONTROL, 0, KEYEVENTF_KEYUP);
    key(VK_MENU, 0, KEYEVENTF_KEYUP);
    key(0, c, KEYEVENTF_UNICODE);
    key(0, c, KEYEVENTF_UNICODE | KEYEVENTF_KEYUP);
    key(VK_MENU, 0, 0);
}

int WINAPI WinMain(HINSTANCE h, HINSTANCE p, LPSTR cmd, int show) {
    RegisterHotKey(NULL, 1, MOD_ALT | MOD_NOREPEAT, VK_OEM_1);              // Alt + ;
    RegisterHotKey(NULL, 2, MOD_ALT | MOD_SHIFT | MOD_NOREPEAT, VK_OEM_1);  // Alt + Shift + ;
    MSG m;
    while (GetMessage(&m, NULL, 0, 0)) {
        if (m.message == WM_HOTKEY)
            type_char(m.wParam == 1 ? 0x00F1 : 0x00D1);
    }
    return 0;
}
