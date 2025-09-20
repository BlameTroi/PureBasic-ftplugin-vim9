ARCHIVED September 2025.

This is usable at this point but I've switched to the plugin free Helix editor. The real solution to the problems this plugin tries to solve is at minimum a TreeSitter grammar for PureBasic and with luck an LSP.

# PureBasic Filetype Plugin for Vim

This is an early (and as yet incomplete) filetype plugin for the [PureBasic](https://www.purebasic.com/) programming language.

## Motivation

PureBasic comes with a very good IDE but I prefer Vim for code editing. Rather than have functionality split between two editors, I am adding functionality to Vim so I can spend all (or almost all) of my time in one editor.

## Expected functionality

- Syntax highlighting
- Code folding
- Indenting
- Some completion support
- Compilation

## Unlikely but possible additional functionality

- Tagging
- Help lookup

## Lineage

I started this project by forking the [vim-purebasic](https://github.com/DNSGeek/vim-purebasic) syntax file. As I added more functionality I realized that quadrupling (at least) the LOC was not really what a fork was for. Hence this new project and repository.

A good portion of the syntax/purebasic.vim file is taken straight out of the vim-purebasic plugin. I changed naming, added several new items, and did some formatting.

I spent a lot of time in Steve Losh's [Learn Vimscript the Hard Way](http://learnvimscriptthehardway.stevelosh.com/). The chapters on plugin architecture and creating a filetype plugin for Potion were particularly helpful.

As with any foray into an unknown area, I found read Reddit posts, Stack Overflow questions, and personal blogs. I don't believe any code in here traces directly back to any of these sources, but I learned a lot.

And, of course, Vim's built in documentation was excellent as always.

Once I started trying to package the bits of functionality properly I realized that I needed a template. The Ada language support in the Vim runtime is well laid out and documented. I copied the files and replaced the code with my own work. Thanks to Bram and the various authors of the Ada support!

## Progress and To Do List

- [x] Plugin layout
- [x] Documentation consistency
- [x] Syntax highlighting
- [ ] Folding
- [x] Indenting
- [ ] Compilation support
- [ ] Completion
- [ ] Vim text format documentation

## License

Vim itself is charityware. See `:help license` or `uganda.txt`. I believe plugins such as this should carry the same license. DNSGeek's work carried the Gnu General Public License (version 2). The Ada plugin shows a copyright of 2006 by Martin Krischik <krischik AT users DOT sourceforge DOT net>.

To the extent that an additional copyright or license is needed:

This software code is copyright 2025 by Troy Brumley <blametroi@gmail.com>

Released to the public domain without restrictions, warranty, or guarantee. Use this at your own risk.

## In Conclusion

The PureBasic community on Vim probably isn't very large, I imagine people not using the PureBasic IDE use Sublime, VS Code, or some other `Windows` friendly environment. I'm writing it for my own education as much as any other reason.

[BlameTroi](BlameTroi@Gmail.com)\
is Troy Brumley

So let it be written...\
...so let it be done.
