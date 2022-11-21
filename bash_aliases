alias checkout-32gb='srun --gpus-per-node=1 --partition=devaccel --time=3000 --cpus-per-task 10 --ntasks-per-node 1 --mem=50G --constraint volta32gb --pty zsh -l'
alias checkout-node='srun --gpus-per-node=8 --partition=devaccel --time=3000 --cpus-per-task 80 --ntasks-per-node 1 --mem=375G --constraint volta32gb --pty zsh -l'
alias ll='ls -lh'
alias sq='squeue --me -o "%.18i %.9P %.128j %.8u %.2t %.10M %.6D %R"'
alias countseqs='grep -c "^>"'
alias catfasta="awk '1'"
