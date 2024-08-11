Bash is an insteractive shell used mainly in unix operating systems. Here is some useful quick links to understand bash

## [Bash Documentation](https://www.gnu.org/software/bash/manual/)

## Bash Cheatsheet 

[devhints](https://devhints.io/bash)

## Bash Guides
[James Website](https://www.jpnc.info/category/bash.html)

### Introduction to Advanced Bash Usage - James Pannacciulli @ OSCON 2014
[![yt video](https://img.youtube.com/vi/uqHjc7hlqd0/0.jpg)](https://www.youtube.com/watch?v=uqHjc7hlqd0)

## .bashrc, .bash_profile, .profile

- .bashrc contains commands that are specific to the Bash shells. Every interactive non-login shell reads .bashrc first. Normally .bashrc is the best place to add aliases and Bash related functions.

- The .bash_profile file contains commands for setting environment variables. Consequently, future shells inherit these variables.

- During an interactive shell login, if .bash_profile is not present in the home directory, Bash looks for .bash_login. If found, Bash executes it. If .bash_login is not present in the home directory, Bash looks for .profile and executes it.
.profile can hold the same configurations as .bash_profile or .bash_login. It controls prompt appearance, keyboard sound, shells to open, and individual profile settings that override the variables set in the /etc/profile file.

[Reference](https://www.baeldung.com/linux/bashrc-vs-bash-profile-vs-profile)

## Bash Builtin Commands
.
:
[
alias
bg
bind
break
builtin
caller
cd
command
compgen
complete
compopt
continue
declare
dirs
disown
echo
enable
eval
exec
exit
export
false
fc
fg
getopts
hash
help
history
jobs
kill
let
local
logout
mapfile
popd
printf
pushd
pwd
read
readarray
readonly
return
set
shift
shopt
source
suspend
test
times
trap
true
type
typeset
ulimit
umask
unalias
unset
wait


## Prompt: 
Here are the different meanings for the different parts of the BASH prompt [PhoenixNAP](https://phoenixnap.com/kb/change-bash-prompt-linux):

PS1 – This is the primary prompt display. This is where you set special characters or important information. <br />
PS2 – This is the secondary prompt string. This is usually set as a divider between the prompt display and the text entry. It is also used to display when a long command is broken into sections with the \ sign. <br />
PS3 – This is the prompt for the select command <br />
PS4 – This is the prompt for running a shell script in debug mode. <br />
Under most circumstances, you’ll be working with just the PS1 option and maybe the PS2 option as well. <br />

#### Prompt Colors
Escape characers
```
\a – A bell character
\d – Date (day/month/date)
\D{format} – Use this to call the system to respond with the current time
\e – Escape character
\h – Hostname (short)
\H – Full hostname (domain name)
\j – Number of jobs being managed by the shell
\l – The basename of the shells terminal device
\n – New line
\r – Carriage return
\s – The name of the shell
\t – Time (hour:minute:second)
\@ – Time, 12-hour AM/PM
\A – Time, 24-hour, without seconds
\u – Current username
\v – BASH version
\V – Extra information about the BASH version
\w – Current working directory ($HOME is represented by ~)
\W – The basename of the working directory ($HOME is represented by ~)
\! – Lists this command’s number in the history
\# – This command’s command number
\$ – Specifies whether the user is root (#) or otherwise ($)
\\– Backslash
\[ – Start a sequence of non-displayed characters (useful if you want to add a command or instruction set to the prompt)
\] – Close or end a sequence of non-displayed characters
```

The first number in the color code specifies the typeface:
```
0 – Normal
1 – Bold (bright)
3 - Italics
2 – Dim
4 – Underlined
```

The second number indicates the color you want:
```
30 – Black
31 – Red
32 – Green
33 – Brown
34 – Blue
35 – Purple
36 – Cyan
37 – Light gray
```
Additionally, if you combine the bright option with a color code, you get a lighter version of that color. For example, if you use color code 1;32, you would get light green instead of the normal green. If you use 1;33, you get yellow instead of brown.


The following terminfo capabilities are useful for prompt customization and are supported by many terminals. #1 and #2 are placeholders for numeric arguments.

Capability	Escape sequence	Description [Arch wiki](https://wiki.archlinux.org/title/Bash/Prompt_customization)
```
Text attributes
blink	\e[5m	blinking text on
bold	\e[1m	bold text on
dim	\e[2m	dim text on
rev	\e[7m	reverse video on (switch text/background colors)
sitm	\e[3m	italic text on
ritm	\e[23m	italic text off
smso	\e[7m	highlighted text on
rmso	\e[27m	highlighted text off
smul	\e[4m	underlined text on
rmul	\e[24m	underlined text off
setab #1	\e[4#1m	set background color #1 (0-7)
setaf #1	\e[3#1m	set text color #1 (0-7)
sgr0	\e(B\e[m	reset text attributes
Cursor movement
sc	\e7	save cursor position
rc	\e8	restore saved cursor position
clear	\e[H\e[2J	clear screen and move cursor to top left
cuu #1	\e[#1A	move cursor up #1 rows
cud #1	\e[#1B	move cursor down #1 rows
cuf #1	\e[#1C	move cursor right #1 columns
cub #1	\e[#1D	move cursor left #1 columns
home	\e[H	move cursor to top left
hpa #1	\e[#1G	move cursor to column #1
vpa #1	\e[#1d	move cursor to row #1, first column
cup #1 #2	\e[#1;#2H	move cursor to row #1, column #2
Removing characters
dch #1	\e#1P	remove #1 characters (like backspacing)
dl #1	\e#1M	remove #1 lines
ech #1	\e#1X	clear #1 characters (without moving cursor)
ed	\eE[J	clear to bottom of screen
el	\e[K	clear to end of line
el1	\e[1K	clear to beginning of line
```


## Spinner example

[spinner-example](https://github.com/ebelious/Self-Hosted/blob/main/spinner-example)

## Bash Guide - [cyberciti.biz](https://bash.cyberciti.biz/guide/Main_Page)

Linux Bash Shell Scripting Tutorial

Written by [Vivek Gite](https://bash.cyberciti.biz/guide/Linux_Shell_Scripting_Tutorial_-_A_Beginner%27s_handbook:About "Linux Shell Scripting Tutorial - A Beginner's handbook:About"). Copyright 1999-2017 Vivek Gite and its [contributors](https://bash.cyberciti.biz/guide/Special:ListUsers "Special:ListUsers"). Some rights reserved.

---

## [Chapter 1: Quick Introduction to Linux](https://bash.cyberciti.biz/guide/Chapter_1:_Quick_Introduction_to_Linux "Chapter 1: Quick Introduction to Linux")

- [What Is Linux?](https://bash.cyberciti.biz/guide/What_Is_Linux "What Is Linux")
- [Who created Linux?](https://bash.cyberciti.biz/guide/Who_created_Linux "Who created Linux")
- [Where can I download Linux?](https://bash.cyberciti.biz/guide/Where_can_I_download_Linux "Where can I download Linux")
- [How do I Install Linux?](https://bash.cyberciti.biz/guide/How_do_I_Install_Linux "How do I Install Linux")
- [Linux usage in everyday life](https://bash.cyberciti.biz/guide/Linux_usage_in_everyday_life "Linux usage in everyday life")
- [What is Linux Kernel?](https://bash.cyberciti.biz/guide/What_is_Linux_Kernel "What is Linux Kernel")
- [What is Linux Shell?](https://bash.cyberciti.biz/guide/What_is_Linux_Shell "What is Linux Shell")
- [Unix philosophy](https://bash.cyberciti.biz/guide/Unix_philosophy "Unix philosophy")
- [But how do you use the shell?](https://bash.cyberciti.biz/guide/But_how_do_you_use_the_shell "But how do you use the shell")
- [What is a Shell Script or shell scripting?](https://bash.cyberciti.biz/guide/What_is_a_Shell_Script_or_shell_scripting "What is a Shell Script or shell scripting")
- [Why shell scripting?](https://bash.cyberciti.biz/guide/Why_shell_scripting "Why shell scripting")
- [Chapter 1 Challenges](https://bash.cyberciti.biz/guide/Chapter_1_Challenges "Chapter 1 Challenges")

## [Chapter 2: Getting Started With Shell Programming](https://bash.cyberciti.biz/guide/Chapter_2:_Getting_Started_With_Shell_Programming "Chapter 2: Getting Started With Shell Programming")

- [The bash shell](https://bash.cyberciti.biz/guide/The_bash_shell "The bash shell")
- [Shell commands](https://bash.cyberciti.biz/guide/Shell_commands "Shell commands")
- [The role of shells in the Linux environment](https://bash.cyberciti.biz/guide/The_role_of_shells_in_the_Linux_environment "The role of shells in the Linux environment")
- [Other standard shells](https://bash.cyberciti.biz/guide/Other_standard_shells "Other standard shells")
- [Write a simple shell script - "Hello World!"](https://bash.cyberciti.biz/guide/Hello,_World!_Tutorial "Hello, World! Tutorial")
    - [Starting a script with Shebang line (#!)](https://bash.cyberciti.biz/guide/Shebang "Shebang")
    - [Comments in a script](https://bash.cyberciti.biz/guide/Shell_Comments "Shell Comments")
    - [Setting up permissions on a script](https://bash.cyberciti.biz/guide/Setting_up_permissions_on_a_script "Setting up permissions on a script")
    - [Execute a script](https://bash.cyberciti.biz/guide/Execute_a_script "Execute a script")
    - [Debug a script](https://bash.cyberciti.biz/guide/Debug_a_script "Debug a script")
- [Chapter 2 Challenges](https://bash.cyberciti.biz/guide/Chapter_2_Challenges "Chapter 2 Challenges")

## [Chapter 3:The Shell Variables and Environment](https://bash.cyberciti.biz/guide/Chapter_3:The_Shell_Variables_and_Environment "Chapter 3:The Shell Variables and Environment")

- [Variables in shell](https://bash.cyberciti.biz/guide/Variables "Variables")
    - [Assign values to shell variables](https://bash.cyberciti.biz/guide/Assign_values_to_shell_variables "Assign values to shell variables")
    - [Default shell variables value](https://bash.cyberciti.biz/guide/Default_shell_variables_value "Default shell variables value")
    - [Rules for Naming variable name](https://bash.cyberciti.biz/guide/Rules_for_Naming_variable_name "Rules for Naming variable name")
    - [Display the value of shell variables](https://bash.cyberciti.biz/guide/Echo_Command "Echo Command")
    - [Quoting](https://bash.cyberciti.biz/guide/Quoting "Quoting")
    - [The export statement](https://bash.cyberciti.biz/guide/Export_Variables "Export Variables")
    - [Unset shell and environment variables](https://bash.cyberciti.biz/guide/Unset "Unset")
    - [Getting User Input Via Keyboard](https://bash.cyberciti.biz/guide/Getting_User_Input_Via_Keyboard "Getting User Input Via Keyboard")
- [Perform arithmetic operations](https://bash.cyberciti.biz/guide/Perform_arithmetic_operations "Perform arithmetic operations")
    - [Create an integer variable](https://bash.cyberciti.biz/guide/Create_an_integer_variable "Create an integer variable")
    - [Create the constants variable](https://bash.cyberciti.biz/guide/Create_the_constants_variable "Create the constants variable")
- [Bash variable existence check](https://bash.cyberciti.biz/guide/Bash_variable_existence_check "Bash variable existence check")
- [Customize the bash shell environments](https://bash.cyberciti.biz/guide/Customize_the_bash_shell_environments "Customize the bash shell environments")
    - [Recalling command history](https://bash.cyberciti.biz/guide/Recalling_command_history "Recalling command history")
    - [Path name expansion](https://bash.cyberciti.biz/guide/Path_name_expansion "Path name expansion")
    - [Create and use aliases](https://bash.cyberciti.biz/guide/Create_and_use_aliases "Create and use aliases")
    - [The tilde expansion](https://bash.cyberciti.biz/guide/The_tilde_expansion "The tilde expansion")
    - [Startup scripts](https://bash.cyberciti.biz/guide/Startup_scripts "Startup scripts")
        - [Using aliases](https://bash.cyberciti.biz/guide/Using_aliases "Using aliases")
        - [Changing bash prompt](https://bash.cyberciti.biz/guide/Changing_bash_prompt "Changing bash prompt")
        - [Setting shell options](https://bash.cyberciti.biz/guide/Setting_shell_options "Setting shell options")
        - [Setting system wide shell options](https://bash.cyberciti.biz/guide/Setting_system_wide_shell_options "Setting system wide shell options")
- [Chapter 3 Challenges](https://bash.cyberciti.biz/guide/Chapter_3_Challenges "Chapter 3 Challenges")

## [Chapter 4: Conditionals Execution (Decision Making)](https://bash.cyberciti.biz/guide/Chapter_4:_Conditionals_Execution_(Decision_Making) "Chapter 4: Conditionals Execution (Decision Making)")

- [Bash structured language constructs](https://bash.cyberciti.biz/guide/Bash_structured_language_constructs "Bash structured language constructs")
- [Test command](https://bash.cyberciti.biz/guide/Test_command "Test command")
- [if structures to execute code based on a condition](https://bash.cyberciti.biz/guide/If_structures_to_execute_code_based_on_a_condition "If structures to execute code based on a condition")
- [If..else..fi](https://bash.cyberciti.biz/guide/If..else..fi "If..else..fi")
- [Nested ifs](https://bash.cyberciti.biz/guide/Nested_ifs "Nested ifs")
- [Multilevel if-then-else](https://bash.cyberciti.biz/guide/Multilevel_if-then-else "Multilevel if-then-else")
- [The exit status of a command](https://bash.cyberciti.biz/guide/The_exit_status_of_a_command "The exit status of a command")
- [Conditional execution](https://bash.cyberciti.biz/guide/Conditional_execution "Conditional execution")
- [Logical AND &&](https://bash.cyberciti.biz/guide/Logical_AND "Logical AND")
- [Logical OR |](https://bash.cyberciti.biz/guide/Logical_OR "Logical OR")
- [Logical Not !](https://bash.cyberciti.biz/guide/Logical_Not_! "Logical Not !")
- [Conditional expression using(portable version)](https://bash.cyberciti.biz/guide/Conditional_expression "Conditional expression")
- [Conditional expression using](https://bash.cyberciti.biz/guide/Bash_test_conditional_expression_(safer_version) "Bash test conditional expression (safer version)")
- [Numeric comparison](https://bash.cyberciti.biz/guide/Numeric_comparison "Numeric comparison")
- [String comparison](https://bash.cyberciti.biz/guide/String_comparison "String comparison")
- [File attributes comparisons](https://bash.cyberciti.biz/guide/File_attributes_comparisons "File attributes comparisons")
- [Shell command line parameters](https://bash.cyberciti.biz/guide/Shell_command_line_parameters "Shell command line parameters")
    - [How to use positional parameters](https://bash.cyberciti.biz/guide/How_to_use_positional_parameters "How to use positional parameters")
    - [Parameters Set by the Shell](https://bash.cyberciti.biz/guide/Parameters_Set_by_the_Shell "Parameters Set by the Shell")
    - [Create usage messages](https://bash.cyberciti.biz/guide/Create_usage_messages "Create usage messages")
    - [Exit command](https://bash.cyberciti.biz/guide/Exit_command "Exit command")
- [The case statement](https://bash.cyberciti.biz/guide/The_case_statement "The case statement")
    - [Dealing with case sensitive pattern](https://bash.cyberciti.biz/guide/Dealing_with_case_sensitive_pattern "Dealing with case sensitive pattern")
- [Chapter 4 Challenges](https://bash.cyberciti.biz/guide/Chapter_4_Challenges "Chapter 4 Challenges")

## [Chapter 5: Bash Loops](https://bash.cyberciti.biz/guide/Chapter_5:_Bash_Loops "Chapter 5: Bash Loops")

- [The for loop statement](https://bash.cyberciti.biz/guide/For_loop "For loop")
- [Nested for loop statement](https://bash.cyberciti.biz/guide/Nested_for_loop_statement "Nested for loop statement")
- [The while loop statement](https://bash.cyberciti.biz/guide/While_loop "While loop")
    - [Use of : to set infinite while loop](https://bash.cyberciti.biz/guide/Infinite_while_loop "Infinite while loop")
- [The until loop statement](https://bash.cyberciti.biz/guide/Until_loop "Until loop")
- [The select loop statement](https://bash.cyberciti.biz/guide/Select_loop "Select loop")
    - [Exit the select loop statement](https://bash.cyberciti.biz/guide/Exit_select_loop "Exit select loop")
- [Using the break statement](https://bash.cyberciti.biz/guide/Break_statement "Break statement")
- [Using the continue statement](https://bash.cyberciti.biz/guide/Continue_statement "Continue statement")
- [Command substitution](https://bash.cyberciti.biz/guide/Command_substitution "Command substitution")
- [Chapter 5 Challenges](https://bash.cyberciti.biz/guide/Chapter_5_Challenges "Chapter 5 Challenges")

## [Chapter 6: Shell Redirection](https://bash.cyberciti.biz/guide/Chapter_6:_Shell_Redirection "Chapter 6: Shell Redirection")

- [Input and Output](https://bash.cyberciti.biz/guide/Input_and_Output "Input and Output")
- [Standard input](https://bash.cyberciti.biz/guide/Standard_input "Standard input")
- [Standard output](https://bash.cyberciti.biz/guide/Standard_output "Standard output")
- [Standard error](https://bash.cyberciti.biz/guide/Standard_error "Standard error")
- [Empty file creation](https://bash.cyberciti.biz/guide/Empty_file_creation "Empty file creation")
- [/dev/null discards unwanted output](https://bash.cyberciti.biz/guide//dev/null_discards_unwanted_output "/dev/null discards unwanted output")
- [here documents](https://bash.cyberciti.biz/guide/Here_documents "Here documents")
- [here strings](https://bash.cyberciti.biz/guide/Here_strings "Here strings")
- [Redirection of standard error](https://bash.cyberciti.biz/guide/Redirection_of_standard_error "Redirection of standard error")
- [Redirection of standard output](https://bash.cyberciti.biz/guide/Redirection_of_standard_output "Redirection of standard output")
- [Appending redirected output](https://bash.cyberciti.biz/guide/Appending_redirected_output "Appending redirected output")
- [Redirection of both standard error and output](https://bash.cyberciti.biz/guide/Redirection_of_both_standard_error_and_output "Redirection of both standard error and output")
- [Writing output to files](https://bash.cyberciti.biz/guide/Writing_output_to_files "Writing output to files")
- [Assigns the file descriptor (fd) to file for output](https://bash.cyberciti.biz/guide/Assigns_the_file_descriptor_(fd)_to_file_for_output "Assigns the file descriptor (fd) to file for output")
- [Assigns the file descriptor (fd) to file for input](https://bash.cyberciti.biz/guide/Assigns_the_file_descriptor_(fd)_to_file_for_input "Assigns the file descriptor (fd) to file for input")
- [Closes the file descriptor (fd)](https://bash.cyberciti.biz/guide/Closes_the_file_descriptor_(fd) "Closes the file descriptor (fd)")
- [Opening the file descriptors for reading and writing](https://bash.cyberciti.biz/guide/Opening_the_file_descriptors_for_reading_and_writing "Opening the file descriptors for reading and writing")
- [Reads from the file descriptor (fd)](https://bash.cyberciti.biz/guide/Reads_from_the_file_descriptor_(fd) "Reads from the file descriptor (fd)")
- [Executes commands and send output to the file descriptor (fd)](https://bash.cyberciti.biz/guide/Executes_commands_and_send_output_to_the_file_descriptor_(fd) "Executes commands and send output to the file descriptor (fd)")
- [Chapter 6 Challenges](https://bash.cyberciti.biz/guide/Chapter_6_Challenges "Chapter 6 Challenges")

## [Chapter 7: Pipes and Filters](https://bash.cyberciti.biz/guide/Chapter_7:_Pipes_and_Filters "Chapter 7: Pipes and Filters")

- [Linking Commands](https://bash.cyberciti.biz/guide/Linking_Commands "Linking Commands")
- [Multiple commands](https://bash.cyberciti.biz/guide/Multiple_commands "Multiple commands")
- [Putting jobs in background](https://bash.cyberciti.biz/guide/Putting_jobs_in_background "Putting jobs in background")
- [Pipes](https://bash.cyberciti.biz/guide/Pipes "Pipes")
    - [How to use pipes to connect programs](https://bash.cyberciti.biz/guide/How_to_use_pipes_to_connect_programs "How to use pipes to connect programs")
    - [Input redirection in pipes](https://bash.cyberciti.biz/guide/Input_redirection_in_pipes "Input redirection in pipes")
    - [Output redirection in pipes](https://bash.cyberciti.biz/guide/Output_redirection_in_pipes "Output redirection in pipes")
    - [Why use pipes](https://bash.cyberciti.biz/guide/Why_use_pipes "Why use pipes")
- [Filters](https://bash.cyberciti.biz/guide/Filters "Filters")
- [Chapter 7 Challenges](https://bash.cyberciti.biz/guide/Chapter_7_Challenges "Chapter 7 Challenges")

## [Chapter 8: Traps](https://bash.cyberciti.biz/guide/Chapter_8:_Traps "Chapter 8: Traps")

- [Signals](https://bash.cyberciti.biz/guide/Signals "Signals")
    - [What is a Process?](https://bash.cyberciti.biz/guide/What_is_a_Process%3F "What is a Process?")
    - [How to view Processes](https://bash.cyberciti.biz/guide/How_to_view_Processes "How to view Processes")
    - [Sending signal to Processes](https://bash.cyberciti.biz/guide/Sending_signal_to_Processes "Sending signal to Processes")
    - [Terminating Processes](https://bash.cyberciti.biz/guide/Terminating_Processes "Terminating Processes")
    - [Shell signal values](https://bash.cyberciti.biz/guide/Shell_signal_values "Shell signal values")
- [The trap statement](https://bash.cyberciti.biz/guide/Trap_statement "Trap statement")
- [How to clear trap](https://bash.cyberciti.biz/guide/How_to_clear_trap "How to clear trap")
- [Include trap statements in a script](https://bash.cyberciti.biz/guide/Include_trap_statements_in_a_script "Include trap statements in a script")
- [Use the trap statement to catch signals and handle errors](https://bash.cyberciti.biz/guide/Use_the_trap_statement_to_catch_signals_and_handle_errors "Use the trap statement to catch signals and handle errors")
- [What is a Subshell?](https://bash.cyberciti.biz/guide/What_is_a_Subshell%3F "What is a Subshell?")
    - [Compound command](https://bash.cyberciti.biz/guide/Compound_command "Compound command")
    - [exec command](https://bash.cyberciti.biz/guide/Exec_command "Exec command")
- [Chapter 8 Challenges](https://bash.cyberciti.biz/guide/Chapter_8_Challenges "Chapter 8 Challenges")

## [Chapter 9: Functions](https://bash.cyberciti.biz/guide/Chapter_9:_Functions "Chapter 9: Functions")

- [Writing your first shell function](https://bash.cyberciti.biz/guide/Writing_your_first_shell_function "Writing your first shell function")
    - [Displaying functions](https://bash.cyberciti.biz/guide/Displaying_functions "Displaying functions")
    - [Removing functions](https://bash.cyberciti.biz/guide/Removing_functions "Removing functions")
- [Defining functions](https://bash.cyberciti.biz/guide/Defining_functions "Defining functions")
- [Writing functions](https://bash.cyberciti.biz/guide/Writing_functions "Writing functions")
- [Calling functions](https://bash.cyberciti.biz/guide/Calling_functions "Calling functions")
- [Pass arguments into a function](https://bash.cyberciti.biz/guide/Pass_arguments_into_a_function "Pass arguments into a function")
    - [local variable](https://bash.cyberciti.biz/guide/Local_variable "Local variable")
- [Returning from a function](https://bash.cyberciti.biz/guide/Returning_from_a_function "Returning from a function")
- [Shell functions library](https://bash.cyberciti.biz/guide/Shell_functions_library "Shell functions library")
    - [Source command](https://bash.cyberciti.biz/guide/Source_command "Source command")
- [Recursive function](https://bash.cyberciti.biz/guide/Recursive_function "Recursive function")
- [Putting functions in background](https://bash.cyberciti.biz/guide/Putting_functions_in_background "Putting functions in background")
- [Chapter 9 Challenges](https://bash.cyberciti.biz/guide/Chapter_9_Challenges "Chapter 9 Challenges")

## [Chapter 10: Interactive Scripts](https://bash.cyberciti.biz/guide/Chapter_10:_Interactive_Scripts "Chapter 10: Interactive Scripts")

- [Menu driven scripts](https://bash.cyberciti.biz/guide/Menu_driven_scripts "Menu driven scripts")
    - [Getting information about your system](https://bash.cyberciti.biz/guide/Getting_information_about_your_system "Getting information about your system")
- [Bash display dialog boxes](https://bash.cyberciti.biz/guide/Bash_display_dialog_boxes "Bash display dialog boxes")
    - [dialog customization with configuration file](https://bash.cyberciti.biz/guide/Dialog_customization_with_configuration_file "Dialog customization with configuration file")
    - [A yes/no dialog box](https://bash.cyberciti.biz/guide/A_yes/no_dialog_box "A yes/no dialog box")
    - [An input dialog box](https://bash.cyberciti.biz/guide/An_input_dialog_box "An input dialog box")
    - [A password box](https://bash.cyberciti.biz/guide/A_password_box "A password box")
    - [A menu box](https://bash.cyberciti.biz/guide/A_menu_box "A menu box")
    - [A progress bar (gauge box)](https://bash.cyberciti.biz/guide/A_progress_bar_(gauge_box) "A progress bar (gauge box)")
    - [The file selection box](https://bash.cyberciti.biz/guide/The_file_selection_box "The file selection box")
    - [The form dialog for input](https://bash.cyberciti.biz/guide/The_form_dialog_for_input "The form dialog for input")
- [Console management](https://bash.cyberciti.biz/guide/Console_management "Console management")
    - [Get the name of the current terminal](https://bash.cyberciti.biz/guide/Get_the_name_of_the_current_terminal "Get the name of the current terminal")
    - [Fixing the display with reset](https://bash.cyberciti.biz/guide/Fixing_the_display_with_reset "Fixing the display with reset")
    - [Get screen width and hight with tput](https://bash.cyberciti.biz/guide/Get_screen_width_and_hight_with_tput "Get screen width and hight with tput")
    - [Moving the cursor with tput](https://bash.cyberciti.biz/guide/Moving_the_cursor_with_tput "Moving the cursor with tput")
    - [Display centered text in the screen in reverse video](https://bash.cyberciti.biz/guide/Display_centered_text_in_the_screen_in_reverse_video "Display centered text in the screen in reverse video")
    - [Set the keyboard leds](https://bash.cyberciti.biz/guide/Set_the_keyboard_leds "Set the keyboard leds")
        - [Turn on or off NumLock leds](https://bash.cyberciti.biz/guide/Turn_on_or_off_NumLock_leds "Turn on or off NumLock leds")
        - [Turn on or off CapsLock leds](https://bash.cyberciti.biz/guide/Turn_on_or_off_CapsLock_leds "Turn on or off CapsLock leds")
        - [Turn on or off ScrollLock leds](https://bash.cyberciti.biz/guide/Turn_on_or_off_ScrollLock_leds "Turn on or off ScrollLock leds")
    - [Set terminal attributes](https://bash.cyberciti.biz/wiki/index.php?title=Set_terminal_attributes&action=edit&redlink=1 "Set terminal attributes (page does not exist)")
- [Display KDE / GTK+ GUI dialog](https://bash.cyberciti.biz/guide/Display_KDE_/_GTK%2B_GUI_dialog "Display KDE / GTK+ GUI dialog")
    - [zenity: Shell Scripting with Gnome](https://bash.cyberciti.biz/guide/Zenity:_Shell_Scripting_with_Gnome "Zenity: Shell Scripting with Gnome")
        - [Shell script create a calendar GUI dialog box](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_create_a_calendar_GUI_dialog_box&action=edit&redlink=1 "Shell script create a calendar GUI dialog box (page does not exist)")
        - [Shell script create a file selection GUI dialog box](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_create_a_file_selection_GUI_dialog_box&action=edit&redlink=1 "Shell script create a file selection GUI dialog box (page does not exist)")
        - [Shell script to send notification to the Gnome notification area](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_to_send_notification_to_the_Gnome_notification_area&action=edit&redlink=1 "Shell script to send notification to the Gnome notification area (page does not exist)")
        - [Shell script create a list GUI dialog box](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_create_a_list_GUI_dialog_box&action=edit&redlink=1 "Shell script create a list GUI dialog box (page does not exist)")
        - [Shell script create an error message GUI dialog box](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_create_an_error_message_GUI_dialog_box&action=edit&redlink=1 "Shell script create an error message GUI dialog box (page does not exist)")
        - [Shell script create an information message GUI dialog box](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_create_an_information_message_GUI_dialog_box&action=edit&redlink=1 "Shell script create an information message GUI dialog box (page does not exist)")
        - [Shell script create a question message GUI dialog box](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_create_a_question_message_GUI_dialog_box&action=edit&redlink=1 "Shell script create a question message GUI dialog box (page does not exist)")
        - [Shell script create a warning message GUI dialog box](https://bash.cyberciti.biz/wiki/index.php?title=Shell_script_create_a_warning_message_GUI_dialog_box&action=edit&redlink=1 "Shell script create a warning message GUI dialog box (page does not exist)")
    - [kdialog: Shell scripting with KDE](https://bash.cyberciti.biz/guide/Kdialog:_Shell_scripting_with_KDE "Kdialog: Shell scripting with KDE")
- [notify-send: Send desktop notifications](https://bash.cyberciti.biz/guide/Notify-send:_Send_desktop_notifications "Notify-send: Send desktop notifications")
- [Chapter 10 Challenges](https://bash.cyberciti.biz/guide/Chapter_10_Challenges "Chapter 10 Challenges")
