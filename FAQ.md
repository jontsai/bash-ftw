# bash-ftw FAQ (Frequently Asked Questions)

## SSH not working, missing SSH keys, etc.

If you're on a remote server with `bash-ftw` installed, and you're forwarding your local agent via either `ssh -A username@host` or the SSH config value `ForwardAgent yes`, and `ssh-add -l` shows `The agent has no identities.`, this could be due to `bash-ftw` not detecting your forwarded agent from a previous session, and starting a separate SSH agent.

To fix this, check your home directory for a file like `.ssh-vars.YOURHOSTNAME.sh` by doing `ls -a ~ | grep .ssh-vars`, and remove any such matching files. Then, disconnect from your remote server and relogin via `ssh -A`.
