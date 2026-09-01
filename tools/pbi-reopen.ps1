# Genåbner HR_OEKONOMI.pbip i en kørende "Untitled" PBI Desktop via UIA-recents (File → Recent → Hyperlink → Invoke).
# TO FÆLDER, begge kostede tid 2026-09-01:
#  1) Recents rummer FLERE poster ved navn 'HR_OEKONOMI.pbip' — heriblandt den NEDLAGTE 'AI-SOSU'-sti
#     fra før omdøbningen 29-08. FindFirst kunne ramme den, og Invoke no-op'ede så UDEN fejl (scriptet
#     skrev 'invoked recents link', og vinduet blev ved med at hedde 'Untitled'). Derfor vælges nu den
#     ØVERSTE post (mindst Y) = den senest åbnede.
#  2) Recents-listen er først i UIA-træet nogle sekunder EFTER at backstage er åbnet. Efter en helt
#     frisk start skal scriptet typisk køres TO gange: første kald åbner backstage, andet finder posten.
# Forudsætning: PBIDesktopStore.exe er startet og viser "Untitled - Power BI Desktop". Se BI-OEKONOMI/CLAUDE.md "Kørende model og disk-cache".
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
$ErrorActionPreference = 'Continue'
$proc = Get-Process PBIDesktop | Where-Object { $_.MainWindowTitle -ne '' } | Select-Object -First 1
if (-not $proc) { "FEJL: intet PBI-vindue"; exit 1 }
"window: $($proc.MainWindowTitle) pid $($proc.Id)"
$pc = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ProcessIdProperty, $proc.Id)
$root = [System.Windows.Automation.AutomationElement]::RootElement.FindFirst([System.Windows.Automation.TreeScope]::Children, $pc)
if (-not $root) { "FEJL: UIA fandt ikke vinduet"; exit 1 }
function Find-ByName($el, $name, $type) {
  $c1 = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::NameProperty, $name)
  $c2 = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ControlTypeProperty, $type)
  $and = New-Object System.Windows.Automation.AndCondition($c1, $c2)
  return $el.FindFirst([System.Windows.Automation.TreeScope]::Descendants, $and)
}
$link = $null
for ($i = 0; $i -lt 12 -and -not $link; $i++) {
  # ALLE poster med navnet - ikke FindFirst: flere kan hedde det samme, og de døde stier no-op'er
  $hc = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::Hyperlink)
  $alle = @($root.FindAll([System.Windows.Automation.TreeScope]::Descendants, $hc) | Where-Object { $_.Current.Name -eq 'HR_OEKONOMI.pbip' })
  if ($alle.Count -gt 0) { $link = $alle | Sort-Object { $_.Current.BoundingRectangle.Y } | Select-Object -First 1 }
  if (-not $link) {
    foreach ($n in @('File','Filer')) {
      $tab = Find-ByName $root $n ([System.Windows.Automation.ControlType]::TabItem)
      if ($tab) { try { $tab.GetCurrentPattern([System.Windows.Automation.SelectionItemPattern]::Pattern).Select(); "selected tab $n" } catch { "tab select fejl: $_" } ; break }
    }
    Start-Sleep -Seconds 3
  }
}
if (-not $link) {
  "FEJL: fandt ikke recents-link. Hyperlinks set:"
  $cond = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::Hyperlink)
  $root.FindAll([System.Windows.Automation.TreeScope]::Descendants, $cond) | ForEach-Object { "  " + $_.Current.Name } | Select-Object -First 30
  exit 1
}
try { $link.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern).Invoke(); "invoked recents link" }
catch {
  $r = $link.Current.BoundingRectangle
  Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern bool SetCursorPos(int x,int y); [DllImport("user32.dll")] public static extern void mouse_event(int f,int x,int y,int d,int e);' -Name U -Namespace W
  [W.U]::SetCursorPos([int]($r.X + $r.Width/2), [int]($r.Y + $r.Height/2)); [W.U]::mouse_event(2,0,0,0,0); [W.U]::mouse_event(4,0,0,0,0); "clicked recents link"
}
$deadline = (Get-Date).AddSeconds(300)
while ((Get-Date) -lt $deadline) {
  $p = Get-Process PBIDesktop -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like '*HR_OEKONOMI*' } | Select-Object -First 1
  if ($p) { "LOADED: $($p.MainWindowTitle) (pid $($p.Id))"; break }
  Start-Sleep -Seconds 5
}
Get-Process PBIDesktop, msmdsrv -ErrorAction SilentlyContinue | Select-Object Name, Id, MainWindowTitle | Format-Table -AutoSize
