# Warthunder replay

Description: The scope of this is that when playing warthunder and doing a kill or similar a 30 seconds recording will be captured by NVIDIA. The limit of the folder is 100GB until it start to remove old files.
To resolve this I thought about building a script that would check the folder size and when it gets to 99GB to move the content to a different folder so it keeps it fresh.

Pseudo code:

1. Schedule task
2. Check folder size.
   1. If folder_size > 90Gb:
      1. Check size of the Drive. 
         1. If free space is more than 100GB:
            1. Create new folder with todays date in the format of 31_Aug_2023-Replays
            2. Move content to different folder
            3. Send notification
         2. Else:
            1. Send error notification
   2. Else:
      1. Put script to wait.


- Enhancement. Can I make the script start when I start the WarThunder launcher? Should be doable

What I know:

- Folder path of the recordings is `C:\Users\Anubis\AppData\Local\Temp\Highlights\War Thunder`
- Folder where I should move them `D:\Wt_saves`
  - When I move them I should create a folder with the date when it was moved.
    - Example: 31_Aug_2023-Replays
    - Move all the content of the recording to the new folder.

Get the folder size.

```Powershell
[math]::Round((Get-ChildItem -Path C:\WarThunder -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB,2)
```

---

# 31-08-2023

* The following parts of the script have been done:
	* Check Folder A size
	* Set new folder path
	* Get the size of the Folder A 
	* Get the free space of the drive where we want to move
	* Create the if statement to handle the functionality
		* If FolderA size is greater than x:
			* If Drive where we move has more space than what we move:
				* Get current date in the format of "dd_MMM_yyyy" and store it in the variable `$todaysDate`
				* Create the variable `$folderName` where we concatenate `$todaysDate`  + `-Replays`
				* Create the folder  `$pathOfNewFolder\$folderName`
				* Get the files inside of the folder where the recordings are stored and move them to the new path created above
				* Once done use the voice method to output that the files have been moved
			* Else:
				* TODO - Set the error part
		* Else:
			* Script should stop. Do nothing

TODO:
	- Create the error part if the size is smaller. 
		- Suggest informing me of that
	- Add the logging mechanism to add the information to the log file so that we know what happens.


- Can I dump this into a SIEM tool and get it logged there?
- Once the powershell script is complete convert it to Python so that you learn how to do the same there as well.