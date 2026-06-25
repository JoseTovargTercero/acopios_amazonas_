
# AnimalPesoModel & AnimalPesoController — Guía paso a paso

**Objetivo:** Documentar qué hace el módulo de **pesos de animales**: validaciones, entradas/salidas, reglas de negocio, flujo de auditoría, endpoints HTTP y ejemplos prácticos.

---

## 1) Arquitectura y dependencias

**Archivos requeridos por el modelo**

- `../config/Database.php` — Singleton de conexión **MySQLi** (`Database::getInstance()`).
- `../config/ClientEnvironmentInfo.php` — Contexto de **auditoría** (IP, agente, etc.) y utilidades de fecha/hora.
- `../config/TimezoneManager.php` — Aplicación de **zona horaria** a la sesión/entorno.
- `../helpers/UuidHelper.php` — Generación de **UUID v4**.

**Tabla principal:** `animal_pesos`  
**Propósito:** Registrar y consultar **pesajes** de animales, con conversión automática de unidades (KG/LB) y evaluación automática vía **Stored Procedure** contra un tabulador **raza+edad** (alerta `PESO_FUERA_RANGO`).

---

## 2) Visión general de clases

```php
class AnimalPesoModel {
  private $db;
  private $table = 'animal_pesos';

  public function __construct();
  // Utilidades
  private function nowWithAudit(): array;
  private function animalExiste(string $animalId): bool;
  private function validarFecha(string $fechaYmd): void;
  private function normalizarPeso(float $valor, string $unidad): float;
  private function evaluarPesoDestete(string $animalPesoId): void;

  // Lecturas
  public function listar(...): array;
  public function obtenerPorId(string $id): ?array;

  // Escrituras
  public function crear(array $data): string;
  public function actualizar(string $id, array $data): bool;
  public function eliminar(string $id): bool;
}

class AnimalPesoController {
  // Entradas/salidas HTTP en JSON, mapeadas al modelo
  public function listar(): void;
  public function mostrar(array $params): void;
  public function crear(): void;
  public function actualizar(array $params): void;
  public function eliminar(array $params): void;
}
```

**Rutas registradas:**

```php
GET    /animal_pesos
GET    /animal_pesos/{animal_peso_id}
POST   /animal_pesos
POST   /animal_pesos/{animal_peso_id}
DELETE /animal_pesos/{animal_peso_id}
```

---

## 3) Utilidades y validaciones (modelo)

### 3.1 `nowWithAudit()`
- Inicializa `ClientEnvironmentInfo` con la base **GeoLite**.
- Aplica contexto de auditoría (`applyAuditContext($db, 0)`), útil si existen triggers/bitácoras que leen variables de sesión o contexto.
- Ajusta la **zona horaria** vía `TimezoneManager::applyTimezone()`.
- **Devuelve:** `[$fechaActual, $env]`, con la fecha/hora alineada a la TZ activa.

### 3.2 `animalExiste($animalId)`
- Comprueba existencia en `animales` con `deleted_at IS NULL`.
- **Error técnico:** `mysqli_sql_exception` si falla `prepare()`; **negocio:** retorna `false` si no existe.

### 3.3 `validarFecha($fechaYmd)`
- Solo acepta formato `YYYY-MM-DD` y valida calendario con `checkdate()`.
- **Error:** `InvalidArgumentException` si no cumple.

### 3.4 `normalizarPeso($valor, $unidad)`
- Acepta `KG` o `LB` (case-insensitive), convierte **LB → KG** con factor `0.45359237`.
- Valida rango razonable `(0, 9999]`.
- **Errores:** `InvalidArgumentException` por unidad inválida o valor fuera de rango.

### 3.5 `evaluarPesoDestete($animalPesoId)`
- Llama al **SP** `sp_evaluar_peso_animal(?)` que compara **raza + edad** vs peso registrado, y:
  - **Crea** o **limpia** alerta `PESO_FUERA_RANGO` **referenciando** este `animal_peso_id`.
- Limpia todos los **result sets** del SP con el bucle `do...while`.
- **Errores:** `mysqli_sql_exception` si falla ejecución.

---

## 4) Lecturas

### 4.1 `listar(limit, offset, incluirEliminados=false, animalId?, desde?, hasta?) : array`
- **Filtros:**
  - `animal_id` — restringe a un animal.
  - `desde` y `hasta` — en `YYYY-MM-DD` sobre `fecha_peso`. (Ambos validados con `validarFecha()`).
  - `incluirEliminados` — si `true`, lista **también** soft-deleted; si `false`, solo activos.
