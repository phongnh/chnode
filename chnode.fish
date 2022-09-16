set CHNODE_VERSION '0.1.0'

set -ge NODES
test -d "$PREFIX/opt/nodes" ;and set -gx NODES $NODES "$PREFIX"/opt/nodes/*
test -d "$HOME/.nodes" ;and set -gx NODES $NODES "$HOME"/.nodes/*

function chnode_reset -d 'chnode_reset'
    test -z "$NODE_ROOT" ;and return

    set PATH (string match -v "$NODE_ROOT/bin" $PATH)

    set -e NODE_ROOT
    set -e NODEOPT

    type hash >/dev/null 2>&1 ;and hash -r

    return 0
end

function chnode_use -d 'chnode_use'
    echo $argv | read -l node_path opts

    if not test -x "$node_path/bin/node"
        echo "chnode: $node_path/bin/node not executable" >&2
        return 1
    end

    test -n "$NODE_ROOT" ;and chnode_reset

    set -gx NODE_ROOT "$node_path"
    set -gx NODEOPT "$opts"
    set -gx PATH "$NODE_ROOT/bin" $PATH

    set -gx NODE_VERSION ""(eval "$NODE_ROOT/bin/node -v" | cut -c 2-)""

    type hash >/dev/null 2>&1 ;and hash -r

    return 0
end

function chnode -d 'chnode'
    if test (count $argv) -eq 0
        for node_path in $NODES
            if test "$node_path" = "$NODE_ROOT"
                echo -n ' * '
            else
                echo -n '   '
            end
            echo (string split -m 1 -r -- / $node_path)[-1] $NODEOPT
        end
        return 0
    end

    switch $argv[1]
    case '-h' '--help'
        echo 'usage: chnode [NODE|VERSION|system] [NODEOPT...]'
    case '-v' '--version' '-V'
        echo "chnode: $CHNODE_VERSION"
    case 'system'
        chnode_reset
    case '*'
        echo $argv | read -l node_version opts

        set -l match ''

        if test -n "$node_version"
            set -l node
            for dir in $NODES
                set node (string split -m 1 -r -- / $dir)[-1]
                if test "$node_version" = "$node"
                    set match "$dir"
                else if string match -r -q "^$node_version\." "$node"
                    set match "$dir"
                else if string match -r -q "^$node_version" "$node"
                    set match "$dir"
                end
            end
        end

        if test -z "$match"
            echo "chnode: unknown Node: $node_version" >&2
            return 1
        end

        chnode_use "$match" "$opts"
    end
end
