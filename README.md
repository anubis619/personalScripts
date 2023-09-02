# Personal scripts

This repository contains a collections of scripts that I am making to handle some specific tasks and automate them.

Might not be amazing in look but I am learning by doing.


## WarThunder replay moving script

Location: [WarthunderScript](/Scripts/Powershell/warThunder_replay.ps1)  

When playing WarThunder Nvidia Gforce Experiece has a feature that captures 30 seconds of specific settings that I have selected. The main parts that I'm interested are kills of enemy or teammates (mostly by mistake :smile:)

The folder can keep up to 100GB of data at any given them. When it reaches that amount it will start to overwrite the old data. The goal of this script is to automate what I was doing manually in moving the files out when at 100GB or close. 

---

Mainly for myself to keep a note of what the script does.

Script functionality:  
* Setting the variables for where the recording part is located.
* Setting the variable to where I want to move the files
* Storing the free space of the partition where I want to move the .mp4 files.
* Subtracting 30GB from the free space to make sure I have some free space left at any given point
* Storing the recording path folder size
* Variable that contains the path of where I want to log the data
* Function that handles the log creation.
* Setting up voice output as one of the ways of letting me know that the script is done
* Main script.
  * Checks to see if the recording path is greater or equal to 80GB (it is set to 1 for testing)
  * makes sure that the partition free space is bigger than the recording path folder size
  * Get the current data so that it makes the new folder path structure
  * Variable to create the new folder name
  * Adding path and folder name together - Might be able to reduce them into one line instead
  * Added a if/else to make sure that the path does not exist
    * If it exists continue the script
    * If folder does not exist create it
      * Added error handling and logging in case this fails
  * Count the files to know how many are to be moved
  * Move all content of the recording folder to the new path. Added inside of a try/catch so that I can log if it fails
  * Count the files that are in the new folder
  * Inform via voice that the script is done
  * Log that it has finished successfully
* If the partition free space is smaller than the recording folder log failure in the log file
* Final else that stops the script of the recording folder is smaller than 80GB (1Gb for testing phase)
* Log the information into the log file.
