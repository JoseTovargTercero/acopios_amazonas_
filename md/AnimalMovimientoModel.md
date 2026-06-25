
# AnimalMovimientoModel (PHP) — Guía paso a paso

**Contexto:** Este documento explica, de forma práctica, qué hace el modelo `AnimalMovimientoModel` y los endpoints asociados a `animal_movimientos` dentro de un backend PHP (MySQL/MariaDB). Incluye **qué recibe**, **qué devuelve**, validaciones, reglas de negocio, errores comunes y **ejemplos de uso**.

---

## 1) Dependencias y propósito general

**Ficheros requeridos por el modelo**

- `../config/Database.php`: Singleton de conexión MySQLi (`Database::getInstance()`).
- `../config/ClientEnvironmentInfo.php`: Recolecta info del cliente (IP, agente, etc.) y la **inyecta como contexto de auditoría**.
- `../config/TimezoneManager.php`: Ajusta la **zona horaria** de la sesión de base de datos/entorno.
- `../helpers/UuidHelper.php`: Genera **UUID v4** para claves primarias.

**Tabla principal:** `animal_movimientos`  
**Propósito:** Registrar eventos de movimiento de animales (ingreso, egreso, traslado, venta, compra, nacimiento, muerte u otros) y exponer CRUD + listados filtrados.

---

## 2) Estructura general de la clase

```php
class AnimalMovimientoModel
{
    private $db;                     // Conexión MySQLi
    private $table = 'animal_movimientos';

    public function __construct()    // Inicia singleton DB
    private function nowWithAudit()  // Aplica contexto y tz; retorna [fecha_actual, env]
    private function validarFecha()
    private function validarEnum()
    private function animalExiste()
    private function fincaExiste()    // idem para aprisco/área/recinto
    private function validarJerarquia()
    private function validarCompatibilidadTraslado()

    // Lecturas
    public function listar(...): array
    public function obtenerPorId(string $id): ?array

    // Escrituras
    private function validarReglasTipo(...): void
    public function crear(array $data): string
    public function actualizar(string $id, array $data): bool
    public function eliminar(string $id): bool
}
```

---

## 3) Utilidades y validaciones internas

### 3.1 `nowWithAudit()`
- Crea `ClientEnvironmentInfo` usando una base GeoLite (`geolite.mmdb`).
- Llama `applyAuditContext($this->db, 0)` para **guardar en la sesión** info del cliente (útil en triggers/bitácoras).
- Ajusta zona horaria vía `TimezoneManager` (`applyTimezone()`).
- **Devuelve:** `[$fechaActual, $env]`, donde `$fechaActual` es un `YYYY-MM-DD HH:MM:SS` consistente con la TZ aplicada.

### 3.2 `validarFecha($ymd, $campo='fecha')`
- Exige formato `YYYY-MM-DD` y valida calendario con `checkdate`.  
- **Error:** `InvalidArgumentException` si el formato o la fecha son inválidos.

### 3.3 `validarEnum($valor, $permitidos, $campo)`
- Normaliza a `UPPER(trim(valor))` y comprueba pertenencia a una **lista blanca**.
- **Error:** `InvalidArgumentException` si no coincide.

### 3.4 Validaciones de existencia
- `animalExiste($animalId)` → busca en `animales` con `deleted_at IS NULL`.
- `fincaExiste/apriscoExiste/areaExiste/recintoExiste` → verifican FKs activas.
- **Errores:** `mysqli_sql_exception` si falla `prepare`, o `RuntimeException` de negocio cuando no existe.

### 3.5 `validarJerarquia($fincaId, $apriscoId, $areaId, $recintoId)`
- Comprueba **consistencia jerárquica**: `recinto` → `area` → `aprisco` → `finca`.
- Si se provee un nivel inferior (ej. `recinto_id`), verifica que **pertenezca** a los padres indicados.
- **Errores de negocio:** `InvalidArgumentException` con mensajes del tipo *"El recinto no pertenece al área indicada."*

