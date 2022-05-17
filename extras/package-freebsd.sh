#!/bin/sh

SCRIPT=$(readlink -f "$0")
PACKAGE_DIR=$(dirname "$SCRIPT")
DISTDIR=$(readlink -f $PACKAGE_DIR/..)
STAGEDIR=$(readlink -f $PACKAGE_DIR/../../)`mktemp`

echo ${STAGEDIR}

if [ ! -d "${DISTDIR}" ]; then
  echo "${DISTDIR} not exists"
  exit 1
fi

echo "Prepando ambiente"

rm -rf ${STAGEDIR}
mkdir -p ${STAGEDIR}

cat >> ${STAGEDIR}/+POST_INSTALL <<EOF

if [ ! -f /usr/bin/lua ]; then
    ln -s /usr/local/bin/lua51 /usr/bin/lua
fi
EOF

cat >> ${STAGEDIR}/+MANIFEST <<EOF
name: lua51-dbi-pgsql
version: "@VERSION@"
origin: sysutils/lua51-dbi-pgsql
comment: "LUA DBI Driver PostgreSQL Unofficial"
desc: "LUA DBI Driver PostgreSQL Unofficial"
maintainer: support@i9corp.com.br
www: https://github.com/i9corp/lua-dbi
prefix: /
EOF


echo "deps: {" >> ${STAGEDIR}/+MANIFEST
pkg rquery -r i9corp '  %n: { version: "%v", origin: %o }' lua51 >> ${STAGEDIR}/+MANIFEST
pkg rquery -r i9corp '  %n: { version: "%v", origin: %o }' postgresql96-client >> ${STAGEDIR}/+MANIFEST
echo "}" >> ${STAGEDIR}/+MANIFEST

mkdir -p ${STAGEDIR}/usr/local/share/lua/5.1
mkdir -p ${STAGEDIR}/usr/local/lib/lua/5.1

cp -f ${DISTDIR}/dist/lib/libdbdpostgresql.so  ${STAGEDIR}/usr/local/lib/lua/5.1/dbdpostgresql.so
cp -f ${DISTDIR}/dist/bin/DBI.lua  ${STAGEDIR}/usr/local/share/lua/5.1/DBI.lua

cat >> ${STAGEDIR}/plist <<EOF
/usr/local/share/lua/5.1/DBI.lua
/usr/local/lib/lua/5.1/dbdpostgresql.so
EOF

echo "Gerando compactando pacote..."
# tar -cvf ${PACKAGE_DIR}/manute-ui.tar.gz ${STAGEDIR}
pkg create -m ${STAGEDIR}/ -r ${STAGEDIR}/ -p ${STAGEDIR}/plist -o ${PACKAGE_DIR}
echo "Limpando ambiente..."
rm -fr ${STAGEDIR}
echo "Concluido..."