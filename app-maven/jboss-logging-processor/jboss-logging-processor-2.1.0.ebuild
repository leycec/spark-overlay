# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jboss-logging-processor-2.1.0.Final.pom --download-uri https://repo.maven.apache.org/maven2/org/jboss/logging/jboss-logging-processor/2.1.0.Final/jboss-logging-processor-2.1.0.Final-sources.jar --slot 0 --keywords "~amd64" --ebuild jboss-logging-processor-2.1.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Parent POM for JBoss projects. Provides default project build configuration."
HOMEPAGE="http://www.jboss.org/jboss-logging-tools-parent/jboss-logging-processor"
SRC_URI="https://repo.maven.apache.org/maven2/org/jboss/logging/${PN}/${PV}.Final/${P}.Final-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.jboss.logging:jboss-logging-processor:2.1.0.Final"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.Final.pom
# org.jboss.jdeparser:jdeparser:2.0.2.Final -> >=app-maven/jdeparser-2.0.2:0
# org.jboss.logging:jboss-logging-annotations:2.1.0.Final -> >=app-maven/jboss-logging-annotations-2.1.0:0

CDEPEND="
	>=app-maven/jboss-logging-annotations-2.1.0:0
	>=app-maven/jdeparser-2.0.2:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.Final.pom
# org.jboss.logging:jboss-logging:3.1.2.GA -> >=dev-java/jboss-logging-3.1.4:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	app-arch/unzip
	>=dev-java/jboss-logging-3.1.4:0
"

RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="jdeparser,jboss-logging-annotations"
JAVA_CLASSPATH_EXTRA="jboss-logging"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
