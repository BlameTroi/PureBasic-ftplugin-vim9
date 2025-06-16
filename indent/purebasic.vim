vim9script
#------------------------------------------------------------------------------
# indent/purebasic.vim
# vim: ts=3 sw=3 sts=3 et ai fdm=manual
# -----------------------------------------------------------------------------
# Vim9 filetype plugin for the PureBasic language
# Last Change: WIP 2026
# Maintainer: Troy Brumley <BlameTroi@gmail.com>
# License: Released to the public domain.
# -----------------------------------------------------------------------------
# PureBasic filetype suppport for indenting.
#------------------------------------------------------------------------------
# This is for PureBasic (ft=purebasic) and it might work OK for SpiderBasic.
# I'm using the built-in /vim/runtime/indent/vb.vim and /cobol.vim as starting
# points.
#
# PureBasic is very regular so hopefully this will be a smooth operation.
#------------------------------------------------------------------------------

if exists("b:did_indent")
   finish
endif
b:did_indent = 1

# vim9script automatically handles cpoptions, so only set the undo.

b:undo_indent = "setlocal cindent< ai< sw< et< sts< ts< indentexpr< indentkeys< copyindent<"

# These are the expected indent settings. It seems to me they should be set
# elsewhere, but as this is where undo is set, I'll leave it for now.
#
# Spaces and not tabs, three characters per indent.

setlocal indentexpr=GetPureBasicIndent(v:lnum)
setlocal   ai
setlocal   copyindent
setlocal sw=2
setlocal sts=2
setlocal ts=2
setlocal et
setlocal nocindent

# Define PureBasic Indentkeys:

# Unfortunately, Vim9script is single pass, so these have to be in front of
# their usage.

# Words that can indent and outdent are part of multi-line constructs. Either 
# `if/elseif/else/endif` or `select/case/case/default/endselect`. If there are
# no intervening statements between two of these (which isn't a frequent thing)
# the indenting is changed.
#
# Note that I'm only dealing with symantically valid combinations here. `else`
# immediately followed by an `elseif` is clearly wrong and I'll let it screw up
# indenting. But I won't spot the error if the `else` block is not empty.

# The words `else`, `elseif`, `case`, and `default` are in both lists.

const PureBasicIndenters: list<string> = [
         \ 'compilerendif',
         \ 'compilerif',
         \ 'datasection',
         \ 'declaremodule',
         \ 'enumeration',
         \ 'enumerationbinary',
         \ 'for',
         \ 'foreach',
         \ 'if',
         \ 'import',
         \ 'importc',
         \ 'interface',
         \ 'macro',
         \ 'module',
         \ 'procedure',
         \ 'procedurec',
         \ 'procedurecdll',
         \ 'proceduredll',
         \ 'repeat',
         \ 'structure',
         \ 'structureunion',
         \ 'while',
         \ 'with',
         \ 'else',
         \ 'elseif',
         \ 'case',
         \ 'default',
         \ ]->sort()

const PureBasicOutdenters: list<string> = [
         \ 'compilerendif',
         \ 'enddatasection',
         \ 'enddeclaremodule',
         \ 'endenumeration',
         \ 'endif',
         \ 'endimport',
         \ 'endinterface',
         \ 'endmacro',
         \ 'endmodule',
         \ 'endprocedure',
         \ 'endstructure',
         \ 'endstructureunion',
         \ 'endwith',
         \ 'forever',
         \ 'next',
         \ 'until',
         \ 'wend',
         \ 'else',
         \ 'elseif',
         \ 'case',
         \ 'default',
         \ ]->sort()

const PureBasicDualDenters: dict<string> = {
   'elseif': '\v\celse(if)?',
   'case': '\v\cdefault',
   'default': '\v\ccase',
}

# Set Indentkeys:

# Getting indent to fire at the right times was more difficult than I expected.
# I believe some of that was due to my ignorance, but some was also due to
# PureBasic not being a C-ish language. Vim is certainly has a C first bent.
#
# When entering text, indent will be called if the first word on a line is one
# recognized from `indentkeys`. Indet will always be called when you press <CR>
# to end a line.

# First remove the C style brackets and then add the keywords that indent
# and/or outdent.

# Note: This is a hard reset of `indentkeys`, not a -= += change.
# Note: *<CR> is required to indent the line -as- you enter it.

setlocal indentkeys=!^F,o,O,*<CR>,<TAB>

