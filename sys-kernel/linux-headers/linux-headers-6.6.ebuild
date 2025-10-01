# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ETYPE="headers"
H_SUPPORTEDARCH="arm64"

inherit kernel-2
detect_version

RM_VER="3.22"
RM_KERNEL="linux-imx-rel-5.2-rm-3.22.0.64-cc26ce6266b2"

DESCRIPTION="Linux kernel headers for reMarkable Paper Pro"
HOMEPAGE="https://github.com/reMarkable/linux-imx-rm"
SRC_URI="https://github.com/reMarkable/linux-imx-rm/raw/refs/heads/rmpp_${PV}.52_v${RM_VER}.x/${RM_KERNEL}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	S="${WORKDIR}/${RM_KERNEL}"
}

src_install() {
	kernel-2_src_install
}
