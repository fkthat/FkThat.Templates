[CmdletBinding()]
param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet('start-feature', 'finish-feature')]
    $Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]
    $Args
)

Push-Location $PSScriptRoot

try {
    switch($Command) {
        'start-feature' {
            $name = $Args[0]
            git checkout develop && `
            git pull && `
            git checkout -b feature/$name && `
            git push -u origin feature/$name
        }
        'finish-feature' {
            $name = $Args[0]

            if(-not $name) {
                $name = (git branch --show-current)

                if($name -match '^feature/') {
                    $name = $name.Substring(8)
                }
                else {
                    Write-Error "$name is not a feature branch"
                    break;
                }
            }

            git checkout develop && `
            git pull && `
            git remote prune origin && `
            git branch -d feature/$name
        }
    }
}
finally {
    Pop-Location
}
