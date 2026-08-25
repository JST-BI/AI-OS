# Vælger en rapportfane i den kørende HR_OEKONOMI-instans (UIA TabItem, match på -Tab som *contains*), lukker backstage, maksimerer,
# søger efter fejltekster og gemmer et PrintWindow-screenshot til -Out. Brug -Tab "Z8050" o.l. (æøå i parametre kan fejle i PS 5.1).
param([string]$Tab = 'Elever pr. tælleperiode (Z8050)', [string]$Out)
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
Add-Type -AssemblyName System.Drawing
$proc = Get-Process PBIDesktop | Where-Object { $_.MainWindowTitle -like '*HR_OEKONOMI*' } | Select-Object -First 1
$pc = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ProcessIdProperty, $proc.Id)
$root = [System.Windows.Automation.AutomationElement]::RootElement.FindFirst([System.Windows.Automation.TreeScope]::Children, $pc)
Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h,int c); [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h); [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint f); [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r); public struct RECT { public int L,T,R,B; }' -Name N -Namespace W
[W.N]::ShowWindow($proc.MainWindowHandle, 3) | Out-Null
[W.N]::SetForegroundWindow($proc.MainWindowHandle) | Out-Null
Start-Sleep -Seconds 2
$cond = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::TabItem)
# luk evt. backstage (File-menu) via 'Back'
$back = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants, $cond) | Where-Object { $_.Current.Name -eq 'Back' } | Select-Object -First 1
if ($back) { try { $back.GetCurrentPattern([System.Windows.Automation.SelectionItemPattern]::Pattern).Select(); "backstage lukket" } catch { try { $back.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern).Invoke(); "backstage lukket (invoke)" } catch { "back fejl: $_" } } ; Start-Sleep -Seconds 2 }
# find fane
$tabs = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants, $cond)
$hit = $null
foreach ($t in $tabs) { if ($t.Current.Name -like "*$Tab*") { $hit = $t } }
if ($hit) { try { $hit.GetCurrentPattern([System.Windows.Automation.SelectionItemPattern]::Pattern).Select(); "selected: $($hit.Current.Name)" } catch { "select fejl: $_" } } else { "FEJL: fane ikke fundet. Faner: " + (($tabs | ForEach-Object { $_.Current.Name }) -join ' | ') }
Start-Sleep -Seconds 12
# fejltekster?
$tc = New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::Text)
$texts = $root.FindAll([System.Windows.Automation.TreeScope]::Descendants, $tc) | ForEach-Object { $_.Current.Name }
"Fejltekster: " + (($texts | Where-Object { $_ -match "Something's wrong|See details|Error fetching|Can't display|kan ikke vises|Der er noget galt" }) -join ' | ')
# screenshot via PrintWindow
$r = New-Object W.N+RECT
[W.N]::GetWindowRect($proc.MainWindowHandle, [ref]$r) | Out-Null
$w = $r.R - $r.L; $h = $r.B - $r.T
$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$hdc = $g.GetHdc()
[W.N]::PrintWindow($proc.MainWindowHandle, $hdc, 2) | Out-Null
$g.ReleaseHdc($hdc)
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
"saved $Out ($w x $h)"
