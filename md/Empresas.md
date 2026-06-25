# Módulo: Empresas

## Tabla: `empresas`

| Columna      | Tipo         | Notas                      |
|--------------|--------------|----------------------------|
| `id`         | VARCHAR(36)  | UUID v4, PK                |
| `nombre`     | VARCHAR(150) | Requerido                  |
| `telefono`   | VARCHAR(30)  | Opcional                   |
| `created_at` | DATETIME     | Auto al crear              |
| `usuario_id` | VARCHAR(36)  | FK system_users(user_id)   |

## SQL de creación

```sql
CREATE TABLE IF NOT EXISTS empresas (
    id          VARCHAR(36)  NOT NULL PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    telefono    VARCHAR(30)  DEFAULT NULL,
    created_at  DATETIME     NOT NULL,
    usuario_id  VARCHAR(36)  NOT NULL
);
```

## Endpoints REST

| Método | Ruta                 | Acción     |
|--------|----------------------|------------|
| GET    | /api/empresas        | listar     |
| GET    | /api/empresas/{id}   | mostrar    |
| POST   | /api/empresas        | crear      |
| POST   | /api/empresas/{id}   | actualizar |
| DELETE | /api/empresas/{id}   | eliminar   |

## Vista

- **URL:** `/empresas`
- **Archivo vista:** `views/modules/empresas_view.php`
- **JS:** `public/assets/js/modules/empresas_view.js`
- **Controller:** `controllers/EmpresaController.php`
- **Model:** `models/EmpresaModel.php`

## Acciones en la vista

- **Listado** vía bootstrap-table con AJAX
- **Crear** empresa — modal: nombre, teléfono
- **Editar** empresa — mismo modal pre-rellenado
- **Eliminar** empresa — confirmación SweetAlert2

## Flujo JS

1. Bootstrap-table carga `GET /api/empresas` al init.
2. "Nueva Empresa" → abre `#modalEmpresa` (modo crear).
3. Btn editar → pre-rellena modal y cambia a modo editar.
4. Btn eliminar → SweetAlert2 → `DELETE /api/empresas/{id}` → refresh tabla.
5. Submit form → POST crear/actualizar → refresh tabla.

## Archivos del módulo

```
controllers/EmpresaController.php
models/EmpresaModel.php
views/modules/empresas_view.php
public/assets/js/modules/empresas_view.js
md/Empresas.md
```

