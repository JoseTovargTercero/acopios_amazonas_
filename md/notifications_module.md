# 📢 Módulo de Notificaciones (`NotificationModel` / `NotificationController`)

## 🧩 Descripción general

El módulo **Notification** gestiona las notificaciones internas del sistema.  
Permite crear, listar, marcar como leídas/vistas y eliminar notificaciones asociadas a un usuario.

Cada notificación se guarda en la tabla `notifications` y puede tener los siguientes estados:

- `new`: indica si la notificación es nueva (1) o ya vista (0).
- `read_unread`: indica si la notificación ha sido leída (1) o no (0).
- `deleted_at`: eliminación lógica (soft delete).

---

## 🗄️ Estructura de la tabla `notifications`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `notifications_id` | CHAR(36) | UUID de la notificación |
| `template_key` | VARCHAR(255) | Clave del tipo de notificación |
| `template_params` | JSON | Parámetros dinámicos (opcional) |
| `route` | VARCHAR(255) | Ruta de destino al hacer clic |
| `module` | VARCHAR(255) | Módulo relacionado |
| `rol` | VARCHAR(100) | Rol del destinatario |
| `user_id` | CHAR(36) | Usuario destinatario |
| `new` | TINYINT(1) | 1 = nueva / 0 = vista |
| `read_unread` | TINYINT(1) | 1 = leída / 0 = no leída |
| `created_at` | DATETIME | Fecha de creación |
| `created_by` | CHAR(36) | Usuario creador |
| `updated_at` | DATETIME | Última modificación |
| `updated_by` | CHAR(36) | Usuario que modificó |
| `deleted_at` | DATETIME | Fecha de eliminación lógica |
| `deleted_by` | CHAR(36) | Usuario que eliminó |

---

## ⚙️ Modelo: `NotificationModel`

Ubicación: `/models/NotificationModel.php`

### Métodos principales

| Método | Descripción |
|---------|--------------|
| `listar($limit, $offset, $incluirEliminados, $userId, $soloNuevas, $soloNoLeidas)` | Lista notificaciones con filtros. |
| `listarDeUsuarioActual()` | Lista las notificaciones del usuario en sesión. |
| `obtenerPorId($id)` | Devuelve los datos de una notificación específica. |
| `crear($data)` | Crea una nueva notificación. |
| `actualizar($id, $data)` | Actualiza campos de una notificación existente. |
| `actualizarNew($id, $valor)` | Cambia el flag `new` (0/1). |
| `actualizarReadUnread($id, $valor)` | Cambia el flag `read_unread` (0/1). |
| `marcarTodasComoVistas($userId)` | Marca todas las notificaciones como vistas (`new = 0`). |
| `marcarTodasComoLeidas($userId)` | Marca todas las notificaciones como leídas (`read_unread = 1`). |
| `eliminar($id)` | Elimina lógicamente una notificación. |

---

## 🧠 Controlador: `NotificationController`

Ubicación: `/controllers/NotificationController.php`

### Métodos expuestos

| Método | Ruta | Descripción |
|---------|------|-------------|
| `listar()` | `GET /notifications` | Lista notificaciones con filtros. |
| `listarDeSesion()` | `GET /notifications/mias` | Lista las notificaciones del usuario en sesión. |
| `mostrar($params)` | `GET /notifications/{notifications_id}` | Muestra una notificación específica. |
| `crear()` | `POST /notifications` | Crea una nueva notificación. |
| `actualizar($params)` | `POST /notifications/{notifications_id}` | Actualiza una notificación existente. |
| `actualizarNew($params)` | `POST /notifications/{notifications_id}/flag/new` | Actualiza el flag `new`. |
| `actualizarReadUnread($params)` | `POST /notifications/{notifications_id}/flag/read_unread` | Actualiza el flag `read_unread`. |
| `marcarTodasComoVistas()` | `POST /notifications/marcar_todas_vistas` | Marca todas las notificaciones como vistas (`new=0`). |
| `marcarTodasComoLeidas()` | `POST /notifications/marcar_todas_leidas` | Marca todas las notificaciones como leídas (`read_unread=1`). |
| `eliminar($params)` | `DELETE /notifications/{notifications_id}` | Elimina lógicamente una notificación. |

---

## 🧭 Rutas (`routes.php`)

```php
// endpoints de notificaciones
$router->get('/notifications', [
    'controlador' => NotificationController::class,
    'accion'      => 'listar'
]);

$router->get('/notifications/mias', [
    'controlador' => NotificationController::class,
    'accion'      => 'listarDeSesion'
]);

$router->get('/notifications/{notifications_id}', [
    'controlador' => NotificationController::class,
    'accion'      => 'mostrar'
]);

$router->post('/notifications', [
    'controlador' => NotificationController::class,
    'accion'      => 'crear'
]);

$router->post('/notifications/{notifications_id}', [
    'controlador' => NotificationController::class,
    'accion'      => 'actualizar'
]);

$router->post('/notifications/{notifications_id}/flag/new', [
    'controlador' => NotificationController::class,
    'accion'      => 'actualizarNew'
]);

$router->post('/notifications/{notifications_id}/flag/read_unread', [
    'controlador' => NotificationController::class,
    'accion'      => 'actualizarReadUnread'
]);

$router->post('/notifications/marcar_todas_vistas', [
    'controlador' => NotificationController::class,
    'accion'      => 'marcarTodasComoVistas'
]);

$router->post('/notifications/marcar_todas_leidas', [
    'controlador' => NotificationController::class,
    'accion'      => 'marcarTodasComoLeidas'
]);

$router->delete('/notifications/{notifications_id}', [
    'controlador' => NotificationController::class,
    'accion'      => 'eliminar'
]);
```

---

## 📤 Ejemplos de uso API

### 1️⃣ Crear una notificación
```bash
POST /notifications
Content-Type: application/json

{
  "template_key": "ALERTA_PESO",
  "template_params": {
    "animal": "Toro A12",
    "peso": "470 kg"
  },
  "route": "/panel/animales/A12",
  "module": "ganado",
  "rol": "admin",
  "user_id": "e3357e12-7a73-49c3-b51f-6dfe34151fb5"
}
```

✅ **Respuesta**
```json
{
  "value": true,
  "message": "Notificación creada correctamente.",
  "data": { "notifications_id": "uuid-generado" }
}
```

---

### 2️⃣ Marcar todas como vistas
```bash
POST /notifications/marcar_todas_vistas
```
✅ **Respuesta**
```json
{
  "value": true,
  "message": "Todas las notificaciones marcadas como vistas.",
  "data": { "updated": true }
}
```

---

### 3️⃣ Marcar una como leída
```bash
POST /notifications/1a2b3c4d-5678-90ef/flag/read_unread
Content-Type: application/json

{ "valor": 1 }
```

✅ **Respuesta**
```json
{
  "value": true,
  "message": "Flag read_unread actualizado correctamente.",
  "data": { "updated": true }
}
```

---

### 4️⃣ Eliminar una notificación
```bash
DELETE /notifications/1a2b3c4d-5678-90ef
```

✅ **Respuesta**
```json
{
  "value": true,
  "message": "Notificación eliminada correctamente.",
  "data": { "deleted": true }
}
```

---

## 🧾 Notas adicionales

- Todas las operaciones registran información de auditoría (`created_by`, `updated_by`, etc.) mediante `ClientEnvironmentInfo` y `TimezoneManager`.
- El modelo usa **UUIDv4** para las claves primarias.
- Se emplean **transacciones MySQL** para asegurar integridad.
- Compatible con PHP 7.4+.
