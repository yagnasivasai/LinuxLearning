If u run a command or script in a terminal? What will happen if u exit terminal?
--- It will be terminated as soon as you exit your terminal.

But if you want it to run in the background until it finishes even if you exit the terminal? what will you do?
--- nohup allows you do that
--- nohup tar -cvzf backup.tar.gz backups&
--- disown
--- tmux

How do you bring the process that is in the background fo foreground?
--- fg processid

