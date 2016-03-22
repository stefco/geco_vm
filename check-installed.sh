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

# TODO: authenticate ligo-proxy-init, check for something on the server, then
# unvalidate

# TODO: authenticate kinit, try an nds2 query, then unvalidate

# TODO: test the python nds2 package
