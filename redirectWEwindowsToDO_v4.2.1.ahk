/*	Copyright: autocart (user name at the ahk and Directory Opus forums) unless otherwise noted in the code
Regarding my code, I am just a hobby ahk programmer, so please don't be too critical with my coding style and mess, thank you.
!! This code is provided "AS IS". Usage is completely at your own risk. No warranties from my side. !!

Script: "redirectWEwindowsToDO"
Version: 4.2.1
Date: 2022-10-20

CONTENTS

INTRO
HOW TO CONTROL REDIRECTIONS
MORE SETTINGS
KNOWN LIMITATIONS
CREDITS
CHANGE LOG
IDEAS FOR THE FUTURE


INTRO

Hi all,
here is a script written in AutoHotkey (AHK), which works in combination with the file explorer Directory Opus (from now on called "DO") and Windows Explorer (from now on called "WE").

The script was written for the following scenarios:

(A) XY's setting "XY is default file manager" is not getting respected by some programs
Despite XY's build-in optional functionality to act as the system's default file manager (XY menu Tools/Configuration/Other/Shell Integration), sometimes there still are WE windows opening instead of XY (e.g. from within certain 3rd-party-software or for other reasons).

(B) List items are not getting automatically selected in XY
At other times XY *is* sucessfully used as the system's default file manager to open a folder (if that setting is on) but any list itmes which would normally be selected in WE do *not* get selected in XY (e.g. when clicking in Firefox in the "downloads" window on the "open containing folder" button).

For such scenarios, this script, if running in the system tray, catches any newly opening WE window, reads the path and selected items shown in that WE window, closes that WE window, opens a new tab in XY with that path *and* selects any list items in XY that where selected in WE before (and scrolling them into view), thus "redirecting" the WE window to XY.

Hint:
For the script to work also in cases of scenario No. (2), of course, the XY setting to act as the system's default file manager must be turned *off*.

The script will stay in the system tray until manually exited through the script's tray context menu.

Some of the scripts settings can be customized by the user. These settings are located in a separate config file. That config file is named "redirectWEwindowsToXY_v#.#.config.ahk", with "#.#" standing for the config file's version number, e.g. “4.1“. Each config file is compatible to all scripts who's version number starts with those same digits. However, a script file's version number may be longer.


HOW TO CONTROL REDIRECTIONS

There are WE windows that should not be redirected, e.g. control panel windows. Various users might also want to keep various other content inside WE, e.g. any special folders, for what reason ever. Thus, if one wants any WE windows to be kept as WE windows and *not* be redirected to XY, then there are the following two options:

(I) Manually Escape Redirection With the Control Key
Hold the left or right control key pressed down while the WE window opens, which you want to keep. Typically, the control key must be held down until the WE window is actually visible. If released too early, it might not work.

Example:
With the script running, pressing Win+E would open a new WE window which normally would get redirected to XY.
Pressing Control+Win+E, the new WE window would *not* get redirected to XY. (Of course the control key escape option should work also if a WE window is opened by other means.)

This functionality of the control key can be activated or deactivated on the fly in the script's system tray context menu, by clicking on the applicable menu item. The item also serves as a reminder that you can use the control key in such a way. Currently, there is no other way to deactivate it, e.g. in the config file, but it is on the to-do list.

(II) Automatically escape redirection with keyword and path definitions:
The script allows to specify keywords and paths that are then compared with the location being displayed in a new WE window. That location typically amounts to the same as the content of the WE address bar, e.g. "Computer", "Libraries", "Pictures", etc., and actual paths. Based on the result of the comparision the script will either redirect the WE window to XY or not. Details in the next paragraphs.

The Compare Method

The method of how the keywords and paths are compared with the WE window's location can be specified in the setting vUseRegExForPathCompare. The setting can have one of the following two values:
(A) "1": The "RegEx" (Regular Expressions) compare method is used. That means that RegEx patterns (PCRE flavor) can be used for keywords and paths. This compare method is recommended due to its ability to formulate general patterns.
(B) "0": The "identical" compare method is used. That means that one of the keywords or paths and the WE window's location must be identical to be a match.

Hint:
Regarding RegEx, here are some helpful sites for learning and formulating:
https://www.regular-expressions.info/quickstart.html
https://regex101.com/ (a testing environment)

Keywords and Paths

For specifying the keywords and paths themselves, the following two options for doing so are available:
(A) They can be specified in the setting vWindowsExplorerPaths - each separated by "|" (pipe character).
(B) They can be passed to the script as command line parameters - each separated by a space (and quoted if they contain spaces).
In both cases, any folder paths must be specified without trailing backslash. (The trailing backslash thing is on the to-do list, so that the user should not have to care about it anymore. However, it is harder to take care of it than one might think.)

Both kinds options of specification *are* allowed together at the same time.

Example with command line parameters:
"path_to_autohotkey.exe" "path_to_script.ahk" Computer Libraries Pictures "C:\some kind of folder\another folder"

Hint:
In the config file there are some suggestions for keywords to be used on an English, German, and Spanish version of Windows.

Exceptions from general RegEx patterns

If RegEx is used as a compare method, then the script also allows to specify exception patterns from the main patterns. Therefore, those main patterns can contain more general patterns and the exception patterns can take care of special exceptional cases. (Since this setting would not make any sense for the "identical" compare method, it is ignored in that case.)

These exception patterns can be specified in the setting vExceptionPathsInCaseOfRegEx. There is no option to feed them by command line. Of course, they also use RegEx syntax. Again, each exception must be separated by "|" (pipe character).

Choose Redirect or Keep

The User can specify whether all the matching new WE windows are redirected to XY or, otherwise, all the not matching ones are redirected. This is specified in the setting vKeepOrRedirect_matchingWEPaths. The setting can have one of the following two values:
(A) "Redirect": All matching new WE windows *are* redirected. All not matching ones are *not* redirected.
(B) "Keep": All matching new WE windows are *not* redirected (they are "kept" as they are). All not matching ones *are* redirected.


MORE SETTINGS

Redirection at Scriptstart

The script can apply auto-redirection also to all WE windows already existing at the moment of the script's start (not just to newly created ones while it is running in the background). This behavior can be activated in the setting vApplyRulesToExistingWEwindowsAtScriptStart. The setting can have one of the following two values:
(A) "1": activated
(B) "0": deactivated

Manual Redirection (to XY)

WE Windows that did not get redirected to XY can be redirected manually. This is done by pressing a keyboard shortcut, aka "hotkey", while the source WE window is active. The user can specify the key combination for manual redirection in the setting vHotkeyInWEwindowsToTriggerRedirectionToXY. Details are given in the config file next to the setting.

The hotkey can be activated or deactivated on the fly in the script's system tray context menu. As a reminder, the corresponding menu item also shows which hotkey has been specified. If no such hotkey is specified, then the system tray context menu will contain an item indicating that the hotkey could be defined but has not been.

Hint:
Since the hotkeys for manual redirection (to XY) and for redirection from XY to WE only work in their respective source applications, both hotkeys can be set to the same keyboard combination. This could save brain power.

Manual Redirection from XY Back to WE

Also XY tabs can be redirected to WE (the other direction than usual), but only manually. This is done by pressing a keyboard shortcut, aka "hotkey", while XY is active and the source tab is open. The user can specify the key combination for redirection in the setting vHotkeyInXYtabsToTriggerRedirectionToWE. Details are given in the config file next to the setting.

In case that a view in XY does not have a real path (e.g. "My Computer" or XY paper folders), WE for now always opens with the "My Computer" view.

The hotkey can be activated or deactivated on the fly in the script's system tray context menu. As a reminder, the corresponding menu item also shows which hotkey has been specified. If no such hotkey is specified, then the system tray context menu will contain an item indicating that the hotkey could be defined but has not been.

Additionally, the script can be told to close the tab in XY or not. This can be specified in the setting vCloseXYtabIfRedirectedToWE. The setting can have one of the following two values:
(A) "1": Close the XY tab when redirected to WE
(B) "0": Do not close the XY tab
However, in case that the view in XY does not have an existing path, the XY tab is not closed, regardless of this setting.

Hint:
Since the hotkeys for manual redirection (to XY) and for redirection from XY to WE only work in their respective source applications, both hotkeys can be set to the same keyboard combination. This could save brain power.

XY Autostart

If XY is not running it will be started automatically if the path to XYplorer.exe is specified correctly. The path can be specified in the setting vPathToXYplorerForAutostart. A tooltip close to the mouse cursor will indicate the starting process of XY. If the XY autostart should not work for some reason (e.g. if the wrong or no path is specified) the script will display a message box and wait for the user to start XY manually.

Redirection to XY Read-Only Instances

The following is more of an experimental feature to see if it is useful and if it gives users ideas for maybe other similar features.

Normally, the script redirects WE windows to the first found existing XY instance or else opens XY in a normal way. However, the script can be set to instead redirect WE windows each time to a new XY read-only instance (aka "throw away clone" - compare XY file menu > item "Open Throw Away Clone"). That can especially be beneficial with the setting to use a separate ini file in such a case (see below). This feature can be activated in the setting vOpenRedirectedPathsInSeparateReadOnlyXYInstances. The setting can have one of the following two values:
(A) "1": Use XY read-only instances for redirection
(B) "0": Use first found XY or open in normal way

Remark:
Always opening a whole new XY instance will most likely be considerably slower than reusing an existing one. So, use with low expectations. An alternative idea could be to keep one dedicated XY instance (with or without a special ini file) always running just for the purpose of redirection. Feedback and ideas are welcome.

Separate Ini File for XY Read-Only Instances

When the script is set to use XY read-only instances for redirection (see above) it can also use a separate ini file to open these XY instances with. Thus these XY read-only instances can, e.g., have either a simplified or an especially complex layout - whatever one wants.

The name and path to this ini file can be specified in the setting vUseSeparateIniFileInCaseOfReadOnlyXYInstance. If the specified ini file does not exist or the setting is left blank, then the normal ini file is used also in read-only instances. More details are given in the config file next to the setting.

Autofocus of List in XY

Normally, it is not ensured that the list in XY will have focus after a redirection from WE. This can sometimes be annoying because it can be hard to distinguish the selected items when the list does not have focus. Therefore, in the setting vAutofocusListInXYAfterRedirection the script can be told to automatically focus the list in XY after a redirection from WE. The setting can have one of the following two values:
(A) "1": Autofocus list after a redirection from WE
(B) "0": Do not change focus in XY after a redirection from WE

Zip and Other Files

WE windows can show the content of a zip file, whereas XY cannot.

Therefore, if the "identical" compare method is used, WE windows that show the content of a zip file, are *not* automatically redirected to XY. They are kept as WE windows. Otherwise the content view of the zip file would be lost.

However, if RegEx is used as compare method, then the user must specify it manually in one of the RegEx patterns if he/she wants a zip file content view to be kept in WE (e.g. with \.zip$ either as part of a "keep pattern" or as part of an "exeption to redirection pattern").

If (for any reason) any file path is redirected to XY (zip or any other file), then the XY tab is opened at the containing folder and the file is selected in the list.

Temporary Script Suspension

The whole script with all its functionality can be suspended/unsuspended in the script's system tray context menu and/or with a global keyboard shortcut, aka "hotkey". The user can specify the key combination for the global hotkey in the setting vHotkeyGlobalToSuspendUnsuspendTheWholeScript. Details are given in the config file next to the setting.

As a reminder, the corresponding menu item also shows which hotkey has been specified. If no such hotkey is specified, then the system tray context menu will contain an item indicating that the hotkey could be defined but has not been.

This hotkey cannot be deactivated on the fly, as can the hotkeys for manual redirection (to XY) and for redirection from XY to WE.


KNOWN LIMITATIONS

-) Whenever a WE window is "redirected" to XY, it will still open for a short moment in a normal way before it is closed again. For this script to work, I do not know of any way how to avoid that.
-) In case of multiple XY windows being open at the same time, the most recently active XY window will be used for redirection.
-) This script has not been tested with WE add-ons, which add tabs to WE.


CREDITS

First of all, not all AHK code used in the script was written by me. I am specifically pointing out in the code itself, where I got it from if it was from someone else. Other than that, all the following cool people helped so far (as of 2021-08-30) with e.g. testing, bug fixing, suggestions and motivation, as can be seen in this script's forums' thread: viewtopic.php?f=7&t=10671

binocular222
kiwichick
yusef88
Dustydog (Special thanks to Dustydog for motivating me to pick this baby back up after a couple of years! This also shows that posting to a year's old thread is not bad at all but can be very good.)
yuyu
1024mb
Keagel
kotlmg
gb007
hankr123
sovot29146
wfeg


CHANGE LOG

Changes in version 4.2.1 - 210831:

-) The line 825 - WinWaitActive, ahk_id %vXYhWnd% - could have caused the redirection to pause until XY was manually activated. I think I had it in previous versions and wrongly readded it in in 4.2 again. Since the script seems to work better without the line, I commented it out (again).

Changes in version 4.2 - 210831:

-)  Added a tray menu item which activates or deactivates the hotkey for redirecting
XY tabs manually to WE, that is specified in the config file.
-)  Added the variable vAutofocusListInXYAfterRedirection to the config file to specify
if the list in XY should automatically get focus after a redirection, in case some other
part of XY has focus at the time. This can be useful, because if the list does *not* have
focus, then any selected items might visually not be distinguishable so easily.
-)  Added the variable vOpenRedirectedPathsInSeparateReadOnlyXYInstances to the
config file to specify whether redirected WE paths should be opened in separate (new)
XY read-only instances or in the normal XY window as new tab.
-)  Added the variable vUseSeparateIniFileInCaseOfReadOnlyXYInstance in the config
file to specify a path to a separate ini file (e.g. for the layout) that should be used
for read-only XY instances. If left blank, the normal ini file is used.
-)  The tray icon context menu can now be opened also with a single left mouse button
click on the tray icon. Before, the context menu opened only with a right mouse button
click.
-)  Changed the indicator symbol in the tray menu for the suspended state from a check
mark to a big fat dot. This way it might be less confusing, since the meaning of the
other checkable items is slightly different, plus their logic is reverse too (check =
hotkeys are "on" but with the suspend item it means check = script is "off"). Just a
little tiny experiment. (FYI, other indicator symbols for the tray menu items are, it
seems, not available in standard AutoHotkey.)
-)  If a hotkey is not defined, then the tray item context menu will still generate an
entry indicating that the hotkey could be defined but has not been. (BTW, the Ctrl-Hotkey
for manually avoiding redirection is, so far, hard coded / not user definable. Right now
it can be de-/activated but only through the tray icon context menu at runtime. However,
this is on the to-do list.)
-)  Tried to improve the structure and the explanations in the config file a bit.
-)  Internal change: Added StringReplace, path, path, file://, // to the function
Explorer_GetPath(hwnd=""), as suggested by gb007
(https://www.xyplorer.com/xyfc/viewtopic.php?f=7&t=10671&start=75#p179211)
-)  Internal change: Added quotes to the autorun-path of XY.
-)  Internal change: Updated the XYmessenger functions.
-)  Internal change: Changed how the red-S tray icon in suspended/deactivated state is
generated.

Changes in version 4.1 - 200512:

-)  Added the variable vHotkeyInXYtabsToTriggerRedirectionToWE to the config file
to specify a hotkey to manually redirect a tab in XY to WE (which is the opposite
direction than usually). This hotkey only works in XY.
It can be set to the same hotkey as vHotkeyInWEwindowsToTriggerRedirectionToXY is
set to, which only works in WE, so that the hotkey serves as kind of a toggle-hotkey
between XY and WE. (As suggested by Dustydog, see
https://www.xyplorer.com/xyfc/viewtopic.php?f=7&t=10671&p=178249#p178248)
In case that a view in XY does not have a real path (e.g. "My Computer" or XY paper
folders), WE for now always opens with the "My Computer" view.
-)  Added the variable vCloseXYtabIfRedirectedToWE to the config file to specify
whether or not the XY tab should be closed if it is redirected to WE.
In case that the view in XY does not have a real path, the XY tab is not closed,
regardless of this variable.
-)  Internal change: Changed the function name ShellMessage_forCtrlWinE to
ShellMessage_keepTheNextWEwindow.

Changes in version 4.0 - 200501:

-) Moved the user customize section out into a separate .config.ahk file. (As suggested
   by 1024mb, see https://www.xyplorer.com/xyfc/viewtopic.php?f=7&t=10671&start=45#p177998)
   This helps the user to not have to update the user customizeation part of
   the script each time a new version is released. Plus, it is easier to keep the
   overview in a much shorter file without the distraction of the intro or the
   main code below. The new .config.ahk file carries the first two digits of the
   version number of the script version, which it belongs to, in its name, e.g.
   “4.1“. The main version and/or the first sub-version number of the script
   (and thus the name of the .config.ahk file) will from now on be incremented
   only, if the compatibility of the .config.ahk file changes. When the script is
   updated but the compatibility with the config file stays the same, only the 3rd
   part of the script's version number will be incremented, e.g. “4.1.2“. (At first
   I was about to increment only the script's main version number each time the
   config file would change, but realized that there might still be a considerable
   amount of new user settings to come?, so the chances that the main version
   number would go up fast seemed to risky to me.)
-) Added a check for the script file's encoding and the encoding of the new config.ahk
   file. If they are not saved in the UTF-8 format with BOM, then the script will pop
   a message box and refuse to run.
-) Added a global hotkey, specified in the variable
   vHotkeyGlobalToSuspendUnsuspendTheWholeScript in the .config.ahk file, which will
   suspend or unsuspend the script. (As suggested by Dustydog, see
   https://www.xyplorer.com/xyfc/viewtopic.php?f=7&t=10671&start=30#p177771)
-) Added a tray menu item which toggles the use of Ctrl to manually keep a WE
   window (just in case).
-) Renamed the tray menu items a bit.

Changes in version 3.4.1 - 200430:

-) Fixed a bug with none-ascii characters.
   Saved the script file as with UTF-8 *with* BOM. Before it was saved as UTF-8
   without BOM, which caused none-ascii characters to be processed incorrectly.

Changes in version 3.4 - 200429: (only bug fixes)

-) Maybe fixed that XY sometimes crashed when being autostarted. When XY was
   autostarted it sometimges crashed, as it seems, without the line "WinWait,
   XYplorer ahk_class ThunderRT6FormDC", which is strange to me because the
   code before that line should have aleady made sure that the XY window exists.
   However, it did not always crash. Re-added that line in for now, nevertheless.
   So far, it never crashed on autostart with that line.
-) Fixed / Changed (hopefully improved) the way how paths, which are being
   redirected to XY, are passed to XY. There could have been problems with how
   paths were compared to the existing tabs. Especially if the redirected path was
   a sub path of an existing tab, it would have not opened a new tab but changed
   the current tab to the new path.
-) Fixed a bug by which the script would send XY into a scripting error, if the
   redirected path contained single quote characters.
-) Fixed a bug that if a path was redirected to XY and the list in XY did *not* have
   focus, then any selected items in WE would be selected in XY but not be scrolled
   into view. Now they are (respectively the first selected item is).
-) Fixed a bug preventing to manually force redirect zip content views to XY.
-) Fixed / Changed the way how paths, that are really files (e.g zip files), are
   handled when passed to XY. There was an inconsistency in the code how such
   paths were handled, which could have led to XY displaying nothing in a new tab.
   This was highly unlikely to surface to the user, but might have after the fix
   above. Now, if the path is really a file, then the path to the parent directory of
   that file is always taken as the redirected path and the file as selection.

Changes in version 3.3 - 200428:

-) Fixed some wrong logic in the processing of events. Previously, if XY was not
   already running, it would be automatically started also if the WE window was to
   be kept as WE window. In that scenario also, if no correct path to XYplorer.exe
   was specified, then the script would still pop the corresponding message box and
   wait for XY to be started manually. This made not even any sense, since the WE
   window would anyway not be redirected to XY. This is changed now. The script
   will only check for the open XY window and react accordingly if the WE window
   is to be redirected.
-) Fixed a logical bug with RegEx compare: If hard coded keywords/paths were used
   AND command line parameters AND RegEx was used as compare method, then
   there was a logical bug which could have led to everything being a match (besides
   the RegEx-exeptions)
-) Changed the order of the help text a bit. Adjusted the order of the variables in
   the "USER CUSTOMIZE SECTION" of the code accordingly.
-) Added the variable vApplyRulesToExistingWEwindowsAtScriptStart to optionally
   apply the specified rules also to existing WE windows at script start.
-) Added the variable vHotkeyInWEwindowsToTriggerRedirectionToXY to be able to
   specify a hotkey to redirect WE windows to XY manually, if pressed while the
   targeted WE window is active.
-) Simplified the system tray context menu to three items:
	(1) Toggle menu item to use/activate the specified hotkey for redirecting WE
	    windows manually (or deactivate it).
	(2) Toggle menu item to Pause / Suspend Script which both pauses the script
	    and suspends the hotkeys.
	(3) Fully exit the script.

Changes in version 3.2 - 200425:

-) Added code for an optional custom tray icon and supplied a simple icon with it.
-) Renamed the variables; especially the variable with all the keywords and paths is
   now called vWindowsExplorerPaths.
-) Added the options/variables vKeepOrRedirect_matchingWEPaths,
   vUseRegExForPathCompare and vExceptionPathsInCaseOfRegEx.
-) Added some visual marking of the user customize section in the code below
-) In case the variable vKeepOrRedirect_matchingWEPaths has an incorrect value, a
   message box will pop.
-) Changed the hard coded behaviour of *not* redirecting the display of the content
   of zip files to XY:
   Now it is only hard coded for the case if RegEx is *not* used as compare method. If
   RegEx is used, then the behaviour for zip files can be specified in the RegEx pattern.

Changes in version 3.1 - 200424:

-) Fixed the problem that the script would crash if XY was not active.
-) The path to XY can now be specified in the variable $pathToXYplorer at the beginning
   of the code.
-) In case of a XY autostart process, a tooltip will be diplayed close to the mouse cursor.
-) In case the XY autostart process could not be started, a message box will pop.

Changes in version 3.0 - 200423:

-) Improved reliability:
   Before, the script sometimes missed WE windows or seemingly could not retrieve its
   path and then did not react as expected.
-) Improved behaviour when paused:
   Now the script is respecting the script's paused state (see the script's system tray
   context menu) in that it stops redirecting when the script paused. (As suggested by
   Dustydog, see https://www.xyplorer.com/xyfc/viewtopic.php?f=7&t=10671&start=30#p177771)
   Before it ignored the state of being paused and redirected anyway.
-) Changed the behaviour of the script regarding already existing WE windows:
   In previous versions, when the title bar of already existing WE windows (which existed
   prior to the scripts start) changed (e.g. when changing a folder in such a window or
   when refreshing by hitting F5), then the script also used to redirect such WE windows
   to XY. Not anymore. Now, if a WE window already exist at the scripts start, the script
   leaves it untouched.
-) Added a Control-key-escape option:
   If the left or right Control key is pressed while a WE window opens, then this
   particular WE window will *not* get redirected to XY.


IDEAS FOR THE FUTURE

-) make a separate help/readme file
-) maybe handle also other message scenarios - not just "window created"
-) maybe re-introduce automatic redirection of existing WE windows while browsing the file system in that WE window. I think, this has pros and cons. The pros are that if I specifially browse to a path which I want to open in XY it will be done automatically. The cons are that if I browse to a path which gets redirected to XY, I might have forgotten to think of it and might not want that at this very moment. I think for now, the new hotkey feature with which it is possible to manually force-redirect the current path/view in an WE window to XY, might be the best solution. But I am open for suggestions.
-) improve the MsgBox popping when the WE path could not be determined (maybe with debug-information that a user could then post in the forum for my knowledge) and make it easier for the end user to disable that MsgBox if he/she would want to not see it
-) add a compatibility check for the found config file; in case it is not there or it is an old version, offer the user to create a new config file with default values.
-) adding to the throw away clone idea (read-only instance): implement a functionality to move the throw away clone window tab to a main XY window tab. and vice versa.
-) adding to the throw away clone idea: allow the user to specify, which WE windows get redirected to a throw away clone window in XY and which get redirected to the main XY window
-) Add an entry to the tray menu to open the config file in the default editor.
-) Make a GUI for the config options.
-) Make the Ctrl-Hotkey for manually avoiding redirection user definable. (Right now it can only be de-/activated through the tray icon context menu at runtime.)
-) Take the burden off the user to have to think of defining paths without trailing backslash.
-) ... to be continued ...

The list above are just brainstorming results and not a real roadmap, just saying. For any suggestions for improvement I am grateful (whether they are aleady included in the list above or not), because I want this script to be of help to many users. Many thanks in advance!
*/



