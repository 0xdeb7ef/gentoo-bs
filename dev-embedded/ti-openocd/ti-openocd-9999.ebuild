# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="	https://github.com/TexasInstruments/ti-openocd.git"
else
	MY_PV="ti-v${PV}"
	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}"/${MY_P}
	KEYWORDS="amd64 ~arm x86"
	SRC_URI="https://github.com/TexasInstruments/${PN}/archive/refs/tags/${MY_PV}.zip"
fi

DESCRIPTION="OpenOCD - Open On-Chip Debugger (Texas Instruments Fork)"
HOMEPAGE="https://github.com/TexasInstruments/ti-openocd"

LICENSE="GPL-2+"
SLOT="0"
IUSE="capstone +cmsis-dap dummy +ftdi gpiod +jlink parport +usb verbose-io"
RESTRICT="strip" # includes non-native binaries

RDEPEND="
	acct-group/plugdev
	>=dev-lang/jimtcl-0.81:=
	gpiod? ( dev-libs/libgpiod:0/2 )
	capstone? ( dev-libs/capstone )
	cmsis-dap? ( dev-libs/hidapi )
	jlink? ( >=dev-embedded/libjaylink-0.2.0 )
	usb? ( virtual/libusb:1 )
	ftdi? ( dev-embedded/libftdi:= )"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	AT_NO_RECURSIVE=yes eautoreconf
}

src_configure() {
	local myconf=(
		--program-prefix=ti-
		--datadir=/usr/share/ti-openocd
		--infodir=/usr/share/info/ti-openocd
		--docdir=/usr/share/doc/ti-openocd
		--enable-amtjtagaccel
		--enable-am335xgpio
		--enable-arm-jtag-ew
		--enable-at91rm9200
		--enable-bcm2835gpio
		--enable-buspirate
		--enable-ep93xx
		--enable-gw16012
		--enable-jtag_dpi
		--enable-sysfsgpio
		--enable-vdebug
		--disable-internal-jimtcl
		--disable-internal-libjaylink
		--disable-parport-giveio
		--disable-werror
		$(use_with capstone)
		$(use_enable cmsis-dap)
		$(use_enable dummy)
		$(use_enable ftdi openjtag)
		$(use_enable ftdi presto)
		$(use_enable ftdi usb-blaster)
		$(use_enable gpiod linuxgpiod)
		$(use_enable jlink)
		$(use_enable parport)
		$(use_enable parport parport_ppdev)
		$(use_enable usb aice)
		$(use_enable usb armjtagew)
		$(use_enable usb ftdi)
		$(use_enable usb osbdm)
		$(use_enable usb opendous)
		$(use_enable usb rlink)
		$(use_enable usb stlink)
		$(use_enable usb ti-icdi)
		$(use_enable usb usbprog)
		$(use_enable usb usb-blaster-2)
		$(use_enable usb ulink)
		$(use_enable usb vsllink)
		$(use_enable verbose-io verbose-jtag-io)
		$(use_enable verbose-io verbose-usb-io)
		$(use_enable verbose-io verbose_usb_comms)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	dostrip /usr/bin
	mv "${ED}"/usr/share/${PN}/openocd/contrib/60-openocd.rules \
	"${ED}"/usr/share/${PN}/openocd/contrib/60-ti-openocd.rules
	udev_dorules "${ED}"/usr/share/${PN}/openocd/contrib/*.rules
}

pkg_postinst() {
	udev_reload

	elog "To access openocd devices as user you must be in the plugdev group"
	elog "Installed as ti-openocd"
}

pkg_postrm() {
	udev_reload
}
