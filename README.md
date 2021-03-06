# bitbucket-cli

Some useful shell functions for creating git branch, sending pull request on Bitbucket.

## Install

1. Clone code

    1. `mkdir ~/bin/; cd ~/bin/`
    2. `git clone https://github.com/rainchen/bitbucket-cli.git`
    
    NOTE: if you change the clone path, you need to change `source` path in your shell startup file in next step.

2. Setup shell

  - for Bash shell user

      1. update Bash shell startup file: append `source ~/bin/bitbucket-cli/bitbucket-functions.sh` to `~/.bash_profile`
      2. activate: open a new Terminal window or run `source ~/.bash_profile` in your current Terminal window.

  - for Fish shell user

      1. update Fish shell startup file: append `source ~/bin/bitbucket-cli/bitbucket-functions.fish` to `~/.config/fish/config.fish`
      2. activate: open a new Terminal window or run `source ~/.config/fish/config.fish` in your current Terminal window.

## Usage

cd to your local project dir which is hosting on Bitbucket, then you can run these commands:

* `bitbucket-open`

    open bitbucket page for current repo

* `bitbucket-new-branch "issue title"`

    create a new branch, example:

    ```
    $ bitbucket-new-branch "MyProject-1234 [docs] fix typos in README."
    Switched to a new branch 'MyProject-1234-docs-fix-typos-in-readme'
    ```

    Keeping the begging "MyProject-1234" unchanged because `Jira` will use it to reference to Bitbucket.


* `bitbucket-push-current-branch`

    push current local branch to remote


* `bitbucket-send-pull-request`

    use current branch to send pull request on Bitbucket

    it will open an url like: `https://bitbucket.org/${bitbucket_user}/${bitbucket_repo}/pull-requests/new?source=${current_branch}&dest=${base_branch}`

    ```
    # example for using develop as base branch:
    $ bitbucket-send-pull-request develop
    ```

    There is also an alias `bitbucket-send-pull-request-to-develop` for convenient.

* `bitbucket-delete-remote-branch`

    delete a remote branch, use it to delete the branch was merged in a pull request

## Jira Helper

[jira-helper.user.js](jira-helper.user.js) is a Jira helper usercript, it enhances Jira web UI.

### Features:

* added a "Copy issue title" button, to copy issue key and title for creating git branch and git commit message.

    - add copy button on issue browser page:
    
        ![add copy button on issue browser page](https://user-images.githubusercontent.com/71397/41328743-4b7078a8-6efc-11e8-9886-2eef18e3441f.png)
    
    - add copy button on RapidBoard page:
    
        ![add copy button on RapidBoard page](https://user-images.githubusercontent.com/71397/41328760-6313a1c4-6efc-11e8-8ffe-b695f417e650.png)


### Install Jira Helper

1. install Chrome extension [Tampermonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)
2. install this script: 
    * on Greasyfork: [https://greasyfork.org/en/scripts/369468-jira-helper](https://greasyfork.org/en/scripts/369468-jira-helper) (recommended, auto updated) 
    * or Github: [https://github.com/rainchen/bitbucket-cli/raw/master/jira-helper.user.js](https://github.com/rainchen/bitbucket-cli/raw/master/jira-helper.user.js)

## License

MIT License


