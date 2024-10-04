@echo off 
powershell -c "jj file list --no-pager | foreach {$_ -replace '\\','/'} | echo"
