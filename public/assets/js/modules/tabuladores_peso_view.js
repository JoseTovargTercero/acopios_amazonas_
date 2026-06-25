import { showErrorToast, showSuccessToast } from '../helpers/helpers.js'
// Asumo que populateSelect no es necesario aquí
// import { populateSelect } from '../helpers/populateSelect.js'

// Helper para construir rutas de la API
const api = (path) => `${baseUrl}api/${path}`

// Variable global para el modal de gestión
let currentRazaId = null
const $modalGestion = new bootstrap.Modal(
  document.getElementById('modalGestionRangos')
)
const $formRango = $('#formRango')
const $btnSubmitRango = $('#btnSubmitRango')
const $btnCancelarEdicion = $('#btnCancelarEdicionRango')
const $formRangoTitulo = $('#formRangoTitulo')
const $tablaRangosBody = $('#tablaRangosBody')
const $rangosLoader = $('#rangos-loader')

// ==========================================================
// == FORMATTERS Y HELPERS
// ==========================================================

window.responseHandler = (res) => ({
  rows: res.data ?? [],
  total: res.data?.length ?? 0,
})

// Formateador de estado para la tabla de Razas
window.estadoRazaFormatter = (v, row) => {
  if (row.deleted_at) {
    return '<span class="badge bg-danger">Eliminado</span>'
  }
  if (v === 'ACTIVA') {
    return '<span class="badge bg-success">Activa</span>'
  }
  return '<span class="badge bg-secondary">Inactiva</span>'
}

// Formateador de acciones para la tabla de Razas
window.gestionarFormatter = (v, row) => {
  // Solo mostramos 'Gestionar' si la raza está ACTIVA
  if (row.estado === 'ACTIVA' && !row.deleted_at) {
    return `
      <button class="btn btn-primary btn-sm btn-gestionar" 
        data-id="${v}" 
        data-nombre="${row.nombre}" 
        title="Gestionar Rangos">
        <i class="mdi mdi-scale-balance"></i> Gestionar Rangos
      </button>`
  }
  return '<span class="text-muted">N/A</span>'
}

// Formateador de peso (simple)
const formatPeso = (v) => (v ? `${parseFloat(v).toFixed(2)} kg` : '-')

// ==========================================================
// == LÓGICA PRINCIPAL
// ==========================================================

document.addEventListener('DOMContentLoaded', () => {
  initFiltersAndTable()
  initGestionModal()
})

/* =========================
   Inicialización
========================= */

function initFiltersAndTable() {
  // Inicializar Select2 de filtro
  $('#filtroEspecie').select2({
    allowClear: true,
  })

  // Cargar tabla de Razas
  $('#tablaRazas').bootstrapTable({
    queryParams: (params) => {
      //
      const especie = $('#filtroEspecie').val() || ''
      if (especie) params.especie = especie
      // Filtramos solo activas, no tiene sentido gestionar tabuladores de razas inactivas
      params.estado = 'ACTIVA'

      // Manejo del search
      if (params.search) {
        params.q = params.search
        delete params.search
      }
      return params
    },
  })

  // Refresco de tabla
  $('#filtroEspecie').on('change', () => {
    $('#tablaRazas').bootstrapTable('refresh')
  })

  // Delegación de eventos (Gestionar)
  $('#tablaRazas').on('click', 'button.btn-gestionar', function () {
    const $btn = $(this)
    currentRazaId = $btn.data('id')
    const razaNombre = $btn.data('nombre')

    $('#modalGestionLabel').text(`Gestionar Rangos para: ${razaNombre}`)

    // Resetear formulario de añadir
    resetRangoForm()

    // Cargar los rangos existentes
    cargarRangos(currentRazaId)

    $modalGestion.show()
  })
}

/* =========================
   Lógica del Modal de Gestión
========================= */

function initGestionModal() {
  // Submit del formulario (Crear o Actualizar)
  document
    .getElementById('formRango')
    .addEventListener('validation:success', submitRango)

  // Cancelar edición
  $btnCancelarEdicion.on('click', resetRangoForm)

  // Delegación de eventos (Editar/Eliminar Rango)
  $tablaRangosBody.on('click', 'button', handleRangoAction)
}

/**
 * Carga la lista de rangos para la raza seleccionada
 *
 */