- **Paginación:** `LIMIT ? OFFSET ?`.
- **Salida:** filas con joins útiles (`animal_identificador`).
- **Orden:** `p.fecha_peso DESC, p.created_at DESC`.
- **Errores:** `mysqli_sql_exception` si falla `prepare`/`execute`.

**Ejemplo de salida:**
```json
[
  {
    "animal_peso_id": "UUID",
    "animal_id": "UUID",
    "animal_identificador": "TAG-101",
    "fecha_peso": "2025-10-21",
    "peso_kg": 34.50,
    "metodo": "balanza",
    "observaciones": "Destete",
    "created_at": "2025-10-21 09:43:00",
    "created_by": "user-uuid",
    "updated_at": null,
    "updated_by": null
  }
]
```

### 4.2 `obtenerPorId($id) : ?array`
- Devuelve el registro con metadata de auditoría (`created_*`, `updated_*`, `deleted_*`) y `animal_identificador`.
- `null` si no existe.

---

## 5) Escrituras (reglas de negocio)

### 5.1 `crear(array $data) : string`

**Requeridos:**  
- `animal_id` (UUID existente y activo)  
- `fecha_peso` (`YYYY-MM-DD`)  
- `peso_kg` (numérico) — **Nombre del campo de entrada**; puede venir en **LB** si `unidad='LB'`, el modelo lo convertirá a **KG** antes de guardar.  
- `unidad` (`'KG'|'LB'`)

**Opcionales:**  
- `metodo` (string corto)  
- `observaciones` (texto)

**Flujo de negocio:**  
1) Valida requeridos y **existencia del animal**.  
2) Valida fecha (`validarFecha`) y **normaliza** el peso a **KG** (`normalizarPeso`).  
3) Inicia **transacción**, genera `UUID`, obtiene `[now, actor]` por `nowWithAudit()`.  
4) Inserta registro (bind types `sssdssss`). Gestiona errores de **FK** y **duplicados** (ej.: restricción única por `animal_id + fecha_peso`).  
5) Invoca `evaluarPesoDestete($uuid)` para **crear/limpiar alerta** según tabulador.  
6) `commit()` y **retorna** `animal_peso_id`.

**Errores posibles:**  
- `InvalidArgumentException` (faltantes, formato, rango, unidad).  
- `RuntimeException` (FK o duplicado semántico).  
- `mysqli_sql_exception` (SQL/prepare/execute).

**Ejemplo JSON de entrada (en libras):**
```json
{
  "animal_id": "c3b2b630-e3f7-4a8d-8f4e-34eaf9b6c657",
  "fecha_peso": "2025-10-22",
  "peso_kg": 80,
  "unidad": "LB",
  "metodo": "balanza portátil",
  "observaciones": "Pesaje al destete"
}
```
> El modelo almacenará `peso_kg` ≈ `36.287` luego de convertir.

**Respuesta:**  
```json
{
  "value": true,
  "message": "Registro de peso creado correctamente.",
  "data": { "animal_peso_id": "UUID" }
}
```

> **Nota de nombres:** En `crear()` el payload usa la clave **`peso_kg`** (con `unidad`). En `actualizar()` se usa el par **`peso` + `unidad`** cuando se modifica el valor. Esto permite distinguir entre creación (entrada cruda) y edición (reescritura explícita del KG).

### 5.2 `actualizar($id, array $data) : bool`

**Campos editables:**  
- `fecha_peso?` — **Revalida** formato y **dispara** re-evaluación.  
- `peso?` **y** `unidad?` — si llega `peso`, **debe** llegar `unidad`. Se normaliza a **KG** y se guarda en `peso_kg`.  
- `metodo?`, `observaciones?` — Strings (permiten `null`).

**Auditoría:** setea `updated_at` y `updated_by` usando `nowWithAudit()`.

**Re-evaluación automática:**  
- Si cambian `fecha_peso` **o** (`peso` y `unidad`), llama a `evaluarPesoDestete($id)`.

**Errores posibles:**  
- `InvalidArgumentException` (sin campos, fecha inválida, enviar `peso` sin `unidad`, etc.).  
- `RuntimeException` (conflicto de unicidad).  
- `mysqli_sql_exception` (SQL).

### 5.3 `eliminar($id) : bool`
- **Soft delete**: marca `deleted_at` y `deleted_by`.  
- Devuelve `true`/`false` según el `UPDATE`.

---

## 6) Capa HTTP — `AnimalPesoController`

### 6.1 Contratos de entrada/salida

- **Formato de entrada:** `application/json` en `POST /animal_pesos` y `POST /animal_pesos/{id}`.  
- **Formato de salida:** JSON `{ value, message, data }` con **status code** apropiado.

### 6.2 Endpoints y casos

