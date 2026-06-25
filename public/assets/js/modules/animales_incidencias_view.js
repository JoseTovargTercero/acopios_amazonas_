import {
  showErrorToast,
  showSuccessToast,
  formatDate,
} from '../helpers/helpers.js'
import { populateSelect } from '../helpers/populateSelect.js'

const api = (path) => `${baseUrl}api/${path}`

// ================= FORMATTERS =================

window.responseHandler = (res) => ({
  rows: res.data ?? [],
  total: res.data?.length ?? 0,
})
window.fechaHoraFormatter = (v) => (v ? formatDate(v, true) : '-')

window.tipoFormatter = (v) => {
  const map = {
    RIÑA: { class: 'danger', text: 'Riña/Pelea', icon: 'boxing-glove' },
    AGRESIVIDAD: { class: 'danger', text: 'Agresividad', icon: 'flash' },
    APLASTAMIENTO: { class: 'danger', text: 'Aplastamiento', icon: 'weight' },
    RECHAZO_CRIAS: {
      class: 'warning text-dark',
      text: 'Rechazo Crías',
      icon: 'cancel',
    },
    FUGA: { class: 'info', text: 'Fuga', icon: 'run' },
    OTRA: { class: 'secondary', text: 'Otra', icon: 'help-circle' },
  }
  const conf = map[v] || { class: 'light text-dark', text: v, icon: 'circle' }
  return `<span class="badge bg-${conf.class}"><i class="mdi mdi-${conf.icon}"></i> ${conf.text}</span>`
}

window.fotoTableFormatter = (value) => {
  if (!value) return '<span class="text-muted">-</span>'
  // Asumiendo que 'value' ya viene con la ruta relativa '/uploads/...'
  // y 'baseUrl' está definida globalmente en la vista PHP
  const url = `${baseUrl}${value}`
  return `<a href="${url}" target="_blank" title="Ver imagen completa">
            <img src="${url}" alt="Evidencia" style="height: 30px; width: auto; border-radius: 4px; border: 1px solid #ddd;">
          </a>`
}

window.incidenciaAccionesFormatter = (v, row) => `
    <div class="btn-group">
      <button class="btn btn-info btn-sm btn-ver" data-id="${row.incidencia_id}" title="Ver"><i class="mdi mdi-eye"></i></button>
      <button class="btn btn-warning btn-sm btn-editar" data-id="${row.incidencia_id}" title="Editar"><i class="mdi mdi-pencil"></i></button>
      <button class="btn btn-danger btn-sm btn-eliminar" data-id="${row.incidencia_id}" title="Eliminar"><i class="mdi mdi-delete"></i></button>
    </div>`

// Formatter para tabla de animales (Tab 2)
window.ubicacionFormatter = (value, row) => {
  if (!row.nombre_finca) return '<span class="text-muted">-</span>'
  return [row.nombre_finca, row.nombre_aprisco, row.nombre_area]
    .filter(Boolean)
    .join(' / ')
}

window.historialBtnFormatter = (value, row) => `
    <button class="btn btn-primary btn-sm btn-historial-animal" 
            data-id="${value}" 
            data-identificador="${row.identificador}">
        <i class="mdi mdi-history"></i> Ver Historial
    </button>`

// ================= LÓGICA PRINCIPAL =================

document.addEventListener('DOMContentLoaded', () => {
  initTabGlobal()
  initTabAnimals()
  initFormLogic() // Nueva lógica compleja de formulario

  // Auto-abrir detalle si viene en URL
  const urlParams = new URLSearchParams(window.location.search)
  const incidenciaId = urlParams.get('incidencia_id')
  if (incidenciaId) verDetalleIncidencia(incidenciaId)
})

