[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$petId = 'anya-forger'
$expectedManifestHash = '5BA6C96C66B686C34706CC797FBBECF2A0CCC422BADF237DE50B3AF069297CB3'
$expectedSpriteHash = '5558F5724A14D01CA76011476AD8A0C0BD9976345D1B68271F7BE8226B03D248'
$sourceManifest = Join-Path $PSScriptRoot 'pet.json'
$sourceSprite = Join-Path $PSScriptRoot 'spritesheet.webp'

function Assert-FileHash {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Expected
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing required file: $Path"
    }

    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
    if ($actual -ne $Expected) {
        throw "SHA-256 verification failed for $Path. Expected $Expected but found $actual."
    }
}

Assert-FileHash -Path $sourceManifest -Expected $expectedManifestHash
Assert-FileHash -Path $sourceSprite -Expected $expectedSpriteHash

$sourcePet = Get-Content -Raw -Encoding UTF8 -LiteralPath $sourceManifest | ConvertFrom-Json
if ($sourcePet.id -ne $petId) {
    throw "Unexpected pet id '$($sourcePet.id)'. Expected '$petId'."
}
if ([int]$sourcePet.spriteVersionNumber -ne 2) {
    throw "This installer requires spriteVersionNumber 2."
}

$codexRoot = Join-Path $env:USERPROFILE '.codex'
$petsRoot = Join-Path $codexRoot 'pets'
$targetDir = Join-Path $petsRoot $petId
$targetManifest = Join-Path $targetDir 'pet.json'
$targetSprite = Join-Path $targetDir 'spritesheet.webp'

$alreadyInstalled = $false
if ((Test-Path -LiteralPath $targetManifest -PathType Leaf) -and
    (Test-Path -LiteralPath $targetSprite -PathType Leaf)) {
    $installedManifestHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $targetManifest).Hash
    $installedSpriteHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $targetSprite).Hash
    $alreadyInstalled = ($installedManifestHash -eq $expectedManifestHash -and
        $installedSpriteHash -eq $expectedSpriteHash)
}

if ($alreadyInstalled) {
    Write-Host 'Anya is already installed and verified.' -ForegroundColor Green
    Write-Host "Location: $targetDir"
    exit 0
}

if (Test-Path -LiteralPath $targetDir) {
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupDir = Join-Path (Join-Path $petsRoot '_backups') "$petId-$timestamp"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

    if (Test-Path -LiteralPath $targetManifest -PathType Leaf) {
        Copy-Item -LiteralPath $targetManifest -Destination (Join-Path $backupDir 'pet.json') -Force
    }
    if (Test-Path -LiteralPath $targetSprite -PathType Leaf) {
        Copy-Item -LiteralPath $targetSprite -Destination (Join-Path $backupDir 'spritesheet.webp') -Force
    }

    Write-Host "Existing Anya files were backed up to: $backupDir" -ForegroundColor Yellow
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
Copy-Item -LiteralPath $sourceManifest -Destination $targetManifest -Force
Copy-Item -LiteralPath $sourceSprite -Destination $targetSprite -Force

Assert-FileHash -Path $targetManifest -Expected $expectedManifestHash
Assert-FileHash -Path $targetSprite -Expected $expectedSpriteHash

Write-Host ''
Write-Host 'Anya was installed successfully.' -ForegroundColor Green
Write-Host "Location: $targetDir"
Write-Host 'Restart Codex, open Settings > Pets, select Refresh, and choose Anya.'
Write-Host 'Enter /pet to wake the pet.'

