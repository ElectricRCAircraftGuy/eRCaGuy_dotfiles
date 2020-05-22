      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{print "-"left++ ": " line;next};\
          bare~/^[+]/{print "+"right++ ": " line;next};\
          {print "("left++","right++"): "line;next}'


      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf "\n-%-8s:", left++ line;next};\
          bare~/^[+]/{printf "\n+%-8s:", right++ line;next};\
          {print "("left++","right++"): "line;next}'

      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf "\n-%-s:", left++ line;next};\
          bare~/^[+]/{printf "\n+%-s:", right++ line;next};\
          {print "("left++","right++"): "line;next}'

      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf "-%-9s:%s\n", left++, line;next};\
          bare~/^[+]/{printf "+%-9s:%s\n", right++, line;next};\
          {printf "(%s,%s):%s\n", left++, right++, line;next}'


# works!:

      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf   "-%+4s     :%s\n", left++, line;next};\
          bare~/^[+]/{printf "+%+4s     :%s\n", right++, line;next};\
          {printf            " %+4s,%+4s:%s\n", left++, right++, line;next}'

# now, try to add some color in to the + and - sections at the beginning!

# See my ans: https://stackoverflow.com/questions/18810623/git-diff-to-show-only-lines-that-have-been-modified/61929887#61929887


      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf   "-%+4s     :%s\n", left++, line;next};\
          bare~/^[+]/{printf "+%+4s     :%s\n", right++, line;next};\
          {printf            " %+4s,%+4s:%s\n", left++, right++, line;next}'


      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf   "-%+4s     :%s\n", left++, line;next};\
          bare~/^[+]/{printf "+%+4s     :%s\n", right++, line;next};\
          {printf            " %+4s,%+4s:%s\n", left++, right++, line;next}' > temp3.txt


# colored numbers on left--works!
# NEXT: JUST CLEAN THIS UP, MAKE IT INTO A SCRIPT, INTEGRATE IT INTO my .gitconfig file as a
# `git diffn` alias (git diff line 'n'umbers); write up a full answer, incorporate it into my
# dotfiles repo here, and be done!
# Write a *super* abbreviated answer here, with no improved formatting: https://stackoverflow.com/questions/61932427/git-diff-with-line-numbers-and-proper-code-alignment-indentation
# and link to a nice, complete answer here: https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers/33249416#33249416
# Be sure to include screenshots and demo input files.
# file.cpp original and file.cpp new, to give people something to run `git diffn` on!
# Save this script into a file called `git-diffn`. It will be run as `git diffn`.
# Note: it will keep numbers aligned up to 4 chars, or a maximum line number of 9999.

# Once done with this, also integrate using `git diffn` into my `git-filechange-search` script,
# which you should also integrate into a git usage; ex: `git filechange` alias.
# Also, edit that script to auto-detect if the user has `git diffn` available, and if they don't, 
# pop up a warning and instructions on how to get and install it.
      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf   "\033[31m-%+4s     :%s\n", left++, line;next};\
          bare~/^[+]/{printf "\033[32m+%+4s     :%s\n", right++, line;next};\
          {printf                    " %+4s,%+4s:%s\n", left++, right++, line;next}'


      git diff HEAD~..HEAD --color=always | \
        gawk '{bare=$0;gsub("\033[[][0-9]*m","",bare)};\
          match(bare,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
          bare ~ /^(---|\+\+\+|[^-+ ])/{print;next};\
          {line=gensub("^(\033[[][0-9]*m)?(.)","\\2\\1",1,$0)};\
          bare~/^-/{printf   "\033[31m-%+4s     :%s\n", left++, line;next};\
          bare~/^[+]/{printf "\033[32m+%+4s     :%s\n", right++, line;next};\
          {printf                    " %+4s,%+4s:%s\n", left++, right++, line;next}' > temp5.txt