// --- TAB 1: GLOBAL ---
function initTabGlobal() {
  const $table = $('#tablaIncidencias')
  $table.bootstrapTable({
    queryParams: (params) => {
      // Mapeo de filtros manuales
      const f = {
        animal_id: $('#filtroAnimal').val(),
        area_id: $('#filtroArea').val(),
        tipo: $('#filtroTipo').val(),
        desde: $('#filtroDesde').val(),
        hasta: $('#filtroHasta').val(),
      }
      // Eliminar vacíos
      Object.keys(f).forEach((key) => f[key] === '' && delete f[key])
      return { ...params, ...f }
    },
  })

  // Carga Filtros
  populateSelect({
    selector: '#filtroAnimal',
    url: api('animales'),
    placeholder: 'Todos',
    valueField: 'animal_id',
    textField: 'identificador',
    useSelect2: true,
  })
  populateSelect({
    selector: '#filtroArea',
    url: api('areas'),
    placeholder: 'Todas',
    valueField: 'area_id',
    textField: 'nombre_personalizado',
    useSelect2: true,
  })
  $('#filtroTipo').select2({ placeholder: 'Todos', allowClear: true })

  // Botones Filtros
  $('#btnAplicarFiltros').on('click', () => $table.bootstrapTable('refresh'))
  $('#btnResetFilters').on('click', () => {
    $('#filtroAnimal, #filtroArea, #filtroTipo').val(null).trigger('change')
    $('#filtroDesde, #filtroHasta').val('')
    $table.bootstrapTable('refresh')
  })

  // Acciones de Tabla Global
  $table.on('click', '.btn-ver', function () {
    verDetalleIncidencia($(this).data('id'))
  })
  $table.on('click', '.btn-eliminar', function () {
    eliminarIncidencia($(this).data('id'))
  })
  $table.on('click', '.btn-editar', function () {
    prepararEdicion($(this).data('id'))
  })
}

// --- TAB 2: POR ANIMAL ---
function initTabAnimals() {
  // La tabla se inicializa vía data-attributes en el HTML.
  // Solo escuchamos el botón de historial
  $('#tablaAnimalesIncidencias').on(
    'click',
    '.btn-historial-animal',
    function () {
      const id = $(this).data('id')
      const ident = $(this).data('identificador')

      $('#lblHistorialAnimal').text(ident)
      const $tbody = $('#bodyHistorialIndividual')
      $tbody.html(
        '<tr><td colspan="6" class="text-center"><div class="spinner-border spinner-border-sm"></div> Cargando...</td></tr>'
      )

      const modal = new bootstrap.Modal(
        document.getElementById('modalHistorialAnimal')
      )
      modal.show()

      $.ajax({
        url: api(`incidencias?animal_id=${id}`),
        method: 'GET',
        success: function (res) {
          $tbody.empty()
          if (!res.data || res.data.length === 0) {
            $tbody.html(
              '<tr><td colspan="6" class="text-center text-muted">Sin incidencias registradas.</td></tr>'
            )
            return
          }
          res.data.forEach((i) => {
            $tbody.append(`
                        <tr>
                            <td>${formatDate(i.fecha_evento, true)}</td>
                            <td>${window.tipoFormatter(i.tipo)}</td>
                            <td><small>${i.descripcion || '-'}</small></td>
                            <td><small>${i.area_nombre || 'Actual'}</small></td>
                            <td><small>${i.responsable || '-'}</small></td>
                            <td>
                                <button class="btn btn-xs btn-outline-info btn-ver-historial" data-id="${
                                  i.incidencia_id
                                }"><i class="mdi mdi-eye"></i></button>
                            </td>
                        </tr>
                    `)
          })
        },
        error: () =>
          $tbody.html(
            '<tr><td colspan="6" class="text-center text-danger">Error al cargar datos.</td></tr>'
          ),
      })
    }
  )

  // Acción dentro del modal de historial: VER DETALLE
  $('#bodyHistorialIndividual').on('click', '.btn-ver-historial', function () {
    const idIncidencia = $(this).data('id')

    // 1. Referencias a los elementos DOM
    const elModalHistorial = document.getElementById('modalHistorialAnimal')
    const elModalDetalle = document.getElementById('modalDetalle')

    // 2. Instancias de Bootstrap
    const bsModalHistorial = bootstrap.Modal.getInstance(elModalHistorial)

    // 3. Ocultar el Historial primero
    bsModalHistorial.hide()

    // 4. Configurar el "Retorno": Cuando se cierre el Detalle, reabrir el Historial
    // Usamos .one() para que este evento se dispare solo una vez y no se acumule
    $(elModalDetalle).one('hidden.bs.modal', function () {
      bsModalHistorial.show()
    })

    // 5. Abrir el Detalle (pequeño delay para evitar choque de animaciones CSS)
    setTimeout(() => {
      verDetalleIncidencia(idIncidencia)
    }, 200)
  })
}

// ================= FORMULARIO COMPLEJO (INCIDENCIAS + VÍCTIMAS) =================

