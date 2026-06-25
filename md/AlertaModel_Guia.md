
# AlertaModel & AlertaController — Guía paso a paso

**Objetivo:** Explicar el módulo de **alertas**: cómo valida entradas, cómo construye consultas dinámicas según las columnas existentes, qué retorna, reglas de negocio, endpoints HTTP, ejemplos cURL, y errores típicos.

---

## 1) Arquitectura y dependencias

**Archivos requeridos**

- `../config/Database.php` — Singleton **MySQLi** (`Database::getInstance()`).
- `../config/ClientEnvironmentInfo.php` — Contexto de **auditoría** (IP/UA/Geo) y utilidades de fecha/hora.
- `../config/TimezoneManager.php` — Ajuste de **zona horaria** por conexión.
- `../helpers/UuidHelper.php` — Generación de **UUID v4**.

**Tabla principal:** `alertas`  
**Otros módulos relacionados:** `periodos_servicio` (FK opcional), `animales` (FK opcional).

**Propósito:** Gestionar **alertas operativas** (p. ej., `REVISION_20_21`, `PROX_PARTO_117`, `PESO_FUERA_RANGO`, `COMPATIBILIDAD_ANIMAL`, `OTRA`) con soporte para **campos opcionales** como `origen_modulo`, `referencia_id`, `severidad` y `prioridad` cuando existan en la base de datos.

---

## 2) Visión general de clases

```php
class AlertaModel {
  private $db;
  private $table = 'alertas';
  private $columnsCache = null;

  // Utilidades
  private function nowWithAudit(): array;
  private function getActorIdFallback(string $fallback): string;
  private function getTableColumns(): array;  // lee INFORMATION_SCHEMA
  private function hasColumn(string $name): bool;
  private function validarTipoAlerta(string $tipo): void;
  private function validarEstadoAlerta(string $estado): void;
  private function validarFechaYMD(?string $ymd, string $campo='fecha'): void;
  private function periodoExiste(?string $periodoId): bool;
  private function animalExiste(?string $animalId): bool;
  private function validarOrigenModulo(?string $mod): void;
  private function validarSeveridad(?string $sev): void;

  // Lecturas
  public function listar(...): array;
  public function obtenerPorId(string $alertaId): ?array;

  // Escrituras
  public function crear(array $in): string;
  public function actualizar(string $alertaId, array $in): bool;
  public function cambiarEstado(string $alertaId, string $nuevoEstado): bool;
  public function eliminar(string $alertaId): bool;
}

class AlertaController {
  public function listar(): void;
  public function mostrar(array $params): void;
  public function crear(): void;
  public function actualizar(array $params): void;
  public function cambiarEstado(array $params): void;
  public function eliminar(array $params): void;
}
```

**Rutas expuestas:**

```php
GET    /alertas
GET    /alertas/{alerta_id}
POST   /alertas
POST   /alertas/{alerta_id}
POST   /alertas/{alerta_id}/estado
DELETE /alertas/{alerta_id}
```

---

## 3) Utilidades y validaciones (modelo)

### 3.1 `nowWithAudit()`
- Crea `ClientEnvironmentInfo` (GeoLite), aplica **contexto de auditoría** (`applyAuditContext`) y **TimezoneManager**.
- **Devuelve:** `[$now, $env]` para timestamps consistentes.

### 3.2 Cache y detección de columnas (`getTableColumns()` / `hasColumn()`)
- Consulta `INFORMATION_SCHEMA.COLUMNS` para **detectar** cuáles columnas existen en `alertas`.
- **Cachea** el resultado en `columnsCache` para evitar múltiples lecturas.
- Permite construir **SELECT/WHERE/INSERT/UPDATE dinámicos** sin romper si faltan columnas (por ejemplo, instancias con o sin `severidad`/`prioridad`).

### 3.3 Validadores de catálogo
- `validarTipoAlerta($tipo)` → admite: `REVISION_20_21`, `PROX_PARTO_117`, `PESO_FUERA_RANGO`, `COMPATIBILIDAD_ANIMAL`, `OTRA`.
- `validarEstadoAlerta($estado)` → admite: `PENDIENTE`, `CUMPLIDA`, `VENCIDA`, `CANCELADA`.
- `validarOrigenModulo($mod)` → admite: `PESO`, `MOVIMIENTO`, `PARTO`, `INCIDENCIA`, `OTRO`. (Solo si existe la columna).
- `validarSeveridad($sev)` → admite: `BAJA`, `MEDIA`, `ALTA`, `CRITICA`. (Solo si existe la columna).

### 3.4 Validadores de integridad y fecha
- `validarFechaYMD($ymd, $campo)` → exige `YYYY-MM-DD` y valida calendario.
- `periodoExiste($periodoId?)` y `animalExiste($animalId?)` → **opcionales**, pero si se envían deben existir (`deleted_at IS NULL`).

