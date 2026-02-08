# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Mount Nintendo GameCube disc images using FUSE"
HOMEPAGE="https://github.com/multimediamike/gcfuse https://multimedia.cx/gcfuse/"
COMMIT="892e69e0af90f90d472e96000e9014758d821555"
SRC_URI="https://github.com/multimediamike/gcfuse/archive/${COMMIT}.tar.gz
	-> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-fs/fuse:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