function initFormLogic() {
  const $form = $('#formIncidencia')
  const $modal = $('#modalIncidencia')
  const $containerVictimas = $('#lista-victimas')
  const $seccionConsecuencias = $('#seccion-consecuencias')

  // ======================================================
  // 0. DEFINICIÓN DE ELEMENTOS DE FOTO (Ámbito local)
  // ======================================================
  // Nota: Estas variables también existen abajo en "FOTO PREVIEW LOGIC",
  // pero para asegurar que initFormLogic las tenga disponibles al ejecutarse:
  const $previewContainer = $('#foto-preview-container')
  const $previewImage = $('#foto-preview')
  const $previewFilename = $('#foto-filename')
  const $eliminarFotoInput = $('#eliminar_foto_existente')
  const $btnEliminarFoto = $('#btn-eliminar-foto-existente')
  const $fileInput = $('#fotografia')

  // 1. Helper para agregar fila (Se mantiene igual)
  const addVictimRow = (data = null) => {
    const idx = Date.now() + Math.floor(Math.random() * 1000)
    const saludId = data?.animal_salud_id || ''
    const animalId = data?.animal_id || ''
    const desc = data?.descripcion?.replace(/^Consecuencia.*?\.\s*/i, '') || ''
    const sev = data?.severidad || 'LEVE'

    const row = `
            <div class="row g-1 mb-2 align-items-center fila-victima" id="row-${idx}">
                <input type="hidden" class="input-salud-id" value="${saludId}">
                <div class="col-md-4">
                    <select class="form-select form-select-sm select-victima"></select>
                </div>
                <div class="col-md-4">
                    <input type="text" class="form-control form-control-sm input-desc" placeholder="Detalle herida" value="${desc}">
                </div>
                <div class="col-md-3">
                    <select class="form-select form-select-sm input-sev">
                        <option value="LEVE" ${
                          sev === 'LEVE' ? 'selected' : ''
                        }>Leve</option>
                        <option value="MODERADA" ${
                          sev === 'MODERADA' ? 'selected' : ''
                        }>Moderada</option>
                        <option value="GRAVE" ${
                          sev === 'GRAVE' ? 'selected' : ''
                        }>Grave</option>
                        <option value="NO_APLICA" ${
                          sev === 'NO_APLICA' ? 'selected' : ''
                        }>No Aplica</option>
                    </select>
                </div>
                <div class="col-md-1 text-center">
                    <button type="button" class="btn btn-sm text-danger btn-remove-victima"><i class="mdi mdi-close"></i></button>
                </div>
            </div>`

    $containerVictimas.append(row)
    // ... (Logica de Select2 igual que antes) ...
    const $sel = $(`#row-${idx} .select-victima`)
    populateSelect({
      selector: $sel,
      url: api('animales'),
      placeholder: 'Buscar...',
      valueField: 'animal_id',
      textField: 'identificador',
      useSelect2: true,
      select2Options: { dropdownParent: $modal },
    }).then(() => {
      if (animalId) {
        if ($sel.find(`option[value='${animalId}']`).length === 0) {
          // data no está definido aquí si viene de addVictimRow vacío, corregimos:
          const label = data
            ? data.animal_identificador || 'Seleccionado'
            : 'Seleccionado'
          $sel.append(new Option(label, animalId, true, true))
        }
        $sel.val(animalId).trigger('change')
      }
    })
  }

  // 2. Eventos Formulario
  $('#btnAgregarVictima').on('click', () => addVictimRow())
  $containerVictimas.on('click', '.btn-remove-victima', function () {
    $(this).closest('.fila-victima').remove()
  })

  $('#tipo').on('change', function () {
    const t = $(this).val()
    if (['RIÑA', 'AGRESIVIDAD', 'APLASTAMIENTO'].includes(t)) {
      $seccionConsecuencias.removeClass('d-none')
    } else {
      $seccionConsecuencias.addClass('d-none')
      $containerVictimas.empty()
    }
  })

  // ======================================================
  // CORRECCIÓN: Eventos de FOTO movidos al nivel principal
  // ======================================================

  // A. Cambio en Input File
  $fileInput.on('change', function () {
    if (this.files && this.files[0]) {
      const file = this.files[0]
      const reader = new FileReader()
      reader.onload = (e) => {
        // Nota: showPhotoPreview está definida globalmente abajo
        showPhotoPreview(e.target.result, file.name)
      }
      reader.readAsDataURL(file)
    } else {
      // Si cancela la selección, reseteamos
      // (Podrías mejorar esto chequeando si estamos editando para no borrar la existente)
      resetPhotoPreview()
    }
  })

  // B. Botón Eliminar Foto Existente
  $btnEliminarFoto.on('click', function () {
    // Marcamos el campo oculto para que el backend sepa que debe eliminar la foto
    $eliminarFotoInput.val('1')

    // Cambiamos la apariencia para indicar que la foto se eliminará
    $previewContainer.addClass('bg-warning-light border-warning')
    $previewFilename.text('Foto marcada para eliminación.')

    // Ocultamos el botón de eliminar y la imagen real
    $btnEliminarFoto.hide()
    $previewImage.attr('src', '#')

    // Limpiamos el input file por si acaso
    $fileInput.val('')
  })

  // C. Limpiar al cerrar modal
  $modal.on('hidden.bs.modal', resetPhotoPreview)

  // ======================================================

  // 3. Abrir Modal Crear
  $('#btnNuevaIncidencia').on('click', () => {
    $form[0].reset()
    resetPhotoPreview() // Resetea visualmente
    $('#incidencia_id').val('')
    $('#modalIncidenciaLabel').text('Nueva Incidencia')
    $containerVictimas.empty()
    $seccionConsecuencias.addClass('d-none')

    // Selects init
    $('#tipo').val('').trigger('change')
    const now = new Date()
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset())
    $('#fecha_evento').val(now.toISOString().slice(0, 16))

    populateSelect({
      selector: '#animal_id',
      url: api('animales'),
      placeholder: 'Seleccione...',
      valueField: 'animal_id',
      textField: 'identificador',
      useSelect2: true,
      select2Options: { dropdownParent: $modal },
    })
    populateSelect({
      selector: '#area_id',
      url: api('areas'),
      placeholder: 'Ninguna',
      valueField: 'area_id',
      textField: 'nombre_personalizado',
      useSelect2: true,
      select2Options: { dropdownParent: $modal },
    })

    new bootstrap.Modal(document.getElementById('modalIncidencia')).show()
  })

  // 4. Submit
  document
    .getElementById('formIncidencia')
    .addEventListener('validation:success', (e) => {
      const data = e.detail.datos
      const id = $('#incidencia_id').val()
      const url = id ? api(`incidencias/${id}`) : api('incidencias')

      // Recolectar víctimas (código original...)
      let cons = []
      if (!$seccionConsecuencias.hasClass('d-none')) {
        $('.fila-victima').each(function () {
          const $r = $(this)
          const vid = $r.find('.select-victima').val()
          if (vid) {
            cons.push({
              animal_salud_id: $r.find('.input-salud-id').val(),
              animal_id: vid,
              descripcion: $r.find('.input-desc').val(),
              severidad: $r.find('.input-sev').val(),
            })
          }
        })
      }
      if (cons.length > 0) data.consecuencias_salud = cons
      data.area_id = data.area_id || null

      // FORMDATA
      const formData = new FormData()
      const fileInput = document.getElementById('fotografia')
      const file = fileInput.files.length > 0 ? fileInput.files[0] : null

      for (const key in data) {
        if (data[key] !== null && data[key] !== undefined) {
          if (Array.isArray(data[key])) {
            formData.append(key, JSON.stringify(data[key]))
          } else {
            formData.append(key, data[key])
          }
        }
      }

      // Lógica de eliminación de foto
      if (id && $eliminarFotoInput.val() === '1') {
        if (!file) {
          // Forzamos el borrado enviando URL vacía si no hay archivo nuevo
          formData.append('fotografia_url', '')
        }
      }

      if (file) {
        formData.append('fotografia', file)
      }

      $.ajax({
        url: url,
        method: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: (res) => {
          bootstrap.Modal.getInstance(
            document.getElementById('modalIncidencia')
          ).hide()
          showSuccessToast(res)
          $('#tablaIncidencias').bootstrapTable('refresh')
        },
        error: (xhr) => showErrorToast(xhr.responseJSON),
      })
    })
}

