# c

**catfish**, or **c**, is a better `cat` for your [fish](http://fish.sh/).

It puts files through syntax highlighting, and intelligently pipes to a pager (`less`) if the file is quite long (1.5x the height of your terminal); it simply displays to standard output otherwise.

It's useful for quickly looking at code.

## Installation

You need to be using the [fish](http://fish.sh) shell. Copy `c.fish` to `~/.config/fish/functions/` and it should work for you. You also need Pygments for the syntax highlighting: `pip install pygments`.

## Usage

`c file1 [file2...]`

### Options

`-p, --pager, --less`: Force the usage of less, instead of outputting inline, even if the files are short  
`-i, --inline` : Force outputting to standard output and don't pipe to less, even if the files are long  
`-l, --line-numbers` : Force showing line numbers  
`-n, --no-line-numbers` : Disable line numbers  
`-h, --help` : Display this help

## To do

This was quickly hacked together, but still needs to be made more robust.

- [ ] Doesn't handle multiple files very well when using less (it goes through them one by one)
- [ ] The automatic line number algorithm isn't actually implemented
- [ ] It should use the user-defined pager, instead of `less`
- [ ] Slightly better error handling
