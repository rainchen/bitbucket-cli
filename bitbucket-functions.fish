#!/usr/bin/env fish

# open bitbucket page for current repo
function bitbucket-open -d "open bitbucket page for current repo"
  set bitbucket_repo_url (git ls-remote --get-url)
  set bitbucket_user (echo $bitbucket_repo_url|cut -d : -f 2|cut -d / -f 1)
  set bitbucket_repo (echo $bitbucket_repo_url|cut -d : -f 2|cut -d / -f 2|cut -d . -f 1)
  set current_branch (git rev-parse --abbrev-ref HEAD)

  set bitbucket_pr_url "https://bitbucket.org/$bitbucket_user/$bitbucket_repo"
  open $bitbucket_pr_url
end

# create a new branch which name is using dasherize style, e.g.: "the-branch-name
# usage example:
#   $ bitbucket-new-branch "MyProject-1234 [docs] fix typos in README."
#   Switched to a new branch 'MyProject-1234-docs-fix-typos-in-readme'
# keeping the begging "MyProject-1234" unchanged because Jira will use it reference to Bitbucket
# more naming examples:
#   $ bitbucket-new-branch "[docs] fix typos in README."
#   $ docs-fix-typos-in-readme
#   $ bitbucket-new-branch "[refactor]log 放入logger里面"
#   $ refactor-log-logger
function bitbucket-new-branch -d "create a new branch which name is using dasherize style, e.g.: \"the-branch-name\""

  # conver input to a dasherize style branch name
  function format_branch_name
    set -l input $argv[1]
    # convert none-alpha to "-", keep one "-" only, remove first "-", remove last "-"
    set -l branch_name ( echo $input | sed -e 's/[^a-zA-Z0-9]/-/g' -e 's/--*/-/g'  -e 's/^-//' -e 's/-$//' )
    set -l project_key ""
    if test (string match -ar '^[A-Za-z]+-[0-9]+.+' $branch_name)
      set branch_name ( echo $branch_name | sed -e 's/\(^[A-Za-z]*-[0-9]*\)\(.*\)/\1:\2/' )
      set project_key ( echo $branch_name | cut -d : -f 1 )
      set branch_name ( echo $branch_name | cut -d : -f 2 )
    end

    # conver branch_name to lowercase, BSD version of sed doesn't support "\L" but GNU version works
    set -l branch_name ( echo $branch_name | sed -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' )
    set -l branch_name "$project_key$branch_name"
    echo $branch_name
  end

  function confirm_branch_name
    set -l branch_name $argv[1]
    read -P "Going to create a branch \"$branch_name\", ok? [y/n]: " -l answer
    if [ "$answer" = "y" ] ;
      create_branch $branch_name
    else
      ask_for_branch_name
    end
  end

  function ask_for_branch_name
    read -P "Please enter a new branch name using dasherize style, e.g.: \"the-branch-name\" (blank to abort): " -l answer
    if test (string match -ar '[^ ]+' $answer)
      create_branch $answer
    else
      echo "Aborted"
    end
  end

  function create_branch
    set -l branch_name $argv[1]
    echo git checkout -b $branch_name
  end

  # main
  set -l input $argv[1]
  set -l branch_name ( format_branch_name \"$input\" )
  confirm_branch_name $branch_name
end

function bitbucket-push-current-branch
  set -l current_branch (git rev-parse --abbrev-ref HEAD)
  git push -u origin $current_branch
end

function bitbucket-delete-remote-branch
  git push --delete origin $argv[1];
end

# use current branch to send pull request on bitbucket
# will open url like:
#   "https://bitbucket.org/${bitbucket_user}/${bitbucket_repo}/pull-requests/new?source=${current_branch}&dest=${base_branch}"
# example for using develop as base branch: $ bitbucket-send-pull-request develop
function bitbucket-send-pull-request -d "use current branch to send pull request on bitbucket"
  set -l default_base_branch "master"
  set -l base_branch ""

  if count $argv > /dev/null
    set base_branch $argv[1]
  else
    # use default_target_branch for target_branch
    set base_branch $default_base_branch
  end

  set -l bitbucket_repo_url (git ls-remote --get-url)
  set -l bitbucket_user (echo $bitbucket_repo_url|cut -d : -f 2|cut -d / -f 1)
  set -l bitbucket_repo (echo $bitbucket_repo_url|cut -d : -f 2|cut -d / -f 2|cut -d . -f 1)
  set -l current_branch (git rev-parse --abbrev-ref HEAD)

  set -l bitbucket_pr_url "https://bitbucket.com/$bitbucket_user/$bitbucket_repo/pull-requests/new?source=$current_branch&dest=$base_branch"
  echo "Prepare sending Pull Request from $current_branch to $base_branch"
  echo $bitbucket_pr_url
  echo open $bitbucket_pr_url
end

alias bitbucket-send-pull-request-to-develop='bitbucket-send-pull-request develop'
