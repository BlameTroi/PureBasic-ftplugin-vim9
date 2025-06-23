vim9script
# syntax/purebasic.vim 
# vim: ts=3 sw=3 sts=3 et ai fdm=manual
# -----------------------------------------------------------------------------
# Vim9 PureBasic filetype syntax and highlighting definitions.
# Last Change: WIP 2026
# Maintainer: Troy Brumley <BlameTroi@gmail.com>
# License: Released to the public domain.
# -----------------------------------------------------------------------------
# I know that the documentation says we shouldn't need to set `\v` for very
# magic in matches but I'm finding that I do sometimes. I've wasted too much
# time chasing regexp weirdness already, so just ignore the `\v` if it
# offends.
# -----------------------------------------------------------------------------

# Save options and note syntax done for this buffer

if exists("b:current_syntax")
    finish
endif
b:current_syntax = "purebasic"

# What makes a keyword?

# PureBasic is case insensitive and allows only `_` as a special character
# for an identifier. Note that `\` is a delimiter where other languages
# would use `.`. These do not need to be restored like `&cpo` because they
# are local to this syntax file.

syntax iskeyword a-z,A-Z,_,48-57
syntax case ignore

# Keywords

syntax keyword pbKeyword Gosub Return FakeReturn Goto
syntax keyword pbKeyword DataSection EndDataSection
syntax keyword pbKeyword Data Restore Read
syntax keyword pbKeyword Define Dim ReDimr Global
syntax keyword pbKeyword Enumeration EnumerationBinary EndEnumeration
syntax keyword pbKeyword Global NewList NewMap Protected
syntax keyword pbKeyword Threaded Import ImportC
syntax keyword pbKeyword VariableName FunctionName EndImport
syntax keyword pbKeyword IncludeFile XIncludeFile IncludeBinary
syntax keyword pbKeyword IncludePath Macro EndMacro
syntax keyword pbKeyword UndefineMacro MacroExpandedCount
syntax keyword pbKeyword DeclareModule EndDeclareModule
syntax keyword pbKeyword Module EndModule
syntax keyword pbKeyword UseModule UnUseModule
syntax keyword pbKeyword End Swap Print PrintN With EndWith
syntax keyword pbKeyword Interface EndInterface
syntax keyword pbKeyword Str Chr
syntax keyword pbKeyword End

# Procedures

syntax keyword pbProcedure Procedure EndProcedure ProcedureReturn
syntax keyword pbProcedure ProcedureC ProcedureCDll ProcedureDll

# Conditionals

syntax keyword pbConditional If ElseIf Else EndIf
syntax keyword pbConditional Select Case Default EndSelect

# Structures

syntax keyword pbStructure Shared Static Structure Extends
syntax keyword pbStructure Align EndStructure
syntax keyword pbStructure StructureUnion EndStructureUnion

# Debugger

syntax keyword pbDebug CallDebugger Debug DebugLevel
syntax keyword pbDebug DisableDebugger EnableDebugger

# Data Types

syntax keyword pbType Array List Map
syntax keyword pbType Byte Ascii Character Word Unicode Long
syntax keyword pbType Integer Float Quad Double String

# Preprocessing and Compiler Directives

# Conditional compilation, directives, and compile time variable/structure
# interrogation.

syntax keyword pbPreProc CompilerIf CompilerElseIf CompilerElse CompilerEndIf
syntax keyword pbPreProc CompilerSelect CompilerCase CompilerDefault CompilerEndSelect
syntax keyword pbPreProc CompilerError CompilerWarning
syntax keyword pbPreProc EnableExplicit DisableExplicit
syntax keyword pbPreProc EnableASM DisableASM
syntax keyword pbPreProc SizeOf OffsetOf TypeOf Subsystem
syntax keyword pbPreProc Defined InitializeStructure CopyStructure
syntax keyword pbPreProc ClearStructure ResetStructure Bool

# Looping

syntax keyword pbRepeat For ForEach To Step Next
syntax keyword pbRepeat Repeat Until Forever
syntax keyword pbRepeat While Wend
syntax keyword pbRepeat Break Continue

# Comments

syntax match pbComment "\;.*$"

# Operators

# PureBasic has the usual operators, bit wise &|!, logical And Or Not, and
# shifts. As a Basic, some of those C operators you might use are invalid.

# As noted in the header comments, a syntax match shouldn't require `\v` as it
# is implied, but several of these do not work without it, eg: `-`, `+`.

syntax match pbOperator "\v\*"
syntax match pbOperator "\v/"
syntax match pbOperator "\v\+"
syntax match pbOperator "\v-"
syntax match pbOperator "\v\%"
syntax match pbOperator "\v\="
syntax match pbOperator "\v\!"
syntax match pbOperator "\v\~"
syntax match pbOperator "\v\|"
syntax match pbOperator "\v\&"
syntax match pbOperator "\v\<"
syntax match pbOperator "\v\>"
syntax match pbOperator "\v\!\="
syntax match pbOperator "\v\<\="
syntax match pbOperator "\v\>\="
syntax match pbOperator "\v\<\>"
syntax match pbOperator "\v\<\<"
syntax match pbOperator "\v\>\>"
syntax keyword pbOperator And Or XOr Not

# Warn people who try to use C/C++ notation erroneously:

syntax match pbError "//"
syntax match pbError "/\*"
syntax match pbError "=="

# Identifiers and Named Constants

# Identifier names follow typical conventions. Named constants are prefixed
# with `#`. PureBasic library constants are usually prefixed with `#<library
# id>_`.

syntax match pbIdentifier "\v<[_,a-z]\k*${0,1}[^\k]"
syntax match pbConstant "\v<\#[_,a-z]\k*${0,1}[^\k]"
syntax match pbBoolean "\v<\#(true|false)>"

# String Literals

# Strings can not span lines. If a string includes the typical escape
# characters (\n, \t, etc.) it should be prefixed with a tilde `~`.

syntax region pbString start=/\v\~?"/ skip=/\v\\./ end=/\v("|$)/

# Numeric Literals

# Numbers, including floating point, exponents, and alternate bases.

syntax match pbBinary "\v\%[01]+"
syntax match pbHexadecimal "\v\$\x+"
syntax match pbInteger "\v\d+"
syntax match pbFloat "\v\d+\.\d+"
syntax match pbScientific "\v\d+[eE]\d+"
syntax match pbScientific "\v\d+[eE][+\-]=\d+"
syntax match pbScientific "\v\d+\.\d+[eE][+\-]=\d+"

# Map PureBasic groups to standard highlight groups

highlight link pbKeyword Keyword
highlight link pbProcedure Function
highlight link pbConditional Conditional
highlight link pbStructure Structure
highlight link pbDebug Debug
highlight link pbType Type
highlight link pbPreProc PreProc
highlight link pbConstant Constant
highlight link pbBoolean Boolean
highlight link pbRepeat Repeat
highlight link pbComment Comment
highlight link pbOperator Operator
highlight link pbError Error
highlight link pbString String
highlight link pbNumber Number
highlight link pbHexadecimal Number
highlight link pbBinary Number
highlight link pbInteger Number
highlight link pbFloat Number
highlight link pbScientific Number
highlight link vbFloat Number
highlight link pbIdentifier Identifier

# Syntax sync

syntax sync minlines=1 maxlines=1

# This is a Vim9script, cpo is handled automatically.
