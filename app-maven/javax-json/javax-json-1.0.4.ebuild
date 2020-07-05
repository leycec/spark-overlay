# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/javax.json-1.0.4.pom --download-uri https://repo.maven.apache.org/maven2/org/glassfish/javax.json/1.0.4/javax.json-1.0.4-sources.jar --slot 0 --keywords "~amd64" --ebuild javax-json-1.0.4.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Default provider for JSR 353:Java API for Processing JSON"
HOMEPAGE="http://jsonp.java.net"
SRC_URI="https://repo.maven.apache.org/maven2/org/glassfish/javax.json/${PV}/javax.json-${PV}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.glassfish:javax.json:1.0.4"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/javax.json-${PV}.pom
# javax.json:javax.json-api:1.0 -> >=app-maven/javax-json-api-1.0:0

CDEPEND="
	>=app-maven/javax-json-api-1.0:0
"


DEPEND="
	>=virtual/jdk-1.6:*
	${CDEPEND}
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.6:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="javax-json-api"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
