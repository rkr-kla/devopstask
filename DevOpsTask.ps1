Import-Module .\DockerHelper

New-Item -Path "." -Name "temp_image" -ItemType Directory -Force
$ComputerName = "192.168.1.100"
CopyPrerequisites -Path @("Dockerfile","Fibonacci.ps1") -Destination "temp_image" -ComputerName $ComputerName
BuildImage -Dockerfile "Dockerfile" -Context "temp_image" -Tag "kruegro/fibonacci" -ComputerName $ComputerName
RunContainer -ImageName "kruegro/fibonacci" -DockerParams @("Fibonacci.ps1", "-n", "4") -ComputerName $ComputerName
