$DesktopPath = [Environment]::GetFolderPath('Desktop')
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$DesktopPath\FocusFlow.lnk")
$Shortcut.TargetPath = "C:\Users\ryuut\myproject\focusflow\dist\FocusFlow.exe"
$Shortcut.WorkingDirectory = "C:\Users\ryuut\myproject\focusflow\dist"
$Shortcut.Save()
