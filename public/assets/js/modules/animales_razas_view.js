import { showErrorToast, showSuccessToast } from '../helpers/helpers.js'
// Asumo que populateSelect no es necesario aquí ya que los selects son estáticos
// Si necesitas cargar Especies/Estados desde una API, puedes añadirlo.

// Helper para construir rutas de la API
const api = (path) => `${baseUrl}api/${path}`

// ==========================================================
// == FORMATTERS Y HELPERS PARA BOOTSTRAP TABLE
// ==========================================================

window.responseHandler = (res) => ({
  rows: res.data ?? [],
  total: res.data?.length ?? 0,
})

// Formateador de estado
window.estadoFormatter = (v, row) => {
  if (row.deleted_at) {
    return '<span class="badge bg-danger">Eliminado</span>'
  }
  if (v === 'ACTIVA') {
    return '<span class="badge bg-success">Activa</span>'
  }
  return '<span class="badge bg-secondary">Inactiva</span>'
}

// Formateador de acciones
window.accionesFormatter = (v, row) => {
  // Si está eliminado (soft delete), muestra 'Restaurar'
  if (row.deleted_at) {
    return `
        <div class="btn-group">
          <button class="btn btn-success btn-sm btn-restaurar" data-id="${v}" title="Restaurar"><i class="mdi mdi-restore"></i></button>
        </div>`
  }
  // Si está activo, muestra 'Editar' y 'Eliminar'
  return `
      <div class="btn-group">
        <button class="btn btn-warning btn-sm btn-editar" data-id="${v}" title="Editar"><i class="mdi mdi-pencil"></i></button>
        <button class="btn btn-danger btn-sm btn-eliminar" data-id="${v}" title="Eliminar"><i class="mdi mdi-delete"></i></button>
      </div>`
}

// ==========================================================
// == LÓGICA PRINCIPAL
// ==========================================================

document.addEventListener('DOMContentLoaded', () => {
  initFiltersAndButtons()
  initRazasTable()
})

/* =========================
     Inicialización
  ========================= */

function initRazasTable() {
  $('#tablaRazas').bootstrapTable({
    queryParams: (params) => {
      //
      const especie = $('#filtroEspecie').val() || ''
      const estado = $('#filtroEstado').val() || ''
      const q = $('#filtroQ').val() || ''
      const incluirEliminados = $('#filtroIncluirEliminados').is(':checked')

      if (especie) params.especie = especie
      if (estado) params.estado = estado
      if (q) params.q = q
      if (incluirEliminados) params.incluirEliminados = 1

      // El 'search' de bootstrap-table es independiente del param 'q' del API
      // Lo mantenemos por consistencia, pero el filtro 'q' es el que usa el modelo
      if (params.search) {
        params.q = params.search
        delete params.search
      }

      return params
    },
  })
}

function initFiltersAndButtons() {
  let debounceTimer
  const $modalRaza = $('#modalRaza')

  // Inicializar Select2 estáticos
  $('#filtroEspecie, #filtroEstado').select2({
    allowClear: true,
  })

  // Botón para crear nueva raza
  $('#btnNuevaRaza').on('click', async () => {
    resetRazaForm()
    $('#modalRazaLabel').text('Nueva Raza')

    // Inicializar Select2 del modal
    $('#especie').select2({
      dropdownParent: $modalRaza,
      placeholder: 'Seleccione una especie...',
    })
    $('#estado').select2({
      dropdownParent: $modalRaza,
      placeholder: 'Seleccione un estado...',
    })

    new bootstrap.Modal($modalRaza[0]).show()
  })

  // Escuchar 'validation:success'
  document
    .getElementById('formRaza')
    .addEventListener('validation:success', submitRaza)

  // Delegación de eventos (Editar, Eliminar, Restaurar)
  $('#tablaRazas').on(
    'click',
    'button.btn-editar, button.btn-eliminar, button.btn-restaurar',
    handleRowAction
  )

  // Botón para resetear filtros
  $('#btnResetFilters').on('click', () => {
    $('#filtroEspecie').val(null).trigger('change')
    $('#filtroEstado').val(null).trigger('change')
    $('#filtroQ').val('')
    $('#filtroIncluirEliminados').prop('checked', false)
    $('#tablaRazas').bootstrapTable('refresh')
  })

  // Refresco de tabla en filtros
  $('#filtroEspecie, #filtroEstado, #filtroIncluirEliminados').on(
    'change',
    () => {
      $('#tablaRazas').bootstrapTable('refresh')
    }
  )

  // Debounce para el filtro 'q'
  $('#filtroQ').on('input', () => {
    clearTimeout(debounceTimer)
    debounceTimer = setTimeout(() => {
      $('#tablaRazas').bootstrapTable('refresh')
    }, 400)
  })
}

