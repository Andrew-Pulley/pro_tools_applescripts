global nonLoopedSampleTypes
set nonLoopedSampleTypes to {"stc"}

on GetIsLoopedSampleType(clipNameAsList)
	if nonLoopedSampleTypes contains item -2 of clipNameAsList then
		display dialog "Return False with " & (clipNameAsList)
		return false
	else
		display dialog "Return True with " & (clipNameAsList)
		return true
	end if
end GetIsLoopedSampleType

set clipName to ""
set previousClipName to ""
set AppleScript's text item delimiters to "-"
tell application "TextEdit" to activate
delay 2
repeat
	tell application "Pro Tools.app" to activate
	tell application "System Events"
		keystroke return
		delay 0.5
		key code 39 using shift down
		delay 0.5
		keystroke "r" using {command down, shift down}

		#Increase delay here if error thrown.
		delay 0.5
		keystroke "c" using command down
		delay 0.5
		key code 53 --escape rename region
	end tell
	set clipboardAsList to every text item of (the clipboard)
	if length of clipboardAsList is greater than 1 then
		set previousClipName to clipName
		set clipName to items 1 through 3 of clipboardAsList as text
	else
		#Clipboard should always have hyphens at this point
		display dialog "Unexpected clipboard contents.  Increase your delay at commented section."
		exit repeat
	end if
	if clipName = previousClipName then exit repeat
	if GetIsLoopedSampleType(clipboardAsList) then
		tell application "TextEdit" to activate
		tell application "System Events"
			keystroke clipName
			keystroke ","
		end tell
		delay 0.5
		tell application "Pro Tools.app" to activate
		tell application "System Events"
			key code 39 --single quote
			delay 0.5
			keystroke "*" --select main counter
			delay 0.5
			keystroke "c" using command down
			delay 0.5
			key code 53 --escape main counter
		end tell
		tell application "TextEdit" to activate
		tell application "System Events"
			keystroke "v" using command down
			keystroke ","
		end tell
		delay 0.5
		tell application "Pro Tools.app" to activate
		tell application "System Events"
			key code 39
			delay 0.5
			keystroke "*" --select main counter
			delay 0.5
			keystroke "c" using command down
			delay 0.5
			key code 53 --escape main counter
			delay 0.5
			keystroke ";" --go to next track
		end tell
		tell application "TextEdit" to activate
		tell application "System Events"
			keystroke "v" using command down
		end tell
	else -- Non-looped event
		tell application "TextEdit" to activate
		tell application "System Events"
			keystroke clipName
		end tell
	end if

	tell application "System Events" to keystroke return
end repeat

