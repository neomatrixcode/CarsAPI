# Usar una imagen base de Debian (bullseye en este ejemplo)
FROM debian:bullseye

# Actualizar el sistema e instalar dependencias necesarias para compilar Ruby
RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  wget \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  libffi-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt1-dev \
  autoconf \
  bison \
  libtool \
  git \
  libpq-dev \
  postgresql-client \
  pkg-config && \
  rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo temporal para la compilación
WORKDIR /tmp

# Descargar, compilar e instalar Ruby 3.4.2
RUN wget https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.2.tar.gz && \
    tar -xzf ruby-3.4.2.tar.gz && \
    cd ruby-3.4.2 && \
    ./configure --disable-install-doc && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf ruby-3.4.2 ruby-3.4.2.tar.gz

# Instalar dependencias del sistema
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    postgresql-client

# Establecer variables de entorno para Ruby y Bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Establecer el directorio de trabajo para la aplicación
WORKDIR /app

COPY ./autos .

# Añadir el script de entrypoint
COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

Run bundle install

# Usar el script de entrypoint
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Comando por defecto (puedes cambiarlo según tus necesidades)
#CMD ["irb"]
#CMD ["rails","server", "-b", "0.0.0.0"]
