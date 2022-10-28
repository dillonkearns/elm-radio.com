#! /usr/bin/bash

# This command is for Mac (might need to tweak for other OSes): https://blog.jasonmeridth.com/posts/use-git-grep-to-replace-strings-in-files-in-your-git-repository/
git grep -l 'Dylan' -- transcripts/ | xargs sed -i '' -e 's/Dylan/Dillon/g'
