# Interactive Bash helpers, sourced by ~/.bashrc.

# Remove repeated PATH entries while retaining their first occurrence.
deduplicate_path() {
    local remaining="$PATH"
    local directory new_path= seen=: separator=

    while :; do
        directory=${remaining%%:*}
        case "$seen" in
            *":$directory:"*) ;;
            *)
                new_path+="$separator$directory"
                seen+="$directory:"
                separator=:
                ;;
        esac
        case "$remaining" in
            *:*) remaining=${remaining#*:} ;;
            *) break ;;
        esac
    done
    export PATH="$new_path"
}

