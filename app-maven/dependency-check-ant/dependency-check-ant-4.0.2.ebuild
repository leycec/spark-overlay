# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/dependency-check-ant-4.0.2.pom --download-uri https://repo.maven.apache.org/maven2/org/owasp/dependency-check-ant/4.0.2/dependency-check-ant-4.0.2-sources.jar --slot 0 --keywords "~amd64" --ebuild dependency-check-ant-4.0.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="dependency-check-ant is an Ant Task that uses dependency-check-core to detect publicly disclosed vulnerabilities associated with the project's dependencies. The task will generate a report listing the dependency, any identified Common Platform Enumeration (CPE) identifiers, and the associated Common Vulnerability and Exposure (CVE) entries."
HOMEPAGE="https://github.com/jeremylong/DependencyCheck.git/dependency-check-ant"
SRC_URI="https://repo.maven.apache.org/maven2/org/owasp/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.owasp:dependency-check-ant:4.0.2"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.owasp:dependency-check-core:4.0.2 -> >=app-maven/dependency-check-core-4.0.2:0
# org.owasp:dependency-check-utils:4.0.2 -> >=app-maven/dependency-check-utils-4.0.2:0

CDEPEND="
	>=app-maven/dependency-check-core-4.0.2:0
	>=app-maven/dependency-check-utils-4.0.2:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# com.google.code.findbugs:annotations:3.0.1u2 -> >=dev-java/findbugs-annotation-3.0.12:3
# org.apache.ant:ant:1.9.9 -> >=dev-java/ant-core-1.10.7:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	app-arch/unzip
	>=dev-java/ant-core-1.10.7:0
	>=dev-java/findbugs-annotation-3.0.12:3
"

RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="dependency-check-core,dependency-check-utils"
JAVA_CLASSPATH_EXTRA="findbugs-annotation-3,ant-core"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
