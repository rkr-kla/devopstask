<#
    .SYNOPSIS PowerShell 'DockerHelper' module containing 3 cmdlets
#>

<#
    .SYNOPSIS
    Copies files and/or directories local machine to $ComputerName\$Destination directory

    .DESCRIPTION
    The cmdlet copies files and/or directories from $Path on a local machine to $ComputerName local $Destination directory (these files could be reqired by some Dockerfiles). Assuming you have admin access to a remote host, and you are able to use admin shares C$, D$, etc.

    .PARAMETER ComputerName
    name of a remote computer 

    .PARAMETER Path
    local path(s) where to copy files from

    .PARAMETER Destination
    local path on a remote host where to copy files
#>
function CopyPrerequisites {
    param (        
        [Parameter(Mandatory=$true)] [string]$ComputerName,
        [Parameter(Mandatory=$true)] [string[]]$Path,
        [Parameter(Mandatory=$true)] [string]$Destination
    )
    Copy-Item -Path $Path -Destination $Destination

    try {
        $Session = New-PSSession -ComputerName $ComputerName
        foreach ($EachPath in $Path) {
            if (-Not (Test-Path -Path $EachPath)) {
                throw "Path '$EachPath' does not exist."
            }
            
            # define target dir
            $RemotePath = "\\$ComputerName\$Destination"

            # copy files or folders
            Write-Host "Copy Prerequisites from ""$EachPath"" to ""\\$ComputerName\$Destination"" ..."
            Copy-Item -Path $EachPath -Destination $RemotePath -Recurse -Force -ToSession $Session
        }
    } catch {
        Write-Output "Error: $_"
    }    
}

<#
    .SYNOPSIS
    Builds a Docker image from the $Dockerfile with a name $Tag on a remote host $ComputerName

    .DESCRIPTION
    The cmdlet builds a Docker image from the $Dockerfile with a name $Tag on a remote host $ComputerName, where Docker is installed. If $ComputerName is omitted cmdlet is executed locally.

    .PARAMETER Tag
    Docker image name

    .PARAMETER Dockerfile
    Path to a Dockerfile, which is used for building an image

    .PARAMETER Context
    Path to Docker context directory        

    .PARAMETER ComputerName
    Name of a computer, where Docker is installed)
#>
function BuildImage {
    param (        
        [Parameter(Mandatory=$true)]  [string]$Tag,
        [Parameter(Mandatory=$true)]  [string]$Dockerfile,
        [Parameter(Mandatory=$true)]  [string]$Context,
        [Parameter(Mandatory=$false)] [string]$ComputerName
    )

    Write-Host "Building Docker Image $Tag ..."
    # create new remote execution context if computername is used
    [bool]$useRemoteContext = ($PSBoundParameters.ContainsKey('ComputerName'))
    if ($useRemoteContext) {
        CreateRemoteContext -ComputerName $ComputerName
    }
    
    docker buildx build --file $Dockerfile $Context --tag $Tag

    if ($useRemoteContext) {
        RemoveRemoteContext -ComputerName $ComputerName
    }
}

<#
    .SYNOPSIS
    Run container on a remote host.

    .DESCRIPTION
    Run container on a remote host. If $ComputerName is omitted cmdlet is executed locally. Returns container name.

    .PARAMETER ImageName
    Docker image name

    .PARAMETER ComputerName
    Path to a Dockerfile, which is used for building an image

    .PARAMETER DockerParams
    Path(s) to Docker context directory
#>
function RunContainer {
    param (
        [Parameter(Mandatory=$true)]    [string]    $ImageName,
        [Parameter(Mandatory=$false)]   [string]    $ComputerName = "localhost",
        [Parameter(Mandatory=$false)]   [string[]]  $DockerParams = @()        
    )      

    # create new remote execution context if computername is used
    [bool]$useRemoteContext = ($PSBoundParameters.ContainsKey('ComputerName'))
    if ($useRemoteContext) {
        CreateRemoteContext -ComputerName $ComputerName
    }  
    [string]$ContainerName="MyDockerHelperContainer"
    if ($PSBoundParameters.ContainsKey('DockerParams')) {
        docker run --rm --name $ContainerName $ImageName $DockerParams
    }
    else {
        docker run --rm --name $ContainerName $ImageName "Fibonacci.ps1"
    }
    
    if ($useRemoteContext) {
        RemoveRemoteContext -ComputerName $ComputerName        
    }
    Write-Host "ContainerName: $ContainerName"
}

function CreateRemoteContext {
    param (        
        [Parameter(Mandatory=$true)]   [string]$ComputerName        
    )
    docker context create remote_$ComputerName --docker "host=ssh://$Env:UserName@$ComputerName"
    docker context use remote_$ComputerName
}

function RemoveRemoteContext {
    param (
        [Parameter(Mandatory=$true)]   [string]$ComputerName        
    )
    docker context rm remote_$ComputerName -f
}