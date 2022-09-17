CHNODE_VERSION="0.3.9"
NODES=()

for dir in "$PREFIX/opt/nodes" "$HOME/.nodes" "$HOME/.nvm/versions/node"; do
    [[ -d "$dir" && -n "$(ls -A "$dir")" ]] && NODES+=("$dir"/*)
    # [[ -d "$dir" && -n "$(ls -A "$dir")" ]] && NODES+=($(ls --sort=version -d "$dir"/*))
done
unset dir

function chnode_reset()
{
    [[ -z "$NODE_ROOT" ]] && return

    PATH=":$PATH:"; PATH="${PATH//:$NODE_ROOT\/bin:/:}"

    PATH="${PATH#:}"; PATH="${PATH%:}"
    unset NODE_ROOT NODEOPT
    hash -r
}

function chnode_use()
{
    if [[ ! -x "$1/bin/node" ]]; then
        echo "chnode: $1/bin/node not executable" >&2
        return 1
    fi

    [[ -n "$NODE_ROOT" ]] && chnode_reset

    export NODE_ROOT="$1"
    export NODEOPT="$2"
    export PATH="$NODE_ROOT/bin:$PATH"

    export NODE_VERSION="$($NODE_ROOT/bin/node -v | cut -c 2-)"

    hash -r
}

function chnode()
{
    case "$1" in
        -h|--help)
            echo "usage: chnode [NODE|VERSION|system] [NODEOPT...]"
            ;;
        -V|--version)
            echo "chnode: $CHNODE_VERSION"
            ;;
        "")
            local dir node
            for dir in "${NODES[@]}"; do
                dir="${dir%%/}"; node="${dir##*/}"
                if [[ "$dir" == "$NODE_ROOT" ]]; then
                    echo " * ${node} ${NODEOPT}"
                else
                    echo "   ${node}"
                fi

            done
            ;;
        system) chnode_reset ;;
        *)
            local dir node match

            if [[ -n "$1" ]]; then
                for dir in "${NODES[@]}"; do
                    dir="${dir%%/}"; node="${dir##*/}"
                    if [[ "$node" = "$1" ]]; then
                        match="$dir"
                    elif [[ "$node" =~ "^$1\." ]]; then
                        match="$dir"
                    elif [[ "$node" =~ "^$1" ]]; then
                        match="$dir"
                    fi
                done
            fi

            if [[ -z "$match" ]]; then
                echo "chnode: unknown Node: $1" >&2
                return 1
            fi

            shift
            chnode_use "$match" "$*"
            ;;
    esac
}
