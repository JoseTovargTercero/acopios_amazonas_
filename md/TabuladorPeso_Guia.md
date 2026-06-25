TabuladorPesoModel & TabuladorPesoController — Guía paso a paso

Objetivo: Documentar qué hace el módulo de tabuladores de peso: validaciones, entradas/salidas, reglas de negocio, endpoints HTTP y ejemplos prácticos.

1) Arquitectura y dependencias

Archivos requeridos por el modelo

../config/Database.php — Singleton de conexión MySQLi (Database::getInstance()).

../config/ClientEnvironmentInfo.php — Contexto de auditoría (IP, agente, etc.) y utilidades de fecha/hora.

../config/TimezoneManager.php — Aplicación de zona horaria a la sesión/entorno.

../helpers/UuidHelper.php — Generación de UUID v4.

Tabla principal: tabuladores_peso
Propósito: Registrar y consultar los rangos de peso ideal por raza y edad (en días). Su regla de negocio principal es evitar el solapamiento de rangos de edad para una misma raza. Estos datos son consumidos por otros módulos (como el SP sp_evaluar_peso_animal) para generar alertas.

2) Visión general de clases

class TabuladorPesoModel {
  private $db;
  private $table = 'tabuladores_peso';

  public function __construct();
  // Utilidades
  private function nowWithAudit(): array;
  private function razaExiste(string $razaId): bool;
  private function validarEnteroNoNegativo($v, string $nombre): int;
  private function validarDecimalPositivo($v, string $nombre, float $max): float;
  private function validarRangoEdades(int $min, int $max): void;
  private function existeSolapamiento(string $razaId, int $min, int $max, ?string $excluirId): bool;

  // Lecturas
  public function listar(int $limit, int $offset, ?string $razaId, ?int $edadDias): array;
  public function obtenerPorId(string $id): ?array;

  // Escrituras
  public function crear(array $in): string;
  public function actualizar(string $id, array $in): bool;
  public function eliminar(string $id): bool;
}

class TabuladorPesoController {
  // Entradas/salidas HTTP en JSON, mapeadas al modelo
  private function getJsonInput(): array;
  private function jsonResponse(...): void;
  public function listar(): void;
  public function mostrar(array $params): void;
  public function crear(): void;
  public function actualizar(array $params): void;
  public function eliminar(array $params): void;
}


Rutas registradas:

GET    /tabuladores_peso
GET    /tabuladores_peso/{tab_peso_id}
POST   /tabuladores_peso
POST   /tabuladores_peso/{tab_peso_id}
DELETE /tabuladores_peso/{tab_peso_id}


3) Utilidades y validaciones (modelo)

3.1 nowWithAudit()

Inicializa ClientEnvironmentInfo y aplica contexto de auditoría.

Ajusta la zona horaria vía TimezoneManager.

Devuelve: [$fechaActual, $env].

3.2 razaExiste($razaId)

Comprueba existencia en la tabla razas (asume deleted_at IS NULL o similar si la tabla usa soft-delete).

Error técnico: mysqli_sql_exception; negocio: retorna false si no existe.

3.3 validarEnteroNoNegativo($v, $nombre)

Valida que $v sea numérico, un entero, y >= 0.

Error: InvalidArgumentException si no cumple.

3.4 validarDecimalPositivo($v, $nombre, $max)

Valida que $v sea numérico y esté en el rango (0, $max].

Error: InvalidArgumentException si no cumple.

3.5 validarRangoEdades($min, $max)

Valida que edad_min_dias no sea mayor que edad_max_dias.

Error: InvalidArgumentException si min > max.

3.6 existeSolapamiento($razaId, $min, $max, $excluirId = null)

Regla de negocio clave.

Comprueba si existe algún registro para la misma $razaId cuyo rango de edad [edad_min_dias, edad_max_dias] se solape con el rango [$min, $max] proporcionado.

La consulta SQL usa la lógica NOT (edad_max_dias < ? OR edad_min_dias > ?).

El parámetro $excluirId se usa durante la actualización para no compararse consigo mismo.

Devuelve: true si hay solapamiento, false si no.

4) Lecturas

4.1 listar(limit, offset, razaId?, edadDias?) : array

Filtros:

raza_id — restringe a una raza.

edad_dias — busca el rango de tabulador que contiene esa edad (? BETWEEN t.edad_min_dias AND t.edad_max_dias).

Paginación: LIMIT ? OFFSET ?.

Salida: filas con join a razas para incluir raza_nombre.

Orden: t.raza_id, t.edad_min_dias ASC, t.edad_max_dias ASC.

