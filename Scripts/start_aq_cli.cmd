@echo off
setlocal enabledelayedexpansion
if not exist d:\batch\aq_cli.cmd goto :failed
color 1a
call d:\batch\aq_cli.cmd -c runaq_ts
goto :eof

:failed
	msg * "airquest steht nicht zur verfügung"
	echo d:\batch\aq_cli.cmd fehlt ..
:eof