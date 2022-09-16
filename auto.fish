set -e NODE_AUTO_VERSION 2>/dev/null

function chnode_auto --on-variable PWD -d 'Auto switch node version'
    set -l dir (pwd)

    while true
        set -l node_version ''

        test -f "$dir/.node-version" ;and read -l node_version < "$dir/.node-version"
        set node_version (string trim "$node_version")

        test -z "$node_version" -a -f "$dir/.nvmrc" ;and read -l node_version < "$dir/.nvmrc"
        set node_version (string trim "$node_version")

        if test -n "$node_version"
            if test "$node_version" = "$NODE_AUTO_VERSION"
                return 0
            else
                set -gx NODE_AUTO_VERSION "$node_version"
                chnode "$node_version" 2>/dev/null
                set -l result $status
                if test $result -ne 0
                    set -l node_major_version (string split -m 1 -- "." "$node_version")[1]
                    if string match -r -q -- "^\d+" "$node_major_version"
                        chnode "$node_major_version" 2>/dev/null
                        set result $status
                        # test $result -eq 0 ;and echo "chnode: using Node: $NODE_VERSION"
                    end
                end
                return $result
            end
        end

        test -z "$dir" -o "$dir" = "/" ;and break

        set dir (string split -m 1 -r -- / $dir)[1]
    end

    if test -n "$NODE_AUTO_VERSION"
        chnode_reset
        set -e NODE_AUTO_VERSION
    end
end

chnode_auto
