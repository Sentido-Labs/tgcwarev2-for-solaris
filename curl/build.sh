#!/bin/bash
# This is a buildpkg build.sh script
# build.sh helper functions
. ${BUILDPKG_SCRIPTS}/build.sh.functions
#
###########################################################
# Check the following 4 variables before running the script
topdir=curl
version=7.73.0
pkgver=1
source[0]=https://curl.haxx.se/download/$topdir-$version.tar.bz2
# https://curl.haxx.se/docs/caextract.html
certdate=2020-10-14
source[1]=https://curl.haxx.se/ca/cacert-$certdate.pem
# If there are no patches, simply comment this
patch[0]=curl-7.73.0-no-ipv6.patch

# Source function library
. ${BUILDPKG_SCRIPTS}/buildpkg.functions

# Global settings
export CPPFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -R$prefix/lib"
export PKG_CONFIG=pkgconf

configure_args+=(--enable-static=no --enable-http --enable-ftp --enable-file --disable-ldap --enable-manual --enable-cookies --enable-crypto --with-libidn2 --with-libssh2 --with-nghttp2 --with-ca-bundle=${prefix}/${_sysconfdir}/curl-ca-bundle.pem)

reg prep
prep()
{
    generic_prep
    setdir source
    # There are weak pthread_* symbols in libc but curl actually needs the real
    # thing so we reverse the test that would normally make configure skip
    # looking for the pthread symbols in libpthread.
    ${__gsed} -i '/USE_THREADS_POSIX/ s/\!= "1"/\= "1"/' configure
    # Ensure testsuite can find sshd
    sed -i 's#/usr/freeware#/usr/tgcware#' tests/sshhelp.pm
}

reg build
build()
{
    generic_build
}

reg check
check()
{
    generic_check
}

reg install
install()
{
    generic_install DESTDIR
    ${__install} -m0644 -D $(get_source_absfilename "${source[1]}") ${stagedir}${prefix}/${_sysconfdir}/curl-ca-bundle.pem
    doc CHANGES COPYING README* RELEASE-NOTES docs/FAQ docs/FEATURES docs/BUGS \
      docs/RESOURCES docs/TODO docs/TheArtOfHttpScripting \
      docs/examples/*.c docs/examples/Makefile.example

    compat curl 7.29.0 1 1
    compat curl 7.30.0 1 1
    compat curl 7.33.0 1 1
    compat curl 7.35.0 1 1
    compat curl 7.36.0 1 1
    compat curl 7.38.0 1 1
    compat curl 7.41.0 1 1
    compat curl 7.42.0 1 1
    compat curl 7.42.1 1 1
    compat curl 7.44.1 1 1
    compat curl 7.46.0 1 1
    compat curl 7.47.1 1 2
    compat curl 7.48.0 1 1
    compat curl 7.49.0 1 1
    compat curl 7.49.1 1 1
    compat curl 7.50.0 1 1
    compat curl 7.50.3 1 1
    compat curl 7.51.0 1 1
    compat curl 7.52.1 1 1
    compat curl 7.55.1 1 1
    compat curl 7.59.0 1 1
    compat curl 7.61.1 1 1
    compat curl 7.64.0 1 1
    compat curl 7.64.1 1 1
    compat curl 7.69.1 1 1
}

reg pack
pack()
{
    generic_pack
}

reg distclean
distclean()
{
    clean distclean
}

###################################################
# No need to look below here
###################################################
build_sh $*
