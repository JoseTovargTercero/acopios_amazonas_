import { showErrorToast } from "../helpers/helpers.js";

// --- HELPERS Y FORMATTERS PARA LA TABLA ---

/**
 * Adapta la respuesta de la API al formato que Bootstrap Table espera.
 */
window.responseHandler = function (res) {
  return {
    rows: res.data,
    total: res.data.length, // O idealmente un valor desde la API si hay paginación del lado del servidor
  };
};

/**
 * Formatea la columna de acciones con los botones.
 */
window.accionesFormatter = function (value, row) {
  return `
  <div class="btn-group gap-1">
      <button class="btn btn-info btn-sm btn-ver" data-id="${value}" title="Ver Detalles">
          <i class="mdi mdi-eye"></i>
      </button>
     
      ${
        row.estado_periodo === "ABIERTO"
          ? `
      <button class="btn btn-success btn-sm btn-editar" data-id="${value}" title="Agregar servicio">
          <i class="mdi mdi-pencil-plus"></i>
      </button>

      <button class="btn btn-info text-white btn-sm btn-revision-periodo" data-id="${value}" title="Pasar a revisión">
          <i class="mdi mdi-send-check"></i>
      </button>
      <button class="btn btn-danger btn-sm btn-eliminar" data-id="${value}" title="Eliminar">
          <i class="mdi mdi-delete"></i>
      </button>`
          : ""
      }

  </div>`;
};