#### `GET /animal_pesos`
**Query params:**  
- `animal_id?`, `desde? (YYYY-MM-DD)`, `hasta? (YYYY-MM-DD)`, `incluirEliminados=0|1`, `limit?`, `offset?`  
**Respuestas:**  
- `200 OK` `{ value:true, data:[...] }`  
- `400` por `desde/hasta` inválidos  
- `500` por errores del modelo/DB

#### `GET /animal_pesos/{animal_peso_id}`
- `200 OK` con el registro.  
- `404` si no existe.  
- `500` en error interno.

#### `POST /animal_pesos`
**Body:** `{ animal_id, fecha_peso, peso_kg, unidad('KG'|'LB'), metodo?, observaciones? }`  
**Respuestas:**  
- `200 OK` con `{ animal_peso_id }`  
- `400` (faltantes/formatos)  
- `409` (FK/duplicado semántico)  
- `500` (interno)

#### `POST /animal_pesos/{animal_peso_id}`
**Body:** `{ fecha_peso?, peso?, unidad?, metodo?, observaciones? }`  
- **Regla:** si envías `peso`, **debes** enviar `unidad`.  
**Respuestas:**  
- `200 OK` `{ updated:true }`  
- `400` (reglas/formatos)  
- `409` (unicidad)  
- `500` (interno)

#### `DELETE /animal_pesos/{animal_peso_id}`
- `200 OK` `{ deleted:true }`  
- `400` si no se pudo (o ya estaba eliminado)  
- `500` en error interno

---

## 7) Ejemplos cURL

**Listar últimos 20 pesos de un animal:**  
```bash
curl -X GET "https://api.tu-dominio/animal_pesos?animal_id=UUID&limit=20&offset=0"
```

**Crear con unidad en libras:**  
```bash
curl -X POST "https://api.tu-dominio/animal_pesos" \
  -H "Content-Type: application/json" \
  -d '{ "animal_id":"UUID", "fecha_peso":"2025-10-22", "peso_kg": 75, "unidad":"LB", "metodo":"balanza", "observaciones":"control mensual" }'
```

**Actualizar peso/fecha:**  
```bash
curl -X POST "https://api.tu-dominio/animal_pesos/{animal_peso_id}" \
  -H "Content-Type: application/json" \
  -d '{ "fecha_peso":"2025-10-23", "peso": 40.2, "unidad":"KG" }'
```

**Eliminar (soft):**  
```bash
curl -X DELETE "https://api.tu-dominio/animal_pesos/{animal_peso_id}"
```

---

## 8) Modelo de datos (resumen)

**`animal_pesos` (campos principales):**
- `animal_peso_id (PK UUID)`  
- `animal_id (FK animales)`  
- `fecha_peso (DATE)`  
- `peso_kg (DECIMAL)` — Siempre guardado en **KG**  
- `metodo (VARCHAR)`  
- `observaciones (TEXT)`  
- `created_at/by`, `updated_at/by`, `deleted_at/by`

**Índices sugeridos:**  
- `(animal_id, fecha_peso)` único (si la regla lo exige).  
- Índices por `animal_id`, `fecha_peso` y cualquier columna de consulta frecuente.

---

## 9) Alertas automáticas por SP

- El SP `sp_evaluar_peso_animal(p_animal_peso_id)` debe:
  - Leer **raza** y **edad** del animal a la fecha del peso.
  - Consultar el **tabulador** para rango esperado.
  - Crear o limpiar alerta `PESO_FUERA_RANGO` asociada al `animal_peso_id`.
- El modelo lo invoca **al crear** y **al actualizar** (si cambian `fecha_peso` o `peso`/`unidad`).

---

## 10) Errores y códigos HTTP

- **400 / 422**: validaciones de entrada (`InvalidArgumentException`).  
- **404**: recurso no encontrado en `mostrar`.  
- **409**: conflictos de negocio (duplicados/uniqueness, FK).  
- **500**: errores SQL o excepciones no controladas (`mysqli_sql_exception`, `Throwable`).

---

## 11) Checklist de pruebas rápidas

- [ ] Crear en **LB** y confirmar que almacena **KG**.  
- [ ] Rechaza unidad distinta de `KG|LB`.  
- [ ] `actualizar`: enviar `peso` **sin** `unidad` → error 400 esperado.  
- [ ] `listar`: filtra por rango de fechas y `animal_id`.  
- [ ] SP crea/limpia alerta al crear/actualizar.  
- [ ] `eliminar`: marca `deleted_at/by` y no reaparece en listados por defecto.

> Con esto tienes una referencia completa para integrar, probar y extender el módulo de **pesos de animales**.
