# Script to delete empty folders and 0-byte files recursively
param(
    [Parameter(Mandatory=$false)]
    [string]$Path
)

# If no path is provided, use the current directory
if ([string]::IsNullOrWhiteSpace($Path)) {
    $startPath = Get-Location
} else {
    # Verify that the path exists
    if (Test-Path $Path) {
        $startPath = Resolve-Path $Path
    } else {
        Write-Host "ERROR: The path '$Path' does not exist!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Starting cleanup from directory: $startPath" -ForegroundColor Cyan
Write-Host ""

# Counters
$deletedFiles = 0
$deletedFolders = 0

# Function to delete 0-byte files
function Remove-EmptyFiles {
    param([string]$path)
    
    Get-ChildItem -Path $path -File -Recurse -Force -ErrorAction SilentlyContinue | 
        Where-Object { $_.Length -eq 0 } | 
        ForEach-Object {
            try {
                Write-Host "Deleting file: $($_.FullName)" -ForegroundColor Yellow
                Remove-Item $_.FullName -Force
                $script:deletedFiles++
            }
            catch {
                Write-Host "Error deleting $($_.FullName): $_" -ForegroundColor Red
            }
        }
}

# Function to delete empty folders (executed multiple times for nested folders)
function Remove-EmptyFolders {
    param([string]$path)
    
    do {
        $deleted = $false
        Get-ChildItem -Path $path -Directory -Recurse -Force -ErrorAction SilentlyContinue | 
            Sort-Object FullName -Descending | 
            ForEach-Object {
                if ((Get-ChildItem -Path $_.FullName -Force -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
                    try {
                        Write-Host "Deleting folder: $($_.FullName)" -ForegroundColor Yellow
                        Remove-Item $_.FullName -Force
                        $script:deletedFolders++
                        $deleted = $true
                    }
                    catch {
                        Write-Host "Error deleting $($_.FullName): $_" -ForegroundColor Red
                    }
                }
            }
    } while ($deleted)
}

# Execute cleanup
Write-Host "Deleting 0-byte files..." -ForegroundColor Green
Remove-EmptyFiles -path $startPath

Write-Host ""
Write-Host "Deleting empty folders..." -ForegroundColor Green
Remove-EmptyFolders -path $startPath

# Summary
Write-Host ""
Write-Host "=== Cleanup completed ===" -ForegroundColor Cyan
Write-Host "Files deleted: $deletedFiles" -ForegroundColor Green
Write-Host "Folders deleted: $deletedFolders" -ForegroundColor Green
