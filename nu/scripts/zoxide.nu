# Zoxide initialization
# Only regenerate if the cache file doesn't exist or is older than the zoxide binary
let cache_file = "~/.zoxide.nu" | path expand

if not ($cache_file | path exists) or ((which zoxide).path.0 | path exists | if $in { (ls (which zoxide).path.0).modified > (ls $cache_file).modified } else { true }) {
    print "Regenerating zoxide init cache..."
    zoxide init nushell | save -f $cache_file
}