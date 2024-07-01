# Ensure we're in the root of the git repository
$gitRoot = git rev-parse --show-toplevel
Set-Location $gitRoot

# Get the list of files that are now ignored but still tracked
$ignoredFiles = git ls-files -ci --exclude-standard

# Check if there are any files to remove
if ([string]::IsNullOrWhiteSpace($ignoredFiles)) {
    Write-Host "No ignored files are currently tracked. Nothing to do."
    exit 0
}

# Show the files that will be untracked
Write-Host "The following files will be untracked:"
$ignoredFiles
Write-Host ""

# Ask for confirmation
$confirmation = Read-Host "Do you want to proceed? (y/n)"
if ($confirmation -eq 'y') {
    # Remove all files from git tracking at once
    git rm --cached -r $(git ls-files -ci --exclude-standard)
    
    # Commit the changes
    git commit -m "Untrack files that are now in .gitignore"
    
    Write-Host "Files have been untracked and changes committed."
    Write-Host "You may now push these changes to your remote repository."
} else {
    Write-Host "Operation cancelled."
}