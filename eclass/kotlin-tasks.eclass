# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kotlin-tasks.eclass
# @MAINTAINER:
# Yuan Liao <liaoyuan@gmail.com>
# @AUTHOR:
# Yuan Liao <liaoyuan@gmail.com>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: An eclass for building Kotlin library packages
# @DESCRIPTION:
# This eclass provides an abstraction of the Kotlin compiler to support
# building Kotlin library packages. It is based on java-pkg-simple.eclass and
# recognizes variables declared by that eclass when appropriate.

case ${EAPI:-0} in
	6|7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS pkg_setup src_compile src_test src_install

# Allow use of EAPI 7 version manipulators in older EAPIs for both this eclass
# and consumer ebuilds
[[ ${EAPI:-0} -eq 6 ]] && inherit eapi7-ver

_KOTLIN_TASKS_FEATURE_RELEASE_FROM_PV="$(ver_cut 1-2)"

# @ECLASS-VARIABLE: KOTLIN_TASKS_KOTLINC_MIN_VER
# @PRE_INHERIT
# @DESCRIPTION:
# The minimum version of Kotlin compiler required to build this library.
# Defaults to $(ver_cut 1-2), can be overriden from ebuild BEFORE inheriting
# this eclass.
: ${KOTLIN_TASKS_KOTLINC_MIN_VER:="${_KOTLIN_TASKS_FEATURE_RELEASE_FROM_PV}"}

# @ECLASS-VARIABLE: KOTLIN_TASKS_WANT_TARGET
# @DESCRIPTION:
# The argument to kotlinc's -api-version and -language-version options.
# Defaults to $(ver_cut 1-2), can be overriden from ebuild anywhere. It is the
# ebuild itself's responsibility to make sure the target version is supported
# by the Kotlin compiler version specified by KOTLIN_TASKS_KOTLINC_MIN_VER if
# that variable is overriden.
: ${KOTLIN_TASKS_WANT_TARGET:="${_KOTLIN_TASKS_FEATURE_RELEASE_FROM_PV}"}

# @ECLASS-VARIABLE: KOTLIN_TASKS_MODULE_NAME
# @DESCRIPTION:
# The argument to kotlinc's -module-name option. Defaults to ${PN}, can be
# overriden from ebuild anywhere.
: ${KOTLIN_TASKS_MODULE_NAME:="${PN}"}

# @ECLASS-VARIABLE: KOTLIN_TASKS_COMMON_SOURCES
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing the arguments to kotlinc's -Xcommon-sources option. This
# eclass will concatenate each element in the array into a single string, using
# a comma to separate each pair of adjacent elements, and pass the string as
# the option's value to kotlinc. Default is unset, can be overriden from ebuild
# anywhere.

# @ECLASS-VARIABLE: KOTLIN_TASKS_JAVA_SOURCE_ROOTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing the arguments to kotlinc's -Xjava-source-roots option.
# This eclass will concatenate each element in the array into a single string,
# using a comma to separate each pair of adjacent elements, and pass the string
# as the option's value to kotlinc. Default is unset, can be overriden from
# ebuild anywhere.

# @ECLASS-VARIABLE: KOTLIN_TASKS_KOTLINC_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing any extra arguments to kotlinc that will added after all
# other arguments set by the variables of this eclass and before the list of
# source files. Default is unset, can be overriden from ebuild anywhere.

# @ECLASS-VARIABLE: KOTLIN_TASKS_SOURCES
# @DEFAULT_UNSET
# @DESCRIPTION:
# The list of source files that are used as compiler input, where file names
# are separated by white space. Must be overriden from ebuild somewhere when
# compiling from source.

# @ECLASS-VARIABLE: KOTLIN_TASKS_KOTLINC_JAVA_OPTS
# @DESCRIPTION:
# Any options for the JVM instances started by kotlinc. The default option
# allots enough memory to kotlinc to compile every Kotlin Standard Library
# component, and it can be overriden from ebuild anywhere.
: ${KOTLIN_TASKS_KOTLINC_JAVA_OPTS:="-Xmx768M"}

# @ECLASS-VARIABLE: KOTLIN_TASKS_TESTING_FRAMEWORKS
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Any value that should be added to the JAVA_TESTING_FRAMEWORKS variable of the
# ebuild. Default is unset, can be overriden from ebuild BEFORE inheriting this
# eclass.

