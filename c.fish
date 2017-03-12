function c --description "Improved cat"
	# requires getopts:
	# - fisherman getopts
	# and pygmentize
	# - pip install pygmentize

	set use_pager auto
	set show_line_numbers auto
	set close_script no

	getopts $argv | while read -l key option
		switch $key
			case h help
				set_color -o
				echo -n "c"
				set_color normal
				echo " - catfish. Quickly look at code files."
				echo
				echo "c passes FILE through syntax highlighting, and intelligently pipes to a pager"
				echo "if the file is very long; it displays to standard output otherwise."
				echo
				echo "Usage: c [-piln] FILE1 [FILE2...]"
				echo
				echo "Options:"
				set_color -o
				echo -n "    -p, --pager, --less   "
				set_color normal
				echo "Force the usage of less, instead of outputting"
				echo "                           inline, no matter the length of files"

				set_color -o
				echo -n "    -i, --inline          "
				set_color normal
				echo "Force outputting to standard output and don't"
				echo "                           pipe to less, even if the files are long"

				set_color -o
				echo -n "    -l, --line-numbers    "
				set_color normal
				echo "Force showing line numbers"

				set_color -o
				echo -n "    -n, --no-line-numbers "
				set_color normal
				echo "Disable line numbers"

				set_color -o
				echo -n "    -h, --help            "
				set_color normal
				echo "Display this help"


				return 0

			case p pager less
				set use_pager yes
			case i inline
				set use_pager no
			case l line-numbers
				set show_line_numbers yes
			case n no-line-numbers
				set show_line_numbers no
			case _
				set files[(echo (count $files) " + 1" | bc)] $option
			case '*'
				0
		end
	end

	if test (count $files) -eq 0
		echo "No files. Use c --help to get help."
		return 1
	end

	# Automatically attempt to determine if we should use a pager
	# if the length of the file is > 1.5x the height of the terminal
	# then use a pager
	if test (echo $use_pager) = "auto"
		set term_height (echo (tput lines) " * 1.5 / 1" | bc)
		set file_height (grep -c "^" $files[1])
		if test $term_height -le $file_height
			set use_pager yes
		end
	end


	set line_numbers_opt ""
	if test (echo $show_line_numbers) = "yes"
		set line_numbers_opt ",linenos=1"
	end

	for filename in $files
		# Only show the filename is there's > 1 file
		if test (count $files) -gt 1
			tput bold on; tput setab 3; tput setaf 0
			echo $filename
			tput sgr0
			echo
		end

		set cmd 'pygmentize -g -O style=colorful"$line_numbers_opt" "$filename" ^/dev/null; or /bin/cat "$filename"'
		# echo $cmd
		if test (echo $use_pager) = "yes"
			eval $cmd | less -R
		else
			eval $cmd
		end
	end

	# for filename in $files
		# command echo pygmentize -g -O style=colorful,linenos=1 "$filename" "$less" 2> /dev/null; or /bin/cat "$filename" $less
		# command pygmentize -g -O style=colorful,linenos=1 "$filename" "$less" 2> /dev/null; or /bin/cat "$filename" $less
	# end
end
