// CAMBIO 1: Importamos la nueva función showSuccessToast
import { showErrorToast, showSuccessToast } from '../helpers/helpers.js'

/**
 * Maneja la respuesta de la API para adaptarla al formato que Bootstrap Table espera.
 * Tu API (ConfiguracionesController::listar) devuelve { value: true, message: "...", data: [...] }
 * Bootstrap Table necesita { "rows": [...] }.
 */
window.responseHandler = function (res) {
  if (res.value && Array.isArray(res.data)) {
    return {
      rows: res.data,
      total: res.data.length,
    }
  } else {
    // Si la API falla, muestra una tabla vacía
    showErrorToast({ message: res.message || 'Error cargando datos.' })
    return {
      rows: [],
      total: 0,
    }
  }
}

/**
 * Da formato a la columna 'Valor' con badges de color para 0 y 1.
 */
window.valorFormatter = function (value, row) {
  if (String(value) === '1') {
    return '<span class="badge bg-success fs-6">Activado (1)</span>'
  }
  if (String(value) === '0') {
    return '<span class="badge bg-danger fs-6">Desactivado (0)</span>'
  }
  // Para otros valores (texto, números), solo muéstralos
  return `<span class="badge bg-secondary fs-6">${value}</span>`
}

/**
 * Da formato legible a las fechas.
 */
window.dateFormatter = function (value, row) {
  if (!value) {
    return 'N/A'
  }
  return new Date(value).toLocaleString()
}

/**
 * Genera el botón de "Editar" para cada fila.
 * @param {string} value - El config_key para esta fila.
 */
window.accionesFormatter = function (value, row) {
  return `
    <button class="btn btn-warning btn-sm btn-editar" data-id="${value}" title="Editar Configuración">
        <i class="mdi mdi-pencil"></i>
    </button>
  `
}

// --- Lógica principal al cargar la página ---
document.addEventListener('DOMContentLoaded', function () {
  // Inicializa el modal de Bootstrap
  const modalConfig = new bootstrap.Modal(
    document.getElementById('modalConfiguracion')
  )
  const formConfig = document.getElementById('formConfiguracion')
  const valorInputContainer = document.getElementById('valorInputContainer')

  /**
   * Maneja el clic en el botón "Editar" de la tabla.
   */
  $('#tablaConfiguraciones').on('click', '.btn-editar', function () {
    const configKey = $(this).data('id')

    // 1. Obtener datos de la API
    $.ajax({
      url: baseUrl + `api/configuraciones/${configKey}`,
      method: 'GET',
      success: function (response) {
        if (!response.value || !response.data) {
          showErrorToast({ message: 'No se pudieron cargar los detalles.' })
          return
        }
        const data = response.data

        // 2. Rellenar campos del modal
        $('#config_key').val(data.config_key)
        $('#detalle_clave').text(data.config_key)
        $('#detalle_descripcion').text(data.descripcion || 'Sin descripción.')

        // 3. Lógica "inteligente" para crear el input correcto
        valorInputContainer.innerHTML = '' // Limpiar contenedor
        const valor = String(data.config_value)

        if (valor === '0' || valor === '1') {
          // Es un booleano (0 o 1), mostrar un Switch
          const isChecked = valor === '1' ? 'checked' : ''
          valorInputContainer.innerHTML = `
            <div class="form-check form-switch form-switch-lg">
                <input class="form-check-input" type="checkbox" 
                       id="config_value_switch" name="config_value" 
                       value="1" ${isChecked}>
                <label class="form-check-label" for="config_value_switch">
                    ${isChecked ? 'Activado' : 'Desactivado'}
                </label>
            </div>
          `
          // Añadir listener para cambiar el label del switch
          $('#config_value_switch').on('change', function () {
            $(this)
              .next('label')
              .text($(this).is(':checked') ? 'Activado' : 'Desactivado')
          })
        } else {
          // Es un texto o número, mostrar un input de texto
          valorInputContainer.innerHTML = `
            <input type="text" class="form-control" 
                   id="config_value_text" name="config_value" 
                   value="${valor}">
          `
        }

        // 4. Mostrar el modal
        modalConfig.show()
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  /**
   * Maneja el envío del formulario de edición.
   */
  $(formConfig).on('submit', function (e) {
    e.preventDefault()
    const configKey = $('#config_key').val()
    if (!configKey) {
      showErrorToast({
        message: 'Error: Clave de configuración no encontrada.',
      })
      return
    }

    // Determinar el valor (depende de si es un switch o un input de texto)
    const input = $(this).find('[name="config_value"]')
    let valorFinal

    if (input.attr('type') === 'checkbox') {
      // Es el switch
      valorFinal = input.is(':checked') ? '1' : '0'
    } else {
      // Es el input de texto
      valorFinal = input.val()
    }

    // El controlador espera un JSON { "config_value": "..." }
    const payload = {
      config_value: valorFinal,
    }

    // 2. Enviar por AJAX (POST, como en tu router)
    $.ajax({
      url: baseUrl + `api/configuraciones/${configKey}`,
      method: 'POST', // Usamos POST como definiste en tu router para actualizar
      contentType: 'application/json',
      data: JSON.stringify(payload),
      success: function (response) {
        if (response.value) {
          modalConfig.hide()

          // CAMBIO 2: Usamos tu nueva función de toast
          showSuccessToast(response)

          // Recargar la tabla para mostrar el nuevo valor
          $('#tablaConfiguraciones').bootstrapTable('refresh')
        } else {
          showErrorToast(response)
        }
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })
})