Errores: mysqli_sql_exception.

Ejemplo de salida:

[
  {
    "tab_peso_id": "UUID-1",
    "raza_id": "UUID-RAZA-A",
    "raza_nombre": "Angus",
    "edad_min_dias": 0,
    "edad_max_dias": 90,
    "peso_ideal": 85.50,
    "margen_min": 15.00,
    "margen_max": 10.00,
    "created_at": "2025-10-21 09:43:00",
    "created_by": "user-uuid"
  },
  {
    "tab_peso_id": "UUID-2",
    "raza_id": "UUID-RAZA-A",
    "raza_nombre": "Angus",
    "edad_min_dias": 91,
    "edad_max_dias": 180,
    "peso_ideal": 150.00,
    "margen_min": 25.00,
    "margen_max": 20.00,
    "created_at": "...",
    "created_by": "..."
  }
]


4.2 obtenerPorId($id) : ?array

Devuelve el registro con raza_nombre.

null si no existe.

5) Escrituras (reglas de negocio)

5.1 crear(array $data) : string

Requeridos:

raza_id (UUID existente)

edad_min_dias (entero >= 0)

edad_max_dias (entero >= 0)

peso_ideal (decimal > 0)

margen_min (decimal > 0)

margen_max (decimal > 0)

Flujo de negocio:

Valida que todos los campos requeridos estén presentes.

Valida razaExiste($data['raza_id']).

Valida tipos numéricos (validarEnteroNoNegativo, validarDecimalPositivo).

Valida rango de edades (validarRangoEdades).

Validación clave: Llama a existeSolapamiento($razaId, $min, $max, null).

Si hay solapamiento, lanza RuntimeException (mapeado a 409 Conflict).

Obtiene [now, actor] por nowWithAudit(), genera UUID.

Inserta registro (bind types ssii ddd ss).

commit() y retorna tab_peso_id.

Errores posibles:

InvalidArgumentException (400: faltantes, formato, rango, min > max).

RuntimeException (409: raza_id no existe, solapamiento de rango).

mysqli_sql_exception (500: SQL/prepare/execute).

Ejemplo JSON de entrada:

{
  "raza_id": "c3b2b630-e3f7-4a8d-8f4e-34eaf9b6c657",
  "edad_min_dias": 91,
  "edad_max_dias": 180,
  "peso_ideal": 150.5,
  "margen_min": 20.0,
  "margen_max": 15.0
}


Respuesta:

{
  "value": true,
  "message": "Tabulador creado correctamente.",
  "data": { "tab_peso_id": "UUID-GENERADO" }
}


5.2 actualizar($id, array $data) : bool

Campos editables:

Cualquiera de los campos de crear (son opcionales en el JSON).

Auditoría:

Nota: El modelo TabuladorPesoModel no actualiza campos updated_at/updated_by en esta implementación.

Re-evaluación automática (Solapamiento):

Si $data contiene raza_id, edad_min_dias o edad_max_dias, se activa la validación de rango ($tocaRango = true).

El modelo primero lee el registro actual de la BD para obtener los valores (raza_id, min, max) que no vinieron en el payload.

Valida el rango combinado (validarRangoEdades).

Llama a existeSolapamiento($razaId, $min, $max, $id) (excluyéndose a sí mismo).

Si hay solapamiento, lanza RuntimeException (409).

Si pasa, ejecuta el UPDATE.

Errores posibles:

InvalidArgumentException (400: sin campos, formato inválido, min > max).

RuntimeException (409: raza_id no existe, solapamiento de rango).

mysqli_sql_exception (500: SQL).

5.3 eliminar($id) : bool

Borrado Físico: ejecuta un DELETE FROM tabuladores_peso....

Esta tabla no usa soft delete.

Devuelve true/false según el DELETE.

6) Capa HTTP — TabuladorPesoController

6.1 Contratos de entrada/salida

Formato de entrada: application/json en POST.

Formato de salida: JSON { value, message, data } con status code apropiado.

6.2 Endpoints y casos

GET /tabuladores_peso

Query params:

limit?, offset?, raza_id? (UUID), edad_dias? (int)
Respuestas:

200 OK { value:true, data:[...] }

400 por validación de InvalidArgumentException del modelo (si existiera).

500 por errores del modelo/DB.

GET /tabuladores_peso/{tab_peso_id}

200 OK con el registro.

404 si !$row (no encontrado).

400 si tab_peso_id no se provee en la URL.

500 en error interno.

POST /tabuladores_peso

Body: { raza_id, edad_min_dias, edad_max_dias, peso_ideal, margen_min, margen_max }
Respuestas:

