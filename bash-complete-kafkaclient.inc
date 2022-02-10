# bash completion for kafkaclient.
# use this script by sourceing it from your .bashrc, or install it globally in /etc/bash_completion.d/
# completion of -topic is filtered by -env and topic filtering flags

_kafkaclient_complete() {
	COMPREPLY=()

	#echo >>bclog "${COMP_WORDS}"
	#echo >>bclog "${COMP_CWORD}"

	local cur=${COMP_WORDS[COMP_CWORD]}
	case "$cur" in
		-*)
		# complete a flag
		COMPREPLY=( $(compgen -W '-all-errors -c -compact -continue -count -dump-pb -duration -empty-topics -end -env -group -h -health -healthy-age -healthy-isr -healthy-osr -id -idle-topics -info -kafka -kafka-version -key -keys -leaderless-topics -list-assignments -list-brokers -list-ep-ids -list-keys -mac -max-bytes -maxsize -minsize -non-empty-topics -non-idle-topics -offset -one-msg-per-key -org -orgs -partition -pb2j -quiet -raw -regex -rewind -s -seconds -site -sites -start -stats -time -topic -tpo -unique-id -v -version -wc -write' -- "$cur" ) )
		;;

		*)
		# find the -env arg if it exists, along with any topic filtering args
		local env="$MIST_ENV"
		local filters=""
		local match=""
		local topic=""
		local i=0
		while [ $i -lt $((COMP_CWORD-1)) ]; do
			#echo >>bclog "examining COMP_WORDS[$i] = ${COMP_WORDS[i]}"
			case "${COMP_WORDS[i]}" in
				-env)
					env="${COMP_WORDS[$((i+1))]}"
					;;
				-non-empty-topics|-empty-topics|-non-idle-topics|-idle-topics)
					filters="$filters ${COMP_WORDS[i]}"
					match=""
					;;
				-topic)
					topic="${COMP_WORDS[$((i+1))]}"
					;;
			esac
			let i++
		done
		# if no topic filters are defined, match topics which end in -ENV
		[ -n "$filters" -o -z "$env" ] || match="-${env}\$"

		# find the prevous argument to COMP_CWORD, if it exists
		local prev=""
		if [ $COMP_CWORD -gt 1 ]; then
			prev=${COMP_WORDS[$((COMP_CWORD-1))]}
		fi

		#echo >>bclog "env = $env"
		#echo >>bclog "filters = $filters"
		#echo >>bclog "prev = $prev"

		local env_arg=""
		[ -z "$env" ] || env_arg="-env $env"
		case "$prev" in
			"") # suggest they define the -env first
			COMPREPLY=( $(compgen -W '-env' -- "$cur") )
			;;
			-env) # suggest our common envs (does 'dev' exist? I think it is dead)
			COMPREPLY=( $(compgen -W 'staging production testpad eu use1prod2' -- "$cur") )
			;;
			-topic) # suggest a topic
			COMPREPLY=( $(compgen -W "$(kafkaclient $env_arg $filters | grep -- "$match")" -- "$cur") )
			;;
			-write) # suggest a filename
			COMPREPLY=( $(compgen -f -- "$cur") )
			;;
			-key|-mac|-id) # the key isn't always a MAC, but that's the only guess we can make
			COMPREPLY=( $(compgen -W '5c-5b-35-0e-' -- "$cur") )
			compopt -o nospace
			;;
		esac
		;;
	esac
}

complete -F _kafkaclient_complete kafkaclient
