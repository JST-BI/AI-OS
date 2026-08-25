# Genåbner HR_OEKONOMI.pbip i en kørende "Untitled" PBI Desktop via UIA-recents (File → Recent → Hyperlink → Invoke).
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
  $link = Find-ByName $root 'HR_OEKONOMI.pbip' ([System.Windows.Automation.ControlType]::Hyperlink)
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
