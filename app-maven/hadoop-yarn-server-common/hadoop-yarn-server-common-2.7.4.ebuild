# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/hadoop-yarn-server-common-2.7.4.pom --download-uri https://repo.maven.apache.org/maven2/org/apache/hadoop/hadoop-yarn-server-common/2.7.4/hadoop-yarn-server-common-2.7.4-sources.jar --slot 0 --keywords "~amd64" --ebuild hadoop-yarn-server-common-2.7.4.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Hadoop Project POM"
HOMEPAGE=""
SRC_URI="https://repo.maven.apache.org/maven2/org/apache/hadoop/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.hadoop:hadoop-yarn-server-common:2.7.4"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# com.google.guava:guava:11.0.2 -> >=dev-java/guava-29.0:0
# com.google.protobuf:protobuf-java:2.5.0 -> >=dev-java/protobuf-java-3.11.4:0
# commons-logging:commons-logging:1.1.3 -> >=dev-java/commons-logging-1.2:0
# org.apache.hadoop:hadoop-annotations:2.7.4 -> >=app-maven/hadoop-annotations-2.7.4:0
# org.apache.hadoop:hadoop-yarn-api:2.7.4 -> >=app-maven/hadoop-yarn-api-2.7.4:0
# org.apache.hadoop:hadoop-yarn-common:2.7.4 -> >=app-maven/hadoop-yarn-common-2.7.4:0
# org.apache.zookeeper:zookeeper:3.4.6 -> >=app-maven/zookeeper-3.4.6:0
# org.fusesource.leveldbjni:leveldbjni-all:1.8 -> >=dev-java/leveldbjni-all-1.8:0

CDEPEND="
	>=app-maven/hadoop-annotations-2.7.4:0
	>=app-maven/hadoop-yarn-api-2.7.4:0
	>=app-maven/hadoop-yarn-common-2.7.4:0
	>=app-maven/zookeeper-3.4.6:0
	>=dev-java/commons-logging-1.2:0
	>=dev-java/guava-29.0:0
	>=dev-java/leveldbjni-all-1.8:0
	>=dev-java/protobuf-java-3.11.4:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.apache.hadoop:hadoop-common:2.7.4 -> >=app-maven/hadoop-common-2.7.4:0

DEPEND="
	>=virtual/jdk-1.7:*
	${CDEPEND}
	app-arch/unzip
	>=app-maven/hadoop-common-2.7.4:0
"

RDEPEND="
	>=virtual/jre-1.7:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="guava,protobuf-java,commons-logging,hadoop-annotations,hadoop-yarn-api,hadoop-yarn-common,zookeeper,leveldbjni-all"
JAVA_CLASSPATH_EXTRA="hadoop-common"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
