" wipe/delete/unload buffers, not windows
" (Never delete the last remaining buffer)
"
" Author: Jo Totland
"
" Suggested mapping:
"      nnoremap <silent> <leader>q :BdeleteNotClose<cr>

if exists("g:loaded_bdelete_not_close")
    finish
endif
let g:loaded_bdelete_not_close = 1

command! -bang -range -addr=buffers -nargs=* -complete=buffer
    \ BunloadNotClose call
    \ bdelete_not_close#GetridofBufRangeOrList(
    \     'bunload', '<bang>', <line1>, <line2>, <f-args>)
command! -bang -range -addr=buffers -nargs=* -complete=buffer
    \ BdeleteNotClose call
    \ bdelete_not_close#GetridofBufRangeOrList(
    \     'bdelete', '<bang>', <line1>, <line2>, <f-args>)
command! -bang -range -addr=buffers -nargs=* -complete=buffer
    \ BwipeoutNotClose call
    \ bdelete_not_close#GetridofBufRangeOrList(
    \     'bwipeout', '<bang>', <line1>, <line2>, <f-args>)

