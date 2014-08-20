FROM buildpack-deps

RUN gpg --keyserver pgp.mit.edu --recv-keys 0BD78B5F97500D450838F95DFE857D9A90D90EC1 0B96609E270F565C13292B24C13C70B87267B52D

ENV PHP_VERSION 5.5.15

RUN set -x \
	&& apt-get update && apt-get install -y curl && rm -r /var/lib/apt/lists/* \
	&& curl -SLO http://launchpadlibrarian.net/140087283/libbison-dev_2.7.1.dfsg-1_amd64.deb \
	&& curl -SLO http://launchpadlibrarian.net/140087282/bison_2.7.1.dfsg-1_amd64.deb \
	&& dpkg -i libbison-dev_2.7.1.dfsg-1_amd64.deb \
	&& dpkg -i bison_2.7.1.dfsg-1_amd64.deb \
	&& rm *.deb \
	&& curl -SL "http://us2.php.net/get/php-$PHP_VERSION.tar.bz2/from/this/mirror" -o php.tar.bz2 \
	&& curl -SL "http://us2.php.net/get/php-$PHP_VERSION.tar.bz2.asc/from/this/mirror" -o php.tar.bz2.asc \
	&& gpg --verify php.tar.bz2.asc \
	&& mkdir -p /usr/src/php \
	&& tar -xvf php.tar.bz2 -C /usr/src/php --strip-components=1 \
	&& rm php.tar.bz2* \
	&& cd /usr/src/php \
	&& ./buildconf --force \
	&& ./configure --disable-cgi \
	&& make -j"$(nproc)" \
	&& make install \
	&& apt-get purge -y curl \
	&& apt-get autoremove -y \
	&& rm -r /usr/src/php