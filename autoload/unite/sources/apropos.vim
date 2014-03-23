let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
            \ 'name': 'apropos',
            \ 'required_pattern_length': 2,
            \ 'is_volatile': 1,
            \ 'hooks' : {},
            \ 'action_table': {},
            \ 'syntax' : 'uniteSource__Apropos'
            \ }

if executable('apropos')
    let s:command = 'apropos %s'
else
    echoerr 'Apropos is not executable on your system.'
endif

let s:unite_source.action_table.insert= {
            \ 'description' : 'view man page',
            \ 'is_quit' : 0,
            \ }

function! s:unite_source.action_table.insert.func(candidate)
    let name = matchstr(a:candidate.word, '.*\ze\s\+(.*)\s\+-')
    let cate = matchstr(a:candidate.word, '(\zs\d.*\ze)\s\+-')
    execute "Man ".cate." ".name
endfunction

function! s:unite_source.hooks.on_syntax(args, context)
    syntax match uniteSource__Apropos_desc /)\s\+-\zs.*$/ contained containedin=uniteSource__Apropos
    syntax match uniteSource__Apropos_name /.*\ze(/ contained containedin=uniteSource__Apropos contains=uniteCandidateInputKeyword
    highlight default link uniteSource__Apropos_desc Constant
    highlight default link uniteSource__Apropos_name Keyword
endfunction

function! s:unite_source.gather_candidates(args, context)
    return map(
                \ split(
                \   unite#util#system(printf(
                \     s:command,
                \     a:context.input)),
                \   "\n"),
                \ '{"word": v:val,
                \ "kind": "word",
                \ "source": "apropos",
                \ }')
endfunction

function! unite#sources#apropos#define()
    if !exists(':Man')
        runtime ftplugin/man.vim
    endif
    return exists('s:command')? s:unite_source : []
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
