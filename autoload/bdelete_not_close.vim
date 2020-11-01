" wipe/delete/unload buffers, not windows
" (Never delete the last remaining buffer)
"
" Author: Jo Totland

if exists("g:autoloaded_bdelete_not_close")
    finish
endif
let g:autoloaded_bdelete_not_close = 1

function! bdelete_not_close#GetridofBufRangeOrList(cmd, bang, line1, line2, ...)
    if a:0 > 1
        call s:getRidOfBufList(a:cmd, a:bang, a:000)
    elseif a:0 ==# 1
        call s:getRidOfBuf(a:cmd, a:bang, a:1)
    elseif a:line2 <= a:line1
        call s:getRidOfBuf(a:cmd, a:bang, a:line1)
    else
        call s:getRidOfBufList(a:cmd, a:bang, range(a:line1, a:line2))
    endif
endfunction

function! s:getRidOfBufList(cmd, bang, buflist)
    let s:count = 0
    for elem in a:buflist
        call s:getRidOfBuf(a:cmd, a:bang, elem)
    endfor
    echo s:count . ' buffers deleted.'
    unlet s:count
endfunction

function! s:getRidOfBuf(cmd, bang, buf)
    if type(a:buf) == v:t_number
        let buf = a:buf ? bufnr(a:buf) : bufnr('%')
    elseif type(a:buf) == v:t_string
        let buf = a:buf =~# '^\d\+$' ? bufnr(str2nr(a:buf)) : bufnr(a:buf)
    else
        let buf = 99999999
    endif
    if !bufexists(buf)
        echo 'No such buffer: ' . a:buf
        return
    endif
    let orig_tab = tabpagenr()
    let orig_win = winnr()
    try
        for tab in range(1, tabpagenr('$'))
            execute tab . 'tabnext'
            for win in range(1, winnr('$'))
                if winbufnr(win) !=# buf | continue | endif
                execute win . 'wincmd w'
                let other = bufnr('#')
                if other > 0 && buflisted(other) && other !=# buf
                    buffer #
                else
                    bprevious
                endif
                if bufnr('%') ==# buf
                    echo 'This is the last buffer'
                    return
                endif
            endfor
        endfor
        if exists("s:count")
            if a:cmd==#'bunload' && bufloaded(buf)|let s:count+= 1|endif
            if a:cmd==#'bdelete' && buflisted(buf)|let s:count+= 1|endif
            if a:cmd==#'bwipeout'&& bufexists(buf)|let s:count+= 1|endif
        endif
        execute 'silent! ' . a:cmd . a:bang . ' ' . buf
    finally
        execute orig_tab . 'tabnext'
        execute orig_win . 'wincmd w'
    endtry
endfunction
