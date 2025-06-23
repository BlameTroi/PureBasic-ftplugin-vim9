vim9script
# ftplugin/purebasic.vim
# vim: ts=3 sw=3 sts=3 et ai fdm=manual
# -----------------------------------------------------------------------------
# Vim9 filetype plugin for the PureBasic language
# Last Change: WIP 2026
# Maintainer: Troy Brumley <BlameTroi@gmail.com>
# License: Released to the public domain.
# -----------------------------------------------------------------------------
# PureBasic filetype suppport functions. Everything but indent and syntax is
# in here.
# -----------------------------------------------------------------------------
#
# Inspired by Steve Losh's _Learn Vimscript the Hard Way_ and with a
# pre-existing syntax file by Github user DNSGeek, I decided ot make a more
# functional filetype plugin for PureBasic.
#
#  If you don't understand filetype plugins see:
#
#  - Vim :help (particularly in the area of `syntax`, `plugins`, and `ftplugin`).
#
#  - Steve Losh's _Learn Vimscript the Hard Way_. Even if you don't plan to use
#    Vimscript or are a Neovim user (as I am) there is much to learn from that
#    text.
#
#  - Internet search standbys Reddit, Stack Overflow/Exchange, and the random
#    blog.
#  -----------------------------------------------------------------------------
#
#  Features:
#
# - Regex based syntax highlighting.
#
# - Vimscript based indenting.
#
#  Still to do:
#
# - Compiler invocation.
#
# - Some sort of completion support, even if only keywords.
#
# - Normalize keyword casing to the PureBasic IDE standard (PascalCase).
#
#  Limitations/Bugs/Antifeatures:
#
# - I make no attempt at backward compatability. Vim 8 was released in 2017.
#   It's now 2025.
#
# - If/EndIf folds do not consider Else/ElseIf. The fold is from the If to the
#   EndIf. I might revisit this if I find it to be a problem.
#
# - Select/EndSelect (and variants) do not consider Case/Default. The fold is
#   from the Select to the EndSelect.
#
#  People, if you have enough code in a Case to warrant folding, you are
#  doing it wrong. I will not revisit this.
# -----------------------------------------------------------------------------
# EditorConfig/Vim-Sleuth/Guess-Indent users -- those plugins sometimes mess
# each other up. I don't use any of them myself. If things look weird, make
# sure they aren't involved.
#------------------------------------------------------------------------------
# Maintenance log:
# 17 Jun 2025  Put in version 9 guard
# -----------------------------------------------------------------------------

if !has('vim9script') ||  v:version < 900
    # Needs Vim version 9.0 and above
    echoerr "You need at least Vim 9.0"
    finish
endif

if exists("b:did_ftplugin")
   finish
endif
b:did_ftplugin = 1

b:undo_ftplugin = 'setlocal iskeyword< commentstring< comments< suffixesadd< formatoptions< ignorecase<'

setlocal suffixesadd=.pb,pbi

# NOTE: No matter what I did, I could not get tpope/vim-commentary to properly
# uncomment a comment line. With and without trailing space, with and without
# "b:", it just kept inserting new comment characters. I find that
# tomtom/tcomment_vim works correctly.

setlocal comments=:;\ 
setlocal commentstring=;\ %s\ 
setlocal iskeyword=a-z,A-Z,_,48-57
setlocal ignorecase
setlocal formatoptions-=tcan
setlocal formatoptions+=roql1
setlocal tw=0