### 3.6 `validarCompatibilidadTraslado(...)`
- Invoca **SP** `sp_validar_compatibilidad_transferencia(animal, destino, fecha, mov_id, actor_id)`.  
- Diseño esperado del SP: si detecta **riesgo de convivencia**, **registra una alerta** (por ejemplo `COMPATIBILIDAD_RIESGO`) referenciando el movimiento.  
- **Nota:** Si tu BD usa otro nombre o firma del SP, **ajústalo aquí**.

---

## 4) Lecturas

### 4.1 `listar(...) : array`

**Filtros admitidos (todos opcionales):**
- `animalId`, `tipo_movimiento`, `motivo`, `estado`, `desde`, `hasta`  
- Origen/destino: `finca/aprisco/area/recinto` (cada uno por separado)  
- `incluirEliminados` (por defecto **false**, lista solo activos)

**Paginación:** `limit`, `offset` (obligatorios internamente en el `LIMIT ? OFFSET ?`).

**Salida:** array de filas con **joins amistosos** (identificador del animal, nombre de finca/aprisco/área, códigos de recinto, etc.).  
**Orden:** `fecha_mov DESC, created_at DESC`.

**Errores:** `mysqli_sql_exception` si falla `prepare`/`execute`.

**Ejemplo (pseudo-JSON):**
```json
[
  {
    "animal_movimiento_id": "...",
    "animal_id": "...",
    "animal_identificador": "TAG-123",
    "fecha_mov": "2025-10-05",
    "tipo_movimiento": "TRASLADO",
    "motivo": "TRASLADO",
    "estado": "REGISTRADO",
    "finca_origen": "Finca A",
    "finca_destino": "Finca B",
    "codigo_recinto_origen": "R-01",
    "codigo_recinto_destino": "R-02",
    "observaciones": "Obs...",
    "created_at": "2025-10-05 12:00:00",
    "updated_at": null
  }
]
```

### 4.2 `obtenerPorId($id) : ?array`
- Devuelve **todos los campos** del movimiento + `animal_identificador` y códigos de recintos (origen/destino).
- `null` si no existe.

---

## 5) Escrituras (reglas de negocio + validaciones)

### 5.1 Reglas por **tipo_movimiento**
- **INGRESO / COMPRA / NACIMIENTO** → **requiere DESTINO** (al menos uno de: finca/aprisco/area/recinto).
- **EGRESO / VENTA / MUERTE** → **requiere ORIGEN**.
- **TRASLADO** → **requiere ORIGEN y DESTINO**.

Si no se cumple, lanza `InvalidArgumentException`.

### 5.2 `crear(array $data) : string`

**Campos requeridos:** `animal_id`, `fecha_mov` (YYYY-MM-DD), `tipo_movimiento`  
**Opcionales:** `motivo` (default `OTRO`), `estado` (default `REGISTRADO`), FKs de origen/destino, `costo` (nullable), `documento_ref` (nullable), `observaciones` (nullable).

**Flujo:**  
1) Valida requeridos y existencia del **animal**.  
2) Valida `fecha_mov`, **enums**, existencia de FKs y **jerarquía** origen/destino.  
3) Aplica **reglas por tipo** (5.1).  
4) Normaliza `costo` a `string|null` para **permitir NULL en bind**.  
5) Inicia **transacción**; genera `UUID` para `animal_movimiento_id`; obtiene `[now, actor]` desde `nowWithAudit()` y `$_SESSION['user_id']`.  
6) Inserta registro (19 placeholders); si hay error `foreign key` → lanza `RuntimeException` semántica.  
7) Si `tipo = TRASLADO` **y hay destino** → llama `validarCompatibilidadTraslado(...)` (posible **alerta**).  
8) Hace `commit()` y devuelve el **UUID** creado.

**Errores a contemplar:**
- `InvalidArgumentException` por formato/enum/reglas no cumplidas.
- `RuntimeException` por inexistencia de FKs o `foreign key` semántica.
- `mysqli_sql_exception` por errores de SQL/prepare/execute.

