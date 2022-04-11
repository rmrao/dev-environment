evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
    git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}
plug "andreyorst/plug.kak" noload
plug 'delapouite/kakoune-livedown' %{
   set-option global livedown_browser 'firefox --new-window'
}

plug "andreyorst/fzf.kak" config %{
    require-module fzf
    map global user -docstring "Search only in the subdirectory of this file" e %{
        :fzf -kak-cmd %{edit -existing} -preview -items-cmd "fd --type f -L . $(dirname %val{bufname})"<ret>
    }
    map global user -docstring "Search hidden + gitignored files as well" a %{
        :fzf -kak-cmd %{edit -existing} -preview -items-cmd "fd --type f -L -H"<ret>
    }
} defer "fzf-file" %{
    set-option global fzf_file_command 'fd -L --type f'
}

plug "ul/kak-tree" do %{
    git submodule update --init --recursive
    cargo install --path . --force --features "rust python html javascript typescript cpp c bash json"
}

plug "andreyorst/powerline.kak" defer powerline_gruvbox %{
    powerline-theme gruvbox
} config %{
    powerline-start
}


plug "andreyorst/smarttab.kak" config %{
    hook global WinSetOption filetype=(makefile|gas) noexpandtab
    hook global WinSetOption filetype=(rust|markdown|kak|c|cpp|python) expandtab
    hook global WinSetOption filetype=(yaml|json) %{ set-option window tabstop 2 }
    hook global WinSetOption filetype=(yaml|json) %{ set-option window softtabstop 2 }
} defer "smarttab" %{
    echo -debug "smarttab"
    set-option global tabstop 4
    set-option global softtabstop 4
}


plug "kak-lsp/kak-lsp" do %{
    cargo build --release --locked
    cargo install --force --path .
} config %{
    define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
    define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
    define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

    define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }
    hook global WinSetOption filetype=(c|cpp|cc|rust|javascript|typescript|python|sh|latex) %{
        set-option window lsp_auto_highlight_references true
        set-option window lsp_hover_anchor false
        lsp-auto-hover-enable
        echo -debug "Enabling LSP for filtetype %opt{filetype}"
        set global lsp_cmd "kak-lsp -s %val{session} -vvvv --log /tmp/kak-lsp.log --config ~/.config/kak-lsp/kak-lsp.toml"
        lsp-enable-window
    }

    hook global KakEnd .* lsp-exit
}

#map global insert <c-n> "<a-;>: insert-c-n<ret>"

plug "h-youhei/kakoune-surround"
declare-user-mode plugin
map global plugin s ':surround<ret>' -docstring 'surround'
map global plugin v ':select-surround<ret>' -docstring 'surround select'
map global plugin c ':change-surround<ret>' -docstring 'surround change'
map global plugin d ':delete-surround<ret>' -docstring 'surround delete'
map global plugin t ':select-surrounding-tag<ret>' -docstring 'surround select tag'

map global plugin j ':tree-select-next-node<ret>' -docstring 'ast next'
map global plugin k ':tree-select-previous-node<ret>' -docstring 'ast prev'
map global plugin h ':tree-select-parent-node<ret>' -docstring 'ast parents'
map global plugin l ':tree-select-first-child<ret>' -docstring 'ast child'
map global plugin L ':tree-select-children<ret>' -docstring 'ast children'
map global normal 'v' ':enter-user-mode plugin<ret>'

map global normal = ':format<ret>'
map global normal * <a-i>w*
map global insert <c-w> '<a-;>:exec -draft hbd<ret>'

map global user f ':fzf-mode<ret>'
                        map global user , ':lsp-hover<ret>'
map global user l ':enter-user-mode lsp<ret>'
map global normal D ':lsp-find-error<ret>l:lsp-hover<ret>'
map global normal \' \;
map global normal <semicolon> :

# Use tabs to navigate buffers
map global normal <tab> ':buffer-next<ret>'
map global normal <s-tab> ':buffer-previous<ret>'
map global normal <c-x> ':delete-buffer<ret>'
# nnoremap <Tab> :bnext<CR>
#nnoremap <S-Tab> :bprevious<CR>
#nnoremap <C-X> :bdelete<CR>

hook global InsertChar j %{ try %{
    exec -draft hH <a-k>jj<ret> d
    exec <esc>
}}

hook global WinCreate .* %{ addhl window/ show-matching }

hook global InsertCompletionShow .* %{
    try %{
        # this command temporarily removes cursors preceded by whitespace;
        # if there are no cursors left, it raises an error, does not
        # continue to execute the mapping commands, and the error is eaten
        # by the `try` command so no warning appears.
        execute-keys -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
    }
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}

hook global WinSetOption filetype=cpp %{ set window formatcmd 'clang-format-7 -assume-filename ${kak_buffile}' }
hook global WinSetOption filetype=rust %{ set window formatcmd 'rustfmt' }
hook global WinSetOption filetype=json %{ set window formatcmd 'jq .' }
hook global WinSetOption filetype=xml %{ set window formatcmd 'xmllint --format -' }
hook global WinSetOption filetype=python %{
    set window formatcmd 'isort --profile=black - | black -'
    # hacky-workaround to get linefeeds into paste buffers
    # Credit to @cole-h
    execute-keys ':set-register p "        __import__(''ipdb'').set_trace()<c-v><ret>"<ret>'
}

add-highlighter global/ number-lines -relative
face global MenuBackground default,black

set global scrolloff 10,10
colorscheme gruvbox-dark
