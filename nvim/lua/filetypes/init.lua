-- TODO: Replace these with the neovim callback API for autocommands?
vim.api.nvim_exec([[
au BufRead,BufNewFile Dockerfile set ft=Dockerfile
au BufRead,BufNewFile *.css set ts=2 sw=2 sts=2 filetype=css
au BufRead,BufNewFile *.go set noexpandtab
au BufRead,BufNewFile *.html set ts=2 sw=2 sts=2 filetype=html
au BufRead,BufNewFile *.j2 set ts=2 sw=2 sts=2 expandtab ft=jinja
au BufRead,BufNewFile *.js set ts=2 sw=2 sts=2 filetype=javascriptreact
au BufRead,BufNewFile *.pp set ts=2 sw=2 sts=2 filetype=puppet
au BufRead,BufNewFile *.rb set ts=2 sw=2 sts=2 expandtab
au BufRead,BufNewFile *.thrift set ts=2 sw=2 sts=2 expandtab ft=thrift
au BufRead,BufNewFile *.yaml set ts=2 sw=2 sts=2 expandtab ft=yaml
au BufRead,BufNewFile *.yml set ts=2 sw=2 sts=2 expandtab ft=yaml
au BufRead,BufNewFile BUILD set filetype=bzl
au BufRead,BufNewFile TARGETS set filetype=bzl
au BufRead,BufNewFile */ghostty/config set ft=ghostty
]], true)
