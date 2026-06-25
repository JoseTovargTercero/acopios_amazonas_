
# IncidenciaModel & IncidenciaController — Guía paso a paso

**Objetivo:** Documentar el módulo de **incidencias** (eventos como RINA/APLASTAMIENTO/HERIDA/MORDIDA/FUGA/OTRA): validaciones, entradas/salidas, reglas, auditoría, endpoints HTTP, errores comunes y ejemplos.

---

## 1) Arquitectura y dependencias

**Archivos requeridos**

- `../config/Database.php` — Singleton **MySQLi** (`Database::getInstance()`).
- `../config/ClientEnvironmentInfo.php` — Contexto de **auditoría** (IP/UA/geo) + utilidades de fecha/hora.
- `../config/TimezoneManager.php` — Ajuste de **zona horaria**.
- `../helpers/UuidHelper.php` — **UUID v4** para claves primarias.

**Tablas clave:**  
- `incidencias` (principal)  
- `animales` (FK obligatoria)  
- `areas` (FK opcional)  

**Propósito:** Registrar, consultar, actualizar y eliminar (soft) **incidencias** asociadas a animales, con filtros por fecha, tipo, área y responsable.

---

## 2) Visión general de clases

```php
class IncidenciaModel {
  private $db;
  private $table = 'incidencias';

  // Utilidades
  private function nowWithAudit(): array;
  private function validarFechaHora(string $value, string $campo='fecha_evento'): string;
  private function normalizarTipo(string $tipo): string;
  private function animalExiste(string $animalId): bool;
  private function areaExiste(?string $areaId): bool;

  // Lecturas
  public function listar(...): array;
  public function obtenerPorId(string $id): ?array;

  // Escrituras
  public function crear(array $data): string;
  public function actualizar(string $id, array $data): bool;
  public function eliminar(string $id): bool;
}

class IncidenciaController {
  public function listar(): void;
  public function mostrar(array $params): void;
  public function crear(): void;
  public function actualizar(array $params): void;
  public function eliminar(array $params): void;
}
```

**Rutas registradas:**

```php
GET    /incidencias
GET    /incidencias/{incidencia_id}
POST   /incidencias
POST   /incidencias/{incidencia_id}
DELETE /incidencias/{incidencia_id}
```

---

## 3) Utilidades y validaciones (modelo)

### 3.1 `nowWithAudit()`
- Inicializa `ClientEnvironmentInfo` (usa GeoLite DB).
- Inyecta **contexto de auditoría** en la sesión (`applyAuditContext`), útil para triggers/bitácoras.
- Aplica **TimezoneManager** a la conexión.
- **Devuelve:** `[$now, $env]` con fecha/hora consistente.

### 3.2 `validarFechaHora($value, $campo='fecha_evento') : string`
- Acepta formatos: `YYYY-MM-DD`, `YYYY-MM-DD HH:MM`, `YYYY-MM-DD HH:MM:SS` (también con separador `T`).
- Normaliza a **`Y-m-d H:i:s`**.
- Valida fecha/hora reales (`checkdate`, rangos de HH:MM:SS).
- **Errores:** `InvalidArgumentException` si el formato o valores no son válidos.

### 3.3 `normalizarTipo($tipo) : string`
- Normaliza el texto a la **enumeración exacta** de la BD:  
  `RINA`, `APLASTAMIENTO`, `HERIDA`, `MORDIDA`, `FUGA`, `OTRA`  
  > Soporta variantes: `RIÑA`→`RINA`, `OTRO/OTRAS`→`OTRA`.
- **Errores:** `InvalidArgumentException` si no pertenece al catálogo.

### 3.4 `animalExiste($animalId)` y `areaExiste($areaId)`
- Verifican FKs activas (`deleted_at IS NULL`).  
- **Errores técnicos:** `mysqli_sql_exception` en `prepare`.  
- En la lógica de negocio, se usan para **informar** inexistencia con `RuntimeException`.

---

## 4) Lecturas

