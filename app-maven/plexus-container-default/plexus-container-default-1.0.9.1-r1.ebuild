# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/plexus-container-default-1.0-alpha-9-stable-1.pom --download-uri https://repo1.maven.org/maven2/org/codehaus/plexus/plexus-container-default/1.0-alpha-9-stable-1/plexus-container-default-1.0-alpha-9-stable-1-sources.jar --slot 0 --keywords "~amd64" --ebuild plexus-container-default-1.0.9.1-r1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test binary"

inherit java-pkg-2 java-pkg-simple java-pkg-maven

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://repo1.maven.org/maven2/org/codehaus/plexus/${PN}/1.0-alpha-9-stable-1/${PN}-1.0-alpha-9-stable-1-sources.jar -> ${P}-sources.jar
	https://repo1.maven.org/maven2/org/codehaus/plexus/${PN}/1.0-alpha-9-stable-1/${PN}-1.0-alpha-9-stable-1.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.codehaus.plexus:plexus-container-default:1.0-alpha-9-stable-1"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${PN}-1.0-alpha-9-stable-1.pom
# classworlds:classworlds:1.1-alpha-2 -> >=app-maven/classworlds-1.1_alpha2:0
# junit:junit:3.8.1 -> >=dev-java/junit-4.12:4
# org.codehaus.plexus:plexus-utils:1.0.4 -> >=app-maven/plexus-utils-1.5.15:0

CDEPEND="
	>=app-maven/classworlds-1.1_alpha2:0
	>=app-maven/plexus-utils-1.5.15:0
	>=dev-java/junit-4.12:4
"


DEPEND="
	>=virtual/jdk-1.8:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="classworlds,junit-4,plexus-utils"
JAVA_SRC_DIR="src/main/java"
JAVA_BINJAR_FILENAME="${P}-bin.jar"

JAVA_TESTING_FRAMEWORK="junit"