# @ECLASS-VARIABLE: KOTLIN_TASKS_BINJAR_SRC_URI
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# The SRC_URI of the binary JAR file to be installed if the 'binary' USE flag
# is enabled. Default is unset, can be overriden from ebuild BEFORE inheriting
# this eclass. Once a value is set, this eclass will add 'binary' and 'test'
# USE flags to it and automatically set 'JAVA_TESTING_FRAMEWORKS+=" pkgdiff"'
# to use the binary JAR for testing.

# @ECLASS-VARIABLE: KOTLIN_TASKS_SRCJAR_SRC_URI
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# The SRC_URI of the source JAR file to be installed if the 'binary' and
# 'source' USE flags are both enabled. Default is unset, can be overriden from
# ebuild BEFORE inheriting this eclass. If KOTLIN_TASKS_BINJAR_SRC_URI is set
# but this variable is unset, this eclass will set
# 'REQUIRED_USE="binary? ( !source )"' for the ebuild.

# @ECLASS-VARIABLE: KOTLIN_TASKS_SRCJAR_FILENAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# The name of the source JAR file to be installed if the 'binary' and 'source'
# USE flags are both enabled. Must be overriden from ebuild somewhere when
# KOTLIN_TASKS_BINJAR_SRC_URI is set.

JAVA_PKG_IUSE="source"
JAVA_TESTING_FRAMEWORKS=""
_KOTLIN_TASKS_REQUIRED_USE=""

if [[ -n "${KOTLIN_TASKS_BINJAR_SRC_URI}" ]]; then
	JAVA_PKG_IUSE+=" binary test"
	JAVA_TESTING_FRAMEWORKS="pkgdiff"
	if [[ -z "${KOTLIN_TASKS_SRCJAR_SRC_URI}" ]]; then
		_KOTLIN_TASKS_REQUIRED_USE="binary? ( !source )"
	fi
fi

if [[ -n "${KOTLIN_TASKS_TESTING_FRAMEWORKS}" ]]; then
	if [[ -z "${JAVA_TESTING_FRAMEWORKS}" ]]; then
		JAVA_TESTING_FRAMEWORKS="${KOTLIN_TASKS_TESTING_FRAMEWORKS}"
	else
		JAVA_TESTING_FRAMEWORKS+=" ${KOTLIN_TASKS_TESTING_FRAMEWORKS}"
	fi
fi

inherit java-pkg-2 java-pkg-simple

: ${DESCRIPTION:="Kotlin library component ${PN}"}
: ${HOMEPAGE:="https://kotlinlang.org"}
: ${LICENSE:="Apache-2.0 BSD MIT NPL-1.1"}
: ${SLOT:="$(ver_cut 1-2)"}

_KOTLIN_TASKS_DEFAULT_SRC_URI="
	https://github.com/JetBrains/kotlin/archive/refs/tags/v${PV}.tar.gz -> kotlin-${PV}.tar.gz
"
if [[ -z "${KOTLIN_TASKS_BINJAR_SRC_URI}" ]]; then
	: ${SRC_URI:="${_KOTLIN_TASKS_DEFAULT_SRC_URI}"}
else
	: ${SRC_URI:=""}
	SRC_URI+="
	!binary? ( ${_KOTLIN_TASKS_DEFAULT_SRC_URI} )
	binary? (
		${KOTLIN_TASKS_BINJAR_SRC_URI}
		source? ( ${KOTLIN_TASKS_SRCJAR_SRC_URI} )
	)
	test? ( ${KOTLIN_TASKS_BINJAR_SRC_URI} )
	"
fi

REQUIRED_USE="
	${_KOTLIN_TASKS_REQUIRED_USE}
	${REQUIRED_USE}
"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

_KOTLIN_TASKS_KOTLINC_DEPEND="
	>=dev-lang/kotlin-bin-${KOTLIN_TASKS_KOTLINC_MIN_VER}:0
"
if has binary ${JAVA_PKG_IUSE}; then
	# Depend on the compiler only when building from source
	DEPEND+=" !binary? ( ${_KOTLIN_TASKS_KOTLINC_DEPEND} )"
else
	# No option to use binary pre-built; always depend on the compiler
	DEPEND+=" ${_KOTLIN_TASKS_KOTLINC_DEPEND}"
fi

# @FUNCTION: kotlin-tasks_pkg_setup
# @DESCRIPTION:
# Sets up the environment according to settings like enabled USE flags that can
# only be checked within a function.
kotlin-tasks_pkg_setup() {
	if ! use binary; then
		S="${WORKDIR}/kotlin-${PV}"
	fi
}

