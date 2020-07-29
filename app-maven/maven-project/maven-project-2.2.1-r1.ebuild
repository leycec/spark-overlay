# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/maven-project-2.2.1.pom --download-uri https://repo1.maven.org/maven2/org/apache/maven/maven-project/2.2.1/maven-project-2.2.1-sources.jar --slot 0 --keywords "~amd64" --ebuild maven-project-2.2.1-r1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test binary"

inherit java-pkg-2 java-pkg-simple java-pkg-maven

DESCRIPTION="This library is used to not only read Maven project object model files, but to assemble inheritence
    and to retrieve remote models as required."
HOMEPAGE="http://maven.apache.org/maven-project"
SRC_URI="https://repo1.maven.org/maven2/org/apache/maven/${PN}/${PV}/${P}-sources.jar -> ${P}-sources.jar
	https://repo1.maven.org/maven2/org/apache/maven/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.maven:maven-project:2.2.1"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.apache.maven:maven-artifact:2.2.1 -> >=app-maven/maven-artifact-2.2.1:0
# org.apache.maven:maven-artifact-manager:2.2.1 -> >=app-maven/maven-artifact-manager-2.2.1:0
# org.apache.maven:maven-model:2.2.1 -> >=app-maven/maven-model-2.2.1:0
# org.apache.maven:maven-plugin-registry:2.2.1 -> >=app-maven/maven-plugin-registry-2.2.1:0
# org.apache.maven:maven-profile:2.2.1 -> >=app-maven/maven-profile-2.2.1:0
# org.apache.maven:maven-settings:2.2.1 -> >=app-maven/maven-settings-2.2.1:0
# org.codehaus.plexus:plexus-container-default:1.0-alpha-9-stable-1 -> >=app-maven/plexus-container-default-1.0.9.1:0
# org.codehaus.plexus:plexus-interpolation:1.11 -> >=app-maven/plexus-interpolation-1.11:0
# org.codehaus.plexus:plexus-utils:1.5.15 -> >=app-maven/plexus-utils-1.5.15:0

CDEPEND="
	>=app-maven/maven-artifact-2.2.1:0
	>=app-maven/maven-artifact-manager-2.2.1:0
	>=app-maven/maven-model-2.2.1:0
	>=app-maven/maven-plugin-registry-2.2.1:0
	>=app-maven/maven-profile-2.2.1:0
	>=app-maven/maven-settings-2.2.1:0
	>=app-maven/plexus-container-default-1.0.9.1:0
	>=app-maven/plexus-interpolation-1.11:0
	>=app-maven/plexus-utils-1.5.15:0
"


DEPEND="
	>=virtual/jdk-1.5:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	)
"

RDEPEND="
	>=virtual/jre-1.5:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="maven-artifact,maven-artifact-manager,maven-model,maven-plugin-registry,maven-profile,maven-settings,plexus-container-default,plexus-interpolation,plexus-utils"
JAVA_SRC_DIR="src/main/java"
JAVA_BINJAR_FILENAME="${P}-bin.jar"

