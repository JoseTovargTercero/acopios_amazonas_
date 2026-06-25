
# PartoModel & PartoController — Guía paso a paso

**Objetivo:** Explicar el módulo de **partos**: entradas/salidas, validaciones, reglas de negocio, autogeneración de incidencias/alertas, endpoints HTTP, errores habituales y ejemplos.

---

## 1) Arquitectura y dependencias

**Archivos requeridos**

- `../config/Database.php` — Singleton de conexión **MySQLi** (`Database::getInstance()`).
- `../config/ClientEnvironmentInfo.php` — Contexto de **auditoría** y fecha/hora del cliente.
- `../config/TimezoneManager.php` — Ajuste de **zona horaria** de la sesión.
- `../helpers/UuidHelper.php` — Generación de **UUID v4**.

**Tablas clave:**  
- `partos` (entidad principal)  
- `periodos_servicio` (para validar/obtener `hembra_id` y `verraco_id`)  
- `incidencias` (registros de eventos no planificados)  
- `alertas` (tareas/recordatorios derivados)

**Propósito del módulo:** Registrar **partos** y, dependiendo del estado del parto, **autogenerar incidencias** y **crear alertas** con fechas objetivo (postparto, investigación, etc.).

---

## 2) Visión general de clases

```php
class PartoModel {
  private $db;
  private $table = 'partos';

  // Configuración para autogenerados
  private const INC_MAP_AUTOGEN;
  private const ALERT_MAP_AUTOGEN;
  private const ALERT_ESTADO_DEFAULT = 'PENDIENTE';

  // Utilidades
  private function nowWithAudit(): array;
  private function validarEstadoParto(?string $v): void;
  private function periodoExiste(string $id): bool;
  private function animalExiste(string $animalId): bool;
  private function areaExiste(?string $areaId): bool;
  private function normalizarTipoIncidencia(string $tipo): string;

  // Lecturas
  public function listar(...): array;
  public function obtenerPorId(string $partoId): ?array;

  // Helpers (inserciones auxiliares)
  private function insertIncidencia(array $ctx, ...): string;
  private function insertAlerta(array $ctx, ...): string;
  private function fechaPlusDias(string $ymd, int $dias): string;

  // Escrituras
  public function crear(array $data): string;
  public function actualizar(string $partoId, array $data): bool;
  public function actualizarEstado(string $partoId, string $estado): bool;
  public function eliminar(string $partoId): bool;
}

class PartoController {
  public function listar(): void;
  public function mostrar(array $params): void;
  public function crear(): void;
  public function actualizar(array $params): void;
  public function actualizarEstado(array $params): void;
  public function eliminar(array $params): void;
}
```

**Rutas expuestas:**

```php
GET    /partos
GET    /partos/{parto_id}
POST   /partos
POST   /partos/{parto_id}
POST   /partos/{parto_id}/estado
DELETE /partos/{parto_id}
```

---

## 3) Configuración de autogenerados

### 3.1 Incidencias automáticas (`INC_MAP_AUTOGEN`)
- **`DISTOCIA`** → Crea una **incidencia** tipo `OTRA` con descripción "Parto con distocia".
- **`MUERTE_PERINATAL`** → Crea una **incidencia** tipo `OTRA` con descripción "Muerte perinatal".

> Se registran para la **hembra** (`hembra_id`) del `periodo_id` asociado.

### 3.2 Alertas automáticas (`ALERT_MAP_AUTOGEN`)
- **`DISTOCIA`** → `POSTPARTO_REVISION` con **fecha objetivo** = `fecha_parto + 3 días`.
- **`MUERTE_PERINATAL`** → `INVESTIGACION_MUERTE_PERINATAL` con **fecha objetivo** = `fecha_parto + 1 día`.

**Estado por defecto de alertas:** `PENDIENTE` (ajústalo a tu módulo de alertas).

---

## 4) Utilidades y validaciones (modelo)

### 4.1 `nowWithAudit()`
- Aplica **contexto de auditoría** y **zona horaria**.  
- **Devuelve:** `[$now, $env]` con fecha/hora consistente para `created_at/updated_at/deleted_at` y `actorId` derivado de `$_SESSION['user_id']` o del propio UUID en caso de ausencia.

### 4.2 `validarEstadoParto($v)`
- Estados válidos: `NORMAL`, `DISTOCIA`, `MUERTE_PERINATAL`, `OTRO`.  
- Lanza `InvalidArgumentException` si no coincide.

### 4.3 `periodoExiste($id)`
- Valida que `periodos_servicio.periodo_id` exista y **no** esté eliminado.

### 4.4 `animalExiste($animalId)` y `areaExiste($areaId)`
- Usado por helpers para incidencias: aseguran **FKs activas**.

