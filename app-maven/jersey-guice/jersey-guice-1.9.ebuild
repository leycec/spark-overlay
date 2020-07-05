# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jersey-guice-1.9.pom --download-uri https://repo.maven.apache.org/maven2/com/sun/jersey/contribs/jersey-guice/1.9/jersey-guice-1.9-sources.jar --slot 0 --keywords "~amd64" --ebuild jersey-guice-1.9.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Projects that provide additional functionality to jersey, like integration
        with other projects/frameworks."
HOMEPAGE="https://jersey.java.net/jersey-contribs/jersey-guice/"
SRC_URI="https://repo.maven.apache.org/maven2/com/sun/jersey/contribs/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="com.sun.jersey.contribs:jersey-guice:1.9"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# com.google.inject:guice:3.0 -> >=dev-java/guice-4.1:4
# com.google.inject.extensions:guice-servlet:3.0 -> >=dev-java/guice-4.1:4
# com.sun.jersey:jersey-server:1.9 -> >=app-maven/jersey-server-1.9:0
# javax.inject:javax.inject:1 -> >=dev-java/javax-inject-1:0

CDEPEND="
	>=app-maven/jersey-server-1.9:0
	>=dev-java/guice-4.1:4
	>=dev-java/javax-inject-1:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# javax.servlet:servlet-api:2.5 -> >=java-virtuals/servlet-api-4.0:4.0

DEPEND="
	>=virtual/jdk-1.6:*
	${CDEPEND}
	app-arch/unzip
	>=java-virtuals/servlet-api-4.0:4.0
"

RDEPEND="
	>=virtual/jre-1.6:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="guice-4,guice-4,jersey-server,javax-inject"
JAVA_CLASSPATH_EXTRA="servlet-api-4.0"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