# @FUNCTION: kotlin-tasks_kotlinc
# @USAGE: <kotlinc_arguments>
# @DESCRIPTION:
# Invokes the Kotlin compiler with arguments specified by pertaining variables
# in this eclass, followed by <kotlinc_arguments>, using the source files
# listed in ${KOTLIN_TASKS_SOURCES} as compiler input.
kotlin-tasks_kotlinc() {
	debug-print-function ${FUNCNAME} "$@"

	local compiler_executable
	compiler_executable="kotlinc"

	local OLD_IFS="${IFS}"
	IFS=','
	local common_sources=\
		"${KOTLIN_TASKS_COMMON_SOURCES:+-Xcommon-sources=${KOTLIN_TASKS_COMMON_SOURCES[*]}}"
	local java_source_roots=\
		"${KOTLIN_TASKS_JAVA_SOURCE_ROOTS:+-Xjava-source-roots=${KOTLIN_TASKS_JAVA_SOURCE_ROOTS[*]}}"
	IFS="${OLD_IFS}"

	local compiler_command_args=(
		"${compiler_executable}"
		"${KOTLIN_TASKS_WANT_TARGET:+-api-version ${KOTLIN_TASKS_WANT_TARGET}}"
		"${KOTLIN_TASKS_WANT_TARGET:+-language-version ${KOTLIN_TASKS_WANT_TARGET}}"
		"${KOTLIN_TASKS_MODULE_NAME:+-module-name ${KOTLIN_TASKS_MODULE_NAME}}"
		"${common_sources}"
		"${java_source_roots}"
		"${KOTLIN_TASKS_KOTLINC_ARGS[@]}"
		"$@"
	)
	local compiler_command="${compiler_command_args[@]}"

	if [[ -n ${JAVA_PKG_DEBUG} ]]; then
		einfo "Verbose logging for \"${FUNCNAME}\" function"
		einfo "JAVA_OPTS: ${KOTLIN_TASKS_KOTLINC_JAVA_OPTS}"
		einfo "Compiler arguments:"
		einfo "${compiler_command}"
		einfo "Input source files:"
		einfo "${KOTLIN_TASKS_SOURCES}"
	fi

	ebegin "Compiling"
	JAVA_OPTS="${KOTLIN_TASKS_KOTLINC_JAVA_OPTS}" \
		${compiler_command} ${KOTLIN_TASKS_SOURCES} || \
		die "${FUNCNAME} failed"
}

# @FUNCTION: kotlin-tasks_src_compile
# @DESCRIPTION:
# Compiles the source files in ${KOTLIN_TASKS_SOURCES} using compiler arguments
# specified by other variables of this eclass, with classpath calculated from
# ${JAVA_GENTOO_CLASSPATH}, and packages the resulting classes to a single JAR
# ${JAVA_JAR_FILENAME}. If the file target/META-INF/MANIFEST.MF exists, it will
# be used as the manifest of the created JAR. If the 'binary' USE flag is
# enabled, nothing will be compiled and the binary JAR ${JAVA_BINJAR_FILENAME}
# will be used directly.
kotlin-tasks_src_compile() {
	local target="target"

	java-pkg_gen-cp JAVA_GENTOO_CLASSPATH

	if has binary ${JAVA_PKG_IUSE} && use binary; then
		for dependency in ${JAVA_GENTOO_CLASSPATH//,/ }; do
			java-pkg_record-jar_ ${dependency}
		done

		cp "${DISTDIR}"/${JAVA_BINJAR_FILENAME} ${JAVA_JAR_FILENAME} \
			|| die "Could not copy the binary JAR file to ${S}"
		return 0
	else
		# Fail fast if the package is requested to be built from source, but no
		# source files are specified
		[[ -n "${KOTLIN_TASKS_SOURCES}" ]] \
			|| die "Building from source, but no source files were specified"
	fi

	mkdir -p "${target}" || die "Could not create target directory"

	local classpath=""
	java-pkg-simple_getclasspath
	java-pkg-simple_prepend_resources "${target}" "${JAVA_RESOURCE_DIRS[@]}"

	kotlin-tasks_kotlinc -d "${target}" ${classpath:+-classpath ${classpath}}

	local jar_args
	if [[ -e ${target}/META-INF/MANIFEST.MF ]]; then
		jar_args="cfm ${JAVA_JAR_FILENAME} ${target}/META-INF/MANIFEST.MF"
	elif [[ ${JAVA_MAIN_CLASS} ]]; then
		jar_args="cfe ${JAVA_JAR_FILENAME} ${JAVA_MAIN_CLASS}"
	else
		jar_args="cf ${JAVA_JAR_FILENAME}"
	fi
	jar ${jar_args} -C ${target} . || die "jar failed"
}

# @FUNCTION: kotlin-tasks_src_test
# @DESCRIPTION:
# Runs tests against ${JAVA_JAR_FILENAME} with supported frameworks defined in
# ${JAVA_TESTING_FRAMEWORKS}.
kotlin-tasks_src_test() {
	if ! has test ${JAVA_PKG_IUSE}; then
		return
	elif ! use test; then
		return
	elif [[ ! "${JAVA_TESTING_FRAMEWORKS}" ]]; then
		return
	fi

	local unsupported_frameworks=()
	for framework in ${JAVA_TESTING_FRAMEWORKS}; do
		case ${framework} in
			pkgdiff)
				java-pkg-simple_test_with_pkgdiff_;;
			*)
				unsupported_frameworks+=( ${framework} );;
		esac
	done
	if [[ -n "${unsupported_frameworks[@]}" ]]; then
		einfo "To maintainers of ${CATEGORY}/${PF}:"
		einfo
		einfo "kotlin-tasks does not provide built-in support for running tests"
		einfo "with these frameworks in \${JAVA_TESTING_FRAMEWORKS} yet:"
		einfo
		einfo "	${unsupported_frameworks[@]}"
		einfo
		einfo "If you want to run test cases using these frameworks,"
		einfo "please manually compile and run them in src_test."
	fi
}

