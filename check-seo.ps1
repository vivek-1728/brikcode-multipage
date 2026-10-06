# BRIKCODE SEO CLI Auditor
param (
    [string]$Path = "brikcode"
)

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "         BRIKCODE SEO CLI AUDITOR (Google Standards)" -ForegroundColor Cyan
Write-Host "=======================================================`n" -ForegroundColor Cyan

$files = Get-ChildItem -Path $Path -Filter "*.html" -Recurse
$totalChecks = 0
$passedChecks = 0
$warnings = 0
$errors = 0

foreach ($file in $files) {
    $relPath = $file.FullName.Replace((Get-Location).Path + "\", "")
    $content = Get-Content -Path $file.FullName -Raw

    Write-Host "Auditing: $relPath" -ForegroundColor Yellow

    # 1. Meta Charset First
    $totalChecks++
    if ($content -match '(?s)<head>\s*<meta charset="utf-8">') {
        $passedChecks++
        Write-Host "  [PASS] Charset is first tag in <head>" -ForegroundColor Green
    } else {
        $errors++
        Write-Host "  [FAIL] Charset is not first in <head>" -ForegroundColor Red
    }

    # 2. Title Tag
    $totalChecks++
    if ($content -match '<title>(.*?)</title>') {
        $title = $matches[1]
        $len = $title.Length
        if ($len -ge 25 -and $len -le 65) {
            $passedChecks++
            Write-Host "  [PASS] Title ($len chars): $title" -ForegroundColor Green
        } else {
            $warnings++
            Write-Host "  [WARN] Title length is $len chars (recommended 35-65): $title" -ForegroundColor DarkYellow
        }
    } else {
        $errors++
        Write-Host "  [FAIL] Missing <title> tag" -ForegroundColor Red
    }

    # 3. Meta Description
    $totalChecks++
    if ($content -match '<meta\s+name="description"\s+content="([^"]+)"') {
        $desc = $matches[1]
        $len = $desc.Length
        if ($len -ge 120 -and $len -le 170) {
            $passedChecks++
            Write-Host "  [PASS] Meta Description ($len chars)" -ForegroundColor Green
        } else {
            $warnings++
            Write-Host "  [WARN] Meta Description ($len chars, recommended 130-160)" -ForegroundColor DarkYellow
        }
    } else {
        $errors++
        Write-Host "  [FAIL] Missing meta description" -ForegroundColor Red
    }

    # 4. Single H1
    $totalChecks++
    $h1Matches = [regex]::Matches($content, '<h1[^>]*>(.*?)</h1>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($h1Matches.Count -eq 1) {
        $passedChecks++
        $h1Text = ($h1Matches[0].Groups[1].Value -replace '<[^>]+>', '').Trim()
        Write-Host "  [PASS] Single H1: $h1Text" -ForegroundColor Green
    } else {
        $errors++
        Write-Host "  [FAIL] Found $($h1Matches.Count) H1 tags (must be exactly 1)" -ForegroundColor Red
    }

    # 5. Canonical URL
    $totalChecks++
    if ($content -match '<link\s+rel="canonical"\s+href="([^"]+)"') {
        $passedChecks++
        Write-Host "  [PASS] Canonical: $($matches[1])" -ForegroundColor Green
    } elseif ($file.Name -eq "404.html") {
        $passedChecks++
        Write-Host "  [PASS] 404 page correctly has no canonical" -ForegroundColor Green
    } else {
        $errors++
        Write-Host "  [FAIL] Missing canonical link" -ForegroundColor Red
    }

    # 6. JSON-LD Structured Data
    $totalChecks++
    $schemaMatches = [regex]::Matches($content, '(?s)<script type="application/ld\+json">(.*?)</script>')
    if ($schemaMatches.Count -gt 0) {
        $jsonValid = $true
        foreach ($sm in $schemaMatches) {
            try {
                $null = ConvertFrom-Json $sm.Groups[1].Value.Trim() -ErrorAction Stop
            } catch {
                $jsonValid = $false
            }
        }
        if ($jsonValid) {
            $passedChecks++
            Write-Host "  [PASS] Valid JSON-LD Schema ($($schemaMatches.Count) blocks)" -ForegroundColor Green
        } else {
            $errors++
            Write-Host "  [FAIL] Invalid JSON-LD Schema syntax" -ForegroundColor Red
        }
    } elseif ($file.Name -eq "404.html") {
        $passedChecks++
        Write-Host "  [PASS] 404 page correctly has no structured data" -ForegroundColor Green
    } else {
        $warnings++
        Write-Host "  [WARN] No JSON-LD structured data" -ForegroundColor DarkYellow
    }

    # 7. Favicon link
    $totalChecks++
    if ($content -match 'rel="icon"') {
        $passedChecks++
        Write-Host "  [PASS] Favicon tags configured" -ForegroundColor Green
    } else {
        $errors++
        Write-Host "  [FAIL] Missing favicon tags" -ForegroundColor Red
    }

    Write-Host ""
}

# Summary Score
$score = [math]::Round(($passedChecks / $totalChecks) * 100)
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "AUDIT COMPLETE: $passedChecks / $totalChecks checks passed" -ForegroundColor Cyan
Write-Host "Errors: $errors | Warnings: $warnings" -ForegroundColor $(if ($errors -eq 0) { "Green" } else { "Red" })
Write-Host "SEO HEALTH SCORE: $score% / 100%" -ForegroundColor $(if ($score -ge 90) { "Green" } else { "Yellow" })
Write-Host "=======================================================`n" -ForegroundColor Cyan
