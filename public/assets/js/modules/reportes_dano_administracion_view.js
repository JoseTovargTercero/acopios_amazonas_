import { showErrorToast, formatDate } from '../helpers/helpers.js'
import { populateSelect } from '../helpers/populateSelect.js'

// Helper para construir rutas de la API (Sin cambios)
const api = (path) => `${baseUrl}api/${path}`

// ==========================================================
// == FORMATTERS Y HELPERS PARA BOOTSTRAP TABLE (Sin cambios) ==
// ==========================================================

window.responseHandler = (res) => ({
  rows: res.data ?? [],
  total: res.data?.length ?? 0,
})

window.reporteFechaFormatter = (v) => (v ? formatDate(v) : '-')

window.criticidadFormatter = (v) => {
  if (v === 'ALTA') return '<span class="badge bg-danger">Alta</span>'
  if (v === 'MEDIA')
    return '<span class="badge bg-warning text-dark">Media</span>'
  return '<span class="badge bg-success">Baja</span>'
}

window.reporteEstadoFormatter = (v) => {
  if (v === 'EN_PROCESO')
    return '<span class="badge bg-info text-dark">En Proceso</span>'
  if (v === 'CERRADO') return '<span class="badge bg-secondary">Cerrado</span>'
  return '<span class="badge bg-primary">Abierto</span>'
}

window.reporteAccionesFormatter = (v, row) => {
  const id = v
  const estado = row.estado_reporte

  let buttons = `
    <button class="btn btn-info btn-sm btn-ver" data-id="${id}" title="Ver"><i class="mdi mdi-eye"></i></button>
    <button class="btn btn-danger btn-sm btn-eliminar" data-id="${id}" title="Eliminar"><i class="mdi mdi-delete"></i></button>
  `
  if (estado === 'ABIERTO') {
    buttons += `<button class="btn btn-info btn-sm btn-cambiar-estado" data-id="${id}" data-nuevo-estado="EN_PROCESO" title="Marcar En Proceso"><i class="mdi mdi-play-circle-outline"></i></button>`
    buttons += `<button class="btn btn-secondary btn-sm btn-cambiar-estado" data-id="${id}" data-nuevo-estado="CERRADO" title="Marcar Cerrado"><i class="mdi mdi-check-circle-outline"></i></button>`
  } else if (estado === 'EN_PROCESO') {
    buttons += `<button class="btn btn-secondary btn-sm btn-cambiar-estado" data-id="${id}" data-nuevo-estado="CERRADO" title="Marcar Cerrado"><i class="mdi mdi-check-circle-outline"></i></button>`
    buttons += `<button class="btn btn-primary btn-sm btn-cambiar-estado" data-id="${id}" data-nuevo-estado="ABIERTO" title="Re-abrir"><i class="mdi mdi-lock-open-outline"></i></button>`
  } else if (estado === 'CERRADO') {
    buttons += `<button class="btn btn-primary btn-sm btn-cambiar-estado" data-id="${id}" data-nuevo-estado="ABIERTO" title="Re-abrir"><i class="mdi mdi-lock-open-outline"></i></button>`
  }

  return `<div class="btn-group">${buttons}</div>`
}

// ==========================================================
// == LÓGICA PRINCIPAL (Sin cambios) ==
// ==========================================================

document.addEventListener('DOMContentLoaded', () => {
  initFiltersAndButtons()
  initReportesTable()
})

/* =========================
   Helpers de Fetch (Sin cambios)
========================= */
async function jget(url) {
  const r = await fetch(url)
  const j = await r.json().catch(() => ({}))
  if (!j || j.value !== true) throw new Error(j?.message || 'Error de servidor')
  return j
}