// ================= FOTO PREVIEW LOGIC =================

const $previewContainer = $('#foto-preview-container')
const $previewImage = $('#foto-preview')
const $previewFilename = $('#foto-filename')
const $eliminarFotoInput = $('#eliminar_foto_existente')
const $btnEliminarFoto = $('#btn-eliminar-foto-existente')
const $fileInput = $('#fotografia')

/** Limpia la vista previa y el campo de archivo. */
const resetPhotoPreview = () => {
  $previewContainer
    .addClass('d-none')
    .removeClass('bg-warning-light border-warning')
  $previewImage.attr('src', '#')
  $previewFilename.text('')
  $eliminarFotoInput.val('0')
  $fileInput.val('')
  $btnEliminarFoto.show() // Mostrar siempre por defecto
}

/** Muestra una imagen desde un archivo (creación) o desde una URL (edición). */
const showPhotoPreview = (source, filename, isExisting = false) => {
  $previewContainer.removeClass('d-none')
  $previewImage.attr('src', source)
  $previewFilename.text(filename)

  if (isExisting) {
    // Si es una foto existente (edición)
    $btnEliminarFoto.show()
    $previewContainer.removeClass('bg-warning-light border-warning')
  } else {
    // Si es una foto recién seleccionada (creación o reemplazo)
    $btnEliminarFoto.hide()
    $eliminarFotoInput.val('0') // Aseguramos que no borre la anterior
  }
}

