# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/avro-mapred-1.8.2.pom --download-uri https://repo.maven.apache.org/maven2/org/apache/avro/avro-mapred/1.8.2/avro-mapred-1.8.2-sources.jar --slot 0 --keywords "~amd64" --ebuild avro-mapred-1.8.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An org.apache.hadoop.mapred compatible API for using Avro Serializatin in Hadoop"
HOMEPAGE="http://avro.apache.org/avro-mapred"
SRC_URI="https://repo.maven.apache.org/maven2/org/apache/avro/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.avro:avro-mapred:1.8.2"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# commons-codec:commons-codec:1.9 -> >=dev-java/commons-codec-1.11:0
# org.apache.avro:avro-ipc:1.8.2 -> >=app-maven/avro-ipc-1.8.2:0
# org.codehaus.jackson:jackson-core-asl:1.9.13 -> >=app-maven/jackson-core-asl-1.9.13:0
# org.codehaus.jackson:jackson-mapper-asl:1.9.13 -> >=app-maven/jackson-mapper-asl-1.9.13:0
# org.slf4j:slf4j-api:1.7.7 -> >=dev-java/slf4j-api-1.7.7:0

CDEPEND="
	>=app-maven/avro-ipc-1.8.2:0
	>=app-maven/jackson-core-asl-1.9.13:0
	>=app-maven/jackson-mapper-asl-1.9.13:0
	>=dev-java/commons-codec-1.11:0
	>=dev-java/slf4j-api-1.7.7:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.apache.hadoop:hadoop-client:2.5.1 -> >=app-maven/hadoop-client-2.5.1:0

DEPEND="
	>=virtual/jdk-1.6:*
	${CDEPEND}
	app-arch/unzip
	>=app-maven/hadoop-client-2.5.1:0
"

# Runtime dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.slf4j:slf4j-simple:1.7.7 -> >=dev-java/slf4j-simple-1.7.7:0
RDEPEND="
	>=virtual/jre-1.6:*
${CDEPEND}
	>=dev-java/slf4j-simple-1.7.7:0
"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="commons-codec,avro-ipc,jackson-core-asl,jackson-mapper-asl,slf4j-api,slf4j-simple"
JAVA_CLASSPATH_EXTRA="hadoop-client"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR}
}
