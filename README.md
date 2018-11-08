# Various configs and such.

## TODOs
* Check out https://github.com/junegunn/fzf
* Consolidate git commands
  * https://github.com/timrosenblatt/git-commands
  * https://github.com/timrosenblatt/Git-Hooks
  * https://github.com/timrosenblatt/git-oldbranches
* fix .ssh/config to include a file from in here https://superuser.com/questions/247564/is-there-a-way-for-one-ssh-config-file-to-include-another-one

## Command line fun!

`key, key2` means press `key` first, then press `key2`

`key-key2` means press `key` and `key2` simultaneously

### Navigating text
* `esc, b` -- jump backwards by word
* `esc, f` -- jump forwards by word
* `control-a` -- jump to beginning of line
* `control-e` -- jump to end of line

### Modifying text
* `control-k` -- cut all characters after cursor into buffer
* `control-u` -- cut all characters prior to cursor into buffer
* `control-y` -- paste all characters from buffer
* `control-d` -- exit current login session (either from remote server, su, or local)

### Other
* `command-k` -- clear scrollback buffer

# ~/.ssh/config

Create an iTerm profile called "Red" and set the background color to a dark red, or some kind of visual cue. This can also be implemented within iTerm using the "Automatic Profile Switching" 
```
Host *prod*
  PermitLocalCommand yes
  LocalCommand echo -en "\033]50;SetProfile=Red\a"
```
