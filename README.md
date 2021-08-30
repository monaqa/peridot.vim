# peridot.vim

Make your function dot-repeatable!

## Installation

Use your favorite plugin manager.

## Usage

```vim
function! s:some_func(ctx, arg1, arg2, ...)
  " some procedures you want to make dot-repeatable
  " 'ctx' is a dictionary that contains these fields:
  "   count: the value of [count]
  "   set_count: whether the count was set manually
  "   repeated: whether the function was called via dot-repeating
endfunction

nnoremap <expr> peridot#repeatable_function("\<SID>some_func", [value1, value2, ...])
```

## Examples

The following is a dot-repeatable key command that inserts one or more blank lines into the line immediately before or after the cursor, without changing the cursor position:

```vim
nnoremap <expr> <Leader>o peridot#repeatable_function("\<SID>append_new_lines", [line(".")])
nnoremap <expr> <Leader>O peridot#repeatable_function("\<SID>append_new_lines", [line(".") - 1])

function! s:append_new_lines(ctx, pos_line)
  let n_lines = a:ctx['set_count'] ? a:ctx['count'] : 1
  let lines = repeat([""], n_lines)
  call append(a:pos_line, lines)
endfunction
```

The following is a dot-repeatable motion that jumps to the next location where the specified character appears.
(Something like `f` motion, which can span lines.)

```vim
let s:char = ""

function! s:next_char()
  let char = nr2char(getchar())
  let s:char = char
  call search(char, 'W')
endfunction

function! s:next_char_operator_pending(ctx)
  if a:ctx['repeated']
    let char = s:char
  else
    let char = nr2char(getchar())
    let s:char = char
  endif
  normal! m[
  call search(char, 'W')
  normal! m]
endfunction

nnoremap @f <Cmd>call <SID>next_char()<CR>
vnoremap @f <Cmd>call <SID>next_char()<CR>
onoremap <expr> @f peridot#repeatable_textobj("\<SID>next_char_operator_pending")
```
