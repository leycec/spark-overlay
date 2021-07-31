#!/usr/bin/env bash

DEFAULT_EMERGE_OPTS="--color y --verbose --keep-going"

main() {
    for script in "$@"; do
        unset DOCKER_IMAGE PROFILE GENTOO_REPO THREADS EMERGE_OPTS PULL
        unset STORAGE_OPTS PORTAGE_CONFIGS CUSTOM_REPOS SKIP_CLEANUP

        . "${script}"

        args=(
            ebuild-cmder
            --docker-image "${DOCKER_IMAGE:-ghcr.io/leo3418/gentoo-stage3-amd64-java}"
            --portage-config tests/portage-configs/default
            --custom-repo .
            --emerge-opts "${EMERGE_OPTS:-"${DEFAULT_EMERGE_OPTS}"}"
            ${PROFILE:+--profile ${PROFILE}}
            ${GENTOO_REPO:+--gentoo-repo ${GENTOO_REPO}}
            ${THREADS:+--threads ${THREADS}}
            ${PULL:+--pull}
            ${STORAGE_OPTS:+--storage-opts ${STORAGE_OPTS}}
            ${SKIP_CLEANUP:+--skip-cleanup ${SKIP_CLEANUP}}
        )
        for config in "${PORTAGE_CONFIGS[@]}"; do
            args+=( --portage-config "${config}" )
        done
        for repo in "${CUSTOM_REPOS[@]}"; do
            args+=( --custom-repo "${repo}" )
        done

        # Pipe the run_test function's body into ebuild-commander
        type run_test | sed '1,3d;$d' | "${args[@]}"
    done
}

if [[ -n "$@" ]]; then
    main "$@"
else
    main tests/test-cases/*
fi
