" commentary.vim  
" Author: Zain Shamsi

if exists('g:loaded_commentary')
  finish
endif
let g:loaded_commentary = 1

if !exists('g:commentary_map_keys')
	let g:commentary_map_keys = 1
endif

let s:regex_chars = "/*'\"|["

if g:commentary_map_keys

	" Add mappings and call appropriate function. Please feel free to add to this list!
	" Note that some characters may need to be added to the list of regex_chars above
	" if they need to be escaped in the regular expression

	" // for C/C++/Java 
	noremap  <silent> +/ :call Commentary('+', '//')<CR>
	noremap  <silent> -/ :call Commentary('-', '//')<CR>

	" # for Bash/Perl/Python/Ruby
	noremap  <silent> +# :call Commentary('+', '#')<CR>
	noremap  <silent> -# :call Commentary('-', '#')<CR>

	" ; for ASM/Lisp/Scheme
	noremap  <silent> +; :call Commentary('+', ';')<CR>
	noremap  <silent> -; :call Commentary('-', ';')<CR>

	" % for TeX/Matlab/Erlang
	noremap  <silent> +% :call Commentary('+', '%')<CR>
	noremap  <silent> -% :call Commentary('-', '%')<CR>

	" ' for VBasic 
	noremap  <silent> +' :call Commentary('+', "'")<CR>
	noremap  <silent> -' :call Commentary('-', "'")<CR>

	" REM for BASIC/cmd/batch 
	noremap  <silent> +R :call Commentary('+', 'REM')<CR>
	noremap  <silent> -R :call Commentary('-', 'REM')<CR>

	" -- for Haskell
	noremap  <silent> +- :call Commentary('+', '--')<CR>
	noremap  <silent> -- :call Commentary('-', '--')<CR>

	" ! for Fortran
	noremap  <silent> +! :call Commentary('+', '!')<CR>
	noremap  <silent> -! :call Commentary('-', '!')<CR>

	" " for vimscript 
	noremap  <silent> +" :call Commentary('+', '"')<CR>
	noremap  <silent> -" :call Commentary('-', '"')<CR>

	" /* */ for C/C++/Java/PHP
	noremap  <silent> +* :call BlockCommentary('+', '/*', '*/')<CR>
	noremap  <silent> -* :call BlockCommentary('-', '/*', '*/')<CR>

	" {-  -} for Haskell
	noremap  <silent> +{ :call BlockCommentary('+', '{-', '-}')<CR>
	noremap  <silent> -{ :call BlockCommentary('-', '{-', '-}')<CR>

	" %{ %} for Matlab 
	noremap  <silent> +} :call BlockCommentary('+', '%{', '%}')<CR>
	noremap  <silent> -} :call BlockCommentary('-', '%{', '%}')<CR>

	" (* *) for ML/Maple/Mathematica/Delphi
	noremap  <silent> +( :call BlockCommentary('+', '(*', '*)')<CR>
	noremap  <silent> -( :call BlockCommentary('-', '(*', '*)')<CR>

	" --[[ ]] for Lua 
	noremap  <silent> +[ :call BlockCommentary('+', '--[[', ']]')<CR>
	noremap  <silent> -[ :call BlockCommentary('-', '--[[', ']]')<CR>

endif

function! Commentary(operation, cmarker)
	" escape the comment marker and then use simple regex to add to/remove from beginning of the line
	let cmarker = escape(a:cmarker, s:regex_chars)
	if a:operation == "+"
		execute ":silent! s/^/".cmarker."/" 
	endif
	if a:operation == "-"
		execute ":silent! s/^".cmarker."//" 
	endif
endfunction

function! BlockCommentary(operation, cmarkerstart, cmarkerend) range
	" get the range of the selection, then add to/remove from the line above start and line below end
	let start = a:firstline
	let end = a:lastline + 1
	if a:operation == "+"
		execute ":silent! ".start."put!='".a:cmarkerstart."'"
		execute ":silent! ".end."put='".a:cmarkerend."'"
	endif
	if a:operation == "-"
		let cmarkerstart = escape(a:cmarkerstart, s:regex_chars)
		let cmarkerend = escape(a:cmarkerend, s:regex_chars)
		execute ":silent! ".start-1.",".start."g/^".cmarkerstart."/d"	
		execute ":silent! ".end-1.",".end."g/^".cmarkerend."/d"
	endif
endfunction
