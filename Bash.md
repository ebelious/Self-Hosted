Bash is an insteractive shell used mainly in unix operating systems. Here is some useful quick links to understand bash


[James Website](https://www.jpnc.info/category/bash.html)

### Introduction to Advanced Bash Usage - James Pannacciulli @ OSCON 2014
[![yt video](https://img.youtube.com/vi/uqHjc7hlqd0/0.jpg)](https://www.youtube.com/watch?v=uqHjc7hlqd0)

## .bashrc, .bash_profile, .profile


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