# Build indentkeys from PureBasic indent and outdent markers. As PureBasic is
# not case sensitive, neither are these checks.

for txt in PureBasicIndenters
   execute $"setlocal indentkeys+=0=~{txt}"
endfor

for txt in PureBasicOutdenters
   execute $"setlocal indentkeys+=0=~{txt}"
endfor

# display to verify
execute "setlocal indentkeys?"

# Indenting in PureBasic is based on keywords. Words such as `if` indent the
# following lines; words such as `endif` outdent their line and the following
# lines; and words such as `elseif` indent the following lines after outdenting
# their line.
#
# This is text driven, not semantic driven, which leads to two assumptions:
# - Keywords are expected to be the first word on a line.
# - There is only one statement per line.
#
# The expected indenting can be see in the following table:
#
#     prior    this      expected indent
#     -------  -------   ---------------
#     normal   normal    prior
#     normal   indent    prior
#     normal   outdent   prior-shiftwidth
#     indent   normal    prior+shiftwidth
#     indent   indent    prior+shiftwidth
#     indent   outdent   prior
#     outdent  normal    prior
#     outdent  indent    prior
#     outdent  outdent   prior or prior-shiftwidth, depends upon
#                        word pairing. else/elseif are the same,
#                        as are case/default
#
# The indent of the current line is calculated as in the above table. I am
# assuming that returning -1 if the calculated indent is the same as the old
# indent is worth the effort.

# Language keywords that influence indenting. Some keywords are in both lists.

const True: bool = 1
const False: bool = 0


# Learn something about the first word on a line. Does it indent? Does it
# outdent? Is it a word that does both and require even more special
# handling?

# If a word is one of the paired in-out denters in a larger block, return a
# match string for the prior line's first word.

def PureBasicDualPattern(txt: string): string
   return PureBasicDualDenters->get(txt, "")
enddef
defcompile

# Does this word indent?

def IsPureBasicIndenter(txt: string): bool
   return PureBasicIndenters->index(tolower(txt)) != -1
enddef
defcompile

# or outdent?

def IsPureBasicOutdenter(txt: string): bool
   return PureBasicOutdenters->index(tolower(txt)) != -1
enddef
defcompile

# Convert a bool to a string.

def BoolToStr(b: bool): string
   if b
      return "True"
   endif
   return "False"
enddef
defcompile

# Is this a blank or comment line?

def IsPureBasicBlankOrComment(lnum: number): bool
   var line = getline(lnum)
   if len(line) == 0
      return True
   else
      return line =~# '\v\s*REM'
   endif
enddef
defcompile

# Find prior non-comment line.

def GetPureBasicPriorStatement(lnum: number): number
   var pnum = lnum - 1
   while pnum > 0 && IsPureBasicBlankOrComment(pnum)
      pnum = pnum - 1
   endwhile
   return pnum
enddef
defcompile

# echom "IsPureBasicIndenter(if)" .. BoolToStr(IsPureBasicIndenter("if"))
# echom "IsPureBasicIndenter(fred)" .. BoolToStr(IsPureBasicIndenter("fred"))
# echom "IsPureBasicIndenter(add)" .. BoolToStr(IsPureBasicIndenter("add"))
# echom "IsPureBasicIndenter(zebra)" .. BoolToStr(IsPureBasicIndenter("zebra"))

# Determine the proper indent (in spaces) of this line. This is generally
# based upon the prior line's indent and assumes that it has been indented
# correctly.

