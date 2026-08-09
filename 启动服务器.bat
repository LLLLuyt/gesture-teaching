@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ==========================================
echo   Gesture Recognition Demo - Local Server
echo   URL: http://localhost:8000/
echo   Keep this window open while using the app.
echo ==========================================
start "" "http://localhost:8000/"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$base=[IO.Path]::GetFullPath((Get-Location)); $l=New-Object System.Net.HttpListener; $l.Prefixes.Add('http://localhost:8000/'); try { $l.Start() } catch { Write-Host 'Start failed. The server may already be running - just open http://localhost:8000/ in your browser. If not, right-click this file and choose Run as administrator.'; Read-Host; exit 1 }; Write-Host 'Server is running. Close this window to stop.'; while ($l.IsListening) { $c=$l.GetContext(); $u=[uri]::UnescapeDataString($c.Request.Url.LocalPath); if ($u -eq '/' -or $u -eq '') { $u='/index.html' }; $f=[IO.Path]::GetFullPath((Join-Path (Get-Location) ($u.TrimStart('/')))); if (-not $f.StartsWith($base)) { $c.Response.StatusCode=403 } elseif (Test-Path $f) { $m='application/octet-stream'; switch ([IO.Path]::GetExtension($f)) { '.html' { $m='text/html; charset=utf-8' } '.js' { $m='text/javascript' } '.wasm' { $m='application/wasm' } '.css' { $m='text/css' } }; $c.Response.ContentType=$m; $b=[IO.File]::ReadAllBytes($f); $c.Response.OutputStream.Write($b,0,$b.Length) } else { $c.Response.StatusCode=404 }; $c.Response.Close() }"
