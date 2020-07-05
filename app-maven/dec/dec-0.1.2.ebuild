# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/dec-0.1.2.pom --download-uri https://repo.maven.apache.org/maven2/org/brotli/dec/0.1.2/dec-0.1.2-sources.jar --slot 0 --keywords "~amd64" --ebuild dec-0.1.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Brotli is a generic-purpose lossless compression algorithm."
HOMEPAGE="http://brotli.org/dec"
SRC_URI="https://repo.maven.apache.org/maven2/org/brotli/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.brotli:dec:0.1.2"



DEPEND="
	>=virtual/jdk-1.5:*
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.5:*
"

S="${WORKDIR}"

JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
