Output demo.mp4

Require nvim

Set Shell "zsh"
Set Theme { "name": "Gruvbox Dark", "black": "#1e1e1e", "red": "#be0f17", "green": "#868715", "yellow": "#cc881a", "blue": "#377375", "magenta": "#a04b73", "cyan": "#578e57", "white": "#978771", "brightBlack": "#7f7061", "brightRed": "#f73028", "brightGreen": "#aab01e", "brightYellow": "#f7b125", "brightBlue": "#719586", "brightMagenta": "#c77089", "brightCyan": "#7db669", "brightWhite": "#e6d4a3", "background": "#282828", "foreground": "#e6d4a3" }

Set Margin 80
Set MarginFill "#663399"
Set Padding 20
Set BorderRadius 14

Set FontFamily "JetBrainsMono Nerd Font"
Set FontSize 14
Set TypingSpeed 40ms

Set Width 1200
Set Height 800

Hide
Type "nvim" Enter
Type "e"
Show

Sleep 2s
Type "i"
Type "We are in the directory of the bufignore.nvim plugin." Enter
Type "Let's confirm that it's properly tracked by Git:" Sleep 1s Escape
Type@80ms ":read! git rev-parse --show-toplevel" Sleep 1s Enter
Sleep 2s

Type "o" Enter
Type "Great! Now, let's identify directories and files ignored by Git:" Sleep 1s Escape
Type@80ms ":read .gitignore" Sleep 1s Enter
Sleep 2s

Type "o" Enter
Type "Gotcha, we will open an ignored file now." Sleep 1s Escape
Type@80ms ":vsplit ./node_modules/prettier/package.json" Sleep 1s Enter
Sleep 4s
Ctrl+h

Type "o" Enter
Type "At the moment, we have two buffers open: one unsaved and one git ignored." Sleep 1s Escape
Type@80ms ":buffers" Sleep 1s Enter
Sleep 5s Enter

Type "o" Enter
Type "Next, we will open a third buffer in the right window; this should unlist the git ignored buffer as it will become hidden." Sleep 1s Escape
Ctrl+l
Type@80ms ":edit ./LICENSE" Sleep 1s Enter
Sleep 3s
Ctrl+h
Type@80ms ":buffers" Sleep 1s Enter
Sleep 5s Enter

Type "o" Enter
Type "All neat and organized! 🧹" Enter Escape
Sleep 3s