200 OK con { tab_peso_id }

400 (faltantes/formatos, InvalidArgumentException)

409 (FK, solapamiento, RuntimeException)

500 (interno)

POST /tabuladores_peso/{tab_peso_id}

Body: { raza_id?, edad_min_dias?, ..., margen_max? }
Respuestas:

200 OK { updated:true }

400 (reglas/formatos, InvalidArgumentException)

409 (solapamiento, RuntimeException)

500 (interno)

DELETE /tabuladores_peso/{tab_peso_id}

200 OK { deleted:true }

400 si !$ok (no se pudo eliminar o no existía) o si falta id.

500 en error interno.

7) Ejemplos cURL

Listar todos los tabuladores (paginado por defecto):

curl -X GET "[https://api.tu-dominio/tabuladores_peso](https://api.tu-dominio/tabuladores_peso)"


Buscar qué rango aplica para una raza a los 100 días de edad:

curl -X GET "[https://api.tu-dominio/tabuladores_peso?raza_id=UUID-RAZA&edad_dias=100](https://api.tu-dominio/tabuladores_peso?raza_id=UUID-RAZA&edad_dias=100)"


Crear un nuevo rango de tabulador:

curl -X POST "[https://api.tu-dominio/tabuladores_peso](https://api.tu-dominio/tabuladores_peso)" \
  -H "Content-Type: application/json" \
  -d '{ "raza_id":"UUID-RAZA", "edad_min_dias": 181, "edad_max_dias": 365, "peso_ideal": 250, "margen_min": 40, "margen_max": 30 }'


Actualizar solo el peso ideal de un rango:

curl -X POST "[https://api.tu-dominio/tabuladores_peso/](https://api.tu-dominio/tabuladores_peso/){tab_peso_id}" \
  -H "Content-Type: application/json" \
  -d '{ "peso_ideal": 255.5, "margen_min": 42.0 }'


Eliminar (físico):

curl -X DELETE "[https://api.tu-dominio/tabuladores_peso/](https://api.tu-dominio/tabuladores_peso/){tab_peso_id}"


8) Modelo de datos (resumen)

tabuladores_peso (campos principales):

tab_peso_id (PK UUID)

raza_id (FK razas)

edad_min_dias (INT)

edad_max_dias (INT)

peso_ideal (DECIMAL)

margen_min (DECIMAL)

margen_max (DECIMAL)

created_at/by

(No utiliza updated_at ni deleted_at)

Índices sugeridos:

UNIQUE (raza_id, edad_min_dias, edad_max_dias) — O lógica de constraint para evitar solapamiento si la DB lo soporta.

Índice en raza_id.

9) Regla de negocio: Solapamiento de rangos

La principal regla de negocio de este módulo es impedir que existan dos rangos de edad que se solapen para la misma raza.

Ejemplo: Si existe un rango [91, 180] días para la raza "Angus", el sistema debe rechazar (409 Conflict) la creación de:

[100, 150] (totalmente dentro)

[50, 100] (solapamiento al inicio)

[170, 200] (solapamiento al final)

[50, 200] (contiene al original)

Esta validación se ejecuta en crear() y actualizar() (siempre que se modifiquen raza_id, edad_min_dias o edad_max_dias).

10) Errores y códigos HTTP

400 Bad Request: InvalidArgumentException (campos faltantes, formatos incorrectos, edad_min > edad_max). También si falta el id en la URL (mostrar, actualizar, eliminar).

404 Not Found: Recurso no encontrado en mostrar.

409 Conflict: RuntimeException (generalmente, solapamiento de rangos o FK de raza_id no válida).

500 Internal Server Error: Errores SQL o excepciones no controladas (mysqli_sql_exception, Throwable).

11) Checklist de pruebas rápidas

[ ] Crear rango [10, 20] para Raza A → OK (200).

[ ] Crear rango [15, 25] para Raza A → Error (409 Solapamiento).

[ ] Crear rango [5, 12] para Raza A → Error (409 Solapamiento).

[ ] Crear rango [21, 30] para Raza A → OK (200).

[ ] Crear rango [15, 25] para Raza B → OK (200, es otra raza).

[ ] actualizar el rango [10, 20] a [10, 25] → Error (409, choca con [21, 30]).

[ ] actualizar el rango [10, 20] a [10, 19] → OK (200).

[ ] listar?edad_dias=25 → Debe devolver el rango [21, 30] de la Raza A.

[ ] crear con edad_min_dias=30 y edad_max_dias=20 → Error (400 Rango inválido).

[ ] eliminar un registro y verificar que desaparece de la BD (borrado físico).