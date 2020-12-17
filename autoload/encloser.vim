" encloser.vim - Enter to close unbalanced brackets in cursorline
" Maintainer: @mapkts
" Version: 0.1.0
" Repository: github.com/mapkts/vim-encloser

if exists("g:encloser_loaded") | finish | endif
let g:encloser_loaded = 1

let g:encloser_default_escapes = ['''', '"', '/']
let g:encloser_default_escape_leaders = ['\']
let g:encloser_previous_mapped = ''

func! encloser#try_enable()
    let mapped = maparg('<CR>', 'i')
    if mapped ==# '' && get(b:, 'encloser') ==# 1
        imap <CR> <CR><Plug>(EncloserClose)
    else
        execute 'let '.g:encloser_previous_mapped.'='.mapped
    endif
endf

func! encloser#toggle()
    if get(b:, 'encloser') == 0
        let b:encloser = 1 
        imap <silent> <CR> <CR><Plug>(EncloserClose)
        echo "Encloser enabled"
    else
        let b:encloser = 0 
        imap <silent> <CR> <CR>
        echo "Encloser disabled"
    endif
endf

func! encloser#encloser()
    " if encloser is not enabled, just return
    if !get(b:, 'encloser') | return '' | endif

    " if current position is not at EOL, just return
    if match(getline('.'), '^\s*$') == -1 | return '' | endif

    let line = getline(line('.') - 1)
    let missing_brackets = s:get_missing_brackets(line)
    if empty(missing_brackets)
        return ''
    else
        return missing_brackets."\<ESC>==O"
    endif
endf

func! s:get_missing_brackets(line)
    let line = s:strip_comments(a:line)
    let chars = split(line, '\zs')

    let escapes = get(b:, 'encloser_escapes', g:encloser_default_escapes)
    let escape_leaders = get(b:, 'encloser_secape_leaders', g:encloser_default_escape_leaders)    
    
    let skip = 0
    let skip_char = ''
    let idx = -1
    let stack = []
    for ch in chars
        let idx += 1
        if !skip
            if index(escapes, ch) >= 0
                let skip = 1
                let skip_char = ch
            elseif ch ==# '{'
                call add(stack, '}')
            elseif ch ==# '('
                call add(stack, ')')
            elseif ch ==# '['
                call add(stack, ']')
            elseif !empty(stack) && stack[-1] ==# ch
                call remove(stack, -1)
            endif
        elseif index(escapes, ch) >= 0 && ch ==# skip_char
            if index(escape_leaders, get(chars, idx - 1, '')) ==# -1
                let skip = 0
            endif
        endif
    endfor

    return join(reverse(stack), '')
endf

func! s:strip_comments(text)
    let text = a:text
    
    " strip multi-line comments if b:encloser_bcomment_matcher was set
    let matcher = get(b:, 'encloser_bcomment_matcher')
    if !empty(matcher)
        let text = s:strip_multiline_comments(text)
    endif
    
    " strip single-line comments if b:encloser_lcomment_matcher was set
    let matcher = get(b:, 'encloser_lcomment_matcher')
    if !empty(matcher)
        let text = substitute(text, matcher, '', 'g')
    endif

    return text
endf

func! s:strip_multiline_comments(text)
    let line_above = getline(line('.') - 1)

    if match(trim(a:text), '^\*.*$') ==# 0 && match(trim(line_above), '^\/\?\*.*$') ==# 0
        return ''
    endif

    return a:text
endf
