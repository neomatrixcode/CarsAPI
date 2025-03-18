#!/bin/bash
set -e

# Esperar a que la base de datos esté disponible
echo "Esperando a que la base de datos esté disponible..."
until PGPASSWORD=$DATABASE_PASSWORD psql -h $DATABASE_HOST -U $DATABASE_USERNAME -c '\q' 2>/dev/null; do
  echo "PostgreSQL no está disponible todavía - esperando..."
  sleep 3
done
echo "PostgreSQL está disponible"

# Establecer explícitamente el entorno
export RAILS_ENV=development

# Establecer el entorno de Rails correctamente
echo "Configurando el entorno de Rails..."
bundle exec rails db:environment:set RAILS_ENV=development

# Configurar la base de datos
echo "Configurando la base de datos..."
# Si la base de datos ya existe, ejecutar migrate en lugar de setup
if PGPASSWORD=$DATABASE_PASSWORD psql -h $DATABASE_HOST -U $DATABASE_USERNAME -lqt | cut -d \| -f 1 | grep -qw $DATABASE_NAME; then
  echo "La base de datos ya existe, ejecutando migrations..."
  bundle exec rails db:schema:load db:seed db:migrate
else
  echo "Creando base de datos desde cero..."
  bundle exec rails db:create db:schema:load db:seed
fi

# Eliminar el archivo PID si existe
echo "Eliminando archivo PID si existe..."
rm -f /app/tmp/pids/server.pid

# Iniciar el servidor de Rails
echo "Iniciando el servidor de Rails..."
exec bundle exec rails server -b 0.0.0.0