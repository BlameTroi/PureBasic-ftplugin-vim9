vim9script
# ftdetect/purebasic.vim
# vim: ts=3 sw=3 sts=3 et ai fdm=marker
# vim: ts=3 sw=3 sts=3 et ai fdm=manual
# -----------------------------------------------------------------------------
# Vim9 filetype plugin for the PureBasic language
# Last Change: WIP 2026
# Maintainer: Troy Brumley <BlameTroi@gmail.com>
# License: Released to the public domain.
# -----------------------------------------------------------------------------
# PureBasic filetype recognition, set hooks.
# -----------------------------------------------------------------------------
#
# These are all the PureBasic filetypes I know of and their purpose.
#
# pb  -- standard source
# pbf -- from created with designer
# pbi -- looks to be include files
# pbl -- looks to be a parsed C include creating label value pairs
# pbp -- PureBasic project file (Xml)

augroup purebasic_group
   autocmd!
   autocmd BufNewFile,BufRead *.pb,*.pb[i|f] set filetype=purebasic
   autocmd BufNewFile,BufRead *.pbp set filetype=xml
augroup END
