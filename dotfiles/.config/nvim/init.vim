function! SourceConfig(relativePath)
  let root = stdpath('config')
  let fullPath = root . '/' .a:relativePath
  exec 'source ' . fullPath
endfunction

function! SourceDirectory(relativePath)
  for f in split(glob(stdpath('config') . '/' . a:relativePath . '/*.vim'), '\n')
    exe 'source' f
  endfor
endfunction

call SourceConfig('config/plugins.vim')
call SourceConfig('config/keymappings.vim')
call SourceConfig('config/settings.vim')
call SourceDirectory('config/plugins/')
