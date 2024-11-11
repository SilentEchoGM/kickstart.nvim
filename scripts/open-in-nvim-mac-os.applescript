on run {input, parameters}
	if (count of input) > 0 then
		tell application "System Events"
			set runs to false
			try
				set p to application process "iTerm"
				set runs to true
			end try
		end tell
		tell application "iTerm"
			activate
			if (count of terminals) = 0 then
				make new terminal
			end if
			set numItems to the count of items of input
			set numTerms to the count of terminals
			set launchPaths to ""
			repeat with t from 0 to (numTerms - 1)
				tell item (numTerms - t) of terminals
					if (count of sessions) = 0 then
						launch session "Default"
					end if
					repeat with s from 1 to count of sessions
						set currentSession to item s of sessions
						if name of currentSession contains "vim" then
							tell currentSession
								write text (":silent! tablast")
								repeat with x from 1 to numItems
									set filePath to quoted form of POSIX path of item x of input
									write text (":execute 'tabedit '.fnameescape(" & filePath & ")")
								end repeat
								return
							end tell
						end if
					end repeat
				end tell
			end repeat
			tell current terminal
				tell (launch session "Default")
					repeat with x from 1 to numItems
						set filePath to quoted form of POSIX path of item x of input
						set launchPaths to launchPaths & " " & filePath
					end repeat
					write text ("mvim -p " & launchPaths)
				end tell
			end tell
		end tell
	end if
end run