def GetPureBasicIndent(vlnum: number): number

   # Define the variables early.
   var this_line: string
   var this_words: list<string>
   var this_indent: number
   var does_this_indent: bool
   var does_this_outdent: bool
   var prior_lnum: number
   var prior_line: string
   var prior_words: list<string>
   var prior_indent: number
   var does_prior_indent: bool
   var does_prior_outdent: bool

   # Easiest case is that this is the first line in the buffer and the
   # indent is 0.

   echom $">>>GetIndent({vlnum})"
   if vlnum < 2
      # FIXME: This doesn't work of I enter the first line with leading spaces,
      # but it does when I do a manual indent.
      # ??
      echom "<<<First line"
      return 0
   endif

   # Start gathering information about this line and the prior line.

   this_line = getline(vlnum)
   this_words = split(this_line)
   echom $"this  ==> {vlnum}:{this_line}"
   prior_lnum = GetPureBasicPriorStatement(vlnum)

   # Quick return is if there is no prior non-blank. Returns 0.

   if prior_lnum < 1
      # ??
      echom "<<<No prior nonblank line"
      return 0
   endif

   # I need more information. The next quickest decisions are based on the
   # indent direction of the prior line.

   this_indent = indent(vlnum)
   if len(this_words) < 1
      # Do not leave quickly, allowing this to run as a non-denter statement
      # helps with properly indenting after pressing enter.
      # echom "---Empty line treated as a plain statement"
      does_this_outdent = False
      does_this_indent = False
   else
      does_this_outdent = IsPureBasicOutdenter(this_words[0])
      does_this_indent = IsPureBasicIndenter(this_words[0])
   endif

   prior_indent = indent(prior_lnum)
   prior_line = getline(prior_lnum)
   prior_words = split(prior_line)
   echom $"prior ==> {prior_lnum}:{prior_line}"

   does_prior_outdent = IsPureBasicOutdenter(prior_words[0])
   does_prior_indent = IsPureBasicIndenter(prior_words[0])

   # Select/Case... align a bit weirdly.

   if does_prior_indent && !does_prior_outdent
      if prior_words[0] ==? 'select' && (this_words[0] ==? 'case' || this_words[0] ==? 'default')
         echom "---case or default after select"
         if this_indent == prior_indent + shiftwidth()
            echom "<<<Returning -1"
            return -1
         endif
         echom "<<<Returning prior + shiftwidth"
         return prior_indent + shiftwidth()
      endif
   endif

   # Get the EndSelect lined up properly.

   if does_this_outdent && !does_this_indent && this_words[0] ==? 'select'
      echom "---endselect"
      if prior_words[0] ==? 'case' || prior_words[0] ==? 'default'
         echom "---empty case or default prior to endselect"
         if this_indent == prior_indent - shiftwidth()
            echom "<<<Returning -1"
            return -1
         endif
         echom "<<<Returning prior - shiftwidth"
         return prior_indent - shiftwidth()
      elseif prior_words[0] ==? 'select'
         echom "---empty select/endselect"
         if this_indent == prior_indent
            echom "<<<Returning -1"
         endif
         echom "<<<Returning prior"
         return prior_indent
      else
         echom "---non-empty case or default prior to endselect"
         if this_indent == prior_indent - 2 * shiftwidth()
            echom "<<<Returning -1"
            return -1
         endif
         echom "<<<Returing prior - 2 * shiftwidth"
         return prior_indent - 2 * shiftwidth()
      endif
   endif

   # This block causes more problems than it solves.
   # # If the prior line is an outdents always indent under it.
   # # WRONG: or rather not this way,
   # if does_prior_outdent
   #    # ??
   #    echom $"---1:Prior outdents, indents: this={this_indent} prior={prior_indent}"
   #    if this_indent == prior_indent
   #       echom "<<<Same indent, returning -1"
   #       return -1
   #    endif
   #    echom "<<<Returing prior"
   #    return prior_indent
   # endif

   # Next look to see if the prior indents, and if so handle it
   # appropriately.

   if does_prior_indent
      echom $"---2:Prior indents, indents: this={this_indent} prior={prior_indent}"
      if does_this_outdent
         # ??
         echom "---2:This outdents, this likely should return prior"
         if this_indent == prior_indent
            echom "<<<Returning -1"
            return -1
         endif
         echom "<<<Returning prior."
         return prior_indent
      endif
      # ??
      echom "---3:This indents or does nothing, should indent prior + shiftwidth"
      if this_indent == prior_indent + shiftwidth()
         echom "<<<Returning -1"
         return -1
      endif
      echom "<<<Returning prior + shiftwidth"
      return prior_indent + shiftwidth()
   endif

   # The prior statement has no impact, but if this statement is an outdenter
   # then we do need to adjust.

   if does_this_outdent
      echom $"---4:Prior outdents, indents: this={this_indent} prior={prior_indent}"
      # ??
      if this_indent == prior_indent - shiftwidth()
         echom "<<<Returning -1"
         return -1
      endif
      echom "<<<Returning prior - shiftwidth"
      return prior_indent - shiftwidth()
   endif

   # And that's all the cases except for prior has no impact and this statement
   # has no impact on its own indent.

   # ??
   echom $"---5:Neither dents, indents: this={this_indent} prior={prior_indent}"
   if this_indent == prior_indent
      echom "<<<Returning -1"
      return -1
   endif
   echom "<<<Returning prior"
   return prior_indent

enddef
defcompile
