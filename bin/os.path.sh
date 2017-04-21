#!/bin/bash
#
# Some useful path functions. Modelled after Python.
#
# License: MIT Open Source
# Copyright (c) 2016 Joe Linoff
#

# Normalize a path.
# Similar to Python's os.path.normpath()
function os.path.normpath() {
    local Path="$*"
    local Clean=$(sed -e 's@//@/@g' \
                      -e 's@/[^/]*/\.\./@/@' \
                      -e 's@/[^/]*/\.\./@/@' \
                      -e 's@/[^/]*/\.\./@/@' \
                      -e 's@/[^/]*/\.\./@/@' \
                      -e 's@/[^/]*/\.\.$@/@' \
                      -e 's@/[^/]*/\.\.$@/@' \
                      -e 's@^\./@@' \
                      <<< "$Path")
    echo "$Clean"
}

# Absolute path.
# Similar to Python's os.path.abspath()
function os.path.abspath() {
    local Path="$*"
    local AbsPath=$(os.path.normpath "$Path")
    if [[ ! "$AbsPath" =~ ^/ ]] ; then
        AbsPath="$(pwd)/$AbsPath"
    fi
    echo "$AbsPath"
}

# Relative path.
# Similar to Python's os.path.relpath()
function os.path.relpath() {
    local Path="$*"
    local RelPath=$(os.path.normpath "$Path")
    local PwdPath=$(pwd)
    local RelPathLen=${#RelPath}
    local PwdPathLen=${#PwdPath}
    local Done=0
    if (( ${#RelPath} == PwdPathLen )) ; then
        if [[ "$RelPath" == "$PwdPath" ]] ; then
            RelPath="."
            Done=1
        fi
    elif (( ${#RelPath} > PwdPathLen )) ; then
        if [[ "${RelPath:0:$PwdPathLen}" == "$PwdPath" ]] ; then
            RelPath="${RelPath:$PwdPathLen}"
            if [[ "$RelPath" =~ ^/ ]] ; then
                RelPath="${RelPath:1}"
            fi
            Done=1
        fi
    else
        # Check for the case of:
        #   RelPath = /a/b/c
        #   PwdPath = /a/b/c/d/e
        #   Result = ../..
        if [[ "${PwdPath:0:$RelPathLen}" == "$RelPath" ]] ; then
            local TmpPath="${PwdPath:$RelPathLen}"
            NumDirs=$(grep -o '/' <<< "$TmpPath" | wc -l)
            RelPath='..'
            for((i=1; i<NumDirs; i++)) ; do
                RelPath="${RelPath}/.."
            done
            Done=1
        fi
    fi

    # Handle the special case of an absolute path.
    if (( Done == 0 )) && [[ "$RelPath" =~ ^/ ]] ; then
        NumDirs=$(grep -o '/' <<< "$PwdPath" | wc -l)
        local Prefix='..'
        for((i=1; i<NumDirs; i++)) ; do
            Prefix="${Prefix}/.."
        done
        RelPath="${Prefix}${RelPath}"
    fi
    echo "$RelPath"
}

# Test the path functions.
function os.path.test() {
    Patterns=(
        '/a/b/c/d'
        '/a/b/c//d'
        '/a/b//c//d'
        '/a/b/c/..'
        '/a/b/c/../d'
        '/a/b/c/../../d'
        '/a/b/../c/../d'
        'a/b/c/d'
        './a/b/c'
        $(cd $(dirname -- $0) ; pwd)
        $(cd $(dirname -- $(cd $(dirname -- $0) ; pwd)) ; pwd)
        $(cd $(dirname -- $(cd $(dirname -- $(cd $(dirname -- $0) ; pwd)) ; pwd)) ; pwd)
    )
    for Pattern in "${Patterns[@]}" ; do
        printf '%-40s -> ' "$Pattern"

        Clean=$(os.path.normpath "$Pattern")
        printf '%-40s -> ' "$Clean"

        AbsPath=$(os.path.abspath "$Pattern")
        printf '%-40s -> ' "$AbsPath"

        RelPath=$(os.path.relpath "$Pattern")
        printf '%s' "$RelPath"

        printf '\n'
    done
}

if [[ "$(basename $0)" == "$(basename $BASH_SOURCE)" ]] ; then
    os.path.test
fi
