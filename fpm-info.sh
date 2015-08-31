case "$TARGET" in
    debian* | ubuntu*)
        fpm_depends+=('postgresql' 'libpq-dev')
        ;;
esac
