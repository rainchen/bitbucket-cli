# bitbucket-cli

Some useful shell functions for creating git branch, sending pull request on Bitbucket.

## Install

1. clone code

`git clone https://github.com/rainchen/bitbucket-cli.git`

2. setup shell

  - for Bash shell

        append `source path-to-bitbucket-cli/bitbucket-functions.sh` to `~/.bash_profile`

  - for Fish shell

        append `source path-to-bitbucket-cli/bitbucket-functions.fish` to `~/.config/fish/config.fish`

## Usage

* `bitbucket-open`

    open bitbucket page for current repo

* `bitbucket-new-branch`

    create a new branch, example:

    ```
    $ bitbucket-new-branch "MyProject-1234 [docs] fix typos in README."
    Switched to a new branch 'MyProject-1234-docs-fix-typos-in-readme'
    ```

    Keeping the begging "MyProject-1234" unchanged because Jira will use it reference to Bitbucket.


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

## License

MIT License