**Ejemplo JSON de entrada (TRASLADO):**
```json
{
  "animal_id": "9e9394fe-00ac-47ef-a3b7-e97bd3ac0c63",
  "fecha_mov": "2025-10-06",
  "tipo_movimiento": "TRASLADO",
  "motivo": "TRASLADO",
  "finca_origen_id": "06fcbfc8-ffc7-4956-b99d-77d879d772b7",
  "aprisco_origen_id": "78059699-0f15-419e-89a8-fcc2697c4c97",
  "area_origen_id": "9927c9e7-d35a-4b1c-93b0-c078894cc9ef",
  "finca_destino_id": "06fcbfc8-ffc7-4956-b99d-77d879d772b7",
  "aprisco_destino_id": "78059699-0f15-419e-89a8-fcc2697c4c97",
  "area_destino_id": "9927c9e7-d35a-4b1c-93b0-c078894cc9ef",
  "costo": 0,
  "documento_ref": "ORD-123",
  "observaciones": "Movimiento interno"
}
```

**Respuesta:** `200 OK` con el **UUID** del movimiento recién creado, o error con mensaje.

### 5.3 `actualizar($id, array $data) : bool`

**Precondición:** El movimiento **existe** y **no** está eliminado (`deleted_at IS NULL`).

**Admite cambios en:** `fecha_mov`, `tipo_movimiento`, `motivo`, `estado`, **cualquier FK** de origen/destino, `costo`, `documento_ref`, `observaciones`.

**Validaciones clave cuando cambian FKs o tipo/fecha:**
- Revalida **existencia** de FKs.
- Revalida **jerarquía**.
- Revalida **reglas por tipo**.
- Si cambia destino/tipo/fecha → **reinvoca** `validarCompatibilidadTraslado(...)` (solo si termina siendo `TRASLADO` con destino).

**Auditoría:** setea `updated_at`, `updated_by` (usuario o el propio id si no hay sesión).

**Errores comunes:**
- `InvalidArgumentException` (no hay nada que actualizar, o enums/fecha inválidos).
- `RuntimeException` por violaciones de negocio (FK inexistente).
- `mysqli_sql_exception` por errores SQL.

### 5.4 `eliminar($id) : bool`
- Soft delete: setea `deleted_at` y `deleted_by` (con fecha de `nowWithAudit()` y actor).

---

## 6) Endpoints HTTP expuestos

```php
GET    /animal_movimientos                      // listar (con filtros via querystring)
GET    /animal_movimientos/{animal_movimiento_id} // mostrar (obtenerPorId)
POST   /animal_movimientos                      // crear
POST   /animal_movimientos/{animal_movimiento_id} // actualizar (PUT/PATCH emulado)
DELETE /animal_movimientos/{animal_movimiento_id} // eliminar (soft)
```

### 6.1 Ejemplos cURL

**Listar (últimos 50 traslados de un animal):**
```bash
curl -X GET "https://api.tu-dominio/animal_movimientos?animalId=UUID&tipo=TRASLADO&limit=50&offset=0"
```

**Crear (JSON):**
```bash
curl -X POST "https://api.tu-dominio/animal_movimientos" \
  -H "Content-Type: application/json" \
  -d '{ "animal_id":"...", "fecha_mov":"2025-10-06", "tipo_movimiento":"TRASLADO", "motivo":"TRASLADO", "finca_origen_id":"...", "aprisco_origen_id":"...", "area_origen_id":"...", "finca_destino_id":"...", "aprisco_destino_id":"...", "area_destino_id":"..." }'
```

**Actualizar:**
```bash
curl -X POST "https://api.tu-dominio/animal_movimientos/{id}" \
  -H "Content-Type: application/json" \
  -d '{ "estado":"ANULADO", "observaciones":"Se cancela por error de carga" }'
```

**Eliminar (soft):**
```bash
curl -X DELETE "https://api.tu-dominio/animal_movimientos/{id}"
```

