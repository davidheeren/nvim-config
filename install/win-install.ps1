
winget install Neovim.Neovim
winget install marlocarlo.psmux
winget install sharkdp.fd
winget install ajeetdsouza.zoxide
winget install junegunn.fzf
winget install Microsoft.PowerShell

Install-Module -Name PSFzf
Install-Module -Name PSReadLine

# TODO: Check for existing folder and file
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target (Resolve-Path "..\powershell\Microsoft.PowerShell_profile.ps1").Path
New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim\init.lua" -Target (Resolve-Path "..\nvim\init.lua").Path
New-Item -ItemType SymbolicLink -Path "$HOME\.config\psmux\psmux.conf" -Target (Resolve-Path "..\tmux\tmux.conf").Path
