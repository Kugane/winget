@Echo off
Echo "Execute as admin?"
PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File ""%~dpn1.ps1""' -Verb RunAs}"