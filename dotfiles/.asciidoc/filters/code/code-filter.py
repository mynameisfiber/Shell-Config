#!/usr/bin/env python
'''
NAME
	code-filter - AsciiDoc filter to highlight language keywords

SYNOPSIS
	code-filter -b backend -l language [ -t tabsize ]
				[ --help | -h ] [ --version | -v ]

DESCRIPTION
	This filter reads source code from the standard input, highlights language
	keywords and comments and writes to the standard output.

	The purpose of this program is to demonstrate how to write an AsciiDoc
	filter -- it's much to simplistic to be passed off as a code syntax
	highlighter. Use the 'source-highlight-filter' instead.


OPTIONS
	--help, -h
		Print this documentation.

	-b
		Backend output file format: 'docbook', 'linuxdoc', 'html', 'css', 'odf'.

	-l
		The name of the source code language: 'python', 'ruby', 'c', 'c++', 'bash', 'ksh'.

	-t tabsize
		Expand source tabs to tabsize spaces.

	--version, -v
		Print program version number.

BUGS
	- Code on the same line as a block comment is treated as comment.
	  Keywords inside literal strings are highlighted.
	- There doesn't appear to be an easy way to accomodate linuxdoc so
	  just pass it through without markup.

AUTHOR
	Written by Stuart Rackham, <srackham@gmail.com>

URLS
	http://sourceforge.net/projects/asciidoc/
	http://www.methods.co.nz/asciidoc/

COPYING
	Copyright (C) 2002-2006 Stuart Rackham. Free use of this software is
	granted under the terms of the GNU General Public License (GPL).
'''

import os, sys, re, string

VERSION = '1.1.2'

# Globals.
language = None
backend = None
tabsize = 8
keywordtags = {
	'html':
		('<strong>','</strong>'),
	'css':
		('<strong>','</strong>'),
	'docbook':
		('<emphasis role="strong">','</emphasis>'),
	'linuxdoc':
		('',''),
	'odf':
		('<text:span text:style-name="strong">','</text:span>'),
}
whitespace = {
	'odf': '<text:s text:c="%d"/>',
}
newline = {
	'odf': ' <text:line-break/>',
}
commenttags = {
	'html':
		('<i>','</i>'),
	'css':
		('<i>','</i>'),
	'docbook':
		('<emphasis>','</emphasis>'),
	'linuxdoc':
		('',''),
	'odf':
		('<text:span text:style-name="emphasis">','</text:span>'),
}
keywords = {
	'python':
		 ('and', 'del', 'for', 'is', 'raise', 'assert', 'elif', 'from',
		 'lambda', 'return', 'break', 'else', 'global', 'not', 'try', 'class',
		 'except', 'if', 'or', 'while', 'continue', 'exec', 'import', 'pass',
		 'yield', 'def', 'finally', 'in', 'print'),
	'ruby':
		('__FILE__', 'and', 'def', 'end', 'in', 'or', 'self', 'unless',
		'__LINE__', 'begin', 'defined?' 'ensure', 'module', 'redo', 'super',
		'until', 'BEGIN', 'break', 'do', 'false', 'next', 'rescue', 'then',
		'when', 'END', 'case', 'else', 'for', 'nil', 'retry', 'true', 'while',
		'alias', 'class', 'elsif', 'if', 'not', 'return', 'undef', 'yield'),
	'c++':
		('asm', 'auto', 'bool', 'break', 'case', 'catch', 'char', 'class',
		'const', 'const_cast', 'continue', 'default', 'delete', 'do', 'double',
		'dynamic_cast', 'else', 'enum', 'explicit', 'export', 'extern',
		'false', 'float', 'for', 'friend', 'goto', 'if', 'inline', 'int',
		'long', 'mutable', 'namespace', 'new', 'operator', 'private',
		'protected', 'public', 'register', 'reinterpret_cast', 'return',
		'short', 'signed', 'sizeof', 'static', 'static_cast', 'struct',
		'switch', 'template', 'this', 'throw', 'true', 'try', 'typedef',
		'typeid', 'typename', 'union', 'unsigned', 'using', 'virtual', 'void',
		'volatile', 'wchar_t', 'while'),
	'bash':
		('alias', 'bg', 'bind', 'break', 'builtin', 'caller', 'case', 'cd',
		'chdir', 'command', 'compgen', 'complete', 'compopt', 'continue',
		'coproc', 'declare', 'dirs', 'disown', 'do', 'done', 'echo', 'elif',
		'else', 'enable', 'esac', 'eval', 'exec', 'exit', 'export', 'fc', 'fg',
		'fi', 'for', 'function', 'getopts', 'hash', 'help', 'history', 'if',
		'in', 'jobs', 'kill', 'let', 'local', 'logout', 'mapfile', 'popd',
		'printf', 'pushd', 'pwd', 'read', 'readarray', 'readonly', 'return',
		'select', 'set', 'shift', 'shopt', 'source', 'suspend', 'test', 'then',
		'time', 'times', 'trap', 'type', 'typeset', 'ulimit', 'umask',
		'unalias', 'unset', 'until', 'wait', 'while', '!', '[[', ']]',
		'(', ')', '((', '))', '{', '}'),
	'ksh':
		('alias', 'bg', 'break', 'builtin', 'case', 'cd', 'command',
		'continue', 'disown', 'do', 'done', 'echo', 'else', 'enum', 'esac',
		'eval', 'exec', 'exit', 'export', 'false', 'fg', 'fi', 'for',
		'function', 'getconf', 'getopts', 'hist', 'if', 'in', 'jobs', 'kill',
		'let', 'newgrp', 'print', 'printf', 'pwd', 'read', 'readonly',
		'return', 'select', 'set', 'shift', 'sleep', 'then', 'time', 'trap',
		'true', 'typeset', 'ulimit', 'umask', 'unalias', 'unset', 'until',
		'wait', 'while', 'whence', '!', '[[', ']]', '(', ')', '((', '))',
		'{', '}'),
}
block_comments = {
	'python': ("'''","'''"),
	'ruby': None,
	'c++': ('/*','*/'),
	'bash': None,
	'ksh': None,
}
inline_comments = {
	'python': '#',
	'ruby': '#',
	'c++': '//',
	'bash': '#',
	'ksh': '#',
}

