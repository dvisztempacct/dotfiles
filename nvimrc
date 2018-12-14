:set ts=2 sts=2 sw=2 et ai nu hls
:set cursorline cursorcolumn
:set termguicolors
:set noautochdir
colors ChocolateLiquor
"colors Benokai
"colors 3dglasses
"colors perun
"colors murphy

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'dvisztempacct/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

" (Completion plugin option 1)
Plug 'roxma/nvim-completion-manager'
" (Completion plugin option 2)
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'reasonml-editor/vim-reason-plus'

let g:LanguageClient_serverCommands = {
    \ 'reason': ['ocaml-language-server', '--stdio'],
    \ 'ocaml': ['ocaml-language-server', '--stdio'],
    \ }
"   \ 'reason': ['/Users/donviszneki/.nvm/versions/node/v9.8.0/bin/ocaml-language-server', '--stdio'],
"   \ 'ocaml': ['/Users/donviszneki/.nvm/versions/node/v9.8.0/bin/ocaml-language-server', '--stdio'],

Plug 'ruanyl/coverage.vim'
let g:coverage_json_report_path = 'coverage/coverage-final.json'
let g:coverage_sign_covered = '⦿'
let g:coverage_interval = 500000
let g:coverage_show_covered = 0
let g:coverage_show_uncovered = 1
noremap <silent> gc :call coverage#process_buffer()<cr>

" typescript-vim
Plug 'leafgarland/typescript-vim'
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''

call plug#end()

" reasonml
autocmd VimEnter *.re :LanguageClientStart
autocmd CursorHold *.re :call LanguageClient_textDocument_hover()
" reasonml signatures
autocmd VimEnter *.rei :LanguageClientStart
autocmd CursorHold *.rei :call LanguageClient_textDocument_hover()
" ocaml
autocmd VimEnter *.ml :LanguageClientStart
autocmd CursorHold *.ml :call LanguageClient_textDocument_hover()
" CursorHold interval is bound to updatetime setting; however, this is also
" the interval on which vim writes to its swap file; use with care
set updatetime=500
"autocmd BufWritePost *.re,*.ml silent :!bsrefmt --in-place "%"

set autoread
noremap <silent> gd :call LanguageClient_textDocument_definition()<cr>
noremap <silent> gr :call LanguageClient_textDocument_references()<cr>
noremap <silent> gf :call LanguageClient_textDocument_formatting()<cr>

" Convert Ocaml to Reason
" TODO try ^J https://stackoverflow.com/questions/3249275/vim-multiple-commands-on-same-line/3249320#3249320
command Ml2re :set ft=reason|:%!refmt --parse ml -p re

" Convert JSON-ish javascript to JSON
" TODO replace with a javascript thing to evaluate the module and spit out the JSON
command! Js2json :%s/'/"/g | %s/\(\w\+\)/"\1"/g | %s/"\+/"/g<Paste>

" replace AAAAAA with an incrementing number
" TODO make this into a :command
" perl -pe 'BEGIN{$A=1;} s/AAAAAA/$A++/ge'
" or this one:
" '<,'>!perl -pe 'BEGIN{$A=0;} s/\b[0-9]+\b/$A++/ge'

" colorscheme mods
command SeethroughA hi! Normal ctermbg=NONE guibg=NONE | hi! NonText ctermbg=NONE guibg=NONE
SeethroughA
