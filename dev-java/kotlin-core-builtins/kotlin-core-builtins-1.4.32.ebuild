# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kotlin-libs

KEYWORDS="~amd64"

# Kotlin compiler needs not be called for this package; only the built-ins
# serializer is invoked

src_compile() {
	local builtins_cherry_picked="${T}/core/builtins/build/src"
	local kotlinc_jar="${KOTLIN_COMPILER_HOME}/lib/kotlin-compiler.jar"

	mkdir -p "${KOTLIN_UTILS_CLASSES}" || \
		die "Failed to create target directory"
	mkdir -p "${builtins_cherry_picked}" || \
		die "Failed to create temporary directory for cherry-picked built-ins"
	cp libraries/stdlib/src/kotlin/reflect/* "${builtins_cherry_picked}" || \
		die "Failed to copy sources for built-ins to temporary directory"
	rm "${builtins_cherry_picked}"/{typeOf.kt,KClasses.kt} || \
		die "Failed to remove extraneous sources from cherry-picked built-ins"
	local src_dirs=(
		"${builtins_cherry_picked}"
		core/builtins/{src,native}
	)

	ebegin "Serializing built-ins"
	# The built-in serializer needs to access XDG_CACHE_HOME, reassign it to
	# avoid access violations caused by 'mkdir /var/lib/portage/home/.cache'
	XDG_CACHE_HOME="${HOME}/.cache" \
	java -classpath "${kotlinc_jar}" \
		org.jetbrains.kotlin.serialization.builtins.RunKt \
		"${KOTLIN_UTILS_CLASSES}" "${src_dirs[@]}" || \
		die "Failed to serialize built-ins"

	kotlin-utils_jar

	# Generate a list of source files for the source archive
	find "${src_dirs[@]}" -name "*.kt" > kotlin_sources.lst
}
