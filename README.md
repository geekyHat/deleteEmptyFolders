# deleteEmptyFolders
Deletes empty folders and files with 0bits. 

## How to use the script:

### Without arguments (cleans current directory):

`powershell   .\Clean-EmptyFolders.ps1`

### With relative path:

`powershell   .\Clean-EmptyFolders.ps1 "targetFolder"`

### With absolute path:

`powershell   .\Clean-EmptyFolders.ps1 "C:\MyFolder\Documents"`

### With relative parent path:

`powershell   .\Clean-EmptyFolders.ps1 "..\AnotherFolder"`

## Script features:

Optional `$Path` parameter at the beginning
Verifies the path exists before proceeding
If the path doesn't exist, shows an error and exits
If no parameter is provided, uses the current directory
Deletes 0-byte files first, then empty folders
Empty folders are deleted in multiple passes to handle nested folders
Shows the path of each deleted item
Provides a final summary with totals

### If you have execution policy issues, run this first:
`powershellSet-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
