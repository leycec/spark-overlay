# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/scala-reflect-2.12.10.pom --download-uri https://repo.maven.apache.org/maven2/org/scala-lang/scala-reflect/2.12.10/scala-reflect-2.12.10-sources.jar --slot 0 --keywords "~amd64" --ebuild scala-reflect-2.12.10.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Compiler for the Scala Programming Language"
HOMEPAGE="https://www.scala-lang.org/"
SRC_URI="https://repo.maven.apache.org/maven2/org/scala-lang/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.scala-lang:scala-reflect:2.12.10"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.scala-lang:scala-library:2.12.10 -> >=app-maven/scala-library-2.12.10:0

CDEPEND="
	>=app-maven/scala-library-2.12.10:0
"


DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="scala-library"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
