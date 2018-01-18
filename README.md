# vim-color-util
> A few util functions for manipulating colors in vimscript.

## Usage

A brief example of how you might use some of these functions:

```vim
" Get the current background color
let bg = color#GetHighlight('Normal', 'guibg')

" Lighten it by 50%
let marks_color = color#Lighten(bg, 50)

" Use the new color to highlight the foreground of the 'SpecialKey' group
call color#Highlight('SpecialKey', marks_color, '', '')
```

The basic idea is to be able to dynamically manipulate and set colors. The most obvious cases being where you want to set something based on your current colorscheme. Perhaps an airline theme that magically changes colors with the colorscheme, for example.

## Installation

Use your installation method of choice.

Example with Vundle:
```vim
Plugin 'tam5/vim-color-util'
```
