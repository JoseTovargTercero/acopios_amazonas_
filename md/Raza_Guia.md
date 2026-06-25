# RazaModel & RazaController — Guía paso a paso

## Objetivo
Documentar el funcionamiento del módulo de **razas**: validaciones, entradas/salidas, reglas de negocio, endpoints HTTP y ejemplos prácticos.

---

## 1) Arquitectura y dependencias

**Archivos requeridos por el modelo:**

- `../config/Database.php` — Singleton de conexión MySQLi (`Database::getInstance()`).
- `../config/ClientEnvironmentInfo.php` — Contexto de auditoría (IP, agente, etc.) y utilidades de fecha/hora.
- `../config/TimezoneManager.php` — Aplicación de zona horaria a la sesión/entorno.
- `../helpers/UuidHelper.php` — Generación de UUID v4.

**Tabla principal:** `razas`

**Propósito:**  
Gestionar el catálogo de razas animales, diferenciadas por especie.  
Permite registrar, listar, actualizar y eliminar (soft delete) razas, garantizando unicidad de código y trazabilidad mediante campos de auditoría.

---

## 2) Visión general de clases

```php
class RazaModel {
  private $db;
  private $table = 'razas';

  public function __construct();

  // Utilidades
  private function nowWithAudit(): array;
  private function validarEnum(string $val, array $permitidos, string $campo): string;
  private function normalizarCodigo(?string $c): ?string;
  private function normalizarNombre(string $n): string;
  private function normalizarDescripcion(?string $d): ?string;
  private function existeCodigo(string $codigo, ?string $excluirId = null): bool;

  // Lecturas
  public function listar(int $limit, int $offset, ?string $especie, ?string $estado, ?string $q, bool $incluirEliminados): array;
  public function obtenerPorId(string $id): ?array;

  // Escrituras
  public function crear(array $in): string;
  public function actualizar(string $id, array $in): bool;
  public function eliminar(string $id): bool;
  public function restaurar(string $id): bool;
}

class RazaController {
  private function getJsonInput(): array;
  private function jsonResponse(...): void;
  public function listar(): void;
  public function mostrar(array $params): void;
  public function crear(): void;
  public function actualizar(array $params): void;
  public function eliminar(array $params): void;
  public function restaurar(array $params): void;
}
```

**Rutas registradas:**

```
GET    /razas
GET    /razas/{raza_id}
POST   /razas
POST   /razas/{raza_id}
DELETE /razas/{raza_id}
POST   /razas/{raza_id}/restaurar
```

---

## 3) Utilidades y validaciones (modelo)

### 3.1 nowWithAudit()
Inicializa `ClientEnvironmentInfo` y aplica contexto de auditoría.  
Ajusta la zona horaria mediante `TimezoneManager`.  
Devuelve: `[$fechaActual, $env]`.

### 3.2 validarEnum($val, $permitidos, $campo)
Valida que el valor pertenezca al conjunto permitido (p.ej. `ACTIVA`, `INACTIVA`, `BOVINO`, etc.).  
Lanza `InvalidArgumentException` si no coincide.

### 3.3 normalizarCodigo($c)
Transforma el código en mayúsculas, elimina espacios y valida formato (`A-Z0-9_-`, 2–32 caracteres).  
Lanza `InvalidArgumentException` si el formato no cumple.

### 3.4 normalizarNombre($n)
Elimina espacios y verifica que no esté vacío ni supere 120 caracteres.

### 3.5 existeCodigo($codigo, $excluirId = null)
Comprueba si ya existe una raza activa con ese código (considerando `deleted_at IS NULL`).  
Devuelve `true` si ya existe.

---

## 4) Lecturas

### 4.1 listar(limit, offset, especie?, estado?, q?, incluirEliminados?) : array

**Filtros disponibles:**
- `especie`: BOVINO, OVINO, CAPRINO, PORCINO, OTRO
- `estado`: ACTIVA o INACTIVA
- `q`: texto libre en código o nombre
- `incluirEliminados`: muestra registros eliminados lógicamente

**Salida:** lista con todos los campos principales.  
Orden: especie → nombre (ASC).

**Ejemplo de salida:**
```json
[
  {
    "raza_id": "uuid-1",
    "especie": "BOVINO",
    "codigo": "ANGUS",
    "nombre": "Raza Angus",
    "descripcion": "Bovino de carne de alta calidad",
    "estado": "ACTIVA",
    "created_at": "2025-10-27 09:00:00",
    "created_by": "user-uuid"
  }
]
```

### 4.2 obtenerPorId($id)
Devuelve un registro único con todos los campos.  
Retorna `null` si no existe.

---

## 5) Escrituras (reglas de negocio)

### 5.1 crear(array $in)
**Campos requeridos:**
- especie (ENUM)
- nombre (string)
- estado (ENUM)

**Opcionales:**
- codigo (string único entre activos)
- descripcion (texto)

**Flujo de negocio:**
1. Valida presencia de campos requeridos.
2. Valida formato de código y unicidad (`existeCodigo()`).
3. Inserta registro con UUID v4.
4. Registra `created_at` y `created_by` (de sesión o UUID).

