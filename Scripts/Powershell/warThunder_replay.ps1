<#
A simple script that is running and moving the files out of the WT recording folder that NVIDIA is creating and moving them to a different folder when it passed 80GB

The script is made to check the folder size and when it is 80GB or higher it will run. Otherwise do nothing
#>

# Define the paths of the folder where recording are stored and where to move them
$recordingPath = "F:\Test"
$pathOfNewFolder = "F:\Test2"

# Variable to get the FreeSpace of the drive you want to store the files
$partitionSize = [math]::Round((Get-PSDrive -Name 'F' | Select-Object -ExpandProperty Free) / 1GB, 2)
# Allowing some space in the partion
$partitionSize = $partitionSize - 30
# Variable to get the recordingPath size in GB.
$getPathSize = [math]::Round((Get-ChildItem -Path $recordingPath -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB, 2)

# Creating the needed data to log the informaiton.
$logPath = "C:\Users\Anubis\Documents\scriptLogs"

# Creating the log mechanism
Function Log-Message() {
    param
    (
        [Parameter(Mandatory = $true)] [string] $Message
    )
 
    Try {
        #Get the current date
        $LogDate = (Get-Date).tostring("dd_MMM_yyyy")
 
        #Get the Location of the script
        If ($psise) {
            $CurrentDir = Split-Path $psise.CurrentFile.FullPath
        }
        Else {
            $CurrentDir = $Global:PSScriptRoot
        }
 
        #Frame Log File with Current Directory and date
        $LogFile = $logPath + "\" + $LogDate + "-warThunderScript_log" + ".txt"
 
        #Add Content to the Log File
        $TimeStamp = (Get-Date).toString("dd/MM/yyyy HH:mm:ss:fff tt")
        $Line = "$TimeStamp - $Message"
        Add-content -Path $Logfile -Value $Line
 
        Write-host "Message: '$Message' Has been Logged to File: $LogFile"
    }
    Catch {
        Write-host -f Red "Error:" $_.Exception.Message 
    }
}



# Code to inform you when the files have been moved as it is supposed to run in the background. 

# Create a new SpVoice objects
$voice = New-Object -ComObject Sapi.spvoice
# Set the speed - positive numbers are faster, negative numbers, slower
$voice.rate = 0



if ($getPathSize -ge 1) {
    if ($partitionSize -gt $getPathSize) {
        # Write-Output "The fize of F is bigger than $getPathsize"
        $todaysDate = Get-Date -Format "dd_MMM_yyyy"
        $folderName = $todaysDate + "-Replays"
        $newPath = $pathOfNewFolder + "\" + $folderName
        # Create new folder if it does not exist. Continue if it does
        if (Test-Path -Path $newPath) {
            # Path Exists we continue and do not create a new folder
            Log-Message "Folder $newPath exists. Continue the script without creating and moving to next steps which involves moving the files."
        }
        else {
            Try {
                mkdir "F:/Test2/Something" -ErrorAction Stop
                Log-Message "Folder $newPath did not exist so we went ahead and created it."
            }
            Catch {
                $errorMessage = $_
                Log-Message "There was an error while trying to create $newPath. Please investigate."
                Log-Message "Error Message: $errorMessage"
            }
            
        }
        $getCountofFilesToMove = (Get-ChildItem -Path $recordingPath\* -Include *.mp4 | Measure-Object).Count
        # Move the content of the original folder. Return error if it fails
        try {
            Get-ChildItem -Path $recordingPath\*.mp4 -Recurse | Move-Item -Destination $newPath -ErrorAction stop
        }
        catch {
            <#Do this if a terminating exception happens#>
            $errorMessage = $_
            Log-Message "There was an error while trying to create $newPath. Please investigate."
            Log-Message "Error Message: $errorMessage"
        }
        # Count the content that has been moved
        $checkHowManyFilesWhereMoved = (Get-ChildItem -Path $newPath\* -Include *.mp4 | Measure-Object).Count
        # Inform that script is done        
        $voice.speak("Hey, we have moved the content of the $recordingPath folder to $newPath folder. The folder $recordingPath had $getCountofFilesToMove files and we have moved $checkHowManyFilesWhereMoved to $newPath")
        Log-Message "The folder $recordingPath had $getCountofFilesToMove files and we have moved $checkHowManyFilesWhereMoved to $newPath"
    }
    else {
        Log-Message "The $pathOfNewFolder has less space than the $recordingPath. Move terminated."
    }
    # Write-Output "Size is $getPathSize"
}
else {
    Write-Output "Size is less than 1"
    Log-Message "The folder $recordingPath size is smaller than 80GB."
}