unset NODE_AUTO_VERSION

function chnode_auto() {
    local dir="$PWD/" version dot_version
    local result node_major_version version_parts

    until [[ -z "$dir" ]]; do
        dir="${dir%/*}"

        for dot_version in "$dir/.node-version" "$dir/.nvmrc"; do
            if { read -r version < "$dot_version"; } 2>/dev/null || [[ -n "$version" ]]; then
                version="${version%%[[:space:]]}"

                if [[ "$version" == "$NODE_AUTO_VERSION" ]]; then return
                else
                    NODE_AUTO_VERSION="$version"
                    chnode "$version"
                    result=$?
                    if [[ $result -ne 0 ]]; then
                        version_parts=($(echo $version | tr '.' "\n"))
                        node_major_version=${version_parts[1]}
                        if [[ "$node_major_version" =~ ^[0-9]+ ]]; then
                            chnode "$node_major_version" 2>/dev/null
                            result=$?
                            if [[ $result -eq 0 ]]; then
                                echo "chnode: using Node: $NODE_VERSION"
                            fi
                        fi
                    fi
                    return $result
                fi
            fi
        done
    done

    if [[ -n "$NODE_AUTO_VERSION" ]]; then
        chnode_reset
        unset NODE_AUTO_VERSION
    fi
}

if [[ -n "$ZSH_VERSION" ]]; then
    if [[ ! "$preexec_functions" == *chnode_auto* ]]; then
        preexec_functions+=("chnode_auto")
    fi
elif [[ -n "$BASH_VERSION" ]]; then
    trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chnode_auto' DEBUG
fi