### 3.5 `getActorIdFallback($fallback)`
- Obtiene `$_SESSION['user_id']` o usa el **fallback** (normalmente el propio UUID) para `created_by/updated_by/deleted_by`.

---

## 4) Lecturas

### 4.1 `listar(limit, offset, periodoId?, animalId?, tipoAlerta?, estadoAlerta?, desde?, hasta?, incluirEliminados=false, origenModulo?, referenciaId?, severidad?, prioridad?) : array`
**SELECT dinámico** en función de columnas presentes: siempre incluye campos base y agrega `origen_modulo`, `referencia_id`, `severidad`, `prioridad` **solo si existen**.

**Filtros base:**
- `periodo_id`, `animal_id`, `tipo_alerta` (valida catálogo), `estado_alerta` (valida catálogo).
- `desde`/`hasta` (validan `YYYY-MM-DD` sobre `fecha_objetivo`).
- `incluirEliminados` → por defecto solo `a.deleted_at IS NULL`.

**Filtros extra (si existen columnas):**
- `origen_modulo` (valida catálogo), `referencia_id`, `severidad` (valida catálogo), `prioridad` (int).

**Orden:** `fecha_objetivo ASC, created_at DESC`.  
**Salida:** arreglo de filas con los campos efectivos.  
**Errores:** `mysqli_sql_exception` si falla `prepare/execute`.

**Ejemplo de respuesta:**
```json
[
  {
    "alerta_id": "UUID",
    "tipo_alerta": "PESO_FUERA_RANGO",
    "periodo_id": null,
    "animal_id": "UUID-animal",
    "fecha_objetivo": "2025-10-25",
    "estado_alerta": "PENDIENTE",
    "detalle": "Revisar peso del destete",
    "created_at": "2025-10-23 10:02:00",
    "created_by": "user-uuid",
    "updated_at": null,
    "updated_by": null,
    "origen_modulo": "PESO",
    "referencia_id": "UUID-peso",
    "severidad": "ALTA",
    "prioridad": 1
  }
]
```

### 4.2 `obtenerPorId($alertaId) : ?array`
- `SELECT` dinámico igual que en `listar` (agrega columnas extra si existen).  
- Devuelve `null` si no se encuentra.

---

## 5) Escrituras (reglas de negocio)

### 5.1 `crear(array $in) : string`
**Requeridos:**
- `tipo_alerta` (catálogo válido)
- `fecha_objetivo` (`YYYY-MM-DD` válida)

**Opcionales base:**
- `periodo_id?` (si viene, debe existir y estar activo)
- `animal_id?`  (si viene, debe existir y estar activo)
- `estado_alerta?` (default `PENDIENTE` — catálogo válido)
- `detalle?`

**Extras (solo si existen columnas):**
- `origen_modulo?` (catálogo válido), `referencia_id?`, `severidad?` (catálogo válido), `prioridad?` (int)

**Flujo:**
1) Valida requeridos+catálogos y **fecha**.  
2) Verifica FKs opcionales (`periodo_id`, `animal_id`).  
3) Inicia **transacción**; genera `UUID`; obtiene `now` y `actorId`.  
4) Construye **INSERT dinámico** (`cols/vals/params/types`) según columnas existentes.  
5) Ejecuta, `commit()` y **retorna** `alerta_id`.

**Errores:**  
- `InvalidArgumentException` (catálogo/fecha/FKs inválidos).  
- `RuntimeException` (FK inexistente).  
- `mysqli_sql_exception` (SQL/prepare/execute).

**Ejemplo JSON de entrada (con extras):**
```json
{
  "tipo_alerta": "COMPATIBILIDAD_ANIMAL",
  "fecha_objetivo": "2025-10-26",
  "animal_id": "6b4e2e48-94a4-4c0f-9f62-4f3a2b9f8a75",
  "estado_alerta": "PENDIENTE",
  "detalle": "Revisar compatibilidad en traslado",
  "origen_modulo": "MOVIMIENTO",
  "referencia_id": "UUID-movimiento",
  "severidad": "MEDIA",
  "prioridad": 2
}
```

**Respuesta (201):**
```json
{ "value": true, "message": "Alerta creada correctamente.", "data": { "alerta_id": "UUID" } }
```

### 5.2 `actualizar($alertaId, array $in) : bool`
**Precondición:** Alerta existe y **no** está eliminada.  
**Campos editables:** `tipo_alerta?`, `periodo_id?`, `animal_id?`, `fecha_objetivo?`, `estado_alerta?`, `detalle?`  
**Extras (si existen):** `origen_modulo?`, `referencia_id?`, `severidad?`, `prioridad?`  
- Valida catálogos y FKs según aplique.
- Estampa `updated_at/by` con `nowWithAudit()` y `getActorIdFallback()`.

**Errores:** `InvalidArgumentException` (sin campos o catálogos/FKs inválidos), `mysqli_sql_exception` (SQL).

