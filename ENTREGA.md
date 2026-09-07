# Entrega - TODO API con Postgres

## Código fuente

El repositorio incluye el código completo de la práctica:

- `server.js`
- `db.js`
- `Dockerfile`
- `docker-compose.yml`
- `db/init.sql`
- `package.json`
- `.env.example`

## Arranque con Docker Compose

Comando ejecutado:

```bash
docker compose up --build -d
```

Resultado: la imagen `02-todo-api-postgres-api` se construyó correctamente y los servicios quedaron activos:

```text
[+] build 1/1
✔ Image 02-todo-api-postgres-api Built
[+] up 3/3
✔ Container todo_api Running
✔ Container todo_db Healthy
```

La API quedó disponible en `http://localhost:3001` y Postgres en `localhost:5432`.

## Evidencia de endpoints

Las pruebas se ejecutaron con `curl` contra `http://localhost:3001`.

| Endpoint | Resultado |
| --- | --- |
| `GET /tasks` | `200`, devuelve la lista de tareas |
| `POST /tasks` | `201`, crea una tarea y devuelve el registro creado |
| `GET /tasks/:id` | `200`, devuelve la tarea creada |
| `PUT /tasks/:id` | `200`, actualiza el estado a `completed` |
| `DELETE /tasks/:id` | `204`, elimina la tarea sin cuerpo |
| `GET /tasks/999999` | `404`, `{ "error": "Task not found" }` |

Ejemplo de salida observada:

```text
--- POST /tasks ---
{"id":3,"title":"Evidencia endpoints","description":"Tarea temporal","status":"pending"}
HTTP 201

--- PUT /tasks/:id ---
{"id":3,"status":"completed"}
HTTP 200

--- DELETE /tasks/:id ---
HTTP 204

--- 404 GET /tasks/:id ---
{"error":"Task not found"}HTTP 404
```

## Evidencias con capturas

Las capturas PNG de la evidencia deben guardarse en la carpeta `capturas/`:

- `capturas/postman-resultados.png`: ejecución de la colección con los endpoints principales.
- `capturas/postman-404.png`: caso de tarea inexistente.
- `capturas/postman-delete-204.png`: eliminación exitosa sin cuerpo.
- `capturas/docker-compose-up.png`: arranque correcto con Docker Compose.

## Informe de persistencia

Se creó la tarea `Prueba persistencia` y luego se ejecutó `docker compose restart api`. Después del reinicio, la tarea continuó apareciendo en `GET /tasks`, junto con las tareas iniciales. Esto demuestra que los datos no viven en la memoria del proceso Node: están almacenados en PostgreSQL, cuyo contenedor no fue reiniciado ni perdió su volumen.

Luego se ejecutó `docker compose down -v`. Esta variante no solo detiene y elimina los contenedores, sino que también borra el volumen `todo_pgdata`, donde PostgreSQL almacenaba la base de datos. Al levantar nuevamente el proyecto, `db/init.sql` se ejecutó sobre una base nueva y solo reaparecieron `Task 1` y `Task 2`. La tarea creada durante la prueba ya no estaba disponible. Por eso los datos sobreviven a un reinicio de la API, pero se pierden cuando se elimina explícitamente el volumen de PostgreSQL.
