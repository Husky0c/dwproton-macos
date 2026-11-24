/* SPDX-License-Identifier: LGPL-2.1-or-later */

#ifndef __WINE_DWPROTON_WEBVIEW2_H
#define __WINE_DWPROTON_WEBVIEW2_H

#include "wine/unixlib.h"

static inline BOOL dwproton_webview2_gdi_enabled(void)
{
    static const WCHAR option[] = {'D','W','P','R','O','T','O','N','_','W','E','B','V','I','E','W','2','_','G','D','I','=','1',0};
    const WCHAR *env = NtCurrentTeb()->Peb->ProcessParameters->Environment;

    for (; env && *env; env += wcslen( env ) + 1)
        if (!wcsicmp( env, option )) return TRUE;
    return FALSE;
}

static inline BOOL dwproton_is_webview2_process(void)
{
    static const WCHAR browser[] = {'m','s','e','d','g','e','w','e','b','v','i','e','w','2','.','e','x','e',0};
    const WCHAR *name = NtCurrentTeb()->Peb->ProcessParameters->ImagePathName.Buffer;
    const WCHAR *separator;

    if ((separator = wcsrchr( name, '/' ))) name = separator + 1;
    if ((separator = wcsrchr( name, '\\' ))) name = separator + 1;
    return !wcsicmp( name, browser );
}

#endif
