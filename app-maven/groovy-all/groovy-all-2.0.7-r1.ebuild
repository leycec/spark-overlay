# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/groovy-all-2.0.7.pom --download-uri https://repo1.maven.org/maven2/org/codehaus/groovy/groovy-all/2.0.7/groovy-all-2.0.7-sources.jar --slot 0 --keywords "~amd64" --ebuild groovy-all-2.0.7-r1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test binary"

inherit java-pkg-2 java-pkg-simple java-pkg-maven

DESCRIPTION="Groovy: A powerful, dynamic language for the JVM"
HOMEPAGE="http://groovy.codehaus.org/"
SRC_URI="https://repo1.maven.org/maven2/org/codehaus/groovy/${PN}/${PV}/${P}-sources.jar -> ${P}-sources.jar
	https://repo1.maven.org/maven2/org/codehaus/groovy/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.codehaus.groovy:groovy-all:2.0.7"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# bsf:bsf:2.4.0 -> >=dev-java/bsf-2.4.0:2.3
# com.thoughtworks.qdox:qdox:1.12 -> >=dev-java/qdox-1.12.1:1.12
# com.thoughtworks.xstream:xstream:1.4.2 -> >=app-maven/xstream-1.4.2:0
# commons-logging:commons-logging:1.1.1 -> >=dev-java/commons-logging-1.2:0
# jline:jline:1.0 -> >=dev-java/jline-2.12.1:2
# junit:junit:4.10 -> >=dev-java/junit-4.12:4
# org.apache.ant:ant:1.8.4 -> >=dev-java/ant-core-1.10.7:0
# org.apache.ivy:ivy:2.2.0 -> >=dev-java/ant-ivy-2.3.0:2
# org.fusesource.jansi:jansi:1.6 -> >=dev-java/jansi-1.11:1.11

CDEPEND="
	>=app-maven/xstream-1.4.2:0
	>=dev-java/ant-core-1.10.7:0
	>=dev-java/ant-ivy-2.3.0:2
	>=dev-java/bsf-2.4.0:2.3
	>=dev-java/commons-logging-1.2:0
	>=dev-java/jansi-1.11:1.11
	>=dev-java/jline-2.12.1:2
	>=dev-java/junit-4.12:4
	>=dev-java/qdox-1.12.1:1.12
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# javax.servlet:jsp-api:2.0 -> java-virtuals/jsp-api:2.3
# javax.servlet:servlet-api:2.4 -> java-virtuals/servlet-api:4.0

DEPEND="
	>=virtual/jdk-1.8:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	java-virtuals/jsp-api:2.3
	java-virtuals/servlet-api:4.0
	)
"

# Runtime dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.apache.ant:ant-antlr:1.8.4 -> >=dev-java/ant-antlr-1.10.7:0
# org.apache.ant:ant-junit:1.8.4 -> >=dev-java/ant-junit-1.10.7:0
# org.apache.ant:ant-launcher:1.8.4 -> >=app-maven/ant-launcher-1.8.4:0
# org.codehaus.gpars:gpars:1.0.0 -> >=app-maven/gpars-1.0.0:0
# org.testng:testng:6.5.2 -> >=dev-java/testng-6.9.10:0
RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}
	>=app-maven/ant-launcher-1.8.4:0

	>=app-maven/gpars-1.0.0:0

	>=dev-java/ant-antlr-1.10.7:0

	>=dev-java/ant-junit-1.10.7:0

	>=dev-java/testng-6.9.10:0
"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="bsf-2.3,qdox-1.12,xstream,commons-logging,jline-2,junit-4,ant-core,ant-ivy-2,jansi-1.11,ant-antlr,ant-junit,ant-launcher,gpars,testng"
JAVA_CLASSPATH_EXTRA="jsp-2.3,servlet-4.0"
JAVA_SRC_DIR="src/main/java"
JAVA_BINJAR_FILENAME="${P}-bin.jar"

JAVA_TESTING_FRAMEWORK="junit"

