# Documentación del Endpoint: Autenticación de App

Este documento detalla el funcionamiento del endpoint diseñado para la autenticación de usuarios desde aplicaciones externas (móviles o de escritorio), gestionando el token único del dispositivo.

## Endpoint: `POST /system_users/login_app`

---

### Descripción General

Este endpoint autentica a un usuario utilizando su **email** y **contraseña**. Además, recibe un **token** único del dispositivo.

Si la autenticación es exitosa, el sistema:
1.  Verifica si el token del dispositivo ha cambiado.
2.  Si es nuevo o diferente, actualiza el campo `dispositivo_token` del usuario en la base de datos.
3.  Devuelve los datos del usuario, incluyendo su nombre, nivel y la lista de permisos asignados (si no es administrador).

---

### Solicitud (Request)

El `Content-Type` de la solicitud debe ser `application/json`.

#### Parámetros del Body (JSON)

| Parámetro | Tipo | Requerido | Descripción |
| :--- | :--- | :--- | :--- |
| `email` | String | Sí | Correo electrónico del usuario. |
| `password` | String | Sí | Contraseña del usuario (sin encriptar). |
| `token` | String | Sí | Identificador único del dispositivo. (También acepta `dispositivo_token`). |

#### Ejemplo de Body (JSON)

```json
{
  "email": "usuario@ejemplo.com",
  "password": "mi_contraseña_123",
  "token": "fcm_token_o_uuid_del_dispositivo_aqui"
}
Respuestas (Responses)
Todas las respuestas siguen un formato estándar:

JSON

{
  "value": true, // booleano (true para éxito, false para error)
  "message": "...", // string (descripción del resultado)
  "data": { ... } // object (payload con los datos)
}
✅ Respuesta Exitosa (200 OK)
Se devuelve cuando las credenciales son correctas y el usuario está activo.

JSON

{
  "value": true,
  "message": "Login exitoso.",
  "data": {
    "nombre": "Nombre Apellido del Usuario",
    "nivel": 1,
    "permisos": [
      {
        "users_permisos_id": "uuid-permiso-1",
        "user_id": "uuid-usuario",
        "menu": {
          "menu_id": "uuid-menu-1",
          "categoria": "animales",
          "nombre": "Gestión de Rebaño",
          "url": "animales",
          "icono": "mdi mdi-sheep",
          "user_level": 1
        }
      },
      {
        "users_permisos_id": "uuid-permiso-2",
        "user_id": "uuid-usuario",
        "menu": {
          "menu_id": "uuid-menu-2",
          "categoria": "finca",
          "nombre": "Fincas",
          "url": "fincas",
          "icono": "mdi mdi-office-building-marker",
          "user_level": 1
        }
      }
    ]
  }
}
Nota: Si el nivel es 0 (Administrador), el campo permisos se devolverá como null.

❌ Respuestas de Error
400 Bad Request (Campos faltantes)

JSON

{
  "value": false,
  "message": "Email, contraseña y token son obligatorios.",
  "data": null
}
400 Bad Request (Email inválido)

JSON

{
  "value": false,
  "message": "El formato del correo electrónico no es válido.",
  "data": null
}
401 Unauthorized (Credenciales incorrectas)

JSON

{
  "value": false,
  "message": "Contraseña incorrecta.", // o "Usuario no encontrado."
  "data": {
    "nombre": "Nombre Apellido del Usuario", // Puede incluir el nombre si se encontró el email
    "nivel": null,
    "permisos": null
  }
}
401 Unauthorized (Usuario desactivado)

JSON

{
  "value": false,
  "message": "El usuario está desactivado.",
  "data": {
    "nombre": "Nombre Apellido del Usuario",
    "nivel": null,
    "permisos": null
  }
}
500 Internal Server Error

JSON

{
  "value": false,
  "message": "Error interno del servidor: [mensaje de la excepción]",
  "data": null
}
🔒 Lógica de Gestión del Token
El manejo del token del dispositivo es una parte central de este endpoint:

El usuario envía email, password y el token de su dispositivo.

El sistema valida las credenciales (loginConToken en SystemUserModel).

Si las credenciales son correctas:

El sistema consulta el dispositivo_token actualmente guardado en la tabla system_users para ese usuario.

Caso A (Tokens diferentes): Si el token recibido es diferente al dispositivo_token guardado (o si el guardado es NULL), el sistema llama a actualizarToken.

Caso B (Tokens iguales): Si el token recibido es igual al guardado, no se realiza ninguna actualización en la base de datos.

La función actualizarToken actualiza la columna dispositivo_token del usuario con el nuevo token recibido.