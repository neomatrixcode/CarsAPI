# Cars API

Esta es una API RESTful desarrollada con Ruby on Rails para gestionar marcas de coches y sus modelos.

## Tabla de Contenidos
- [Requisitos](#requisitos)
- [Configuración del Entorno](#configuración-del-entorno)
  - [Variables de Entorno](#variables-de-entorno)
  - [Instalación](#instalación)
    - [Nativo](#nativo)
    - [Docker](#docker)
- [Despliegue](#despliege)
- [Documentación API](#documentación-api)
- [Endpoints Principales](#endpoints-principales)
- [Ejemplos de Uso](#ejemplos-de-uso)
- [Paginación](#paginación)
- [Testing](#testing)
- [Linting](#linting-con-rubocop)
- [Arquitectura y Decisiones de Diseño](#arquitectura-y-decisiones-de-diseño)
- [Validaciones](#validaciones)
- [Mejoras Futuras](#mejoras-futuras)

## Requisitos

- Ruby 3.4.2
- Rails 8.0.2
- PostgreSQL
- Docker
- Docker Compose

## Configuración del Entorno

### Variables de Entorno

Asegúrate de configurar las siguientes variables de entorno o ajustar el archivo `config/database.yml`:
```bash
DATABASE_HOST=localhost 
DATABASE_USERNAME=postgres 
DATABASE_PASSWORD=password 
DATABASE_NAME=nexu_backend_test
```

### Instalación

#### Nativo
Clona el repositorio:
```bash
git clone https://github.com/neomatrixcode/CarsAPI.git
cd autos
```
Instala las dependencias:

```bash
bundle install
```

Configura la base de datos:

```bash
bundle exec rails db:create 
bundle exec rails db:schema:load 
bundle exec rails db:seed 
bundle exec rails db:migrate
```

Ejecución
Para iniciar el servidor:

```bash
rails server -b 0.0.0.0 -p 5000
```


#### Docker

```bash
docker-compose up -d
```

### Despliege
La Api se encuentra desplegada en la siguiente url: http://neomatrix.ddns.net:5000/swagger/index.html

### Documentación API
La API está documentada utilizando Swagger. Después de iniciar el servidor, puedes acceder a la documentación en:

http://localhost:5000/swagger

Para regenerar la documentación Swagger después de hacer algun cambio:

```bash
rails rswag:specs:swaggerize
```

### Endpoints Principales
```bash
Brands (Marcas)
GET /brands - Lista todas las marcas (con paginación)
POST /brands - Crea una nueva marca
Models (Modelos)
GET /brands/:id/models - Lista todos los modelos de una marca (con paginación)
POST /brands/:id/models - Crea un nuevo modelo para una marca
PUT /models/:id - Actualiza el precio promedio de un modelo
GET /models - Lista todos los modelos con filtros opcionales (con paginación)
```

### Ejemplos de Uso

#### Listar todas las marcas
```bash
curl -X GET "http://localhost:5000/brands" -H "accept: application/json"
```

Respuesta:
```json
{
  "data": [
    {"id": 1, "nombre": "Acura", "average_price": 702109},
    {"id": 2, "nombre": "Audi", "average_price": 630759},
    {"id": 3, "nombre": "Bentley", "average_price": 3342575},
    {"id": 4, "nombre": "BMW", "average_price": 858702},
    {"id": 5, "nombre": "Buick", "average_price": 290371}
  ],
  "meta": {
    "page": 1,
    "per_page": 5,
    "total_pages": 10,
    "total_count": 50
  }
}
```

#### Crear una nueva marca
```bash
curl -X POST "http://localhost:5000/brands" -H "accept: application/json" -H "Content-Type: application/json" -d '{"name": "Toyota"}'
```

Respuesta:
```json
{
  "id": 51,
  "name": "Toyota",
  "average_price": 0
}
```

#### Listar modelos de una marca
```bash
curl -X GET "http://localhost:5000/brands/1/models" -H "accept: application/json"
```

Respuesta:
```json
{
  "data": [
    {"id": 1, "name": "ILX", "average_price": 303176},
    {"id": 2, "name": "MDX", "average_price": 448193},
    {"id": 1264, "name": "NSX", "average_price": 3818225},
    {"id": 3, "name": "RDX", "average_price": 395753},
    {"id": 354, "name": "RL", "average_price": 239050}
  ],
  "meta": {
    "page": 1,
    "per_page": 5,
    "total_pages": 1,
    "total_count": 5
  }
}
```

#### Añadir un nuevo modelo a una marca
```bash
curl -X POST "http://localhost:5000/brands/51/models" -H "accept: application/json" -H "Content-Type: application/json" -d '{"name": "Prius", "average_price": 406400}'
```

Respuesta:
```json
{
  "id": 3001,
  "name": "Prius",
  "average_price": 406400
}
```

#### Actualizar el precio promedio de un modelo
```bash
curl -X PUT "http://localhost:5000/models/1" -H "accept: application/json" -H "Content-Type: application/json" -d '{"average_price": 310000}'
```

Respuesta:
```json
{
  "id": 1,
  "name": "ILX",
  "average_price": 310000
}
```

#### Filtrar modelos por precio
```bash
curl -X GET "http://localhost:5000/models?greater=380000&lower=400000" -H "accept: application/json"
```

Respuesta:
```json
{
  "data": [
    {"id": 3, "name": "RDX", "average_price": 395753}
  ],
  "meta": {
    "page": 1,
    "per_page": 5,
    "total_pages": 1,
    "total_count": 1
  }
}
```

### Paginación
Todos los endpoints de listado soportan paginación a través de los parámetros page y per_page:

```bash
GET /brands?page=2&per_page=10
```

### Testing
Para ejecutar todas las pruebas:

```bash
bundle exec rspec
```

### Linting con RuboCop

```bash
bundle exec rubocop
```

### Arquitectura y Decisiones de Diseño
- API REST: La aplicación sigue los principios REST para el diseño de APIs.
- Estructura de Datos: Brands (marcas) tienen múltiples Models (modelos).

### Validaciones
- Las marcas tienen nombres únicos.
- Los modelos tienen nombres únicos dentro de cada marca.
- Los precios promedio de los modelos deben ser mayores a 100,000.
- Documentación: Se utiliza Rswag para generar documentación Swagger de la API.
- Paginación: Implementada en todos los endpoints de listado para mejorar el rendimiento con grandes conjuntos de datos.

### Mejoras Futuras
- Implementar autenticación con JWT o OAuth.
- Añadir caché para mejorar el rendimiento.
- Implementar versionado de la API.
- Añadir más filtros y opciones de ordenamiento.
- Implementar rate limiting para evitar abusos.
- Mejorar el manejo de errores con mensajes más descriptivos.
- Mejorar logging con Elasticsearch
- Configurar CI/CD con GitHub Actions
