#include "hbgtwvw.h"
#include "hbapi.h"
#include "windows.h"
#include "ocidl.h"
#include "olectl.h"

HB_FUNC( KS_NOCAPTION )
{
  DWORD Style = (WS_POPUP|WS_BORDER |WS_SYSMENU |WS_CLIPCHILDREN);
  hb_retni( Style );
}
