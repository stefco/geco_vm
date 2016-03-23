cat <<__MSG__
************************************************************
*
*
* CHECKING FOR INSTALLED COMMANDS
*
*
************************************************************
__MSG__
command -v lalapps_tconvert >/dev/null 2>&1 || { echo >&2 "I require lalapps_tconvert but it's not installed.  Aborting."; exit 1; }
command -v ligo-proxy-init >/dev/null 2>&1 || { echo >&2 "I require ligo-proxy-init but it's not installed.  Aborting."; exit 1; }
command -v gsissh >/dev/null 2>&1 || { echo >&2 "I require gsissh but it's not installed.  Aborting."; exit 1; }
command -v kinit >/dev/null 2>&1 || { echo >&2 "I require kinit but it's not installed.  Aborting."; exit 1; }
command -v ipython >/dev/null 2>&1 || { echo >&2 "I require ipython but it's not installed.  Aborting."; exit 1; }
command -v julia >/dev/null 2>&1 || { echo >&2 "I require julia but it's not installed.  Aborting."; exit 1; }
command -v jupyter >/dev/null 2>&1 || { echo >&2 "I require jupyter but it's not installed.  Aborting."; exit 1; }
ipython -c 'import nds2; import gwpy; import matplotlib; import numpy'