### 4.1 `listar(limit=100, offset=0, incluirEliminados=false, animalId?, tipo?, desde?, hasta?, areaId?, responsable?) : array`
**Filtros admitidos:**
- `animal_id` (exacto)
- `tipo` (normalizado por `normalizarTipo`)
- `desde` / `hasta` (sobre `fecha_evento`, normalizadas/validadas por `validarFechaHora`)
- `area_id` (exacto)
- `responsable` (patrón `LIKE %valor%`)
- `incluirEliminados` → si `false` lista solo activos (`deleted_at IS NULL`)

**Salida:** filas con datos de `incidencias` + joins:
- `animal_identificador` (de `animales`)
- `area_nombre`, `tipo_area`, `numeracion` (de `areas`)

**Orden:** `fecha_evento DESC, created_at DESC`.  
**Errores:** `mysqli_sql_exception` si falla `prepare`/`execute`.

**Ejemplo de respuesta:**
```json
[
  {
    "incidencia_id": "UUID",
    "animal_id": "UUID",
    "animal_identificador": "TAG-202",
    "tipo": "HERIDA",
    "fecha_evento": "2025-10-20 15:30:00",
    "descripcion": "Corte leve",
    "responsable": "Juan P.",
    "area_id": "UUID",
    "area_nombre": "Corral 3",
    "tipo_area": "CORRAL",
    "numeracion": 3,
    "created_at": "2025-10-20 16:00:00",
    "created_by": "user-uuid",
    "updated_at": null,
    "updated_by": null
  }
]
```

### 4.2 `obtenerPorId($id) : ?array`
- Devuelve todos los campos de la incidencia + joins de `animal` y `área`.  
- `null` si no existe.

---

## 5) Escrituras (reglas de negocio)

### 5.1 `crear(array $data) : string`
**Requeridos:**
- `animal_id` (debe existir y no estar eliminado)
- `tipo` (`RINA/APLASTAMIENTO/HERIDA/MORDIDA/FUGA/OTRA` — **se normaliza**)
- `fecha_evento` (`YYYY-MM-DD[ HH:MM[:SS]]` — **se normaliza a** `Y-m-d H:i:s`)

**Opcionales:**
- `descripcion` (texto), `responsable` (texto)
- `area_id` (si viene, **debe** existir)

**Flujo:**
1) Valida requeridos y existencia de FKs.  
2) Normaliza **tipo** y **fecha_evento**.  
3) Inicia **transacción**; genera `UUID`; obtiene `now/actorId` con `nowWithAudit()`.  
4) Inserta registro (`created_at/by`).  
5) `commit()` y **retorna** `incidencia_id`.

**Errores:**  
- `InvalidArgumentException` (faltantes/formato/tipo inválido).  
- `RuntimeException` (animal/área inexistentes).  
- `mysqli_sql_exception` (SQL o FK técnica).

**Ejemplo JSON entrada:**
```json
{
  "animal_id": "e5a7b3f1-7f33-4a1d-8ab7-f9e3b9f0c2a1",
  "tipo": "riña",
  "fecha_evento": "2025-10-23 08:30",
  "descripcion": "Pelea breve en el comedero",
  "responsable": "Operario B",
  "area_id": "b1d7b54a-01b9-4c24-b3d9-0cf3c6322ed4"
}
```

### 5.2 `actualizar($id, array $data) : bool`
**Precondición:** La incidencia existe y **no** está eliminada (`deleted_at IS NULL`).

**Campos editables:**
- `tipo` (normalizado y validado)
- `fecha_evento` (validada y normalizada)
- `descripcion` (texto o `null`)
- `responsable` (texto o `null`)
- `area_id` (si viene, debe existir o ser `null`)

**Auditoría:** establece `updated_at` y `updated_by`.  
**Errores:**  
- `InvalidArgumentException` (sin cambios o formatos inválidos).  
- `RuntimeException` (área inexistente).  
- `mysqli_sql_exception` (SQL/FK).

### 5.3 `eliminar($id) : bool`
- **Soft delete**: marca `deleted_at/by`.  
- Devuelve `true/false` según `UPDATE`.

---

## 6) Capa HTTP — `IncidenciaController`