### 4.5 `normalizarTipoIncidencia($tipo)`
- Acepta entradas variadas y normaliza a enumeración BD:  
  `RINA` (admite `RIÑA`), `APLASTAMIENTO`, `HERIDA`, `MORDIDA`, `FUGA`, `OTRA`.

---

## 5) Lecturas

### 5.1 `listar(limit, offset, incluirEliminados, periodoId?, estado?, desde?, hasta?) : array`
**Filtros admitidos:**  
- `periodo_id`, `estado_parto` (valida con `validarEstadoParto`), `desde` y `hasta` (strings `YYYY-MM-DD`).  
- `incluirEliminados` → si `false` solo `deleted_at IS NULL`.

**Salida:** campos de `partos` + `hembra_id` y `verraco_id` desde `periodos_servicio`.  
**Orden:** `fecha_parto DESC`.  
**Errores:** `mysqli_sql_exception` en errores SQL.

### 5.2 `obtenerPorId($partoId) : ?array`
- Devuelve el registro del parto con `created_* / updated_* / deleted_*` y los IDs de `hembra` y `verraco` asociados.
- `null` si no existe.

---

## 6) Helpers de inserción

### 6.1 `insertIncidencia(ctx, animal_id, tipo, fecha_evento, descripcion?, responsable?, area_id?) : string`
- Valida **existencia** de `animal_id` y `area_id`.  
- Normaliza **tipo** (`normalizarTipoIncidencia`).  
- Inserta en `incidencias` con `created_at/by` desde `ctx`.  
- **Retorna:** `incidencia_id (UUID)`.

### 6.2 `insertAlerta(ctx, tipo_alerta, fecha_objetivo, periodo_id?, animal_id?, detalle?, estado='PENDIENTE') : string`
- Inserta en `alertas` con **vínculo** opcional al **periodo** y/o **animal**.  
- **Retorna:** `alerta_id (UUID)`.

### 6.3 `fechaPlusDias(ymd, dias) : string`
- Suma/resta días a una fecha (`YYYY-MM-DD` o `YYYY-MM-DD HH:MM:SS`) y devuelve `YYYY-MM-DD`.

---

## 7) Escrituras

### 7.1 `crear(array $data) : string`

**Requeridos:**  
- `periodo_id` — Debe existir y estar activo.  
- `fecha_parto` — String fecha (`YYYY-MM-DD` o compatible).

**Opcionales:**  
- `crias_machos` (int ≥ 0), `crias_hembras` (int ≥ 0)  
- `peso_promedio_kg` (decimal ≥ 0 o `null`)  
- `estado_parto` (default `NORMAL`)  
- `observaciones` (texto)  
- `generar_alertas` (bool, default **true**)  
- `incidencias` (array de incidencias extra)

**Flujo de negocio:**  
1) Valida requeridos y existencia de `periodo_id`.  
2) Obtiene `hembra_id` y `verraco_id` del período.  
3) Normaliza/valida `crias_*` y `peso_promedio_kg` (no negativos).  
4) Valida `estado_parto`.  
5) Inicia **transacción** y crea `parto` (UUID, `created_at/by`).  
6) **Incidencia autogenerada** por estado (si aplica).  
7) **Incidencias del payload** (si vienen).  
8) **Alerta automática** por estado (si `generar_alertas` y hay configuración).  
9) `commit()` y retorna `parto_id`.

**Errores:**  
- `InvalidArgumentException` (faltantes, negativos, estado inválido).  
- `RuntimeException` (periodo inválido, animal/área inexistentes en helpers).  
- `mysqli_sql_exception` (SQL/prepare/execute).

**Ejemplo JSON de entrada:**  
```json
{
  "periodo_id": "a3014f5e-8d2e-4f83-bb8a-5f1c14df024b",
  "fecha_parto": "2025-10-22",
  "crias_machos": 6,
  "crias_hembras": 5,
  "peso_promedio_kg": 1.6,
  "estado_parto": "DISTOCIA",
  "observaciones": "Asistencia manual",
  "generar_alertas": true,
  "incidencias": [
    {
      "animal_id": "hembra-uuid",
      "tipo": "HERIDA",
      "fecha_evento": "2025-10-22 03:10:00",
      "descripcion": "Pequeño corte en miembro posterior",
      "responsable": "Operario A",
      "area_id": "area-uuid"
    }
  ]
}
```

**Efectos esperados:**  
- Inserta **parto**.  
- Crea **incidencia** automática por `DISTOCIA`.  
- Crea **alerta** `POSTPARTO_REVISION` para `fecha_parto + 3 días`.  
- Inserta **incidencia** extra (HERIDA) del payload.

