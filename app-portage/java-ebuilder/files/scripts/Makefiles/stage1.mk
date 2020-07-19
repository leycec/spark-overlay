
.PHONY: stage1 clean-stage1

${STAGE2_MAKEFILE}: ${PRE_STAGE1_CACHE} ${SEED_DIR}
	echo > $@
	TARGET_MAKEFILE=$@ SEED_DIR="${SEED_DIR}" HANDMADE_DIR="${HANDMADE_DIR}" CUR_STAGE_DIR="${STAGE1_DIR}" CUR_STAGE=stage1 GENTOO_CACHE="${PRE_STAGE1_CACHE}" CONFIG="${CONFIG}" COMPARE_MVN_VERSION=${COMPARE_MVN_VERSION} TSH="${TSH}" ${TSH_WRAPPER}

stage1: ${STAGE2_MAKEFILE}

clean-stage1:
	rm ${STAGE2_MAKEFILE} ${STAGE1_DIR}/* ${CACHEDIR}/*stage1-* -rf