// ================= END FOTO PREVIEW LOGIC =================

// ================= ACCIONES GENERALES =================

function verDetalleIncidencia(id) {
  $.ajax({
    url: api(`incidencias/${id}`),
    method: 'GET',
    success: (res) => {
      const d = res.data
      let fotoHtml = ''
      if (d.fotografia_url) {
        const fullUrl = `${baseUrl}${d.fotografia_url}`
        fotoHtml = `<div class="col-12 mt-3"><small class="text-muted">Evidencia Fotográfica</small><br>
                    <img src="${fullUrl}" alt="Evidencia de Incidencia" class="img-fluid rounded border" style="max-height: 250px;">
                </div>`
      }
      let vicHtml = ''
      if (d.consecuencias_salud?.length > 0) {
        vicHtml =
          '<div class="mt-3 pt-2 border-top"><h6 class="text-danger">Consecuencias:</h6><ul class="list-group list-group-flush small">'
        d.consecuencias_salud.forEach((v) => {
          vicHtml += `<li class="list-group-item px-0 bg-transparent d-flex justify-content-between">
                        <span><strong>${v.animal_identificador}</strong>: ${
            v.descripcion || '-'
          }</span>
                        <span class="badge bg-secondary">${v.severidad}</span>
                    </li>`
        })
        vicHtml += '</ul></div>'
      }

      const html = `
                <div class="row">
                    <div class="col-6 mb-2"><small class="text-muted">Animal</small><br><strong>${
                      d.animal_identificador
                    }</strong></div>
                    <div class="col-6 mb-2"><small class="text-muted">Tipo</small><br>${window.tipoFormatter(
                      d.tipo
                    )}</div>
                    <div class="col-6 mb-2"><small class="text-muted">Fecha</small><br>${formatDate(
                      d.fecha_evento,
                      true
                    )}</div>
                    <div class="col-6 mb-2"><small class="text-muted">Responsable</small><br>${
                      d.responsable || '-'
                    }</div>
                    <div class="col-12 mb-2"><small class="text-muted">Ubicación</small><br>${
                      d.area_nombre || 'Ubicación actual'
                    }</div>
                    <div class="col-12"><small class="text-muted">Descripción</small><p class="bg-light p-2 rounded mb-0">${
                      d.descripcion || 'Sin detalles'
                    }</p></div>
                </div>
                <div class="row">
        ${fotoHtml} </div>
                ${vicHtml}
            `
      $('#modalDetalleBody').html(html)
      new bootstrap.Modal(document.getElementById('modalDetalle')).show()
    },
    error: (xhr) => showErrorToast(xhr.responseJSON),
  })
}

function eliminarIncidencia(id) {
  Swal.fire({
    title: '¿Eliminar?',
    text: 'Se borrará la incidencia y sus registros de salud asociados.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#d33',
    confirmButtonText: 'Sí, eliminar',
  }).then((r) => {
    if (r.isConfirmed) {
      $.ajax({
        url: api(`incidencias/${id}`),
        method: 'DELETE',
        success: (res) => {
          showSuccessToast(res)
          $('#tablaIncidencias').bootstrapTable('refresh')
        },
        error: (xhr) => showErrorToast(xhr.responseJSON),
      })
    }
  })
}

