#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function aspell_guess_lang () {
  local SELFPATH="$(readlink -m "$BASH_SOURCE"/..)"
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly

  local LANGS=( "$1" ); shift
  local SRCFN="$1"; shift

  readarray -t LANGS < <(<<<"${LANGS[0]//[ ,]/$'\n'}" sort -u)
  case "${LANGS[*]}" in
    *[a-z]* ) ;;
    * )
      echo "E: invalid language list: '${LANGS[*]}'" >&2
      return 2;;
    '' )
      LANGS=( en )
      echo "W: no languages given. will use '${LANGS[*]}'." >&2;;
  esac

  [ -n "$SRCFN" ] || return 3$(
    echo "E: no source file given. use '-' for stdin." >&2)
  local SRCTX="$(LANG=C "$SELFPATH"/aspell-clean-input.sed -- "$SRCFN")"

  local TRY_LANG=
  local WORDS_TOTAL=
  local WORDS_UNKNOWN=
  local WORDS_KNOWN=
  local W_KNOWN_PCT=
  for TRY_LANG in "${LANGS[@]}"; do
    [ -n "$TRY_LANG" ] || continue
    WORDS_TOTAL="$(<<<"$SRCTX" aspell_count_uwords "$TRY_LANG" clean 2> >(
      filter_useless_word_warnings >&2))"
    WORDS_UNKNOWN="$(<<<"$SRCTX" aspell_count_uwords "$TRY_LANG" list)"
    let WORDS_KNOWN="$WORDS_TOTAL - $WORDS_UNKNOWN"
    W_KNOWN_PCT="$(calc_pct "$WORDS_KNOWN/$WORDS_TOTAL")"
    printf '%s\t' "$WORDS_KNOWN" "$WORDS_TOTAL" "$W_KNOWN_PCT%"
    echo "$TRY_LANG"
  done | sort --general-numeric-sort --reverse

  return 0
}


function filter_useless_word_warnings () {
  sed -nre '
    s~\s+$~~
    /^W(arning|): /{
      /" is invalid\. The character .+ may not appear (in the middle|$\
        ) of a word\. Skipping word\.$/{
        / \(U\+(27)\) may not appear /d
      }
    }
    '
}


function aspell_count_uwords () {
  local TXLANG="$1"; shift
  local ASCMD=(
    aspell
    --ignore-case
    --dont-suggest
    --dont-time
    --encoding=UTF-8
    --lang="$TXLANG"
    )
  "${ASCMD[@]}" "$@" | sort --unique | wc --lines
}


function calc_pct () {
  perl -e 'map { printf "%7.3f\n", 100 * eval $_ } @ARGV' -- "$@"
}










[ "$1" == --lib ] && return 0; aspell_guess_lang "$@"; exit $?