;*************************************************************
;;***************   HERE STARTS THE CODE   *******************
;*************************************************************

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
#Persistent
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global vSuspendedAndShellMessageDeactivated := 0
global vPathNameCustomFileIcon := A_ScriptDir . "\redirectWEwindowsToDO.ico"


#Include, %A_ScriptDir%\redirectWEwindowsToDO_v4.2.config

; Checks the specified files below for the correct file encoding "UTF-8" with BOM, if not compiled.
if !A_IsCompiled
{
	vFullPathFilesToBeCheckedForEncoding := A_ScriptFullPath . "|" . A_ScriptDir . "\redirectWEwindowsToDO_v4.2.config"
	Loop, Parse, vFullPathFilesToBeCheckedForEncoding, |
	{
		voFile := FileOpen(A_LoopField, "r")
		if (not voFile)
		{
			MsgBox, 262144, %A_ScriptName%, The attempt to check the file "%A_LoopField%" for the right encoding failed, because it could not be opened for reading, which is weird, because the AutoHokey exe itself had no problem reading it.`n`nPlease debug and then start the script again.`n`nThe script will terminate as soon as this dialog is closed.
			ExitApp
		}
		else if (not (voFile.Encoding == "UTF-8" and voFile.Position > 0))
		{
			if voFile.Position = 0
				vtextCurrentFileFormat := "However, it is saved without BOM. Die actual file format could thus not be determined."
			else
				vtextCurrentFileFormat := "However, it is saved as """ . voFile.Encoding . """."
			MsgBox, 262144, %A_ScriptName%, The file "%A_LoopField%" is saved in the wrong file format. It must be "UTF-8" *with* BOM. %vtextCurrentFileFormat%`n`nPlease save the file "%A_LoopField%" in "UTF-8" *with* BOM and then start the script again.`n`nThe script will terminate as soon as this dialog is closed.
			voFile.Close()
			ExitApp
		}
		voFile.Close()
	}
}


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;~~~~   INITIALIZATION of TRAY MENU - START   ~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*Close
if !A_IsCompiled
{
	Menu, Tray, UseErrorLevel
	Menu, Tray, Icon, %vPathNameCustomFileIcon%
}

Menu, Tray, NoStandard
Menu, Tray, Add, Use [Ctrl] to manually keep a WE window, _ToggleUseControlToKeepWE ;_ToggleUseControlToKeepWE()
Menu, Tray, Check, Use [Ctrl] to manually keep a WE window

if (vHotkeyInWEwindowsToTriggerRedirectionToXY)
{
	vDisplayFormatOfHKIWETTRTXY := StrReplace(StrReplace(StrReplace(StrReplace(vHotkeyInWEwindowsToTriggerRedirectionToXY, "+", "Shift+"), "#", "Win+"), "!", "Alt+"), "^", "Ctrl+")
	Menu, Tray, Add, Use [%vDisplayFormatOfHKIWETTRTXY%] to manually redirect WE to DO, _ToggleHotkeyIWETTRTXY ;_ToggleHotkeyIWETTRTXY()
	Menu, Tray, Check, Use [%vDisplayFormatOfHKIWETTRTXY%] to manually redirect WE to DO
}
else
{
	Menu, Tray, Add, [Hotkey to trigger WE -> XY not defined], _TrayMenuDummy
}

if (vHotkeyInXYtabsToTriggerRedirectionToWE)
{
	vDisplayFormatOfHKIXYTTRTWE := StrReplace(StrReplace(StrReplace(StrReplace(vHotkeyInXYtabsToTriggerRedirectionToWE, "+", "Shift+"), "#", "Win+"), "!", "Alt+"), "^", "Ctrl+")
	Menu, Tray, Add, Use [%vDisplayFormatOfHKIXYTTRTWE%] to manually redirect DO to WE, _ToggleHotkeyIXYTTRTWE ;_ToggleHotkeyIXYTTRTWE()
	Menu, Tray, Check, Use [%vDisplayFormatOfHKIXYTTRTWE%] to manually redirect XY to WE
}
else
{
	Menu, Tray, Add, [Hotkey to trigger XY -> WE not defined], _TrayMenuDummy
}

if (vHotkeyGlobalToSuspendUnsuspendTheWholeScript)
{
	vDisplayFormatOfHKGTSUSTWS := StrReplace(StrReplace(StrReplace(StrReplace(vHotkeyGlobalToSuspendUnsuspendTheWholeScript, "+", "Shift+"), "#", "Win+"), "!", "Alt+"), "^", "Ctrl+")
	Menu, Tray, Add, Suspend Script ([%vDisplayFormatOfHKGTSUSTWS%]), _TogglePauseAndSuspendScript, +Radio ;_TogglePauseAndSuspendScript()
}
else
{
	Menu, Tray, Add, [Hotkey to suspend script not defined], _TrayMenuDummy
}
Menu, Tray, Add, Exit Script, _ExitApp ;_ExitApp()

_TrayMenuDummy()
{
	return
}

OnMessage(0x404, "AHK_NOTIFYICON") ; According to the TrayIcon library, messages with ID 0x404 (1028) are sent from the tray icon to the AHK main window (A_ScriptHwnd). https://www.autohotkey.com/boards/search.php?author_id=74796&sr=posts
AHK_NOTIFYICON(wParam, lParam, uMsg, hWnd)
{
	; if (lParam = 0x201) ;WM_LBUTTONDOWN := 0x201 (seemed to work as WM_LBUTTONUP := 0x0202)
	if (lParam = 0x202) ;WM_LBUTTONUP := 0x0202
	; if (lParam = 0x203) ;WM_LBUTTONDBLCLK := 0x203
	{
		Menu, Tray, Show
	}
}
*/
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;~~~~   INITIALIZATION of TRAY MENU - END   ~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


if (vHotkeyInWEwindowsToTriggerRedirectionToXY)
{
	Hotkey, IfWinActive, ahk_class CabinetWClass
	Hotkey, %vHotkeyInWEwindowsToTriggerRedirectionToXY%, _TriggerWEwindowRedirectionToXY ;_TriggerWEwindowRedirectionToXY()
	Hotkey, If
}

if (vHotkeyInXYtabsToTriggerRedirectionToWE)
{
	SetTitleMatchMode, 2
	Hotkey, IfWinActive, dopus ahk_class dopus.lister
	Hotkey, %vHotkeyInXYtabsToTriggerRedirectionToWE%, _TriggerXYtabRedirectionToWE ;_TriggerXYtabRedirectionToWE()
	Hotkey, If
}

if (vHotkeyGlobalToSuspendUnsuspendTheWholeScript)
{
	Hotkey, %vHotkeyGlobalToSuspendUnsuspendTheWholeScript%, _TogglePauseAndSuspendScript ;_TogglePauseAndSuspendScript()
}


; checks if vKeepOrRedirect_matchingWEPaths has an allowed value and, if not, pops a message box
if (not (vKeepOrRedirect_matchingWEPaths = "Keep" or vKeepOrRedirect_matchingWEPaths = "Redirect"))
{
	MsgBox, 262144, %A_ScriptName%, The variable vKeepOrRedirect_matchingWEPaths must be either "Keep" or "Redirect", however it is "%vKeepOrRedirect_matchingWEPaths%".`n`nPlease, correct it in the user customize section of the code.`n`nThe script will terminate as soon as this dialog is closed.
	ExitApp
}

vKeepIfCtrlHeldDown := 1

; Before adding the command line parameters, ensure that the first and last char of vWindowsExplorerPaths is a pipe "|". (Necessary for the "identical" compare method.)
; However, the end must be checked first as to whether it already is a pipe, because if two consecutive pipes end up in the middle of the string (after command line parameters are added) then this would lead to unwanted results in case of the RegEx compare method. (compare below)
if (not SubStr(vWindowsExplorerPaths, 0) = "|")
	vWindowsExplorerPaths := "|" . vWindowsExplorerPaths . "|"
else
	vWindowsExplorerPaths := "|" . vWindowsExplorerPaths

/*	About incorrectly passed command line parameters:
	The help file says:
	Any parameter that contains spaces should be enclosed in quotation marks. A literal quotation mark may be passed in by preceding it with a backslash (\"). Consequently, any trailing slash in a quoted parameter (such as "C:\My Documents\") is treated as a literal quotation mark (that is, the script would receive the string C:\My Documents"). To remove such quotes, use StringReplace, 1, 1, ",, All.
	-> In my opinion that is a two edged sword. The core problem is that literal quotation marks are escaped with a backslash. Thus, two consecutive parameters of which the first ends on \" (backslash quote) are treated as one, no matter what. So, I comment the "correction" out in the next line for now.
	StringReplace, vWindowsExplorerPaths, vWindowsExplorerPaths, ",, All
	If wanted/needed, the whole raw command line can be correctly read using full_command_line := DllCall("GetCommandLine", "Str")
	Then it could be custom-parsed.
	For now, I go with instructing the user to NOT pass paths with a trailing backslash.
*/

For n, param in A_Args
{
    vWindowsExplorerPaths .= param . "|"
}

; if RegEx is used as comparision method, then the pipes "|" at the beginning and end must be removed again, because otherwise the ends would be interpreted as empty patterns which would always match
if vUseRegExForPathCompare
	vWindowsExplorerPaths := Trim(vWindowsExplorerPaths, "|")


; Make the GUI window the last found window for use by the line below.
Gui +LastFound
vHWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt, vHWnd )
vMsgNum := DllCall( "RegisterWindowMessage", Str, "SHELLHOOK" )
OnMessage( vMsgNum, "ShellMessage" )
; MsgBox, %vMsgNum%


if (vApplyRulesToExistingWEwindowsAtScriptStart)
{
	WinGet, vExistingCabinetWClassWindows, List, ahk_class CabinetWClass
	Loop %vExistingCabinetWClassWindows%
	{
		ShellMessage(1, vExistingCabinetWClassWindows%A_Index%)
	}
}

return

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;~~~~   END of AUTOEXECUTE SECTION   ~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


^#e::
;; ^#e::
; Using this construct so that the user in this particular case does not *have* to keep pressing the Ctrl key down until the WE window appears.
OnMessage( vMsgNum, "ShellMessage", 0 )
OnMessage( vMsgNum, "ShellMessage_keepTheNextWEwindow" )
Send, #e
return


ShellMessage_keepTheNextWEwindow( wParam, lParam )
{
	Critical
	global vMsgNum
	; When the function is triggered (by a new window message), do nothing, thus also a new WE window is kept.
	; Then (after doing nothing) set OnMessage back to the normal function.
	if (wParam = 1 and _WinGetClass("ahk_id " lParam) = "CabinetWClass")
	{
		OnMessage( vMsgNum, "ShellMessage_keepTheNextWEwindow", 0 )
		OnMessage( vMsgNum, "ShellMessage" )
	}
}

ShellMessage( wParam, lParam )
{
	global
	Critical

/*wParam =
HSHELL_ACCESSIBILITYSTATE
11
The accessibility state has changed.

HSHELL_ACTIVATESHELLWINDOW
3
The shell should activate its main window.

HSHELL_APPCOMMAND
12
The user completed an input event (for example, pressed an application command button on the mouse or an application command key on the keyboard), and the application did not handle the WM_APPCOMMAND message generated by that input.
If the Shell procedure handles the WM_COMMAND message, it should not call CallNextHookEx. See the Return Value section for more information.

HSHELL_GETMINRECT
5
A window is being minimized or maximized. The system needs the coordinates of the minimized rectangle for the window.

HSHELL_LANGUAGE
8
Keyboard language was changed or a new keyboard layout was loaded.

HSHELL_REDRAW
6
The title of a window in the task bar has been redrawn.

HSHELL_TASKMAN
7
The user has selected the task list. A shell application that provides a task list should return TRUE to prevent Windows from starting its task list.

HSHELL_WINDOWACTIVATED
4
The activation has changed to a different top-level, unowned window.

HSHELL_WINDOWCREATED
1
A top-level, unowned window has been created. The window exists when the system calls this hook.

HSHELL_WINDOWDESTROYED
2
A top-level, unowned window is about to be destroyed. The window still exists when the system calls this hook.

HSHELL_WINDOWREPLACED
13
A top-level window is being replaced. The window exists when the system calls this hook.

lParam differs in type according to the value of wParam received. For most of the wParam values, the lParam is a handle to a window that can be used as ahk_id %lParam% in AHK's Window commands.
*/

	; static vHWndsToIgnore := "|"

	; if ( (wParam = 1 or wParam = 6) and WinActive("ahk_class CabinetWClass"))
	if (wParam = 1 and _WinGetClass("ahk_id " lParam) = "CabinetWClass")
	{
		; if (InStr(vHWndsToIgnore, "|" lParam "|"))
		; 	return
		if (vKeepIfCtrlHeldDown and GetKeyState("Control", "P"))
		{
			; vHWndsToIgnore .= lParam "|"
			return
		}

		vPath := Explorer_GetPath(lParam)
		while ( vPath = "ERROR" and A_Index < 10)
		{
			 Sleep 100
			 vPath := Explorer_GetPath(lParam)
		}
		if ( vPath = "ERROR" )
		{
			 MsgBox Could not retrieve the path of the explorer window.
			 return
		}


		; If RegEx is *not* used as compare method, then keep WE in case of the content of a zip file
		if (not vUseRegExForPathCompare)
		{
			if (StrLen(vPath) > 3 and StrLen(vPath) - InStr(vPath, ".zip", 0, 0) = 3)
				return
		}


		if (vUseRegExForPathCompare)
		{
			; MsgBox, % vPath ", " vWindowsExplorerPaths ", " vKeepOrRedirect_matchingWEPaths
			if (RegExMatch(vPath, vWindowsExplorerPaths))
			{
				if (vKeepOrRedirect_matchingWEPaths = "Keep" and (not vExceptionPathsInCaseOfRegEx or not RegExMatch(vPath, vExceptionPathsInCaseOfRegEx)))
				{
					; MsgBox, 1
					return
				}
				else if (vKeepOrRedirect_matchingWEPaths = "Redirect" and vExceptionPathsInCaseOfRegEx and RegExMatch(vPath, vExceptionPathsInCaseOfRegEx))
				{
					; MsgBox, 2
					return
				}
				; MsgBox, 3
			}
			else if (vKeepOrRedirect_matchingWEPaths = "Redirect")
					return
		}
		else if (InStr(vWindowsExplorerPaths, "|" . vPath . "|"))
		{
			if (vKeepOrRedirect_matchingWEPaths = "Keep")
				return
		}
		else if (vKeepOrRedirect_matchingWEPaths = "Redirect")
			return


		vSelected := Explorer_GetSelected(lParam)
		StringReplace, vSelected, vSelected, % Chr(10), |, 1

		; if vPath is found in a normal way in the file system and is *not* a Directory = vPath is a file (e.g. a zip file)
		vFileAttrib := FileExist(vPath)
		if (vFileAttrib and not InStr(vFileAttrib, "D"))
		{
			SplitPath, vPath, , vOutDir
			vSelected := vPath
			vPath := vOutDir
		}


		;Opens in a new window in DOpus
		If (vSelected = "")   ;If vSelected is empty, set vSelected equal to vPath
		{
			vSelected = %vPath%
		}

		IfExist, %vPathToDOplorerForAutostart%
		{
			Run, %vPathToDOplorerForAutostart% /cmd Go "%vSelected%" NEWTAB=tofront			;If the file exists then run the following command
		}
		else IfExist, C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe                ;Otherwise, if the file exists then run the following command
		{
			Run, C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe /cmd Go "%vSelected%" NEWTAB=tofront
		}
		else IfExist, C:\Program Files\Directory Opus\dopusrt.exe                           ;Otherwise, if the file exists then run the following command
		{
			Run, C:\Program Files\Directory Opus\dopusrt.exe /cmd Go "%vSelected%" NEWTAB=tofront
		}
		else IfExist, D:\Program Files\GPSoftware\Directory Opus\dopusrt.exe                ;Otherwise, if the file exists then run the following command
		{
			Run, D:\Program Files\GPSoftware\Directory Opus\dopusrt.exe /cmd Go "%vSelected%" NEWTAB=tofront
		}
		else IfExist, D:\Program Files\Directory Opus\dopusrt.exe                           ;Otherwise, if the file exists then run the following command
		{
			Run, D:\Program Files\Directory Opus\dopusrt.exe /cmd Go "%vSelected%" NEWTAB=tofront
		}
		else
		{
			MsgBox, Not found dopusrt.exe.`n`nChange the path of dopusrt.exe in the ahk file.
			return
		}

		vXYDidNotAutostart := 0
		; SetTitleMatchMode, 2
		; vXYhWnd := WinExist("XYplorer ahk_class ThunderRT6FormDC")
		vXYhWnd := ahk_class dopus.lister
		;[Close it, change it to the following]if (not vXYhWnd or vOpenRedirectedPathsInSeparateReadOnlyXYInstances)
		if (vOpenRedirectedPathsInSeparateReadOnlyXYInstances)
		{
			SplitPath, vPathToXYplorerForAutostart, , vOutDir
			; MsgBox %vOpenRedirectedPathsInSeparateReadOnlyXYInstances%
			if vOpenRedirectedPathsInSeparateReadOnlyXYInstances
			{
				; MsgBox test
				;[Close]Run, "%vPathToXYplorerForAutostart%" /readonly /ini="%vSeparateIniFileInCaseOfReadOnlyXYInstance%" "%vPath%", vOutDir, UseErrorLevel, vOutputVarPID
				; Run, "%vPathToXYplorerForAutostart%" /readonly /script="::focus 'P1';if(get('#800')){#800;}goto '%vPath%';tab('closeothers');", OutDir, UseErrorLevel
				; Run, "%vPathToXYplorerForAutostart%" /readonly /script="::focus 'P1';tab('closeothers');if(get('#800')){#800;}" "%vPath%||%vPath%", OutDir, UseErrorLevel
				; Run, "%vPathToXYplorerForAutostart%" /readonly /fresh /script="::focus 'P1';" "%vPath%||%vPath%", OutDir, UseErrorLevel
				; Run, "%vPathToXYplorerForAutostart%" /readonly, OutDir, UseErrorLevel
			}
			else
			{
				;[Close]Run, "%vPathToXYplorerForAutostart%", vOutDir, UseErrorLevel
			}

			if (ErrorLevel = "ERROR")
			{
				vXYDidNotAutostart := 1
				vXYhWnd := ahk_class dopus.lister
				if (vXYhWnd and vOpenRedirectedPathsInSeparateReadOnlyXYInstances)
				{
					MsgBox, 262145, %A_ScriptName%, A read-only instance of XYplorer could not be started automatically. However, it was determined that a instance of XYplorer is already running.`n`nIf you click "OK", then the existing instance of XYplorer will be used for redirecting the WE path.`n`nIf you click "Cancel", then the WE window will not be redirected to XYplorer this time.
					IfMsgBox, Cancel
						return
				}
				; while not WinExist("XYplorer ahk_class ThunderRT6FormDC")
				while not vXYhWnd
				{
					MsgBox, 262145, %A_ScriptName%, XYplorer could not be started automatically. Please, start it manually.`n`nOnce XYplorer is started you can close this dialog in order to redirect the Windows Explorer window to XYplorer.`n`nPress Cancel in order to *not* redirect the Windows Explorer window to XYplorer this time.
					IfMsgBox, Cancel
						return
					vXYhWnd := ahk_class dopus.lister
				}
			}
			else
			{
				; WinWait, XYplorer ahk_class ThunderRT6FormDC
				; while not WinExist("XYplorer ahk_class ThunderRT6FormDC")
				SetTitleMatchMode, RegEx
				while not ((vOpenRedirectedPathsInSeparateReadOnlyXYInstances and (vXYhWnd := WinExist(".*XYplorer.* ahk_class ^dopus.lister$ ahk_exe \\dopus\.exe$ ahk_pid " vOutputVarPID))) or (not vOpenRedirectedPathsInSeparateReadOnlyXYInstances and (vXYhWnd := ahk_class dopus.lister)))
				{
					ToolTip, %A_ScriptName%:`n`nXYplorer is being started...
					Sleep, 20
				}
				ToolTip
			}

			; WinWait, XYplorer ahk_class ThunderRT6FormDC
			; vXYhWnd := WinExist()

			; in case that meanwhile the WE window does not exist anymore, then return
			IfWinNotExist, ahk_id %lParam%
				return
		}

		;[Close]WinActivate, ahk_id %vXYhWnd%

		; WinWaitActive, ahk_id %vXYhWnd%
		; WinGetTitle, vtitle, %vXYhWnd%
		; WinGetClass, vclass, %vXYhWnd%
		; MsgBox, "%vXYhWnd%", "%vtitle%", "%vclass%", "%vOutputVarPID%"

		; close the WE window
		WinClose, ahk_id %lParam%

		if (not vOpenRedirectedPathsInSeparateReadOnlyXYInstances or vXYDidNotAutostart)
		{
			;[Close]_XYmessenger_command("if(strpos('|' . get('tabs') . '|', ""|" . vPath . "|"") == -1) {tab('new', """ . vPath . """);} else {goto """ . vPath . """, 1;}", vXYhWnd, 0)
		}

		if (vSelected)
		{
			; MsgBox "%vSelected%"
			vArrSelected := StrSplit(vSelected, "|")
			;[Close]_XYmessenger_command("selfilter row(""" . vArrSelected[1] . """) . ',' . get('CountItems'), , '#', 0, 1;selectitems """ . vSelected . """;", vXYhWnd, 0)
			; _XYmessenger_command("selectitems """ . vSelected . """;", vXYhWnd, 0)
		}

		if (vAutofocusListInXYAfterRedirection)
		{
			;[Close]_XYmessenger_command("focus ""L"";", vXYhWnd, 0)
		}
	}
}
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;~~~~   END of ShellMessage( wParam, lParam )  ~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; #IfWinActive ahk_class ThunderRT6FormDC
; ^t::
; 	; MsgBox test45
; 	_XYmessenger_command("tabset('saveas', 'test24')", , 0)
; return



_TriggerWEwindowRedirectionToXY() {
	global
	Critical
	if (not vHWndWE := WinActive("ahk_class CabinetWClass"))
		return
	vWindowsExplorerPaths_org := vWindowsExplorerPaths
	vWindowsExplorerPaths := ""
	vKeepOrRedirect_matchingWEPaths_org := vKeepOrRedirect_matchingWEPaths
	vKeepOrRedirect_matchingWEPaths := "Redirect"
	vUseRegExForPathCompare_org := vUseRegExForPathCompare
	vUseRegExForPathCompare := 1
	vExceptionPathsInCaseOfRegEx_org := vExceptionPathsInCaseOfRegEx
	vExceptionPathsInCaseOfRegEx := ""
	vKeepIfCtrlHeldDown_org := vKeepIfCtrlHeldDown
	vKeepIfCtrlHeldDown := 0
	ShellMessage( 1, vHWndWE )
	vWindowsExplorerPaths := vWindowsExplorerPaths_org
	vKeepOrRedirect_matchingWEPaths := vKeepOrRedirect_matchingWEPaths_org
	vUseRegExForPathCompare := vUseRegExForPathCompare_org
	vExceptionPathsInCaseOfRegEx := vExceptionPathsInCaseOfRegEx_org
	vKeepIfCtrlHeldDown := vKeepIfCtrlHeldDown_org
}



_TriggerXYtabRedirectionToWE() {
	global
	Critical
	vXYhWnd := _XYmessenger_getXYhWnd(0)
	vCurPath := _XYmessenger_get("resolvepath(""<curpath>"")", vXYhWnd, 0)
	; vCurPath := XY_eval_and_returnvalue("resolvepath(""<curpath>"")")
	; MsgBox, % vCurPath
	if (not FileExist(vCurPath))
	{ ; If the path does not exist open explorer.exe with path "", which should always open the "My Computer" view.
		vCurPath := ""
	}
	OnMessage( vMsgNum, "ShellMessage", 0 )
	OnMessage( vMsgNum, "ShellMessage_keepTheNextWEwindow" )
	WinGet, vOutList, List, ahk_class CabinetWClass
	vActivehWnd := WinExist("A")
	Run, explorer.exe "%vCurPath%"
	; close the XY tab *after* visually opening WE (for psychological support for the user) and only if the path does actually exist (and of course if that setting is turned on)
	if (vCurPath and vCloseXYtabIfRedirectedToWE)
	{
		while 1
		{
			WinWaitNotActive, ahk_id %vActivehWnd%
			vActivehWnd := WinExist("A")
			WinGetClass, vOutClass, ahk_id %vActivehWnd%
			if (vOutClass = "CabinetWClass")
			{
				loop, %vOutList%
				{
					if (vOutList%A_Index% = vActivehWnd)
						continue, 2
				}
				break
			}
		}
		_XYmessenger_command("#351", vXYhWnd, 0) ; close tab
	}
}


_ToggleUseControlToKeepWE() {
	global
	; vKeepIfCtrlHeldDown := vKeepIfCtrlHeldDown ? 0 : 1
	vKeepIfCtrlHeldDown := 0
	Hotkey, ^#e, Toggle
	Menu, Tray, ToggleCheck, Use [Ctrl] to manually keep a WE window
}


_ToggleHotkeyIWETTRTXY() {
	global
	Menu, Tray, ToggleCheck, Use [%vDisplayFormatOfHKIWETTRTXY%] to manually redirect WE to XY
	Hotkey, IfWinActive, ahk_class CabinetWClass
	Hotkey, %vHotkeyInWEwindowsToTriggerRedirectionToXY%, Toggle
	Hotkey, If
}


_ToggleHotkeyIXYTTRTWE() {
	global
	Menu, Tray, ToggleCheck, Use [%vDisplayFormatOfHKIXYTTRTWE%] to manually redirect XY to WE
	SetTitleMatchMode, 2
	Hotkey, IfWinActive, dopus ahk_class dopus.lister
	Hotkey, %vHotkeyInXYtabsToTriggerRedirectionToWE%, Toggle
	Hotkey, If
}


_TogglePauseAndSuspendScript() {
	global
	Suspend, Toggle
	; if A_IsPaused
	if vSuspendedAndShellMessageDeactivated
	{
		OnMessage( vMsgNum, "ShellMessage")
		if A_IsCompiled
		{
			Menu, Tray, Icon, %A_ScriptFullPath%, 1, 1
		}
		else
		{
			Menu, Tray, Icon, %vPathNameCustomFileIcon%, 1, 1
		}
		vSuspendedAndShellMessageDeactivated := 0
	}
	else
	{
		OnMessage( vMsgNum, "ShellMessage", 0 )
		if A_IsCompiled
		{
			Menu, Tray, Icon, %A_ScriptFullPath%, 5, 1
		}
		else
		{
			Menu, Tray, Icon, %A_AhkPath%, 5, 1
		}
		vSuspendedAndShellMessageDeactivated := 1
	}
	; MsgBox test2
	; Pause, Toggle, 1 ; The Pause only is used for the tray icon to show a red S instead of a green S. Otherwise, it is not necessary to use the Pause command. And for checking A_IsPaused in the if clause above. Putting "Suspend, Toggle" after the if clause, does not prevent the hotkey from being suspended. But if I wanted to check in the if clause for A_IsSuspended, then I would have to reverse the if-logic, checking for if *not* A_IsSuspended, since it is already after the Suspend command in the code, which is stupid from the logical part of what this function should do. Thus, since Pause also helps with the tray icon, I might as well use it in the if clause.
	Menu, Tray, ToggleCheck, Suspend Script ([%vDisplayFormatOfHKGTSUSTWS%])
}


_ExitApp() {
	ExitApp
}


_WinGetClass(WinTitle := "", WinText := "", ExcludeTitle := "", ExcludeText := "")
{
	WinGetClass, class, %WinTitle%, %WinText%, %ExcludeTitle%, %ExcludeText%
	return class
}



;*****************************************************************************************************************
;~ Code from others  (or based on):
;*****************************************************************************************************************
/*
	Library for getting info from a specific explorer window (if window handle not specified, the currently active
	window will be used).  Requires AHK_L or similar.  Works with the desktop.  Does not currently work with save
	dialogs and such.


	Explorer_GetSelected(hwnd="")   - paths of target window's selected items
	Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder
	Explorer_GetPath(hwnd="")       - path of target window's folder

	example:
		F1::
			path := Explorer_GetPath()
			all := Explorer_GetAll()
			sel := Explorer_GetSelected()
			MsgBox % path
			MsgBox % all
			MsgBox % sel
		return

	Joshua A. Kinnison
	2011-04-27, 16:12
*/

Explorer_GetPath(hwnd="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	if (path="")
	path := window.LocationName
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All
	; next line added by me on 20200806; suggested by gb007 (https://www.xyplorer.com/xyfc/viewtopic.php?f=7&t=10671&start=75#p179211)
	StringReplace, path, path, file:\\, \\

	; thanks to polyethene
	Loop
		if RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		Else Break
	return path
}

Explorer_GetAll(hwnd="")
{
	return Explorer_Get(hwnd)
}

Explorer_GetSelected(hwnd="")
{
	return Explorer_Get(hwnd,true)
}

Explorer_GetWindow(hwnd="")
{
	; thanks to jethrow for some pointers here
    WinGet, process, processName, % "ahk_id " hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%


	; MsgBox, %hwnd%, %process%, %class%
	; ; if not process
	; 	MsgBox, % WinExist("ahk_id " hwnd)
	; ; return

	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows
			try if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW")
		return "desktop" ; desktop found
}

Explorer_Get(hwnd="",selection=false)
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
		if !hwWindow ; #D mode
			ControlGet, hwWindow, HWND,, SysListView321, A
		ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
		base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
		Loop, Parse, files, `n, `r
		{
			path := base "\" A_LoopField
			IfExist %path% ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}

;*****************************************************************************************************************

;heavily based on binocular222s work:
;https://www.xyplorer.com/xyfc/viewtopic.php?f=7&t=9233

_XYmessenger_command(p_xys_commandString, p_XY_hWnd := 0, p_allowScanForInactiveXY := 0, p_waitHowLongForXYToProcessMessage_ms := 600000) ; 600000 ms are 10 minutes
{
  if !p_XY_hWnd
    if (not (p_XY_hWnd := _XYmessenger_getXYhWnd(p_allowScanForInactiveXY)))
    {
      ErrorLevel := 1
      return 0
    }
  return _XYmessenger(p_xys_commandString, p_XY_hWnd, 0, p_waitHowLongForXYToProcessMessage_ms)
}


_XYmessenger_get(p_xys_expressionString, p_XY_hWnd := 0, p_allowScanForInactiveXY := 0, p_waitHowLongForReturn_ms := 600000) ; 600000 ms are 10 minutes
{
  if !p_XY_hWnd
    if (not (p_XY_hWnd := _XYmessenger_getXYhWnd(p_allowScanForInactiveXY)))
    {
      ErrorLevel := 1
      return 0
    }
  return _XYmessenger(p_xys_expressionString, p_XY_hWnd, 1, p_waitHowLongForReturn_ms)
}



;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;~~~~   INTERNAL FUNCTIONS   ~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; The ahk help for WinGet, , List says: "Windows are retrieved in order from topmost to bottommost (according to how they are stacked on the desktop)."
; Also, the Window Titles chapter says (e.g. for WinExist): "If multiple windows match the WinTitle and any other criteria, the topmost matching window is used. If the active window matches the criteria, it usually takes precedence since it is usually above all other windows. However, if an always-on-top window also matches (and the active window is not always-on-top), it may be used instead."
; Therefore, it is better to specifically test the currently active window first.
_XYmessenger_getXYhWnd(p_allowScanForInactiveXY := 1)
{
	v_org_titleMatchMode := A_TitleMatchMode
  SetTitleMatchMode, RegEx
  v_XY_hWnd := WinActive("ahk_class ^ThunderRT6FormDC$ ahk_exe \\XYplorer\.exe$")
  if !v_XY_hWnd and p_allowScanForInactiveXY
    v_XY_hWnd := WinExist("ahk_class ^ThunderRT6FormDC$ ahk_exe \\XYplorer\.exe$")
	SetTitleMatchMode, % v_org_titleMatchMode
  return v_XY_hWnd
}


_XYmessenger_cleanUp(p_arr_cleanUp) {
  SetWinDelay, % Array.Pop()
}


_XYmessenger(p_xys_commandOrExpressionString, p_XY_hWnd, p_returnResult, p_waitHowLongForReturn_ms)
{
  v_arr_cleanUp := Array(A_WinDelay)
  SetWinDelay, -1

  if (!WinExist("ahk_id " p_XY_hWnd))
  {
    _XYmessenger_cleanUp(v_arr_cleanUp)
    ErrorLevel := 1
    return 0
  }

  v_ahk_hWnd := A_ScriptHwnd + 0  ;Return this script's hidden hwdn id.  +0 to convert from Hex to Dec

  if p_returnResult
  {
    MessagetoXYplorer := "::CopyData " v_ahk_hWnd ", " p_xys_commandOrExpressionString ", 0"    ;resolves to sth like this:   ::CopyData 7409230, <curitem>, 0   _OR like this:  ::CopyData 7409230, tab('get','count'), 0
  }
  else
  {
    MessagetoXYplorer := "::" p_xys_commandOrExpressionString    ;resolves to sth like this:   ::loadtree get('tree').'|'.listfolder(,,2)
  }

  Size := StrLen(MessagetoXYplorer)
  if !(A_IsUnicode)
  {
    VarSetCapacity(Data, Size * 2, 0)
    StrPut(MessagetoXYplorer, &Data, Size, "UTF-16")
  }
  Else
    Data := MessagetoXYplorer

  VarSetCapacity(COPYDATA, A_PtrSize * 3, 0)
  NumPut(4194305, COPYDATA, 0, "Ptr")
  NumPut(Size * 2, COPYDATA, A_PtrSize, "UInt")
  NumPut(&Data, COPYDATA, A_PtrSize * 2, "Ptr")
  if p_returnResult
  {
    global v_XYmessenger_returnMessageProcessed := 0
		global v_XYmessenger_XYreturnValue := ""
    v_waitForReturnInterval := 10 ;ms

		OnMessage(0x4a, "_XYmessenger_receive_WM_COPYDATA")  ; 0x4a is WM_COPYDATA. This onhold and wait for the WM_Copydata from XYplorer then execute Function_Receive_WM_COPYDATA(wParam, lParam) below
    v_startTimeWaiting := A_TickCount
		SendMessage, 0x4a, 0, &COPYDATA, , ahk_id %p_XY_hWnd%, , , , %p_waitHowLongForReturn_ms% ;SendMessage waits for the target window to process the message, up until the timeout period expires. Timeout: The maximum number of milliseconds to wait for the target window to process the message. If omitted, it defaults to >> 5000 << (milliseconds), which is also the default behaviour in older versions of AutoHotkey which did not support this parameter. If the message is not processed within this time, the command finishes and sets ErrorLevel to the word FAIL. This parameter can be an expression.
    while !v_XYmessenger_returnMessageProcessed
    {
      if (A_TickCount - v_startTimeWaiting >= p_waitHowLongForReturn_ms)
      {
        OnMessage(0x4a, "")
        _XYmessenger_cleanUp(v_arr_cleanUp)
        ErrorLevel := 1
        return 0
      }
      Sleep, % v_waitForReturnInterval
    }
    OnMessage(0x4a, "")
    _XYmessenger_cleanUp(v_arr_cleanUp)
		ErrorLevel := 0
    return v_XYmessenger_XYreturnValue
  }
  else
  {
	;~ PostMessage, 0x4a, 0, &COPYDATA, , ahk_id %p_XY_hWnd% ;PostMessage places the message in the message queue associated with the target window. It does not wait for acknowledgement or reply.
    SendMessage, 0x4a, 0, &COPYDATA, , ahk_id %p_XY_hWnd%, , , , %p_waitHowLongForReturn_ms% ;By contrast, SendMessage waits for the target window to process the message, up until the timeout period expires. Timeout in ms.
    _XYmessenger_cleanUp(v_arr_cleanUp)
    ErrorLevel := 0
	return 1
  }
}

_XYmessenger_receive_WM_COPYDATA(wParam, lParam)
{
  Critical
  global v_XYmessenger_returnMessageProcessed
  global v_XYmessenger_XYreturnValue
  StringAddress := NumGet(lParam + 2*A_PtrSize) ;lParam+8 is the address of CopyDataStruct's lpData member.
  CopyOfData := StrGet(StringAddress)    ;May also specify CP0 (default) or UTF-8 or UTF-16:   StrGet(StringAddress, NumGet(lParam+A_PtrSize), "UTF-16")
  cbData := NumGet(lParam+A_PtrSize)/2  ;cbData/2 = String length
  StringLeft, Datareceived, CopyOfData, cbData
  v_XYmessenger_XYreturnValue := Datareceived
  v_XYmessenger_returnMessageProcessed := 1
}

/*
From the XYplorer help file:

COPYDATA

Sends data to another window.

Syntax: copydata hwnd, data, mode

hwnd: Handle of the target window.
data: Text data to send.
mode:
 0: Nothing special, simply send the text data.
 1: Text data is an XYplorer script to be executed by the receiving window (which in this case, of course, has to be XYplorer.exe).
 2: Resolve variables in data and return to sender immediately. Variables are XYplorer native and environment variables.
 3: Pass the value of the data argument as location to another XYplorer instance. Whatever XYplorer accepts in the Address Bar is acceptable here.

Examples:

Run a small script in another XYplorer (197078):
copydata 197078, "::echo 'hi';", 1;

Return the contents of variable <curitem> from another XYplorer (197078) to this window (1573124), using copydata first in this XYplorer process and then again in the other XYplorer process for the return:
copydata 197078, '::copydata 1573124, <curitem>;', 1;

Determine <curitem> in another XYplorer instance (hWnd 197078). Note that the single quotes in the example are essential else <curitem> would be resolved in *this* instance of XYplorer before being sent to the other instance:
copydata 197078, '<curitem>', 2; echo <get copieddata 3>;

Go to "C:\" in the XYplorer instance with hWnd 525048:
copydata 525048, "C:\", 3;

Go to the current path of this instance:
copydata 525048, <curpath>, 3;

Run a script (note that the command only returns when the script is completed in the other instance!):
copydata 525048, 'echo "hi!";', 3;

Notes
· The command only returns when the receiving window has fully processed the data. For example if you send a script the command will return only after the script has terminated.
· The mode parameter in SC CopyData simply selects different dwData:
If called with mode 0 then cds.dwData == 4194304 (0x00400000)
If called with mode 1 then cds.dwData == 4194305 (0x00400001)
If called with mode 2 then cds.dwData == 4194306 (0x00400002)
If called with mode 3 then cds.dwData == 4194307 (0x00400003)
So any application can use these dwData values to trigger a specific reaction in XYplorer when it receives data via WM_COPYDATA.


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
REMOTE CONTROL *** For software developers only ***

You can run an XYplorer script from an external program using the WM_COPYDATA command with XYplorer's hWnd. This means if you are a programmer you can fully remote control XYplorer.
· cds.dwData: 4194305 (0x00400001)
· cds.lpData: The syntax is identical to the one of the command line switch /script=<script resource>, so you can either pass the path to a script file (commonly called *.xys), or pass the script directly (must be preceded by ::).


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
COMMAND LINE SWITCH /script

You can run a script on startup directly from the command line. The switch is /script=[script resource], where [script resource] can be:

1) The path to a script file (commonly called *.xys). The file spec is resolved as in the script command load, so you can skip the XYS extension. You can also skip the path if the XYS file is located in the default scripts folder. For example
 XYplorer.exe /script=test
would run the file <xyscripts>\test.xys on startup. If the path contains spaces it must be quoted:
 XYplorer.exe /script="C:\Zen\test one.xys"

2) A script. It must be preceded by ::, and it must not contain double quotes or other characters that might lead to problems when parsing the command line. For example
 XYplorer.exe /script="::msg 'Welcome to XY!';"
Note the double quotes surrounding the whole argument which are needed because of the spaces in the script line.

If your script needs double quotes you should use the quote() function or runq with single quotes:
 XYplorer.exe /script="::run quote('E:\Test\Has Space.txt');"
 XYplorer.exe /script="::runq 'E:\Test\Has Space.txt';"

Tip: You can "pipe" a value instead of quoting it. This can be useful when unpredictable quotes (that might be returned from variables) make predictable parsing impossible, or simply to make a string more readable. For example, this is the same Command Line Switch, first quoted then piped:
 /script="::text '"R:\a b c"';"        (this would not work; parser cannot handle the ambiguous quotes)
 /script=|::text '"R:\a b c"';|        (this does work)
Of course, you must be sure that no pipes can come up inside the value.
*/

;*****************************************************************************************************************