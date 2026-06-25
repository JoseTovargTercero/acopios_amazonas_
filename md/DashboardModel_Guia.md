
# DashboardModel & DashboardController — Guía paso a paso

**Objetivo:** Explicar el funcionamiento del **Dashboard**, que consolida métricas clave (animales, salud, pesos, bajas, infraestructura, etc.) en una sola estructura JSON para ser consumida por el frontend.

---

## 1) Arquitectura y dependencias

**Archivos requeridos**

- `../config/Database.php` — Singleton **MySQLi** (`Database::getInstance()`).

**Tabla principal:** No aplica (es un modelo de agregación de múltiples tablas: `animales`, `animal_salud`, `animal_pesos`, `camada_bajas`, `reportes_dano`, `animal_decesos`, `partos`, `incidencias`).

**Propósito:** Proveer una "foto" completa del estado del sistema para la pantalla de inicio, evitando múltiples llamadas HTTP separadas.

---

## 2) Visión general de clases

```php
class DashboardModel {
  private $db;

  public function __construct();

  // Método principal público
  public function obtenerResumen(): array;

  // Métodos privados de sección
  private function getAnimalesResumen(): array;
  private function getSaludResumen(): array;
  private function getPesosResumen(): array;
  private function getCamadasBajasResumen(): array;
  private function getInfraestructuraResumen(): array;
  private function getDecesosResumen(): array;
  private function getCamadasResumen(): array;
  private function getIncidenciasResumen(): array;
}

class DashboardController {
  private $model;
  
  public function resumen(): void; // GET /dashboard
}
```

**Rutas expuestas:**

```php
GET    /dashboard
```

---

## 3) Detalle de Secciones (Modelo)

El método `obtenerResumen()` orquesta la llamada a todos los métodos privados y fusiona los arrays resultantes.

### 3.1 Animales (`getAnimalesResumen`)
- **Total de animales** activos.
- **Distribución por etapa productiva** (Cría, Levante, Ceba, etc.).
- **Pirámide de edades**: Histograma agrupado en rangos (0-2 meses, 3-5, ..., 18+).

### 3.2 Salud (`getSaludResumen`)
- **Tratamientos del mes**: Comparativa mes actual vs. anterior.
- **Enfermedades por tipo**: Conteo agrupado por diagnóstico.
- **Eventos trimestrales**: Tabla de recuperados vs. decesos por trimestre (Q1-Q4), comparando año actual vs. anterior.

### 3.3 Pesos (`getPesosResumen`)
- **Lista de pesos**: Datos crudos (animal_id, peso, edad_meses) para scatter plots.
- **Curva ideal**: Promedios desde `tabuladores_peso`.
- **Promedios por etapa**: Peso promedio específico para 'LEVANTE' y 'CEBA'.

### 3.4 Camadas Bajas (`getCamadasBajasResumen`)
- **Muertes lactantes por mes**: Evolución mensual del año actual.
- **Causas de muerte**: Agrupación por causa.
- **Promedio edad muerte**: Días promedio de vida antes del deceso.

### 3.5 Infraestructura (`getInfraestructuraResumen`)
- **Daños mensuales**: Reportes de daño por mes (año actual).
- **Daños por tipo**: Agrupado por tipo de área.

### 3.6 Decesos Generales (`getDecesosResumen`)
- **Muertes mensuales**: Histórico mensual global.
- **Causas probables**: Top 10 causas de muerte.

### 3.7 Camadas / Producción (`getCamadasResumen`)
- **Nacidos vs. Muertos**: Comparativa mensual.
- **Peso promedio al nacer**: Evolución mensual.
- **Promedio crías por parto**: Prolificidad mensual.

### 3.8 Incidencias (`getIncidenciasResumen`)
- **Por tipo**: Conteo por tipo de incidencia.
- **Mensuales**: Evolución temporal.
- **Por área**: Lugares con más incidencias.

---

## 4) Capa HTTP — `DashboardController`

### 4.1 `GET /dashboard`
- Llama a `DashboardModel::obtenerResumen()`.
- Retorna un JSON masivo con todas las claves principales.

**Ejemplo de respuesta (simplificada):**

```json
{
  "value": true,
  "message": "Resumen de dashboard obtenido correctamente.",
  "data": {
    "animales": {
      "total_animales": 150,
      "por_etapa": [...],
      "piramide_edades": [...]
    },
    "salud": {
      "tratamientos_mes": { "actual": 5, "anterior": 2 },
      "eventos_trimestrales": [...]
    },
    "pesos": { ... },
    "camadas_bajas": { ... },
    "infraestructura": { ... },
    "decesos": { ... },
    "camadas": { ... },
    "incidencias": { ... }
  }
}
```

---

## 5) Errores y códigos HTTP

- **200 OK**: Éxito.
- **500 Internal Server Error**: Si falla alguna consulta SQL crítica (aunque el controlador captura excepciones y devuelve 500 con mensaje).

---

## 6) Notas para el Desarrollador

> [!TIP]
> **Performance**: Este endpoint ejecuta múltiples consultas de agregación (COUNT, SUM, AVG, GROUP BY). En bases de datos muy grandes, podría requerir optimización (índices en fechas y columnas de estado/eliminado) o una estrategia de caché si la carga es alta.

> [!NOTE]
> **Fechas**: La mayoría de las métricas filtran por `YEAR(CURDATE())` o comparan contra el mes actual. Asegurarse de que la zona horaria del servidor (o la configurada en `Database`) sea la correcta.
