let s:opfunc = ""
let s:args = []
let s:context = {'count': 0, 'set_count': v:false, 'repeated': v:false}

function! peridot#repeatable_function(fname, args = []) abort
  let s:context['repeated'] = v:false
  call peridot#_reset_counter(v:count, v:count1)
  call peridot#_set_counter(v:count, v:count1)
  let s:opfunc = a:fname
  let s:args = a:args
  set operatorfunc=peridot#_opfunc
  return "g@\<Cmd>call peridot#_set_counter(v:count, v:count1)\<CR>"
endfunction

function! peridot#repeatable_textobj(fname, args = []) abort
  let s:context['repeated'] = v:false
  let s:args = a:args
  return "\<Cmd>call peridot#_textobj('" .. a:fname .. "', v:count, v:count1)\<CR>"
endfunction

function! peridot#_textobj(fname, count, count1) abort
  call peridot#_set_counter(a:count, a:count1)
  let l:Func = function(a:fname, [s:context] + s:args)
  call l:Func()
  let s:context['repeated'] = v:true
endfunction

function! peridot#_opfunc(type, ...) abort
  let l:OpFunc = function(s:opfunc, [s:context] + s:args)
  call l:OpFunc()
  let s:context['repeated'] = v:true
endfunction

function! peridot#_reset_counter(count, count1) abort
  let s:context['count'] = 0
  let s:context['set_count'] = v:false
endfunction

function! peridot#_set_counter(count, count1) abort
  if a:count == a:count1
    let s:context['count'] = a:count
    let s:context['set_count'] = v:true
  endif
endfunction