**Errores posibles:**
- 400: `InvalidArgumentException` (faltantes o formato).
- 409: `RuntimeException` (código duplicado).
- 500: `mysqli_sql_exception` (error SQL).

**Ejemplo JSON de entrada:**
```json
{
  "especie": "BOVINO",
  "codigo": "ANGUS",
  "nombre": "Raza Angus",
  "descripcion": "Raza bovina especializada en carne",
  "estado": "ACTIVA"
}
```

**Respuesta:**
```json
{
  "value": true,
  "message": "Raza creada correctamente.",
  "data": { "raza_id": "UUID-GENERADO" }
}
```

### 5.2 actualizar(string $id, array $in)

Campos editables: cualquiera de los definidos en crear().  
Verifica unicidad de `codigo` si se modifica.

**Errores posibles:**
- 400: Sin campos o formato inválido.
- 409: Código duplicado.
- 500: Error SQL.

**Ejemplo JSON:**
```json
{
  "estado": "INACTIVA",
  "descripcion": "Temporalmente inactiva por falta de datos"
}
```

### 5.3 eliminar(string $id)

Borrado **lógico** (`UPDATE deleted_at/by`).  
Si ya está eliminado, devuelve false.

**Respuesta exitosa:**
```json
{ "value": true, "message": "Raza eliminada correctamente.", "data": { "deleted": true } }
```

### 5.4 restaurar(string $id)

Restaura un registro previamente eliminado (`deleted_at = NULL`).

**Respuesta:**
```json
{ "value": true, "message": "Raza restaurada correctamente.", "data": { "restored": true } }
```

---

## 6) Capa HTTP — RazaController

### Endpoints

| Método | Ruta | Descripción |
|--------|------|--------------|
| GET | /razas | Listar razas (filtros opcionales) |
| GET | /razas/{raza_id} | Obtener una raza específica |
| POST | /razas | Crear raza |
| POST | /razas/{raza_id} | Actualizar raza |
| DELETE | /razas/{raza_id} | Eliminar raza (soft delete) |
| POST | /razas/{raza_id}/restaurar | Restaurar raza eliminada |

**Formato de salida estándar:**  
```json
{ "value": true, "message": "Texto descriptivo", "data": {...} }
```

---

## 7) Ejemplos cURL

**Listar todas las razas:**
```bash
curl -X GET "https://api.tu-dominio/razas"
```

**Filtrar por especie bovina:**
```bash
curl -X GET "https://api.tu-dominio/razas?especie=BOVINO"
```

**Crear una nueva raza:**
```bash
curl -X POST "https://api.tu-dominio/razas"   -H "Content-Type: application/json"   -d '{ "especie":"BOVINO","codigo":"ANGUS","nombre":"Angus","estado":"ACTIVA" }'
```

**Actualizar una raza:**
```bash
curl -X POST "https://api.tu-dominio/razas/{raza_id}"   -H "Content-Type: application/json"   -d '{ "descripcion": "Raza premium de carne" }'
```

**Eliminar una raza:**
```bash
curl -X DELETE "https://api.tu-dominio/razas/{raza_id}"
```

**Restaurar una raza:**
```bash
curl -X POST "https://api.tu-dominio/razas/{raza_id}/restaurar"
```

---

## 8) Modelo de datos (resumen)

**Tabla:** `razas`

| Campo | Tipo | Descripción |
|--------|------|-------------|
| raza_id | CHAR(36) PK | UUID |
| especie | ENUM('BOVINO','OVINO','CAPRINO','PORCINO','OTRO') | Tipo de especie |
| codigo | VARCHAR(32) | Identificador único entre activos |
| nombre | VARCHAR(120) | Nombre de la raza |
| descripcion | TEXT | Información adicional |
| estado | ENUM('ACTIVA','INACTIVA') | Estado operativo |
| created_at/by | DATETIME / CHAR(36) | Auditoría de creación |
| updated_at/by | DATETIME / CHAR(36) | Auditoría de actualización |
| deleted_at/by | DATETIME / CHAR(36) | Auditoría de borrado lógico |

**Índices sugeridos:**
- `UNIQUE (codigo)` — asegura unicidad de código.
- `INDEX (especie)` — para filtros por tipo.

---

## 9) Errores y códigos HTTP

| Código | Causa | Tipo |
|--------|--------|------|
| 400 | Campos faltantes o formato inválido | InvalidArgumentException |
| 404 | Recurso no encontrado | N/A |
| 409 | Código duplicado o conflicto lógico | RuntimeException |
| 500 | Error SQL o interno | mysqli_sql_exception / Throwable |

---

## 10) Checklist de pruebas rápidas

- [ ] Crear raza válida → 200 OK  
- [ ] Crear raza con código duplicado → 409 Conflict  
- [ ] Actualizar nombre y descripción → 200 OK  
- [ ] Eliminar raza → 200 OK (soft delete)  
- [ ] Restaurar raza eliminada → 200 OK  
- [ ] Listar incluyendo eliminadas → 200 OK  
- [ ] Filtrar por especie/estado → resultados correctos  

---

**Fin de la guía — RazaModel & RazaController**