async function prepararEdicion(id) {
  try {
    const res = await $.ajax({ url: api(`incidencias/${id}`), method: 'GET' })
    const d = res.data
    const $form = $('#formIncidencia')
    const $modal = $('#modalIncidencia')

    $form[0].reset()
    $('#incidencia_id').val(d.incidencia_id)
    $('#modalIncidenciaLabel').text('Editar Incidencia')

    // Pre-llenado
    const dt = d.fecha_evento
      ? d.fecha_evento.replace(' ', 'T').substring(0, 16)
      : ''
    $('#fecha_evento').val(dt)
    $('#descripcion').val(d.descripcion)
    $('#responsable').val(d.responsable)

    // Selects
    await populateSelect({
      selector: '#animal_id',
      url: api('animales'),
      placeholder: '...',
      valueField: 'animal_id',
      textField: 'identificador',
      useSelect2: true,
      select2Options: { dropdownParent: $modal },
    })
    $('#animal_id').val(d.animal_id).trigger('change')

    await populateSelect({
      selector: '#area_id',
      url: api('areas'),
      placeholder: 'Ninguna',
      valueField: 'area_id',
      textField: 'nombre_personalizado',
      useSelect2: true,
      select2Options: { dropdownParent: $modal },
    })
    $('#area_id').val(d.area_id).trigger('change')

    // Trigger cambio tipo para mostrar víctimas
    $('#tipo').val(d.tipo).trigger('change')

    // Cargar víctimas si existen y el tipo lo permite
    $('#lista-victimas').empty()
    if (
      ['RIÑA', 'AGRESIVIDAD', 'APLASTAMIENTO'].includes(d.tipo) &&
      d.consecuencias_salud?.length
    ) {
      // Hack: necesitamos acceso a la función addVictimRow definida en initFormLogic.
      // Como está encapsulada, la replicamos o movemos fuera.
      // Por simplicidad aquí, simularé un click en agregar y luego llenado,
      // pero lo ideal es refactorizar addVictimRow a ámbito global o usar eventos.

      // *Mejor enfoque:* Mover lógica de renderizado de fila a funcion exportada o global en el módulo.
      // Aquí usaré lógica manual para recrear las filas:
      d.consecuencias_salud.forEach((v) => {
        // Simulamos la función interna recreando el HTML
        // Nota: Esto duplica código, ideal refactorizar.
        const idx = Date.now() + Math.floor(Math.random() * 1000)
        const row = `
                    <div class="row g-1 mb-2 align-items-center fila-victima" id="row-${idx}">
                        <input type="hidden" class="input-salud-id" value="${
                          v.animal_salud_id
                        }">
                        <div class="col-md-4"><select class="form-select form-select-sm select-victima"></select></div>
                        <div class="col-md-4"><input type="text" class="form-control form-control-sm input-desc" value="${v.descripcion.replace(
                          /^Consecuencia.*?\.\s*/i,
                          ''
                        )}"></div>
                        <div class="col-md-3">
                            <select class="form-select form-select-sm input-sev">
                                <option value="LEVE" ${
                                  v.severidad === 'LEVE' ? 'selected' : ''
                                }>Leve</option>
                                <option value="MODERADA" ${
                                  v.severidad === 'MODERADA' ? 'selected' : ''
                                }>Moderada</option>
                                <option value="GRAVE" ${
                                  v.severidad === 'GRAVE' ? 'selected' : ''
                                }>Grave</option>
                                <option value="NO_APLICA" ${
                                  v.severidad === 'NO_APLICA' ? 'selected' : ''
                                }>No Aplica</option>
                            </select>
                        </div>
                        <div class="col-md-1 text-center"><button type="button" class="btn btn-sm text-danger btn-remove-victima"><i class="mdi mdi-close"></i></button></div>
                    </div>`
        $('#lista-victimas').append(row)
        const $sel = $(`#row-${idx} .select-victima`)
        populateSelect({
          selector: $sel,
          url: api('animales'),
          valueField: 'animal_id',
          textField: 'identificador',
          useSelect2: true,
          select2Options: { dropdownParent: $modal },
        }).then(() => {
          if ($sel.find(`option[value='${v.animal_id}']`).length === 0) {
            $sel.append(
              new Option(v.animal_identificador, v.animal_id, true, true)
            )
          }
          $sel.val(v.animal_id).trigger('change')
        })
      })
    }
    resetPhotoPreview() // Limpiamos cualquier estado anterior

    if (d.fotografia_url) {
      // Usamos la URL base para acceder a la imagen
      const fullUrl = `${baseUrl}${d.fotografia_url}`
      const filename = d.fotografia_url.substring(
        d.fotografia_url.lastIndexOf('/') + 1
      )

      // Muestra la foto existente
      showPhotoPreview(fullUrl, filename, true)
    }

    new bootstrap.Modal(document.getElementById('modalIncidencia')).show()
  } catch (e) {
    showErrorToast({ message: 'Error cargando datos' })
  }
}
