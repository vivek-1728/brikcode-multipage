# BRIKCODE IndexNow CLI Tool
# Submits URLs instantly to Microsoft Bing, Yandex, Seznam, and Naver
param (
    [string[]]$Urls,
    [string]$HostName = "www.brikcode.com",
    [string]$Key = "3c68eb6c7b44454ea096e9d9d6dfe9be"
)

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "             BRIKCODE INDEXNOW CLI TOOL" -ForegroundColor Cyan
Write-Host "=======================================================`n" -ForegroundColor Cyan

# 1. Gather URLs
$urlList = @()
if ($Urls -and $Urls.Count -gt 0) {
    $urlList = $Urls
} else {
    Write-Host "Loading URLs from brikcode\sitemap.xml..." -ForegroundColor Gray
    $sitemapPath = "brikcode\sitemap.xml"
    if (Test-Path $sitemapPath) {
        [xml]$xml = Get-Content $sitemapPath
        foreach ($urlNode in $xml.urlset.url) {
            $loc = $urlNode.loc
            if ($loc -notmatch 'www\.') {
                # Ensure www. consistency
                $loc = $loc.Replace("https://brikcode.com", "https://www.brikcode.com")
            }
            $urlList += $loc
        }
    } else {
        $urlList = @("https://www.brikcode.com/")
    }
}

Write-Host "Found $($urlList.Count) URLs to submit:" -ForegroundColor Yellow
$urlList | ForEach-Object { Write-Host "  -> $_" -ForegroundColor DarkGray }

# 2. Build JSON Payload
$payload = @{
    host = $HostName
    key = $Key
    keyLocation = "https://$HostName/$Key.txt"
    urlList = $urlList
} | ConvertTo-Json -Depth 3

# 3. Submit to IndexNow
Write-Host "`nSubmitting to api.indexnow.org..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "https://api.indexnow.org/indexnow" `
        -Method Post `
        -ContentType "application/json; charset=utf-8" `
        -Body $payload `
        -UseBasicParsing `
        -ErrorAction Stop

    $code = $response.StatusCode
    if ($code -eq 200 -or $code -eq 202) {
        Write-Host "`n[SUCCESS] IndexNow submission received! Status: $code ($($response.StatusDescription))" -ForegroundColor Green
        Write-Host "Participating engines (Bing, Yandex, Seznam, Naver) have queued your URLs for immediate crawl." -ForegroundColor Green
    } else {
        Write-Host "`n[INFO] Response code: $code" -ForegroundColor Yellow
    }
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 202) {
        Write-Host "`n[SUCCESS] HTTP 202 Accepted: IndexNow key is being verified and URLs are queued." -ForegroundColor Green
    } elseif ($statusCode -eq 403) {
        Write-Host "`n[NOTE] HTTP 403: Key file not found on live server yet." -ForegroundColor Yellow
        Write-Host "Make sure commit with $Key.txt is deployed to https://$HostName/$Key.txt" -ForegroundColor Yellow
    } else {
        Write-Host "`n[RESPONSE] Status: $statusCode - $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "`n=======================================================`n" -ForegroundColor Cyan
