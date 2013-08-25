let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
            \ 'name': 'apropos',
            \ 'required_pattern_length': 3,
            \ 'action_table': {},
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
    execute "Man ".matchstr(a:candidate.word, '.*\ze\s\+(1)')
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