/* =========================
     Manejadores de Acciones (CRUD)
  ========================= */

/**
 * Manejador del submit del formulario (Crear o Actualizar)
 *
 */
function submitRaza(e) {
  const body = e.detail.datos
  const razaId = body.raza_id

  let url = api('razas')
  let method = 'POST' //

  if (razaId) {
    url = api(`razas/${razaId}`)
    // El controlador usa POST para actualizar
  }

  // Limpiar opcionales vacíos
  if (body.codigo === '') delete body.codigo
  if (body.descripcion === '') delete body.descripcion

  $.ajax({
    url: url,
    method: method,
    contentType: 'application/json',
    data: JSON.stringify(body),
    dataType: 'json',
    success: function (res) {
      if (res && res.value === true) {
        bootstrap.Modal.getInstance(document.getElementById('modalRaza')).hide()
        $('#tablaRazas').bootstrapTable('refresh')
        showSuccessToast(res)
      } else {
        showErrorToast(res)
      }
    },
    error: function (jqXHR) {
      // Captura 409 (Código duplicado) o 400 (Validación)
      const res = jqXHR.responseJSON || { message: 'Error en la petición' }
      showErrorToast(res)
    },
  })
}

/**
 * Manejador para botones 'editar', 'eliminar' y 'restaurar' de la fila
 */
async function handleRowAction(e) {
  const $btn = $(e.currentTarget)
  const id = $btn.data('id')

  // --- Eliminar (Soft Delete) ---
  if ($btn.hasClass('btn-eliminar')) {
    const ok = await Swal.fire({
      title: '¿Estás seguro?',
      text: 'La raza será eliminada lógicamente (soft delete).', //
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar',
    })
    if (!ok.isConfirmed) return

    //
    $.ajax({
      url: api(`razas/${id}`),
      method: 'DELETE',
      dataType: 'json',
      success: function (res) {
        if (res && res.value === true) {
          $('#tablaRazas').bootstrapTable('refresh')
          showSuccessToast(res)
        } else {
          showErrorToast(res)
        }
      },
      error: function (jqXHR) {
        showErrorToast(jqXHR.responseJSON || { message: 'No se pudo eliminar' })
      },
    })
    return
  }

  // --- Restaurar ---
  if ($btn.hasClass('btn-restaurar')) {
    const ok = await Swal.fire({
      title: '¿Restaurar Raza?',
      text: 'La raza volverá a estar activa.',
      icon: 'info',
      showCancelButton: true,
      confirmButtonText: 'Sí, restaurar',
      cancelButtonText: 'Cancelar',
    })
    if (!ok.isConfirmed) return

    //
    $.ajax({
      url: api(`razas/${id}/restaurar`),
      method: 'POST', //
      dataType: 'json',
      success: function (res) {
        if (res && res.value === true) {
          $('#tablaRazas').bootstrapTable('refresh')
          showSuccessToast(res)
        } else {
          showErrorToast(res)
        }
      },
      error: function (jqXHR) {
        showErrorToast(
          jqXHR.responseJSON || { message: 'No se pudo restaurar' }
        )
      },
    })
    return
  }

  // --- Editar ---
  if ($btn.hasClass('btn-editar')) {
    //
    $.ajax({
      url: api(`razas/${id}`),
      method: 'GET',
      dataType: 'json',
      success: async function (res) {
        if (res && res.value === true) {
          const data = res.data
          resetRazaForm()

          // Llenar campos
          $('#raza_id').val(data.raza_id)
          $('#nombre').val(data.nombre)
          $('#codigo').val(data.codigo)
          $('#descripcion').val(data.descripcion)

          $('#modalRazaLabel').text('Editar Raza')

          // Inicializar y establecer valores de Select2
          const $modalRaza = $('#modalRaza')
          $('#especie')
            .select2({ dropdownParent: $modalRaza })
            .val(data.especie)
            .trigger('change')
          $('#estado')
            .select2({ dropdownParent: $modalRaza })
            .val(data.estado)
            .trigger('change')

          new bootstrap.Modal($modalRaza[0]).show()
        } else {
          showErrorToast(res)
        }
      },
      error: function (jqXHR) {
        showErrorToast(
          jqXHR.responseJSON || { message: 'Error al cargar datos' }
        )
      },
    })
  }
}

/* =========================
     Reseteo
  ========================= */
function resetRazaForm() {
  const form = $('#formRaza')[0]
  if (form) {
    form.reset()
    // Resetear selects estáticos del modal
    $('#especie').val(null).trigger('change')
    $('#estado').val(null).trigger('change')
    window.limpiarErroresDelFormulario?.(form)
  }
}
