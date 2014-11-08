set_default :current_git_branch, %x[git rev-parse --abbrev-ref HEAD].strip