### 6.1 Contratos de entrada/salida
- **Entrada JSON** en `POST /incidencias` y `POST /incidencias/{id}`.  
- **Salida JSON:** `{ value, message, data }` y **status code** adecuado.

### 6.2 Endpoints

#### `GET /incidencias?animal_id=&tipo=&desde=&hasta=&area_id=&responsable=&incluirEliminados=0|1&limit=&offset=`
- Devuelve listado filtrado/paginado.  
- `400` por parámetros inválidos.  
- `500` por errores del modelo.

#### `GET /incidencias/{incidencia_id}`
- `200` con la incidencia o `404` si no existe.

#### `POST /incidencias`
- Crea una incidencia.  
- `200` con `{ incidencia_id }` o `400`/`409`/`500` según error.

#### `POST /incidencias/{incidencia_id}`
- Actualiza campos editables.  
- `200` con `{ updated:true }` o `400`/`409`/`500`.

#### `DELETE /incidencias/{incidencia_id}`
- Soft delete.  
- `200` con `{ deleted:true }`, `400` si ya estaba eliminada, `500` si hay error.

---

## 7) Ejemplos cURL

**Listar por rango de fechas y tipo:**  
```bash
curl -X GET "https://api.tu-dominio/incidencias?desde=2025-10-01&hasta=2025-10-23&tipo=HERIDA&limit=50&offset=0"
```

**Crear (fecha con HH:MM):**  
```bash
curl -X POST "https://api.tu-dominio/incidencias" \
  -H "Content-Type: application/json" \
  -d '{ "animal_id":"UUID", "tipo":"RINA", "fecha_evento":"2025-10-23 08:30", "descripcion":"Pelea", "responsable":"Operario B", "area_id":"UUID" }'
```

**Actualizar responsable y descripción:**  
```bash
curl -X POST "https://api.tu-dominio/incidencias/{incidencia_id}" \
  -H "Content-Type: application/json" \
  -d '{ "responsable":"Operario C", "descripcion":"Revisión realizada y curación" }'
```

**Eliminar (soft):**  
```bash
curl -X DELETE "https://api.tu-dominio/incidencias/{incidencia_id}"
```

---

## 8) Modelo de datos (resumen)

**`incidencias` (campos principales):**
- `incidencia_id (PK UUID)`  
- `animal_id (FK animales)` — **obligatorio**  
- `tipo (ENUM)` — `RINA | APLASTAMIENTO | HERIDA | MORDIDA | FUGA | OTRA`  
- `fecha_evento (DATETIME)` — guardado **normalizado** a `Y-m-d H:i:s`  
- `descripcion (TEXT | NULL)`  
- `responsable (VARCHAR | NULL)`  
- `area_id (FK areas | NULL)`  
- `created_at/by`, `updated_at/by`, `deleted_at/by`

**Índices sugeridos:**  
- `animal_id`, `fecha_evento`  
- (opcional) índice compuesto (`animal_id`, `fecha_evento`) y por `tipo`.

---

## 9) Errores y códigos HTTP

- **400 / 422**: validaciones de entrada (`InvalidArgumentException`).  
- **404**: recurso no encontrado (`mostrar`).  
- **409**: conflictos de negocio (FK inválida/soft delete).  
- **500**: SQL o excepciones no controladas (`mysqli_sql_exception`, `Throwable`).

---

## 10) Checklist de pruebas rápidas

- [ ] Rechaza `tipo` fuera del catálogo (e.g., `"PELEA"`).  
- [ ] Acepta fecha como `YYYY-MM-DD`, `YYYY-MM-DD HH:MM` y `YYYY-MM-DD HH:MM:SS`; normaliza a `Y-m-d H:i:s`.  
- [ ] Rechaza fechas/horas no válidas (31/02, 25:61, etc.).  
- [ ] `listar` filtra por `responsable` con `LIKE`.  
- [ ] `actualizar` permite `area_id = null` y revalida si se cambia.  
- [ ] `eliminar` marca `deleted_at/by` y ya no aparece por defecto.

> Con esto tienes una guía completa para integrar y mantener el módulo de **Incidencias**: qué valida, qué guarda, cómo se consulta y cómo se expone por HTTP.