### 7.2 `actualizar($partoId, array $data) : bool`
**Campos editables:**  
- `periodo_id?` (valida existencia o permite `null`)  
- `fecha_parto?`  
- `crias_machos?`, `crias_hembras?` (no negativos)  
- `peso_promedio_kg?` (≥ 0 o `null`)  
- `estado_parto?` (valida enumeración)  
- `observaciones?` (texto o `null`)

**Auditoría:** agrega `updated_at/by`.  
**Errores:** `InvalidArgumentException` (sin cambios o valores inválidos), `RuntimeException` (FK), `mysqli_sql_exception` (SQL).

### 7.3 `actualizarEstado($partoId, $estado) : bool`
- Valida el **estado** y actualiza `estado_parto`, `updated_at/by`.  
- Retorna `true/false` de `execute()`.

### 7.4 `eliminar($partoId) : bool`
- **Soft delete**: setea `deleted_at/by`.  
- Retorna `true/false` de `execute()`.

---

## 8) Capa HTTP — `PartoController`

### 8.1 Contratos de entrada/salida
- **Entrada JSON** en `POST /partos` y `POST /partos/{id}`.  
- **Salida JSON:** `{ value, message, data }` + **status code**.

### 8.2 Endpoints

#### `GET /partos?limit=&offset=&incluirEliminados=0|1&periodo_id=&estado_parto=&desde=&hasta=`
- Devuelve listado paginado.  
- `400` por parámetros inválidos (p. ej., estado).  
- `500` por errores del modelo.

#### `GET /partos/{parto_id}`
- `200` si existe, `404` si no.

#### `POST /partos`
- Crea un parto y ejecuta reglas de autogeneración.  
- `200` con `{ parto_id }` o: `400` (validación), `409` (FK/negocio), `500` (interno).

#### `POST /partos/{parto_id}`
- Actualiza campos editables.  
- `200` con `{ updated:true }` o: `400`/`409`/`500` según error.

#### `POST /partos/{parto_id}/estado`
- Cambia solo `estado_parto`.  
- `200` con `{ updated:true }` o `400`/`500`.

#### `DELETE /partos/{parto_id}`
- Soft delete.  
- `200` con `{ deleted:true }`, `400` si ya estaba eliminado, `500` si hay error.

---

## 9) Modelo de datos (resumen)

**`partos` (campos principales):**
- `parto_id (PK UUID)`  
- `periodo_id (FK periodos_servicio)`  
- `fecha_parto (DATE)`  
- `crias_machos (INT ≥ 0)`, `crias_hembras (INT ≥ 0)`  
- `peso_promedio_kg (DECIMAL ≥ 0 | NULL)`  
- `estado_parto (ENUM)` — `NORMAL | DISTOCIA | MUERTE_PERINATAL | OTRO`  
- `observaciones (TEXT | NULL)`  
- `created_at/by`, `updated_at/by`, `deleted_at/by`

**Relaciones de apoyo:**  
- `periodos_servicio(periodo_id, hembra_id, verraco_id)`  
- `incidencias(incidencia_id, animal_id, tipo, fecha_evento, ...)`  
- `alertas(alerta_id, tipo_alerta, fecha_objetivo, periodo_id?, animal_id?, detalle?, estado_alerta)`

**Índices sugeridos:**  
- `periodo_id`, `fecha_parto`  
- (Opcional) Índice compuesto por (`periodo_id`, `fecha_parto`).

---

## 10) Errores y códigos HTTP

- **400 / 422**: Validaciones de entrada (formatos, negativos, estados fuera de catálogo).  
- **404**: Recurso no encontrado (`mostrar`).  
- **409**: Conflictos de negocio / FK inválidas.  
- **500**: Errores SQL o excepciones no controladas.

---

## 11) Checklist de pruebas rápidas

- [ ] Crear parto `NORMAL` sin incidencias → no genera alertas/incidencias automáticas.  
- [ ] Crear parto `DISTOCIA` → genera incidencia para la **hembra** y alerta `POSTPARTO_REVISION (+3d)`.  
- [ ] Crear parto `MUERTE_PERINATAL` → genera incidencia y alerta de **investigación (+1d)**.  
- [ ] Cargar incidencias extra en el payload → se insertan respetando `animal_id`/`area_id`.  
- [ ] Actualizar `estado_parto` vía `/estado` → persiste y audita `updated_*`.  
- [ ] Soft delete y ver que no aparezca en listados por defecto.

> Con esto tienes un **mapa completo** del módulo: cómo valida, qué inserta/actualiza, cómo y cuándo crea incidencias/alertas, y cómo consumirlo por HTTP.
