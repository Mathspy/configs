def "nu-complete git branches" [] {
  ^git branch | lines | each { |line| $line | str replace '\* ' "" | str trim }
}

def "nu-complete git r-branches" [current_line: string] {
  # I really don't understand where this weird " a" comes from
  let $remote = ($current_line | str replace "git fetch " "" | str replace " a" "");

  ^git branch -r
    | lines
    | each { |line| $line | str replace '\* ' "" | str replace '.*->' "" | str trim }
    | where ($it | str starts-with $remote)
    | each { |line| $line | str replace $"($remote)/" "" }
    | uniq
}

def "nu-complete git remotes" [] {
  ^git remote | lines | each { |line| $line | str trim }
}

def "nu-complete git log" [] {
  ^git log --pretty=%h | lines | each { |line| $line | str trim }
}

################## AUTO COMPLETIONS ##################
# Check out git branches and files
export extern "git checkout" [
  ...targets: string@"nu-complete git branches"   # name of the branch or files to checkout
  --conflict: string                              # conflict style (merge or diff3)
  --detach(-d)                                    # detach HEAD at named commit
  --force(-f)                                     # force checkout (throw away local modifications)
  --guess                                         # second guess 'git checkout <no-such-branch>' (default)
  --ignore-other-worktrees                        # do not check if another worktree is holding the given ref
  --ignore-skip-worktree-bits                     # do not limit pathspecs to sparse entries only
  --merge(-m)                                     # perform a 3-way merge with the new branch
  --orphan: string                                # new unparented branch
  --ours(-2)                                      # checkout our version for unmerged files
  --overlay                                       # use overlay mode (default)
  --overwrite-ignore                              # update ignored files (default)
  --patch(-p)                                     # select hunks interactively
  --pathspec-from-file: string                    # read pathspec from file
  --progress                                      # force progress reporting
  --quiet(-q)                                     # suppress progress reporting
  --recurse-submodules: string                    # control recursive updating of submodules
  --theirs(-3)                                    # checkout their version for unmerged files
  --track(-t)                                     # set upstream info for new branch
  -b: string                                      # create and checkout a new branch
  -B: string                                      # create/reset and checkout a branch
  -l                                              # create reflog for new branch
]

# Download objects and refs from another repository
export extern "git fetch" [
  repository?: string@"nu-complete git remotes" # name of the branch to fetch
  branch?: string@"nu-complete git r-branches"  # name of the remote branch to fetch
  --all                                         # Fetch all remotes
  --append(-a)                                  # Append ref names and object names to .git/FETCH_HEAD
  --atomic                                      # Use an atomic transaction to update local refs.
  --depth: int                                  # Limit fetching to n commits from the tip
  --deepen: int                                 # Limit fetching to n commits from the current shallow boundary
  --shallow-since: string                       # Deepen or shorten the history by date
  --shallow-exclude: string                     # Deepen or shorten the history by branch/tag
  --unshallow                                   # Fetch all available history
  --update-shallow                              # Update .git/shallow to accept new refs
  --negotiation-tip: string                     # Specify which commit/glob to report while fetching
  --negotiate-only                              # Do not fetch, only print common ancestors
  --dry-run                                     # Show what would be done
  --write-fetch-head                            # Write fetched refs in FETCH_HEAD (default)
  --no-write-fetch-head                         # Do not write FETCH_HEAD
  --force(-f)                                   # Always update the local branch
  --keep(-k)                                    # Keep dowloaded pack
  --multiple                                    # Allow several arguments to be specified
  --auto-maintenance                            # Run 'git maintenance run --auto' at the end (default)
  --no-auto-maintenance                         # Don't run 'git maintenance' at the end
  --auto-gc                                     # Run 'git maintenance run --auto' at the end (default)
  --no-auto-gc                                  # Don't run 'git maintenance' at the end
  --write-commit-graph                          # Write a commit-graph after fetching
  --no-write-commit-graph                       # Don't write a commit-graph after fetching
  --prefetch                                    # Place all refs into the refs/prefetch/ namespace
  --prune(-p)                                   # Remove obsolete remote-tracking references
  --prune-tags(-P)                              # Remove any local tags that do not exist on the remote
  --no-tags(-n)                                 # Disable automatic tag following
  --refmap: string                              # Use this refspec to map the refs to remote-tracking branches
  --tags(-t)                                    # Fetch all tags
  --recurse-submodules: string                  # Fetch new commits of populated submodules (yes/on-demand/no)
  --jobs(-j): int                               # Number of parallel children
  --no-recurse-submodules                       # Disable recursive fetching of submodules
  --set-upstream                                # Add upstream (tracking) reference
  --submodule-prefix: string                    # Prepend to paths printed in informative messages
  --upload-pack: string                         # Non-default path for remote command
  --quiet(-q)                                   # Silence internally used git commands
  --verbose(-v)                                 # Be verbose
  --progress                                    # Report progress on stderr
  --server-option(-o): string                   # Pass options for the server to handle
  --show-forced-updates                         # Check if a branch is force-updated
  --no-show-forced-updates                      # Don't check if a branch is force-updated
  -4                                            # Use IPv4 addresses, ignore IPv6 addresses
  -6                                            # Use IPv6 addresses, ignore IPv4 addresses
]