async function jsend(url, method, body) {
  const r = await fetch(url, {
    method,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
  const j = await r.json().catch(() => ({}))
  if (!j || j.value !== true)
    throw new Error(j?.message || 'Operación no completada')
  return j
}

async function jdel(url) {
  const r = await fetch(url, { method: 'DELETE' })
  const j = await r.json().catch(() => ({}))
  if (!j || j.value !== true)
    throw new Error(j?.message || 'No se pudo eliminar')
  return j
}

/* =========================
   Inicialización
========================= */
function initReportesTable() {
  // (Sin cambios)
  $('#tablaReportes').bootstrapTable({
    queryParams: (params) => {
      const f = $('#filtroFinca').val() || ''
      const a = $('#filtroAprisco').val() || ''
      const r = $('#filtroArea').val() || ''
      const rec = $('#filtroRecinto').val() || ''
      const e = $('#filtroEstado').val() || ''
      const c = $('#filtroCriticidad').val() || ''
      if (f) params.finca_id = f
      if (a) params.aprisco_id = a
      if (r) params.area_id = r
      if (rec) params.recinto_id = rec
      if (e) params.estado_reporte = e
      if (c) params.criticidad = c
      return params
    },
  })
}

function initFiltersAndButtons() {
  const areaTextField = (item) =>
    item.nombre_personalizado ||
    (item.numeracion ? `Área ${item.numeracion}` : item.area_id.substring(0, 8))

  const recintoTextField = (item) =>
    item.codigo_recinto || item.recinto_id.substring(0, 8)

  const modalSelectOptions = {
    useSelect2: true,
    select2Options: { dropdownParent: $('#modalReporte form') },
  }

  // Carga inicial de filtros (Sin cambios)
  populateSelect({
    selector: '#filtroFinca',
    url: api('fincas'),
    placeholder: 'Todas',
    valueField: 'finca_id',
    textField: 'nombre',
    useSelect2: true,
  })
  populateSelect({
    selector: '#filtroAprisco',
    url: api('apriscos'),
    placeholder: 'Todos',
    valueField: 'aprisco_id',
    textField: 'nombre',
    useSelect2: true,
  })
  populateSelect({
    selector: '#filtroArea',
    url: api('areas'),
    placeholder: 'Todas',
    valueField: 'area_id',
    textField: areaTextField,
    useSelect2: true,
  })
  populateSelect({
    selector: '#filtroRecinto',
    url: api('recintos'),
    placeholder: 'Todos',
    valueField: 'recinto_id',
    textField: recintoTextField,
    useSelect2: true,
  })

  // [CAMBIO] Arreglo para limpiar Select2.
  // Quitar 'placeholder' explícito, ya que lo toma del <option value="">
  $('#filtroEstado, #filtroCriticidad').select2({
    allowClear: true,
  })

  // Botón para crear nuevo reporte (Sin cambios)
  $('#btnNuevoReporte').on('click', async () => {
    resetReporteForm()
    $('#modalReporteLabel').text('Nuevo Reporte de Daño')
    await populateSelect({
      ...modalSelectOptions,
      selector: '#finca_id',
      url: api('fincas'),
      placeholder: 'Ninguna',
      valueField: 'finca_id',
      textField: 'nombre',
    })
    await populateSelect({
      ...modalSelectOptions,
      selector: '#aprisco_id',
      url: api('apriscos'),
      placeholder: 'Ninguno',
      valueField: 'aprisco_id',
      textField: 'nombre',
    })
    await populateSelect({
      ...modalSelectOptions,
      selector: '#area_id',
      url: api('areas'),
      placeholder: 'Ninguna',
      valueField: 'area_id',
      textField: areaTextField,
    })
    await populateSelect({
      ...modalSelectOptions,
      selector: '#recinto_id',
      url: api('recintos'),
      placeholder: 'Ninguno',
      valueField: 'recinto_id',
      textField: recintoTextField,
    })
    new bootstrap.Modal('#modalReporte').show()
  })

  // Escuchar 'validation:success' (Sin cambios)
  document
    .getElementById('formReporte')
    .addEventListener('validation:success', submitReporte)

  // [CAMBIO] Delegación de eventos AÑADE 'btn-cambiar-estado-modal'
  $(document).on(
    'click',
    'button.btn-ver, button.btn-eliminar, button.btn-cambiar-estado, button.btn-cambiar-estado-modal',
    handleRowAction
  )

  // [CAMBIO] Botón para resetear filtros
  $('#btnResetFilters').on('click', () => {
    $('#filtroEstado').val(null).trigger('change')
    $('#filtroCriticidad').val(null).trigger('change')
    $('#filtroAprisco').val(null).trigger('change.select2')
    $('#filtroArea').val(null).trigger('change.select2')
    $('#filtroRecinto').val(null).trigger('change.select2')
    $('#filtroFinca').val(null).trigger('change')
  })

  // Filtros en cascada
  $('#filtroFinca').on('change', async function () {
    const fincaId = this.value || ''
    const apriscoUrl = fincaId
      ? api(`apriscos?finca_id=${fincaId}`)
      : api('apriscos')
    await populateSelect({
      selector: '#filtroAprisco',
      url: apriscoUrl,
      placeholder: 'Todos',
      valueField: 'aprisco_id',
      textField: 'nombre',
      useSelect2: true,
    })
    $('#filtroAprisco').trigger('change')
  })

  $('#filtroAprisco').on('change', async function () {
    const apriscoId = this.value || ''
    const areaUrl = apriscoId
      ? api(`areas?aprisco_id=${apriscoId}`)
      : api('areas')
    await populateSelect({
      selector: '#filtroArea',
      url: areaUrl,
      placeholder: 'Todas',
      valueField: 'area_id',
      textField: areaTextField,
      useSelect2: true,
    })
    // [CAMBIO] Quitar refresco de aquí
    $('#filtroArea').trigger('change')
  })

  $('#filtroArea').on('change', async function () {
    const areaId = this.value || ''
    const recintoUrl = areaId
      ? api(`recintos?area_id=${areaId}`)
      : api('recintos')
    await populateSelect({
      selector: '#filtroRecinto',
      url: recintoUrl,
      placeholder: 'Todos',
      valueField: 'recinto_id',
      textField: recintoTextField,
      useSelect2: true,
    })
    $('#filtroRecinto').trigger('change')
  })

  // [CAMBIO] Solo los filtros "finales" refrescan la tabla
  $('#filtroRecinto, #filtroEstado, #filtroCriticidad').on(
    'change',
    function () {
      if (!$(this).is('#filtroFinca, #filtroAprisco, #filtroArea')) {
        $('#tablaReportes').bootstrapTable('refresh')
      }
    }
  )

  // Selects en cascada dentro del modal (Sin cambios)
  $('#finca_id').on('change', async function () {
    const fincaId = this.value || ''
    const apriscoUrl = fincaId
      ? api(`apriscos?finca_id=${fincaId}`)
      : api('apriscos')
    await populateSelect({
      ...modalSelectOptions,
      selector: '#aprisco_id',
      url: apriscoUrl,
      placeholder: 'Ninguno',
      valueField: 'aprisco_id',
      textField: 'nombre',
    })
    $('#aprisco_id').trigger('change')
  })
  $('#aprisco_id').on('change', async function () {
    const apriscoId = this.value || ''
    const areaUrl = apriscoId
      ? api(`areas?aprisco_id=${apriscoId}`)
      : api('areas')
    await populateSelect({
      ...modalSelectOptions,
      selector: '#area_id',
      url: areaUrl,
      placeholder: 'Ninguna',
      valueField: 'area_id',
      textField: areaTextField,
    })
    $('#area_id').trigger('change')
  })
  $('#area_id').on('change', async function () {
    const areaId = this.value || ''
    const recintoUrl = areaId
      ? api(`recintos?area_id=${areaId}`)
      : api('recintos')
    await populateSelect({
      ...modalSelectOptions,
      selector: '#recinto_id',
      url: recintoUrl,
      placeholder: 'Ninguna',
      valueField: 'recinto_id',
      textField: recintoTextField,
    })
  })
}

/* =========================
   Manejadores de Acciones
========================= */

// submitReporte (Solo crear) (Sin cambios)
async function submitReporte(e) {
  const body = e.detail.datos
  body.finca_id = body.finca_id || null
  body.aprisco_id = body.aprisco_id || null
  body.area_id = body.area_id || null
  body.recinto_id = body.recinto_id || null
  const url = api('reportes_dano')
  try {
    const res = await jsend(url, 'POST', body)
    bootstrap.Modal.getInstance(document.getElementById('modalReporte')).hide()
    $('#tablaReportes').bootstrapTable('refresh')
    Swal.fire('Éxito', res.message || 'Reporte guardado', 'success')
  } catch (err) {
    showErrorToast({ message: err.message })
  }
}

// [CAMBIO] handleRowAction ahora maneja botones de fila Y de modal
async function handleRowAction(e) {
  const $btn = $(e.currentTarget)

  // [CAMBIO] Lógica para botones de cambio de estado en MODAL
  if ($btn.hasClass('btn-cambiar-estado-modal')) {
    const modalEl = document.getElementById('modalDetalle')
    const id = modalEl.dataset.reporteId // Obtener ID desde el modal
    const nuevoEstado = $btn.data('nuevo-estado')

    // Ocultar modal antes de mostrar Swal
    bootstrap.Modal.getInstance(modalEl).hide()

    // Reutilizar la función de cambio de estado
    handleChangeEstado(id, nuevoEstado)
    return
  }

  // Lógica para botones de la FILA
  const id = $btn.data('id')
  const url = api(`reportes_dano/${id}`)

  // [CAMBIO] Lógica para botones de cambio de estado en FILA
  if ($btn.hasClass('btn-cambiar-estado')) {
    const nuevoEstado = $btn.data('nuevo-estado')
    handleChangeEstado(id, nuevoEstado)
    return
  }

  if ($btn.hasClass('btn-eliminar')) {
    const ok = await Swal.fire({
      title: '¿Estás seguro?',
      text: 'El reporte será eliminado (borrado lógico).',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar',
    })
    if (!ok.isConfirmed) return
    try {
      const res = await jdel(url)
      $('#tablaReportes').bootstrapTable('refresh')
      Swal.fire('¡Eliminado!', res.message, 'success')
    } catch (err) {
      showErrorToast({ message: err.message })
    }
    return
  }

  // Lógica 'btn-ver'
  try {
    const { data: reporte } = await jget(url)
    if ($btn.hasClass('btn-ver')) {
      const modalEl = document.getElementById('modalDetalle')
      const modal =
        bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl)

      // [CAMBIO] Guardar ID en el modal y renderizar botones
      modalEl.dataset.reporteId = reporte.reporte_id
      document.getElementById('modalDetalleBody').innerHTML =
        renderDetailCard(reporte)
      document.getElementById('modalDetalleAcciones').innerHTML =
        renderModalActionButtons(reporte.estado_reporte)

      modal.show()
    }
  } catch (err) {
    showErrorToast({ message: err.message })
  }
}

// Función de cambio de estado (Sin cambios)
async function handleChangeEstado(id, nuevoEstado) {
  const textoEstado = nuevoEstado.replace('_', ' ').toLowerCase()
  const ok = await Swal.fire({
    title: `¿Cambiar estado a "${textoEstado}"?`,
    text: 'Se actualizará el estado del reporte.',
    icon: 'info',
    showCancelButton: true,
    confirmButtonText: 'Sí, cambiar',
    cancelButtonText: 'Cancelar',
  })
  if (!ok.isConfirmed) return

  try {
    const url = api(`reportes_dano/${id}`)
    const body = { estado_reporte: nuevoEstado }
    const res = await jsend(url, 'POST', body)

    $('#tablaReportes').bootstrapTable('refresh')
    Swal.fire('¡Actualizado!', res.message, 'success')
  } catch (err) {
    showErrorToast({ message: err.message })
  }
}

/* =========================
   Renderizado y Reseteo
========================= */

// [CAMBIO] NUEVA FUNCIÓN para renderizar botones en el modal
function renderModalActionButtons(estado) {
  let buttons = ''
  if (estado === 'ABIERTO') {
    buttons += `<button class="btn btn-info btn-sm btn-cambiar-estado-modal" data-nuevo-estado="EN_PROCESO" title="Marcar En Proceso"><i class="mdi mdi-play-circle-outline"></i> En Proceso</button> `
    buttons += `<button class="btn btn-secondary btn-sm btn-cambiar-estado-modal" data-nuevo-estado="CERRADO" title="Marcar Cerrado"><i class="mdi mdi-check-circle-outline"></i> Cerrar</button>`
  } else if (estado === 'EN_PROCESO') {
    buttons += `<button class="btn btn-secondary btn-sm btn-cambiar-estado-modal" data-nuevo-estado="CERRADO" title="Marcar Cerrado"><i class="mdi mdi-check-circle-outline"></i> Cerrar</button> `
    buttons += `<button class="btn btn-primary btn-sm btn-cambiar-estado-modal" data-nuevo-estado="ABIERTO" title="Re-abrir"><i class="mdi mdi-lock-open-outline"></i> Re-abrir</button>`
  } else if (estado === 'CERRADO') {
    buttons += `<button class="btn btn-primary btn-sm btn-cambiar-estado-modal" data-nuevo-estado="ABIERTO" title="Re-abrir"><i class="mdi mdi-lock-open-outline"></i> Re-abrir</button>`
  }
  return buttons
}

// renderDetailCard (Sin cambios)
function renderDetailCard(d = {}) {
  const V = (x) => x ?? '-'

  // Helper interno para no repetir HTML
  // Mantiene tus clases .label y .value
  const renderField = (label, value, options = {}) => {
    const { isHtml = false, isFullWidth = false, data = d } = options
    let content = '-'

    if (isHtml) {
      content = value // El valor ya viene formateado (ej. badges)
    } else if (data[value]) {
      content = V(data[value])
    } else if (value === 'titulo' || value === 'descripcion') {
      content = V(data[value]) // Asegurar que se muestre aunque esté vacío
    } else {
      return '' // Ocultar campo si no tiene datos (ej. Finca, Aprisco, etc.)
    }

    // Estilos especiales para la descripción
    const valueClass = isFullWidth ? 'd-block' : ''
    const valueStyle = isFullWidth
      ? 'style="white-space:pre-wrap; max-height: 150px; overflow-y: auto;"'
      : ''

    return `
        <div class="mb-1">
            <span class="label">${label}</span>
            <span class="value ${valueClass}" ${valueStyle}>
                ${content}
            </span>
        </div>
    `
  }

  return `
    <div class="container-fluid p-0">
        <div class="row">
            <div class="col-md-7">
                <h5 class="mb-1 text-primary">Detalles del Reporte</h5>
                ${renderField('Título', 'titulo')}
                ${renderField('Descripción', 'descripcion', {
                  isFullWidth: true,
                })}
            </div>

            <div class="col-md-5">
                <h5 class="mb-1 text-primary mt-3 mt-md-0">Ubicación</h5>
                ${renderField('Finca', 'finca_nombre')}
                ${renderField('Aprisco', 'aprisco_nombre')}
                ${renderField('Área', 'area_label')}
                ${renderField('Recinto', 'recinto_label')}
                
                <h5 class="mb-1 text-primary mt-4">Trazabilidad</h5>
                ${renderField(
                  'Criticidad',
                  criticidadFormatter(V(d.criticidad)),
                  { isHtml: true }
                )}
                ${renderField(
                  'Estado',
                  reporteEstadoFormatter(V(d.estado_reporte)),
                  { isHtml: true }
                )}
                ${renderField(
                  'Fecha Reporte',
                  reporteFechaFormatter(d.fecha_reporte),
                  { isHtml: true }
                )}
                ${
                  d.fecha_cierre
                    ? renderField(
                        'Fecha Cierre',
                        reporteFechaFormatter(d.fecha_cierre),
                        { isHtml: true }
                      )
                    : ''
                }
            </div>
        </div>
    </div>
  `
}

// resetReporteForm (Sin cambios)
function resetReporteForm() {
  const form = $('#formReporte')[0]
  if (form) {
    form.reset()
    $('#reporte_id').val('')
    $(
      '#finca_id, #aprisco_id, #area_id, #recinto_id, #criticidad, #estado_reporte'
    )
      .val(null)
      .trigger('change')
    window.limpiarErroresDelFormulario?.(form)
  }
}