### 5.3 `cambiarEstado($alertaId, $nuevoEstado) : bool`
- Valida catálogo de estado, revisa que la alerta exista y no esté eliminada.
- `UPDATE` solo de `estado_alerta` + `updated_*`.

### 5.4 `eliminar($alertaId) : bool`
- **Soft delete**: setea `deleted_at/by`.  
- Devuelve `true/false` de `execute()`.

---

## 6) Capa HTTP — `AlertaController`

### 6.1 Contratos de entrada/salida
- **Entrada JSON** para `POST /alertas` y `POST /alertas/{id}`.  
- **Salida JSON estándar** `{ value, message, data }` con **status code** adecuado.

### 6.2 Endpoints

#### `GET /alertas?limit=&offset=&periodo_id=&animal_id=&tipo_alerta=&estado_alerta=&desde=&hasta=&incluirEliminados=0|1`
- Llama a `listar()` con filtros básicos. (Los filtros extra pueden añadirse en el controlador si se requiere).  
- Respuestas: `200` OK, `400` validaciones, `500` errores internos.

#### `GET /alertas/{alerta_id}`
- `200` si existe, `404` si no.

#### `POST /alertas`
- Crea alerta.  
- `201` con `{ alerta_id }` o `400`/`409`/`500` según error.

#### `POST /alertas/{alerta_id}`
- Actualiza parcialmente.  
- `200` `{ updated:true }` o `400`/`409`/`500`.

#### `POST /alertas/{alerta_id}/estado`
- Cambia solo el estado.  
- `200` `{ updated:true }` o `400`/`500`.

#### `DELETE /alertas/{alerta_id}`
- Soft delete.  
- `200` `{ deleted:true }`, `400` si ya estaba eliminada, `500` si error.

---

## 7) Ejemplos cURL

**Listar pendientes para un animal:**  
```bash
curl -X GET "https://api.tu-dominio/alertas?animal_id=UUID&estado_alerta=PENDIENTE&limit=50"
```

**Crear con extras (si hay columnas):**  
```bash
curl -X POST "https://api.tu-dominio/alertas" \
  -H "Content-Type: application/json" \
  -d '{ "tipo_alerta":"PESO_FUERA_RANGO", "fecha_objetivo":"2025-10-24", "animal_id":"UUID", "detalle":"Revisar peso", "origen_modulo":"PESO", "referencia_id":"UUID-peso", "severidad":"ALTA", "prioridad":1 }'
```

**Actualizar estado directamente (endpoint específico):**  
```bash
curl -X POST "https://api.tu-dominio/alertas/{alerta_id}/estado" \
  -H "Content-Type: application/json" \
  -d '{ "estado_alerta": "CUMPLIDA" }'
```

**Eliminar (soft):**  
```bash
curl -X DELETE "https://api.tu-dominio/alertas/{alerta_id}"
```

---

## 8) Modelo de datos (resumen)

**Campos base en `alertas`:**
- `alerta_id (PK UUID)`  
- `tipo_alerta` — catálogo interno del sistema  
- `periodo_id (FK periodos_servicio | NULL)`  
- `animal_id (FK animales | NULL)`  
- `fecha_objetivo (DATE)`  
- `estado_alerta` — `PENDIENTE | CUMPLIDA | VENCIDA | CANCELADA`  
- `detalle (TEXT | NULL)`  
- `created_at/by`, `updated_at/by`, `deleted_at/by`

**Campos opcionales (si existen):**
- `origen_modulo` — `PESO | MOVIMIENTO | PARTO | INCIDENCIA | OTRO`
- `referencia_id` — UUID del registro origen (si aplica)
- `severidad` — `BAJA | MEDIA | ALTA | CRITICA`
- `prioridad` — `INT` (p. ej., 1 alta, 3 baja)

**Índices sugeridos:**  
- `animal_id`, `periodo_id`, `fecha_objetivo`, `estado_alerta`, `tipo_alerta` y, de existir, `origen_modulo` y `prioridad`.

---

## 9) Errores y códigos HTTP

- **400 / 422**: validaciones de entrada (catálogos, fechas, FKs).  
- **404**: recurso no encontrado en `mostrar`.  
- **409**: conflictos/negocio (FK inexistente al crear/actualizar).  
- **500**: SQL/prepare/execute u otras excepciones.

---

## 10) Checklist de pruebas rápidas

- [ ] Crear alerta mínima (`tipo_alerta` + `fecha_objetivo`).  
- [ ] Validar catálogos rechazando valores fuera de rango.  
- [ ] `listar` incluye/omite `deleted_at` según `incluirEliminados`.  
- [ ] Crear/actualizar con `origen_modulo`/`severidad`/`prioridad` **solo** si existen las columnas.  
- [ ] Cambiar estado vía `/estado`.  
- [ ] Soft delete y ver que no se liste por defecto.

> Esta guía cubre la lógica completa del módulo de **Alertas**, incluidos los caminos dinámicos que se adaptan a distintos esquemas de base de datos.
