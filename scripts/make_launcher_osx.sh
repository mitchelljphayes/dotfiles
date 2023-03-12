read "?Enter your UNSW zID: " zid 
mkdir $HOME/CSE
printf "sshfs -o follow_symlinks,noappledouble,defer_permissions,local,volname=CSE $zid@login.cse.unsw.edu.au: $HOME/CSE\n" > $HOME/Desktop/connect_cse
chmod +x $HOME/Desktop/connect_cse