# @FUNCTION: kotlin-tasks_dosrc
# @USAGE: <path/to/sources> [...]
# @DESCRIPTION:
# Installs a Zip archive containing the specified sources for a package.
kotlin-tasks_dosrc() {
	debug-print-function ${FUNCNAME} "$@"

	java-pkg_check-phase install

	[[ $# -lt 1 ]] && die "At least one argument needed for ${FUNCNAME}"

	if ! [[ ${DEPEND} = *app-arch/zip* ]]; then
		local msg="${FUNCNAME} called without app-arch/zip in DEPEND"
		java-pkg_announce-qa-violation ${msg}
	fi

	java-pkg_init_paths_

	local zip_name="${PN}-src.zip"
	local zip_path="${T}/${zip_name}"
	local path
	for path in "$@"; do
		local dir_parent=$(dirname "${path}")
		local dir_name=$(basename "${path}")
		pushd ${dir_parent} > /dev/null || die "problem entering ${dir_parent}"
		zip -q -r ${zip_path} ${dir_name}
		local result=$?
		# 12 means zip has nothing to do
		if [[ ${result} != 12 && ${result} != 0 ]]; then
			die "failed to zip ${dir_name}"
		fi
		popd >/dev/null || die
	done

	insinto "${JAVA_PKG_SOURCESPATH}"
	doins ${zip_path}

	if [[ -n ${JAVA_PKG_DEBUG} ]]; then
		einfo "Verbose logging for \"${FUNCNAME}\" function"
		einfo "Zip filename created: ${zip_name}"
		einfo "Zip file destination: ${JAVA_PKG_SOURCESPATH}"
		einfo "Paths zipped: $@"
		einfo "Complete command:"
		einfo "${FUNCNAME} $@"
	fi

	JAVA_SOURCES="${JAVA_PKG_SOURCESPATH}/${zip_name}"
	java-pkg_do_write_
}

# @FUNCTION: kotlin-tasks_src_install
# @DESCRIPTION:
# Installs the JAR specified by ${JAVA_JAR_FILENAME}, and a launcher as well if
# ${JAVA_MAIN_CLASS} is set. If the 'source' USE flag is enabled, a Zip archive
# containing the source will also be installed.
kotlin-tasks_src_install() {
	java-pkg_dojar ${JAVA_JAR_FILENAME}

	if [[ -n "${JAVA_MAIN_CLASS}" ]]; then
		java-pkg_dolauncher "${JAVA_LAUNCHER_FILENAME}" --main ${JAVA_MAIN_CLASS}
	fi

	if has source ${JAVA_PKG_IUSE} && use source; then
		if has binary ${JAVA_PKG_IUSE} && use binary; then
			# Install pre-built source JAR for binary installation
			insinto "${JAVA_PKG_SOURCESPATH}"
			doins "${KOTLIN_TASKS_SRCJAR_FILENAME}"
		else
			kotlin-tasks_dosrc ${KOTLIN_TASKS_SOURCES}
		fi
	fi
}
