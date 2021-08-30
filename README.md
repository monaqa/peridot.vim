# peridot.vim

Make your function dot-repeatable!

## Installation

Use your favorite plugin manager.

## Usage

```vim
function! s:some_func(ctx)
  " some procedures you want to make dot-repeatable
endfunction

nnoremap <expr> peridot#repeatable_function("\<SID>some_func")
```

For example, the following is a dot-repeatable key command that inserts one or more blank lines into the line immediately before or after the cursor, without changing the cursor position:

```vim
nnoremap <expr> <Leader>o peridot#repeatable_function("\<SID>append_new_lines", [line(".")])
nnoremap <expr> <Leader>O peridot#repeatable_function("\<SID>append_new_lines", [line(".") - 1])

function! s:append_new_lines(ctx, pos_line)
  let n_lines = a:ctx['set_count'] ? a:ctx['count'] : 1
  let lines = repeat([""], n_lines)
  call append(a:pos_line, lines)
endfunction
```