def print_stderr(line):
	sys.stderr.write(line+os.linesep)

def sub_keyword(mo):
	'''re.subs() argument to tag keywords.'''
	word = mo.group('word')
	if word in keywords[language]:
		stag,etag = keywordtags[backend]
		return stag+word+etag
	else:
		return word

def code_filter():
	'''This function does all the work.'''
	global language, backend
	inline_comment = inline_comments[language]
	blk_comment = block_comments[language]
	if blk_comment:
		blk_comment = (re.escape(block_comments[language][0]),
			re.escape(block_comments[language][1]))
	stag,etag = commenttags[backend]
	in_comment = 0  # True if we're inside a multi-line block comment.
	tag_comment = 0 # True if we should tag the current line as a comment.
	line = sys.stdin.readline()
	line1 = True
	space_regex = re.compile('(  +)')
	while line:
		line = string.rstrip(line)
		line = string.expandtabs(line,tabsize)
		# Escape special characters.
		line = string.replace(line,'&','&amp;')
		line = string.replace(line,'<','&lt;')
		line = string.replace(line,'>','&gt;')
		# Process block comment.
		if blk_comment:
			if in_comment:
				if re.match(r'.*'+blk_comment[1]+r'$',line):
					in_comment = 0
			else:
				if re.match(r'^\s*'+blk_comment[0]+r'.*'+blk_comment[1],line):
					# Single line block comment.
					tag_comment = 1
				elif re.match(r'^\s*'+blk_comment[0],line):
					# Start of multi-line block comment.
					tag_comment = 1
					in_comment = 1
				else:
					tag_comment = 0
		if tag_comment:
			if line: line = stag+line+etag
		else:
			if inline_comment:
				pos = string.find(line,inline_comment)
			else:
				pos = -1
			if pos >= 0:
				# Process inline comment.
				line = re.sub(r'\b(?P<word>\w+)\b',sub_keyword,line[:pos]) \
					+ stag + line[pos:] + etag
			else:
				line = re.sub(r'\b(?P<word>\w+)\b',sub_keyword,line)
		if not line1:
			if backend in whitespace.keys():
				sys.stdout.write(newline[backend])
			else:
				sys.stdout.write(os.linesep)
		line1 = False
		line_split = space_regex.split(line); line_split.append('')
		for text, spaces in zip(*[iter(line_split)]*2):
			sys.stdout.write(text)
			if len(spaces) > 0:
				if backend in whitespace.keys():
					sys.stdout.write(whitespace[backend] % ( len(spaces), ) )
				else:
					sys.stdout.write(spaces)
		line = sys.stdin.readline()

def usage(msg=''):
	if msg:
		print_stderr(msg)
	print_stderr('Usage: code-filter -b backend -l language [ -t tabsize ]')
	print_stderr('				   [ --help | -h ] [ --version | -v ]')

def main():
	global language, backend, tabsize
	# Process command line options.
	import getopt
	opts,args = getopt.getopt(sys.argv[1:],
		'b:l:ht:v',
		['help','version'])
	if len(args) > 0:
		usage()
		sys.exit(1)
	for o,v in opts:
		if o in ('--help','-h'):
			print __doc__
			sys.exit(0)
		if o in ('--version','-v'):
			print('code-filter version %s' % (VERSION,))
			sys.exit(0)
		if o == '-b': backend = v
		if o == '-l':
			v = string.lower(v)
			if v == 'c': v = 'c++'
			language = v
		if o == '-t':
			try:
				tabsize = int(v)
			except:
				usage('illegal tabsize')
				sys.exit(1)
			if tabsize <= 0:
				usage('illegal tabsize')
				sys.exit(1)
	if backend is None:
		usage('backend option is mandatory')
		sys.exit(1)
	if not keywordtags.has_key(backend):
		usage('illegal backend option')
		sys.exit(1)
	if language is None:
		usage('language option is mandatory')
		sys.exit(1)
	if not keywords.has_key(language):
		usage('illegal language option')
		sys.exit(1)
	# Do the work.
	code_filter()

if __name__ == "__main__":
	try:
		main()
	except (KeyboardInterrupt, SystemExit):
		pass
	except:
		print_stderr("%s: unexpected exit status: %s" %
			(os.path.basename(sys.argv[0]), sys.exc_info()[1]))
	# Exit with previous sys.exit() status or zero if no sys.exit().
	sys.exit(sys.exc_info()[1])
