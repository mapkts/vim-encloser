if !get(g:, "encloser_enable_global")
    let g:encloser_enable_global = 0
endif

augroup encloser
    autocmd!

    autocmd Filetype * if g:encloser_enable_global | let b:encloser = 1 | endif

    autocmd Filetype c,cpp,cs,rust,java,javascript,typescript,javascript.jsx,javascriptreact,typescriptreact,php
        \ let b:encloser = 1 |
        \ let b:encloser_bcomment_matcher = '^\*.*$' |
        \ let b:encloser_lcomment_matcher = '\(\/\/.*\|\/\*.*\*\/\)'

    autocmd Filetype css
        \ let b:encloser = 1 |
        \ let b:encloser_bcomment_matcher = '^\*.*$' |
        \ let b:encloser_lcomment_matcher = '\/\*.*\*\/'

    autocmd Filetype python
        \ let b:encloser = 1 |
        \ let b:encloser_lcomment_matcher = '\#.*'

    autocmd Filetype go
        \ let b:encloser = 1 |
        \ let b:encloser_lcomment_matcher = '\/\/.*'


    autocmd Filetype vim
        \ let b:encloser = 1 |
        \ let b:encloser_lcomment_matcher = '\".*'

    autocmd Filetype * call encloser#try_enable()
augroup END

inoremap <silent> <Plug>(EncloserClose) <C-R>=encloser#enclose()<CR>

nnoremap <silent> <Plug>(EncloserToggle) :<C-U>call encloser#toggle()<CR>

command! -nargs=0 EncloserToggle :call encloser#toggle()
