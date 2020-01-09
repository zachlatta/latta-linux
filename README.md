# .dotfiles

Re-doing my dotfiles. Problems with previous set of dotfiles:

- Difficult to edit (not very "hackable")
- Lots of cruft that was no longer used, which made it difficult to see everything that was going on
  - Part of this was the dual-OS support between macOS and Linux
- Annoying to set up on new machines, particularly when it came to theme support (solarized would *always* break on new machines, especially SSHed Linux instances)
  - rcm always felt clunky, symlinks would take forever - especially with the submodule for bash-completion
    - I never used any features of it besides `rcup -v`
- bash never got to the point where it felt great to use

Goals for this new set of dotfiles:

- Low time-to-input and time-to-edit (feels "hackable")
- Very, very quick to get a great vim (maybe neovim?) environment
  - <2m on a brand new machine
  - Should not leave me reading for VS Code when doing more complicated dev work
- A shell that I love using, bash or otherwise