# Push changes
export extern "git push" [
  remote?: string@"nu-complete git remotes",      # the name of the remote
  ...refs: string@"nu-complete git branches"      # the branch / refspec
  --all                                           # push all refs
  --atomic                                        # request atomic transaction on remote side
  --delete(-d)                                    # delete refs
  --dry-run(-n)                                   # dry run
  --exec: string                                  # receive pack program
  --follow-tags                                   # push missing but relevant tags
  --force-with-lease                              # require old value of ref to be at last known value
  --force(-f)                                     # force updates
  --ipv4(-4)                                      # use IPv4 addresses only
  --ipv6(-6)                                      # use IPv6 addresses only
  --mirror                                        # mirror all refs
  --no-verify                                     # bypass pre-push hook
  --porcelain                                     # machine-readable output
  --progress                                      # force progress reporting
  --prune                                         # prune locally removed refs
  --push-option(-o): string                       # option to transmit
  --quiet(-q)                                     # be more quiet
  --receive-pack: string                          # receive pack program
  --recurse-submodules: string                    # control recursive pushing of submodules
  --repo: string                                  # repository
  --set-upstream(-u)                              # set upstream for git pull/status
  --signed: string                                # GPG sign the push
  --tags                                          # push tags (can't be used with --all or --mirror)
  --thin                                          # use thin pack
  --verbose(-v)                                   # be more verbose
]

# Switch between branches and commits
export extern "git switch" [
  switch?: string@"nu-complete git branches"      # name of branch to switch to
  --create(-c): string                            # create a new branch
  --detach(-d): string@"nu-complete git log"      # switch to a commit in a detatched state
  --force-create(-C): string                      # forces creation of new branch, if it exists then the existing branch will be reset to starting point
  --force(-f)                                     # alias for --discard-changes
  --guess                                         # if there is no local branch which matches then name but there is a remote one then this is checked out
  --ignore-other-worktrees                        # switch even if the ref is held by another worktree
  --merge(-m)                                     # attempts to merge changes when switching branches if there are local changes
  --no-guess                                      # do not attempt to match remote branch names
  --no-progress                                   # do not report progress
  --no-recurse-submodules                         # do not update the contents of sub-modules
  --no-track                                      # do not set "upstream" configuration
  --orphan: string                                # create a new orphaned branch
  --progress                                      # report progress status
  --quiet(-q)                                     # suppress feedback messages
  --recurse-submodules                            # update the contents of sub-modules
  --track(-t)                                     # set "upstream" configuration
]

export extern "git merge" [
  branch?: string@"nu-complete git branches"      # name of branch to merge
  --squash
]

# Move or delete or make changes related to branches
export extern "git branch" [
  branch?: string@"nu-complete git branches"      # name of branch to switch to
  --move(-m)                                      # rename the branch
  --delete(-d)                                    # delete a branch if deleting won't causing floating commits
  -D                                              # forces deletes a branch
  --help                                          # show help instructions for command
]

################## CUSTOM COMMANDS ##################
export def "git age" [] {
  ^git branch
    | lines
    | str substring 2,
    | wrap name
    | insert date {
      each { |$it|
        git show $it.name --no-patch --format=%as --
          | into datetime
        }
      }
    | sort-by date
}

export def "git who" [ref: string] {
  {
    author: (^git show -s --format="%an <%ae>" $ref | str substring 1,-2)
    committer: (^git show -s --format="%cn <%ce>" $ref | str substring 1,-2)
  }
}

export def "git cd" [ref: string, --line-numbers: bool = false] {
  if $line_numbers {
    ^git -c delta.line-numbers=true diff $"($ref)~" $ref
  } else {
    ^git diff $"($ref)~" $ref
  }
}

export def "git file" [ref: string, path: string] {
  ^git show $"($ref):($path)"
}