---

## 7) Consideraciones de base de datos y alertas relacionadas

- La tabla `animal_movimientos` usa **FKs** hacia `animales`, `fincas`, `apriscos`, `areas` y `recintos`.  
- Se sugiere un **SP** `sp_validar_compatibilidad_transferencia` para generar alertas de convivencia en **traslados**.  
  - El patrón es similar a los SP y triggers usados para **alertas de reincidencia de aplastamiento** y **peso fuera de rango** (ver *sp_alerta_reincidencia_aplastamiento* y *sp_evaluar_peso_animal*).  
- Para performance, existen **índices** por `animal_id`, `fecha_mov`, `tipo_movimiento`, `estado`, y por FKs de origen/destino.

---

## 8) Errores y manejo de excepciones (resumen)

- **400 / 422** (según convención): `InvalidArgumentException` cuando fallan formatos, enums o reglas de negocio.
- **404**: cuando `obtenerPorId` no encuentra registro, o al `actualizar`/`eliminar` con `deleted_at` no nulo.
- **409**: colisiones de negocio (p. ej., `foreign key` semántica).
- **500**: `mysqli_sql_exception` (errores de SQL/prepare/execute) o cualquier `Throwable` no controlado.

---

## 9) Recomendaciones y extensiones

- Normalizar `documento_ref` y **adjuntos** (p. ej., tabla de documentos por movimiento).  
- Auditar todas las operaciones con **bitácora** (triggers o tabla `audit_log`).  
- Validar **capacidad** de recintos previo a traslados (cupos).  
- Exponer **PUT/PATCH** reales si el router lo permite.  
- Añadir **tests** de integridad de jerarquía (recinto→área→aprisco→finca).

---

## 10) Esquemas de referencia (resumen)

**`animal_movimientos` (campos clave):**
- `animal_movimiento_id (PK UUID)`
- `animal_id (FK animales)`
- `fecha_mov (DATE)`
- `tipo_movimiento (ENUM)` — INGRESO, EGRESO, TRASLADO, VENTA, COMPRA, NACIMIENTO, MUERTE, OTRO
- `motivo (ENUM)` — TRASLADO, INGRESO, EGRESO, AISLAMIENTO, VENTA, OTRO
- `estado (ENUM)` — REGISTRADO, ANULADO
- FKs de **origen**/**destino** (`finca/aprisco/area/recinto`)
- `costo (DECIMAL)`, `documento_ref (VARCHAR)`, `observaciones (TEXT)`
- `created_*`, `updated_*`, `deleted_*`

---

## 11) Checklist de entrada por tipo

**INGRESO / COMPRA / NACIMIENTO**
- [ ] `animal_id`, `fecha_mov`, `tipo_movimiento`  
- [ ] **Destino** presente (≥ 1: finca/aprisco/area/recinto)  
- [ ] Jerarquía válida (si se dan múltiples niveles)

**EGRESO / VENTA / MUERTE**
- [ ] `animal_id`, `fecha_mov`, `tipo_movimiento`  
- [ ] **Origen** presente (≥ 1)  
- [ ] Jerarquía válida

**TRASLADO**
- [ ] `animal_id`, `fecha_mov`, `tipo_movimiento`  
- [ ] **Origen y Destino** presentes (≥ 1 en cada lado)  
- [ ] Jerarquía válida en ambos lados  
- [ ] Invocación a SP de **compatibilidad**

---

## 12) Notas finales

- Si tu motor MySQL no permite alguna sintaxis (por ejemplo, `IS NOT NULL IS FALSE`), el código ya incluye una **línea equivalente segura** (`deleted_at IS NULL`).  
- El bind usa tipos `'s'` (string) incluso para números **para facilitar NULL** sin warnings; la validación previa asegura rangos y semántica.

> **Este documento cubre el flujo completo del modelo y endpoints asociados para que puedas integrarlos, probarlos y extenderlos con seguridad.**

