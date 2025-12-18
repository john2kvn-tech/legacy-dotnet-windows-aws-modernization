param(
  [string]$Url = "http://localhost:5000/health",
  [int]$Retries = 5,
  [int]$DelaySeconds = 2
)

$ErrorActionPreference = "Stop"

for ($i = 1; $i -le $Retries; $i++) {
  try {
    $resp = Invoke-RestMethod -Uri $Url -Method GET -TimeoutSec 5

    if ($resp.status -eq "ok") {
      Write-Host "OK: health endpoint returned status=ok"
      exit 0
    }

    Write-Host "WARN: health returned unexpected payload: $($resp | ConvertTo-Json -Compress)"
  }
  catch {
    Write-Host "WARN: attempt $i failed: $($_.Exception.Message)"
  }

  Start-Sleep -Seconds $DelaySeconds
}

Write-Error "FAILED: health endpoint did not return status=ok after $Retries attempts"
exit 1