async function cargarRangos(razaId) {
  $rangosLoader.show()
  $tablaRangosBody.empty()

  try {
    // Usamos el filtro 'raza_id' del API
    const res = await $.ajax({
      url: api('tabuladores_peso'),
      method: 'GET',
      data: { raza_id: razaId },
      dataType: 'json',
    })

    if (!res || res.value !== true) {
      throw new Error(res.message || 'Error cargando rangos')
    }

    if (res.data.length === 0) {
      $tablaRangosBody.html(
        '<tr><td colspan="4" class="text-center text-muted">No hay rangos definidos para esta raza.</td></tr>'
      )
    } else {
      //
      const html = res.data
        .map((rango) => {
          const pIdeal = parseFloat(rango.peso_ideal)
          const pMin = parseFloat(rango.margen_min)
          const pMax = parseFloat(rango.margen_max)
          const rangoAceptable = `${(pIdeal - pMin).toFixed(2)} - ${(
            pIdeal + pMax
          ).toFixed(2)} kg`

          // Guardamos toda la data en el botón de editar
          return `
                    <tr>
                        <td>${rango.edad_min_dias} - ${
            rango.edad_max_dias
          } días</td>
                        <td>${formatPeso(rango.peso_ideal)}</td>
                        <td>${rangoAceptable}</td>
                        <td>
                            <div class="btn-group">
                                <button class="btn btn-warning btn-xs btn-editar-rango" 
                                    data-id="${rango.tab_peso_id}"
                                    data-min="${rango.edad_min_dias}"
                                    data-max="${rango.edad_max_dias}"
                                    data-ideal="${rango.peso_ideal}"
                                    data-mmin="${rango.margen_min}"
                                    data-mmax="${rango.margen_max}"
                                    title="Editar">
                                    <i class="mdi mdi-pencil"></i>
                                </button>
                                <button class="btn btn-danger btn-xs btn-eliminar-rango" 
                                    data-id="${rango.tab_peso_id}" 
                                    title="Eliminar">
                                    <i class="mdi mdi-delete"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `
        })
        .join('')
      $tablaRangosBody.html(html)
    }
  } catch (error) {
    showErrorToast({
      message: error.message || 'No se pudieron cargar los rangos.',
    })
    $tablaRangosBody.html(
      `<tr><td colspan="4" class="text-center text-danger">Error al cargar datos.</td></tr>`
    )
  } finally {
    $rangosLoader.hide()
  }
}

/**
 * Maneja el submit del formulario de rango (Crear o Actualizar)
 */
function submitRango(e) {
  const body = e.detail.datos
  const tabId = body.tab_peso_id

  // Añadimos la raza que estamos gestionando
  body.raza_id = currentRazaId

  let url = api('tabuladores_peso')
  let method = 'POST' //

  if (tabId) {
    url = api(`tabuladores_peso/${tabId}`)
    // El controlador usa POST para actualizar
  }

  $.ajax({
    url: url,
    method: method,
    contentType: 'application/json',
    data: JSON.stringify(body),
    dataType: 'json',
    success: function (res) {
      if (res && res.value === true) {
        showSuccessToast(res)
        resetRangoForm()
        cargarRangos(currentRazaId) // Recargar la lista
      } else {
        showErrorToast(res)
      }
    },
    error: function (jqXHR) {
      // Captura 409 (Solapamiento) o 400 (Validación)
      const res = jqXHR.responseJSON || { message: 'Error en la petición' }
      showErrorToast(res)
    },
  })
}

/**
 * Maneja los botones de Editar y Eliminar de la tabla de rangos
 */
async function handleRangoAction(e) {
  const $btn = $(e.currentTarget)
  const id = $btn.data('id')

  // --- Eliminar Rango ---
  if ($btn.hasClass('btn-eliminar-rango')) {
    const ok = await Swal.fire({
      title: '¿Estás seguro?',
      text: 'El rango será eliminado permanentemente (borrado físico).', //
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar',
    })
    if (!ok.isConfirmed) return

    //
    $.ajax({
      url: api(`tabuladores_peso/${id}`),
      method: 'DELETE',
      dataType: 'json',
      success: function (res) {
        if (res && res.value === true) {
          showSuccessToast(res)
          cargarRangos(currentRazaId) // Recargar la lista
        } else {
          showErrorToast(res)
        }
      },
      error: function (jqXHR) {
        showErrorToast(jqXHR.responseJSON || { message: 'No se pudo eliminar' })
      },
    })
  }

  // --- Editar Rango ---
  if ($btn.hasClass('btn-editar-rango')) {
    // Llenar el formulario de arriba con los datos del botón
    $formRango.find('#tab_peso_id').val(id)
    $formRango.find('#edad_min_dias').val($btn.data('min'))
    $formRango.find('#edad_max_dias').val($btn.data('max'))
    $formRango.find('#peso_ideal').val($btn.data('ideal'))
    $formRango.find('#margen_min').val($btn.data('mmin'))
    $formRango.find('#margen_max').val($btn.data('mmax'))

    // Cambiar UI del formulario
    $formRangoTitulo.text('Actualizar Rango')
    $btnSubmitRango
      .html('<i class="mdi mdi-check"></i> Actualizar Rango')
      .removeClass('btn-primary')
      .addClass('btn-success')
    $btnCancelarEdicion.show()

    // Foco
    $formRango.find('#edad_min_dias').focus()
  }
}

/**
 * Resetea el formulario de añadir/editar rango
 */
function resetRangoForm() {
  $formRango[0].reset()
  $formRango.find('#tab_peso_id').val('')
  window.limpiarErroresDelFormulario?.($formRango[0])

  // Restaurar UI del formulario
  $formRangoTitulo.text('Añadir Nuevo Rango')
  $btnSubmitRango
    .html('<i class="mdi mdi-plus"></i> Añadir Rango')
    .removeClass('btn-success')
    .addClass('btn-primary')
  $btnCancelarEdicion.hide()
}
