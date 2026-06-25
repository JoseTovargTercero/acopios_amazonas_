// *** MODIFICADO: Añadido showSuccessToast y formatDate ***
import {
  showErrorToast,
  showSuccessToast,
  formatDate,
} from '../helpers/helpers.js'
import { populateSelect } from '../helpers/populateSelect.js'
import { cargarGraficoPesos } from '../helpers/curva_peso_graficos.js'

// --- HELPERS Y FORMATTERS PARA LA TABLA (Sin cambios) ---

window.responseHandler = function (res) {
  return {
    rows: res.data,
    total: res.data.length,
  }
}
window.accionesFormatter = function (value, row) {
  return `
    <div class="btn-group">
        <button class="btn btn-info btn-sm btn-ver" data-id="${value}" title="Ver Detalles"><i class="mdi mdi-eye"></i></button>
        <button class="btn btn-warning btn-sm btn-editar" data-id="${value}" title="Editar"><i class="mdi mdi-pencil"></i></button>
        <button class="btn btn-danger btn-sm btn-eliminar" data-id="${value}" title="Eliminar"><i class="mdi mdi-delete"></i></button>
    </div>`
}
window.pesoFormatter = function (value, row) {
  return value
    ? `${parseFloat(value).toFixed(2)} kg`
    : '<span class="text-muted">N/A</span>'
}
window.ubicacionFormatter = function (value, row) {
  if (row.nombre_finca) {
    let path = [
      row.nombre_finca,
      row.nombre_aprisco,
      row.nombre_area,
      row.codigo_recinto,
    ]
      .filter(Boolean)
      .join(' / ')
    return path
  }
  return '<span class="text-muted">Sin ubicación activa</span>'
}

// *** MODIFICADO: formatDate ahora se importa, pero mantenemos una versión local por si acaso ***
const fDate = (dateString) => {
  if (!dateString) return 'N/A'
  // Asumimos que formatDate importado maneja fechas y fechas-hora
  return formatDate(dateString, false) // false para no incluir hora
}
// *** NUEVO: Formatter de Fecha-Hora para incidencias ***
const fDateTime = (dateTimeString) => {
  if (!dateTimeString) return 'N/A'
  return formatDate(dateTimeString, true) // true para incluir hora
}

// *** NUEVO: Formatters para la tabla de incidencias (adaptados de incidencias_view.js) ***
window.tipoIncidenciaFormatter = (v) => {
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

const incidenciaAccionesFormatter = (v) => `
    <div class="btn-group">
      <button class="btn btn-info btn-xs btn-ver-incidencia" data-id="${v}" title="Ver"><i class="mdi mdi-eye"></i></button>
      <button class="btn btn-warning btn-xs btn-editar-incidencia" data-id="${v}" title="Editar"><i class="mdi mdi-pencil"></i></button>
      <button class="btn btn-danger btn-xs btn-eliminar-incidencia" data-id="${v}" title="Eliminar"><i class="mdi mdi-delete"></i></button>
    </div>`
/* Carga imangen por defecto en caso de que no exista*/
function cargarImagenConFallback(selector, url, fallback) {
  const img = $(selector)
  img.attr('src', url || fallback)
  img.on('error', function () {
    $(this).attr('src', fallback)
  })
}

/* Formatear dias para el error del tabulador y edad */
function formatoTiempoDesdeDias(dias) {
  if (dias < 30) {
    // Menos de un mes
    return `${dias} días`
  }

  const meses = Math.floor(dias / 30)
  const años = Math.floor(meses / 12)
  const mesesRestantes = meses % 12

  if (años >= 1) {
    if (mesesRestantes > 0) {
      return `${años} años con ${mesesRestantes} meses`
    } else {
      return `${años} años`
    }
  } else {
    return `${meses} meses`
  }
}
/* Calcular la edad del animal */
function calcularEdad(fechaStr) {
  // Parsear la fecha en formato DD/MM/YYYY
  const [dia, mes, año] = fechaStr.split('/').map(Number)
  const fechaNacimiento = new Date(año, mes - 1, dia)
  const hoy = new Date()

  // Calcular diferencia total en días
  const diffMs = hoy - fechaNacimiento
  const diffDias = Math.floor(diffMs / (1000 * 60 * 60 * 24))

  // Reutilizamos la misma lógica de formato
  if (diffDias < 30) {
    return `${diffDias} días`
  }

  const meses = Math.floor(diffDias / 30)
  const años = Math.floor(meses / 12)
  const mesesRestantes = meses % 12

  if (años >= 1) {
    if (mesesRestantes > 0) {
      return `${años} años con ${mesesRestantes} meses`
    } else {
      return `${años} años`
    }
  } else {
    return `${meses} meses`
  }
}

// --- LÓGICA PRINCIPAL ---

const api = (path) => `${baseUrl}api/${path}`
const $formAnimal = $(document.getElementById('formAnimal'))

document.addEventListener('DOMContentLoaded', function () {
  const $incidenciaPreviewContainer = $('#incidencia-foto-preview-container')
  const $incidenciaPreviewImage = $('#incidencia-foto-preview')
  const $incidenciaPreviewFilename = $('#incidencia-foto-filename')
  const $incidenciaEliminarFotoInput = $('#eliminar_foto_existente') // Cuidado: ID compartido
  const $btnEliminarIncidenciaFoto = $(
    '#btn-eliminar-incidencia-foto-existente'
  )
  const $incidenciaFileInput = $('#incidencia_fotografia')
  const $incidenciaFotoUrlExistente = $('#fotografia_url_existente')

  /** Limpia la vista previa y el campo de archivo. */
  const resetIncidenciaPhotoPreview = () => {
    $incidenciaPreviewContainer
      .addClass('d-none')
      .removeClass('bg-warning-light border-warning')
    $incidenciaPreviewImage.attr('src', '#')
    $incidenciaPreviewFilename.text('')
    $incidenciaEliminarFotoInput.val('0')
    $incidenciaFileInput.val('')
    $incidenciaFotoUrlExistente.val('') // Limpiar URL existente
    $btnEliminarIncidenciaFoto.show()
  }

  /** Muestra una imagen desde un archivo (creación) o desde una URL (edición). */
  const showIncidenciaPhotoPreview = (source, filename, isExisting = false) => {
    $incidenciaPreviewContainer.removeClass('d-none')
    $incidenciaPreviewImage.attr('src', source)
    $incidenciaPreviewFilename.text(filename)

    if (isExisting) {
      $btnEliminarIncidenciaFoto.show()
      $incidenciaPreviewContainer.removeClass('bg-warning-light border-warning')
    } else {
      // Foto recién seleccionada (reemplazo o creación)
      $btnEliminarIncidenciaFoto.hide()
      $incidenciaEliminarFotoInput.val('0')
      $incidenciaFotoUrlExistente.val('')
    }
  }

  // Evento al seleccionar nuevo archivo
  $incidenciaFileInput.on('change', function () {
    if (this.files && this.files[0]) {
      const file = this.files[0]
      const reader = new FileReader()
      reader.onload = (e) => {
        showIncidenciaPhotoPreview(e.target.result, file.name)
      }
      reader.readAsDataURL(file)
    } else {
      // Si cancela la selección, restauramos el estado (si estábamos editando)
      const existingUrl = $incidenciaFotoUrlExistente.val()
      if (existingUrl) {
        showIncidenciaPhotoPreview(
          `${baseUrl}${existingUrl}`,
          existingUrl.substring(existingUrl.lastIndexOf('/') + 1),
          true
        )
      } else {
        resetIncidenciaPhotoPreview()
      }
    }
  })

  // Evento para marcar/desmarcar borrado
  $btnEliminarIncidenciaFoto.on('click', function () {
    $incidenciaEliminarFotoInput.val('1') // Marcamos para eliminar
    $incidenciaPreviewContainer.addClass('bg-warning-light border-warning')
    $incidenciaPreviewFilename.text('Foto marcada para eliminación.')
    $btnEliminarIncidenciaFoto.hide()
    $incidenciaPreviewImage.attr('src', '#')
    $incidenciaFileInput.val('') // Limpiar input file
  })

  // Limpiar vista previa al cerrar el modal
  $('#modalRegistroIncidencia').on(
    'hidden.bs.modal',
    resetIncidenciaPhotoPreview
  )

  // --- INSTANCIAS DE MODALES (MODIFICADO) ---
  const modalAnimal = new bootstrap.Modal(
    document.getElementById('modalAnimal')
  )
  const modalDetallesAnimal = new bootstrap.Modal(
    document.getElementById('modalDetallesAnimal')
  )
  const modalRegistroPeso = new bootstrap.Modal(
    document.getElementById('modalRegistroPeso')
  )
  const modalRegistroSalud = new bootstrap.Modal(
    document.getElementById('modalRegistroSalud')
  )
  const modalDetallesSalud = new bootstrap.Modal(
    document.getElementById('modalDetallesSalud')
  )
  const modalRegistroMovimiento = new bootstrap.Modal(
    document.getElementById('modalRegistroMovimiento')
  )
  const modalRegistroUbicacion = new bootstrap.Modal(
    document.getElementById('modalRegistroUbicacion')
  )
  // *** NUEVO: Instancias de modales de incidencia ***
  const modalRegistroIncidencia = new bootstrap.Modal(
    document.getElementById('modalRegistroIncidencia')
  )
  const modalDetallesIncidencia = new bootstrap.Modal(
    document.getElementById('modalDetallesIncidencia')
  )

  // --- FORMULARIOS (MODIFICADO) ---
  const formAnimal = document.getElementById('formAnimal')
  const formRegistroPeso = document.getElementById('formRegistroPeso')
  const formRegistroSalud = document.getElementById('formRegistroSalud')
  const formRegistroMovimiento = document.getElementById(
    'formRegistroMovimiento'
  )
  const formRegistroUbicacion = document.getElementById('formRegistroUbicacion')
  // *** NUEVO: Formulario de incidencia ***
  const formRegistroIncidencia = document.getElementById(
    'formRegistroIncidencia'
  )

  // --- MANEJO DE LA VISTA PRINCIPAL (TABLA Y CREACIÓN) ---

  $('#btnNuevoAnimal').on('click', function () {
    formAnimal.reset()
    window.limpiarErroresDelFormulario?.(formAnimal)

    // *** MODIFICADO: Resetear el nuevo select de raza_id ***
    $('#sexo, #especie, #estado, #origen, #raza_id').trigger('change')
    $('#animal_id').val('')
    $('#modalAnimalLabel').text('Registrar Nuevo Animal')
    $('#fotografia-preview').attr(
      'src',
      'https://placehold.co/200x200?text=Vista+Previa'
    )

    // Lógica para Select2 de madre/padre (sin cambios)
    populateSelect({
      selector: '#madre_id',
      url: api('animales?sexo=HEMBRA'), // Usando helper api()
      valueField: 'animal_id',
      textField: 'identificador',
      placeholder: 'Seleccione una madre (Opcional)',
      useSelect2: true,
      select2Options: { dropdownParent: $formAnimal },
      emptyMessage: 'No hay animales para seleccionar',
    })
    populateSelect({
      selector: '#padre_id',
      url: api('animales?sexo=MACHO'), // Usando helper api()
      valueField: 'animal_id',
      textField: 'identificador',
      placeholder: 'Seleccione un padre (Opcional)',
      useSelect2: true,
      select2Options: { dropdownParent: $formAnimal },
      emptyMessage: 'No hay animales para seleccionar',
    })

    // *** NUEVO: Inicializar el select de Raza (vacío y deshabilitado al inicio) ***
    $('#raza_id')
      .select2({
        placeholder: 'Seleccione una especie primero...',
        dropdownParent: $formAnimal,
      })
      .prop('disabled', true)

    modalAnimal.show()
  })

  $formAnimal.on('change', '#especie', function () {
    const especieSeleccionada = $(this).val()
    const $razaSelect = $('#raza_id')

    $razaSelect.val(null).trigger('change') // Limpiar selección anterior

    if (especieSeleccionada) {
      // Usamos el filtro 'especie' del API de razas
      populateSelect({
        selector: $razaSelect,
        url: api(`razas?especie=${especieSeleccionada}&estado=ACTIVA`),
        valueField: 'raza_id',
        textField: 'nombre', //
        placeholder: 'Seleccione una raza...',
        useSelect2: true,
        select2Options: { dropdownParent: $formAnimal },
        emptyMessage: 'No hay razas para esta especie', // Tu helper ya podría mostrar esto
      }).then(() => {
        // *** VALIDACIÓN ADICIONAL ***
        // Contamos cuántas opciones reales (no el placeholder) se cargaron
        const optionsCount = $razaSelect.find('option[value!=""]').length

        if (optionsCount > 0) {
          // Si hay razas, habilita el select
          $razaSelect.prop('disabled', false)
        } else {
          // Si no hay razas, lo deshabilita y actualiza el placeholder
          $razaSelect.prop('disabled', true).select2({
            placeholder: 'No hay razas para esta especie',
            dropdownParent: $formAnimal,
          })
        }
      })
    } else {
      // Deshabilitar si no hay especie seleccionada
      $razaSelect.prop('disabled', true).select2({
        placeholder: 'Seleccione una especie primero...',
        dropdownParent: $formAnimal,
      })
    }
  })
  // (Sin cambios)
  formAnimal.addEventListener('validation:success', function (e) {
    const animalId = $('#animal_id').val()
    let url = baseUrl + 'api/animales'
    let method = 'POST'

    if (animalId) {
      url = `${baseUrl}api/animales/${animalId}`
    }
    const formData = e.detail.formData

    console.log('Enviando datos del formulario:', formData)

    $.ajax({
      url: url,
      method: method,
      data: formData,
      processData: false,
      contentType: false,
      success: function (response) {
        modalAnimal.hide()
        // *** MODIFICADO: Usar showSuccessToast ***
        showSuccessToast(response)
        $('#tablaAnimales').bootstrapTable('refresh')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // (Sin cambios)
  $('#tablaAnimales').on('click', 'button', function () {
    const action = $(this).attr('class')
    const animalId = $(this).data('id')

    if (action.includes('btn-ver')) {
      mostrarDetalles(animalId)
    } else if (action.includes('btn-editar')) {
      editarAnimal(animalId)
    } else if (action.includes('btn-eliminar')) {
      eliminarAnimal(animalId)
    }
  })

  // (Sin cambios)
  $('#fotografia').on('change', function () {
    if (this.files && this.files[0]) {
      const reader = new FileReader()
      reader.onload = function (e) {
        $('#fotografia-preview').attr('src', e.target.result)
      }
      reader.readAsDataURL(this.files[0])
    }
  })

  // --- LÓGICA DE DETALLES Y REGISTROS ANIDADOS ---

  // *** MODIFICADO: mostrarDetalles ahora pide 6 endpoints ***
  let currentAnimalIdForDetails = null

  // *** MODIFICADO: mostrarDetalles ahora pide 7 endpoints ***
  function mostrarDetalles(animalId) {
    currentAnimalIdForDetails = animalId
    $('#detalles-content').addClass('d-none')
    $('#detalles-loader').removeClass('d-none')
    $('#animalDetailsTab button[data-bs-target="#info"]').tab('show')

    const endpoints = {
      animal: `${baseUrl}api/animales/${animalId}`,
      pesos: `${baseUrl}api/animal_pesos?animal_id=${animalId}`,
      salud: `${baseUrl}api/animal_salud?animal_id=${animalId}`,
      movimientos: `${baseUrl}api/animal_movimientos?animal_id=${animalId}`,
      ubicaciones: `${baseUrl}api/animal_ubicaciones?animal_id=${animalId}`,
      incidencias: `${baseUrl}api/incidencias?animal_id=${animalId}`,

      // *** NUEVO: Endpoint de Alertas ***
      // Filtramos por animal, estado PENDIENTE y origen_modulo INCIDENCIA
      alertas: `${baseUrl}api/alertas?animal_id=${animalId}&estado_alerta=PENDIENTE&origen_modulo=INCIDENCIA&tipo_alerta=REINCIDENCIA_APLASTAMIENTO`,
    }

    const requests = Object.values(endpoints).map((url) =>
      $.ajax({ url: url, method: 'GET' })
    )

    Promise.all(requests)
      .then((responses) => {
        const [
          animalRes,
          pesosRes,
          saludRes,
          movimientosRes,
          ubicacionesRes,
          incidenciasRes,
          alertasRes, // *** NUEVO ***
        ] = responses

        populateDetallesModal(
          animalRes.data,
          pesosRes.data,
          saludRes.data,
          movimientosRes.data,
          ubicacionesRes.data,
          incidenciasRes.data,
          alertasRes.data // *** NUEVO ***
        )

        //console.log(alertasRes.data); // *** NUEVO: Log de alertas ***;

        $('#detalles-loader').addClass('d-none')
        $('#detalles-content').removeClass('d-none')

        modalDetallesAnimal.show()
      })
      .catch((error) => {
        showErrorToast(
          error.responseJSON || {
            message: 'Error cargando los detalles.' + error,
          }
        )
      })
  }
  // *** MODIFICADO: populateDetallesModal ahora recibe 'incidencias' ***
  function populateDetallesModal(
    animal,
    pesos,
    salud,
    movimientos,
    ubicaciones,
    incidencias,
    alertas // *** NUEVO ***
  ) {
    // *** NUEVO: Lógica del Badge de Alerta de Riesgo ***
    const $badge = $('#badge_alerta_riesgo')
    // Si la consulta de alertas trajo algún resultado
    if (alertas && alertas.length > 0) {
      $badge.removeClass('d-none')
    } else {
      $badge.addClass('d-none')
    }

    // Objetivo: Detectar animales fuera de rango
    const $badgePeso = $('#badge_alerta_peso')
    const $mensajePeso = $('#peso_status_mensaje')

    // 1. Resetear el badge
    $badgePeso
      .addClass('d-none')
      .removeClass('alert-success alert-warning alert-danger alert-info')
    $mensajePeso.text('')

    // 2. Obtener datos necesarios del animal
    // (Asumiendo que 'raza_id', 'ultimo_peso_kg' y 'fecha_nacimiento' vienen en el objeto 'animal')
    // El campo 'raza' textual no nos sirve, necesitamos 'raza_id'.
    // Asegúrate que tu API /api/animales/{id} devuelva 'raza_id'.
    const razaId = animal.raza_id // <-- NECESITAS ESTE CAMPO DESDE TU API
    const ultimoPeso = parseFloat(animal.ultimo_peso_kg)
    const fechaNac = animal.fecha_nacimiento

    // console.log(`Raza ID: ${razaId}, Último Peso: ${ultimoPeso}, Fecha Nac: ${fechaNac}`);

    // 3. Validar que tenemos los datos para consultar
    // Basado en registros de peso existentes y tabuladores por raza/edad
    if (razaId && !isNaN(ultimoPeso) && ultimoPeso > 0 && fechaNac) {
      // 4. Calcular edad en días
      try {
        const dob = new Date(fechaNac + 'T00:00:00Z') // Asumir UTC para evitar problemas de zona
        const today = new Date()
        today.setUTCHours(0, 0, 0, 0) // Comparar fechas en UTC
        dob.setUTCHours(0, 0, 0, 0)

        if (dob > today) {
          throw new Error('Fecha de nacimiento futura') // Manejar error si la fecha es inválida
        }

        const diffTime = today.getTime() - dob.getTime()
        // Sumamos 1 si la diferencia es 0 (nació hoy), sino usamos ceil.
        const edadDias =
          diffTime === 0 ? 1 : Math.ceil(diffTime / (1000 * 60 * 60 * 24))

        // 5. Consultar el tabulador
        $.ajax({
          url: api('tabuladores_peso'),
          method: 'GET',
          data: {
            raza_id: razaId,
            edad_dias: edadDias, // El controlador usa 'edad_dias'
          },
          dataType: 'json',
          success: function (res) {
            // 6. Validar respuesta y comparar
            // La API devuelve un array, tomamos el primer resultado si existe
            if (res && res.value === true && res.data.length > 0) {
              const tabulador = res.data[0]
              const ideal = parseFloat(tabulador.peso_ideal)
              const min = parseFloat(tabulador.margen_min)
              const max = parseFloat(tabulador.margen_max)

              // Calcular rango aceptable
              const pesoMinAceptable = ideal - min
              const pesoMaxAceptable = ideal + max

              let statusClass = 'alert-info' // Default class
              let statusMsg = ''

              // Comparar y generar alerta si está fuera de rango
              if (ultimoPeso < pesoMinAceptable) {
                statusClass = 'alert-warning' // Amarillo para bajo peso
                statusMsg = `BAJO PESO. (Actual: ${ultimoPeso.toFixed(
                  2
                )} kg vs Rango: ${pesoMinAceptable.toFixed(
                  2
                )} - ${pesoMaxAceptable.toFixed(2)} kg)`
              } else if (ultimoPeso > pesoMaxAceptable) {
                statusClass = 'alert-danger' // Rojo para sobrepeso
                statusMsg = `SOBREPESO. (Actual: ${ultimoPeso.toFixed(
                  2
                )} kg vs Rango: ${pesoMinAceptable.toFixed(
                  2
                )} - ${pesoMaxAceptable.toFixed(2)} kg)`
              } else {
                statusClass = 'alert-success' // Verde para peso ideal
                statusMsg = `PESO IDEAL. (Actual: ${ultimoPeso.toFixed(
                  2
                )} kg. Rango: ${pesoMinAceptable.toFixed(
                  2
                )} - ${pesoMaxAceptable.toFixed(2)} kg)`
              }

              // 7. Mostrar el badge
              $mensajePeso.text(statusMsg)
              $badgePeso.addClass(statusClass).removeClass('d-none')
            } else {
              // No se encontró un tabulador para esta raza/edad
              $mensajePeso.html(
                `No hay tabulador definido para <b>${formatoTiempoDesdeDias(
                  edadDias
                )}</b>.`
              )
              $badgePeso.addClass('alert-info').removeClass('d-none') // Azul informativo
            }
          },
          error: function (xhr) {
            console.error(
              'Error consultando tabulador de peso:',
              xhr.responseJSON
            )
            $mensajePeso.text(`Error al consultar tabulador.`)
            $badgePeso.addClass('alert-secondary').removeClass('d-none') // Gris para error
          },
        })
      } catch (e) {
        console.error('Error calculando edad o procesando datos:', e)
        $mensajePeso.text(`Datos inválidos para calcular estado de peso.`)
        $badgePeso.addClass('alert-secondary').removeClass('d-none')
      }
    } else {
      // No mostrar el badge si falta raza_id, peso o fecha de nacimiento
      $badgePeso.addClass('d-none')
    }

    // Info General (Sin cambios)
    $('#detalle_identificador_titulo').text(animal.identificador)
    $('#detalle_identificador').text(animal.identificador)
    $('#detalle_sexo').text(animal.sexo)
    $('#detalle_especie').text(animal.especie)
    $('#detalle_raza').text(animal.raza_nombre || 'N/A')
    $('#detalle_fecha_nacimiento').text(
      fDate(animal.fecha_nacimiento) +
        ' / ' +
        calcularEdad(fDate(animal.fecha_nacimiento))
    )
    $('#detalle_estado').html(
      `<span class="badge bg-primary">${animal.estado}</span>`
    )
    $('#detalle_origen').text(animal.origen)
    $('#detalle_created_at').text(fDateTime(animal.created_at))
    cargarImagenConFallback(
      '#detalle_fotografia',
      animal.fotografia_url ? `${baseUrl}${animal.fotografia_url}` : null,
      'https://placehold.co/300x300?text=Sin+Foto'
    )
    // Pesos (Sin cambios)
    let pesosHtml = pesos.length
      ? ''
      : '<tr><td colspan="4" class="text-center">No hay registros de peso.</td></tr>'
    pesos.forEach((p) => {
      pesosHtml += `<tr><td>${fDate(p.fecha_peso)}</td><td>${
        p.peso_kg
      }</td><td>${p.metodo || 'N/A'}</td><td>${
        p.observaciones || 'N/A'
      }</td></tr>`
    })

    if (pesos[0]) {
      $('#detalle_ultimo_peso').html(
        `<b>${pesos[0]['peso_kg']} Kg</b> - ${pesos[0]['fecha_peso']}`
      )
    }

    cargarGraficoPesos(pesos)

    $('#tablaDetallesPesos').html(pesosHtml)

    // Salud (Sin cambios)
    let saludHtml = salud.length
      ? ''
      : '<tr><td colspan="5" class="text-center">No hay eventos de salud registrados.</td></tr>'
    salud.forEach((s) => {
      saludHtml += `<tr><td>${fDate(s.fecha_evento)}</td><td>${
        s.tipo_evento
      }</td><td>${s.diagnostico || 'N/A'}</td><td>${
        s.estado
      }</td><td><button class="btn btn-xs btn-info btn-ver-salud" data-salud-id="${
        s.animal_salud_id
      }">Ver</button></td></tr>`
    })
    $('#tablaDetallesSalud').html(saludHtml)

    // Movimientos (Sin cambios)
    let movHtml = movimientos.length
      ? ''
      : '<tr><td colspan="5" class="text-center">No hay movimientos registrados.</td></tr>'
    movimientos.forEach((m) => {
      const origen =
        [
          m.finca_origen,
          m.aprisco_origen,
          m.area_origen,
          m.codigo_recinto_origen,
        ]
          .filter(Boolean)
          .join(' / ') || 'Externo'
      const destino =
        [
          m.finca_destino,
          m.aprisco_destino,
          m.area_destino,
          m.codigo_recinto_destino,
        ]
          .filter(Boolean)
          .join(' / ') || 'Externo'
      movHtml += `<tr><td>${fDate(m.fecha_mov)}</td><td>${
        m.tipo_movimiento
      }</td><td>${m.motivo}</td><td>${origen}</td><td>${destino}</td></tr>`
    })
    $('#tablaDetallesMovimientos').html(movHtml)

    // Ubicaciones (Sin cambios)
    let ubiHtml = ubicaciones.length
      ? ''
      : '<tr><td colspan="5" class="text-center">No hay ubicaciones registradas.</td></tr>'
    ubicaciones.forEach((u) => {
      const ubicacion =
        [u.nombre_finca, u.nombre_aprisco, u.nombre_area, u.codigo_recinto]
          .filter(Boolean)
          .join(' / ') || 'N/A'
      const estadoClass = u.estado === 'ACTIVA' ? 'success' : 'secondary'
      ubiHtml += `<tr>
                <td>${fDate(u.fecha_desde)}</td>
                <td>${fDate(u.fecha_hasta)}</td>
                <td>${ubicacion}</td>
                <td>${u.motivo}</td>
                <td><span class="badge bg-${estadoClass}">${
        u.estado
      }</span></td>
            </tr>`
    })
    $('#tablaDetallesUbicaciones').html(ubiHtml)

    if (ubicaciones[0]) {
      const ubicacionPath = [
        ubicaciones[0]['nombre_finca'],
        ubicaciones[0]['nombre_aprisco'],
        ubicaciones[0]['nombre_area'],
        ubicaciones[0]['codigo_recinto'],
      ]
        .filter(Boolean)
        .join(' / ')
      $('#detalle_ubicacion_actual').text(ubicacionPath)
    }

    // *** NUEVO: Popular tabla de Incidencias ***
    let incidenciasHtml = incidencias.length
      ? ''
      : '<tr><td colspan="6" class="text-center">No hay incidencias registradas para este animal.</td></tr>'
    incidencias.forEach((i) => {
      incidenciasHtml += `<tr>
                <td>${fDateTime(i.fecha_evento)}</td>
                <td>${tipoIncidenciaFormatter(i.tipo)}</td>
                <td>${i.descripcion || 'N/A'}</td>
                <td>${i.responsable || 'N/A'}</td>
                <td>${i.area_nombre || 'N/A'}</td>
                <td>${incidenciaAccionesFormatter(i.incidencia_id)}</td>
            </tr>`
    })
    $('#tablaDetallesIncidencias').html(incidenciasHtml)
  }

  // (Sin cambios)
  $('#btnRegistrarPeso').on('click', function () {
    modalDetallesAnimal.hide()
    formRegistroPeso.reset()
    window.limpiarErroresDelFormulario?.(formRegistroPeso)
    $('#peso_animal_id').val(currentAnimalIdForDetails)
    $('#fecha_peso').val(new Date().toISOString().slice(0, 10))
    modalRegistroPeso.show()
  })

  // (Sin cambios)
  $('#btnRegistrarSalud').on('click', function () {
    modalDetallesAnimal.hide()
    formRegistroSalud.reset()
    window.limpiarErroresDelFormulario?.(formRegistroSalud)
    $('#salud_animal_id').val(currentAnimalIdForDetails)
    $('#fecha_evento').val(new Date().toISOString().slice(0, 10))
    $('#tipo_evento, #severidad, #estado_salud').trigger('change')
    modalRegistroSalud.show()
  })

  // (Sin cambios)
  $('#btnRegistrarMovimiento').on('click', function () {
    modalDetallesAnimal.hide()
    $(formRegistroMovimiento).trigger('reset')
    window.limpiarErroresDelFormulario?.(formRegistroMovimiento)
    $('#tipo_movimiento, #motivo_movimiento').trigger('change')
    $('#movimiento_animal_id').val(currentAnimalIdForDetails)
    $('#fecha_mov').val(new Date().toISOString().slice(0, 10))

    populateSelect({
      selector: '#formRegistroMovimiento select[name="finca_origen_id"]',
      url: `${baseUrl}api/fincas`,
      placeholder: 'Seleccione Finca de Origen',
      valueField: 'finca_id',
      textField: 'nombre',
      useSelect2: true,
      select2Options: {
        dropdownParent: $(formRegistroMovimiento),
      },
    })
    populateSelect({
      selector: '#formRegistroMovimiento select[name="finca_destino_id"]',
      url: `${baseUrl}api/fincas`,
      placeholder: 'Seleccione Finca de Destino',
      valueField: 'finca_id',
      textField: 'nombre',
      useSelect2: true,
      select2Options: {
        dropdownParent: $(formRegistroMovimiento),
      },
    })

    const selectsToReset = [
      '#formRegistroMovimiento select[name="aprisco_origen_id"]',
      '#formRegistroMovimiento select[name="area_origen_id"]',
      '#formRegistroMovimiento select[name="recinto_id_origen"]',
      '#formRegistroMovimiento select[name="aprisco_destino_id"]',
      '#formRegistroMovimiento select[name="area_destino_id"]',
      '#formRegistroMovimiento select[name="recinto_id_destino"]',
    ]
    selectsToReset.forEach((selector) => {
      $(selector).html('<option value="">--</option>').prop('disabled', true)
      if ($(selector).data('select2')) {
        $(selector).select2('destroy')
      }
    })
    modalRegistroMovimiento.show()
  })

  // (Sin cambios)
  $('#btnRegistrarUbicacion').on('click', function () {
    modalDetallesAnimal.hide()
    $(formRegistroUbicacion).trigger('reset')
    window.limpiarErroresDelFormulario?.(formRegistroUbicacion)
    $('#motivo_ubicacion').trigger('change')
    $('#ubicacion_animal_id').val(currentAnimalIdForDetails)
    $('#fecha_desde_ubicacion').val(new Date().toISOString().slice(0, 10))

    populateSelect({
      selector: '#formRegistroUbicacion select[name="finca_id"]',
      url: `${baseUrl}api/fincas`,
      placeholder: 'Seleccione Finca',
      valueField: 'finca_id',
      textField: 'nombre',
      useSelect2: true,
      select2Options: {
        dropdownParent: $(formRegistroUbicacion),
      },
    })

    const selectsToReset = [
      '#formRegistroUbicacion select[name="aprisco_id"]',
      '#formRegistroUbicacion select[name="area_id"]',
      '#formRegistroUbicacion select[name="recinto_id"]',
    ]
    selectsToReset.forEach((selector) => {
      $(selector).html('<option value="">--</option>').prop('disabled', true)
      if ($(selector).data('select2')) {
        $(selector).select2('destroy')
      }
    })
    modalRegistroUbicacion.show()
  })

  // *** MODIFICADO: Lógica de botones de cancelar (añadidos los de incidencia) ***
  $(
    '#btnCancelarRegistroPeso, #btnCancelarRegistroSalud, #btnCancelarRegistroMovimiento, #btnCancelarRegistroUbicacion, #btnCerrarDetalleSalud, #btnCancelarRegistroIncidencia, #btnCerrarDetalleIncidencia'
  ).on('click', function () {
    if (currentAnimalIdForDetails) {
      // Usamos un pequeño timeout para asegurar que el modal actual se cierre
      // antes de mostrar el modal de detalles
      setTimeout(() => modalDetallesAnimal.show(), 200)
    }
  })

  // (Sin cambios)
  $('#tablaDetallesSalud').on('click', '.btn-ver-salud', function () {
    const saludId = $(this).data('salud-id')
    $.ajax({
      url: `${baseUrl}api/animal_salud/${saludId}`,
      method: 'GET',
      success: function (response) {
        const s = response.data
        $('#detalle_salud_fecha').text(fDate(s.fecha_evento))
        $('#detalle_salud_tipo').text(s.tipo_evento)
        $('#detalle_salud_diagnostico').text(s.diagnostico || 'N/A')
        $('#detalle_salud_severidad').text(
          s.severidad ? s.severidad.replace('_', ' ') : 'N/A'
        )
        $('#detalle_salud_tratamiento').text(s.tratamiento || 'N/A')
        $('#detalle_salud_medicamento').text(s.medicamento || 'N/A')
        $('#detalle_salud_dosis').text(s.dosis || 'N/A')
        $('#detalle_salud_via').text(s.via_administracion || 'N/A')
        $('#detalle_salud_costo').text(s.costo ? `Bs. ${s.costo}` : 'N/A')
        $('#detalle_salud_estado').html(
          `<span class="badge bg-info">${s.estado}</span>`
        )
        $('#detalle_salud_revision').text(fDate(s.proxima_revision))
        $('#detalle_salud_responsable').text(s.responsable || 'N/A')
        $('#detalle_salud_observaciones').text(s.observaciones || 'N/A')

        const modalDetallesAnimalEl = document.getElementById(
          'modalDetallesAnimal'
        )
        $(modalDetallesAnimalEl).one('hidden.bs.modal', function (event) {
          modalDetallesSalud.show()
        })
        modalDetallesAnimal.hide()
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // --- ENVÍO DE FORMULARIOS DE REGISTRO SECUNDARIOS ---

  // (Sin cambios)
  formRegistroPeso.addEventListener('validation:success', function (e) {
    const data = JSON.stringify(e.detail.datos)
    $.ajax({
      url: `${baseUrl}api/animal_pesos`,
      method: 'POST',
      contentType: 'application/json',
      data: data,
      success: function (response) {
        modalRegistroPeso.hide()
        showSuccessToast(response) // *** MODIFICADO: Usar showSuccessToast ***
        // Refrescar detalles y tabla principal
        mostrarDetalles(currentAnimalIdForDetails)
        $('#tablaAnimales').bootstrapTable('refresh')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // (Sin cambios)
  formRegistroSalud.addEventListener('validation:success', function (e) {
    const formDataObject = e.detail.datos
    if (formDataObject.proxima_revision === '')
      delete formDataObject.proxima_revision
    if (formDataObject.costo === '') delete formDataObject.costo

    const data = JSON.stringify(formDataObject)
    $.ajax({
      url: `${baseUrl}api/animal_salud`,
      method: 'POST',
      contentType: 'application/json',
      data: data,
      success: function (response) {
        modalRegistroSalud.hide()
        showSuccessToast(response) // *** MODIFICADO: Usar showSuccessToast ***
        mostrarDetalles(currentAnimalIdForDetails)
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // (Sin cambios)
  formRegistroMovimiento.addEventListener('validation:success', function (e) {
    const body = e.detail.datos
    const tipo = body.tipo_movimiento

    const requiereOrigen = ['EGRESO', 'TRASLADO', 'VENTA', 'MUERTE']
    const requiereDestino = ['INGRESO', 'COMPRA', 'NACIMIENTO', 'TRASLADO']

    if (requiereOrigen.includes(tipo) && !body.recinto_id_origen) {
      showErrorToast({
        message:
          'Para este tipo de movimiento, debe seleccionar un Recinto de Origen.',
      })
      $('#formRegistroMovimiento select[name="finca_origen_id"]').select2(
        'open'
      )
      return
    }

    if (requiereDestino.includes(tipo) && !body.recinto_id_destino) {
      showErrorToast({
        message:
          'Para este tipo de movimiento, debe seleccionar un Recinto de Destino.',
      })
      $('#formRegistroMovimiento select[name="finca_destino_id"]').select2(
        'open'
      )
      return
    }

    const data = JSON.stringify(body)
    $.ajax({
      url: `${baseUrl}api/animal_movimientos`,
      method: 'POST',
      contentType: 'application/json',
      data: data,
      success: function (response) {
        modalRegistroMovimiento.hide()
        showSuccessToast(response) // *** MODIFICADO: Usar showSuccessToast ***
        mostrarDetalles(currentAnimalIdForDetails)
        $('#tablaAnimales').bootstrapTable('refresh')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // (Sin cambios)
  formRegistroUbicacion.addEventListener('validation:success', function (e) {
    const formDataObject = e.detail.datos
    if (formDataObject.fecha_hasta === '') delete formDataObject.fecha_hasta

    const data = JSON.stringify(formDataObject)
    $.ajax({
      url: `${baseUrl}api/animal_ubicaciones`,
      method: 'POST',
      contentType: 'application/json',
      data: data,
      success: function (response) {
        modalRegistroUbicacion.hide()
        showSuccessToast(response) // *** MODIFICADO: Usar showSuccessToast ***
        mostrarDetalles(currentAnimalIdForDetails)
        $('#tablaAnimales').bootstrapTable('refresh')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // --- FUNCIONES Y LÓGICA PARA SELECTS DINÁMICOS (Sin cambios) ---

  // (Lógica de selects dinámicos para Movimientos y Ubicaciones no cambia)
  // ... (ver tu archivo original) ...
  const $modalMovimiento = $(formRegistroMovimiento)
  const $modalUbicacion = $(formRegistroUbicacion)

  // --- Lógica para el modal de Movimientos (ORIGEN) ---
  $('#formRegistroMovimiento').on(
    'change',
    'select[name="finca_origen_id"]',
    function () {
      const fincaId = $(this).val()
      const $apriscoSelect = $(
        '#formRegistroMovimiento select[name="aprisco_origen_id"]'
      )
      const $areaSelect = $(
        '#formRegistroMovimiento select[name="area_origen_id"]'
      )
      const $recintoSelect = $(
        '#formRegistroMovimiento select[name="recinto_id_origen"]'
      )

      $areaSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $areaSelect.select2('destroy')
      $recintoSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $recintoSelect.select2('destroy')

      if (fincaId) {
        populateSelect({
          selector: $apriscoSelect,
          url: `${baseUrl}api/apriscos?finca_id=${fincaId}`,
          placeholder: 'Seleccione Aprisco',
          valueField: 'aprisco_id',
          textField: 'nombre',
          useSelect2: true,
          emptyMessage: 'Esta finca no posee apriscos',
          messageSelector: '#formRegistroMovimiento .no-options-message',
          select2Options: {
            dropdownParent: $modalMovimiento,
          },
        })
      } else {
        $apriscoSelect
          .html('<option value="">Seleccione Finca primero</option>')
          .prop('disabled', true)
        if ($apriscoSelect.data('select2')) $apriscoSelect.select2('destroy')
      }
    }
  )

  $('#formRegistroMovimiento').on(
    'change',
    'select[name="aprisco_origen_id"]',
    function () {
      const apriscoId = $(this).val()
      const $areaSelect = $(
        '#formRegistroMovimiento select[name="area_origen_id"]'
      )
      const $recintoSelect = $(
        '#formRegistroMovimiento select[name="recinto_id_origen"]'
      )

      $recintoSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $recintoSelect.select2('destroy')

      if (apriscoId) {
        populateSelect({
          selector: $areaSelect,
          url: `${baseUrl}api/areas?aprisco_id=${apriscoId}`,
          placeholder: 'Seleccione Área',
          valueField: 'area_id',
          textField: (item) =>
            `${item.nombre_personalizado || 'Área'} (${
              item.numeracion || 'S/N'
            })`,
          useSelect2: true,
          emptyMessage: 'Este aprisco no posee áreas',
          messageSelector: '#formRegistroMovimiento .no-options-message',
          select2Options: {
            dropdownParent: $modalMovimiento,
          },
        })
      } else {
        $areaSelect
          .html('<option value="">Seleccione Aprisco primero</option>')
          .prop('disabled', true)
        if ($areaSelect.data('select2')) $areaSelect.select2('destroy')
      }
    }
  )

  $('#formRegistroMovimiento').on(
    'change',
    'select[name="area_origen_id"]',
    function () {
      const areaId = $(this).val()
      const $recintoSelect = $(
        '#formRegistroMovimiento select[name="recinto_id_origen"]'
      )
      if (areaId) {
        populateSelect({
          selector: $recintoSelect,
          url: `${baseUrl}api/recintos?area_id=${areaId}`,
          placeholder: 'Seleccione Recinto',
          valueField: 'recinto_id',
          textField: (item) => `${item.codigo_recinto || 'S/C'}`,
          useSelect2: true,
          emptyMessage: 'Esta área no posee recintos',
          messageSelector: '#formRegistroMovimiento .no-options-message',
          select2Options: {
            dropdownParent: $modalMovimiento,
          },
        })
      } else {
        $recintoSelect
          .html('<option value="">Seleccione Área primero</option>')
          .prop('disabled', true)
        if ($recintoSelect.data('select2')) $recintoSelect.select2('destroy')
      }
    }
  )

  // --- Lógica para el modal de Movimientos (DESTINO) ---
  $('#formRegistroMovimiento').on(
    'change',
    'select[name="finca_destino_id"]',
    function () {
      const fincaId = $(this).val()
      const $apriscoSelect = $(
        '#formRegistroMovimiento select[name="aprisco_destino_id"]'
      )
      const $areaSelect = $(
        '#formRegistroMovimiento select[name="area_destino_id"]'
      )
      const $recintoSelect = $(
        '#formRegistroMovimiento select[name="recinto_id_destino"]'
      )

      $areaSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $areaSelect.select2('destroy')
      $recintoSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $recintoSelect.select2('destroy')

      if (fincaId) {
        populateSelect({
          selector: $apriscoSelect,
          url: `${baseUrl}api/apriscos?finca_id=${fincaId}`,
          placeholder: 'Seleccione Aprisco',
          valueField: 'aprisco_id',
          textField: 'nombre',
          useSelect2: true,
          emptyMessage: 'Esta finca no posee apriscos',
          messageSelector: '#formRegistroMovimiento .no-options-message',
          select2Options: {
            dropdownParent: $modalMovimiento,
          },
        })
      } else {
        $apriscoSelect
          .html('<option value="">Seleccione Finca primero</option>')
          .prop('disabled', true)
        if ($apriscoSelect.data('select2')) $apriscoSelect.select2('destroy')
      }
    }
  )

  $('#formRegistroMovimiento').on(
    'change',
    'select[name="aprisco_destino_id"]',
    function () {
      const apriscoId = $(this).val()
      const $areaSelect = $(
        '#formRegistroMovimiento select[name="area_destino_id"]'
      )
      const $recintoSelect = $(
        '#formRegistroMovimiento select[name="recinto_id_destino"]'
      )

      $recintoSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $recintoSelect.select2('destroy')

      if (apriscoId) {
        populateSelect({
          selector: $areaSelect,
          url: `${baseUrl}api/areas?aprisco_id=${apriscoId}`,
          placeholder: 'Seleccione Área',
          valueField: 'area_id',
          textField: (item) =>
            `${item.nombre_personalizado || 'Área'} (${
              item.numeracion || 'S/N'
            })`,
          useSelect2: true,
          emptyMessage: 'Este aprisco no posee áreas',
          messageSelector: '#formRegistroMovimiento .no-options-message',
          select2Options: {
            dropdownParent: $modalMovimiento,
          },
        })
      } else {
        $areaSelect
          .html('<option value="">Seleccione Aprisco primero</option>')
          .prop('disabled', true)
        if ($areaSelect.data('select2')) $areaSelect.select2('destroy')
      }
    }
  )

  $('#formRegistroMovimiento').on(
    'change',
    'select[name="area_destino_id"]',
    function () {
      const areaId = $(this).val()
      const $recintoSelect = $(
        '#formRegistroMovimiento select[name="recinto_id_destino"]'
      )
      if (areaId) {
        populateSelect({
          selector: $recintoSelect,
          url: `${baseUrl}api/recintos?area_id=${areaId}`,
          placeholder: 'Seleccione Recinto',
          valueField: 'recinto_id',
          textField: (item) => `${item.codigo_recinto || 'S/C'}`,
          useSelect2: true,
          emptyMessage: 'Esta área no posee recintos',
          messageSelector: '#formRegistroMovimiento .no-options-message',
          select2Options: {
            dropdownParent: $modalMovimiento,
          },
        })
      } else {
        $recintoSelect
          .html('<option value="">Seleccione Área primero</option>')
          .prop('disabled', true)
        if ($recintoSelect.data('select2')) $recintoSelect.select2('destroy')
      }
    }
  )

  // --- Lógica para el modal de Ubicaciones ---
  $('#formRegistroUbicacion').on(
    'change',
    'select[name="finca_id"]',
    function () {
      const fincaId = $(this).val()
      const $apriscoSelect = $(
        '#formRegistroUbicacion select[name="aprisco_id"]'
      )
      const $areaSelect = $('#formRegistroUbicacion select[name="area_id"]')
      const $recintoSelect = $(
        '#formRegistroUbicacion select[name="recinto_id"]'
      )

      $areaSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $areaSelect.select2('destroy')
      $recintoSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $recintoSelect.select2('destroy')

      if (fincaId) {
        populateSelect({
          selector: $apriscoSelect,
          url: `${baseUrl}api/apriscos?finca_id=${fincaId}`,
          placeholder: 'Seleccione Aprisco',
          valueField: 'aprisco_id',
          textField: 'nombre',
          useSelect2: true,
          emptyMessage: 'Esta finca no posee apriscos',
          messageSelector: '#formRegistroUbicacion .no-options-message',
          select2Options: {
            dropdownParent: $modalUbicacion,
          },
        })
      } else {
        $apriscoSelect
          .html('<option value="">Seleccione Finca primero</option>')
          .prop('disabled', true)
        if ($apriscoSelect.data('select2')) $apriscoSelect.select2('destroy')
      }
    }
  )

  $('#formRegistroUbicacion').on(
    'change',
    'select[name="aprisco_id"]',
    function () {
      const apriscoId = $(this).val()
      const $areaSelect = $('#formRegistroUbicacion select[name="area_id"]')
      const $recintoSelect = $(
        '#formRegistroUbicacion select[name="recinto_id"]'
      )

      $recintoSelect
        .html('<option value="">--</option>')
        .prop('disabled', true)
        .data('select2') && $recintoSelect.select2('destroy')

      if (apriscoId) {
        populateSelect({
          selector: $areaSelect,
          url: `${baseUrl}api/areas?aprisco_id=${apriscoId}`,
          placeholder: 'Seleccione Área',
          valueField: 'area_id',
          textField: (item) =>
            `${item.nombre_personalizado || 'Área'} (${
              item.numeracion || 'S/N'
            })`,
          useSelect2: true,
          emptyMessage: 'Este aprisco no posee áreas',
          messageSelector: '#formRegistroUbicacion .no-options-message',
          select2Options: {
            dropdownParent: $modalUbicacion,
          },
        })
      } else {
        $areaSelect
          .html('<option value="">Seleccione Aprisco primero</option>')
          .prop('disabled', true)
        if ($areaSelect.data('select2')) $areaSelect.select2('destroy')
      }
    }
  )

  $('#formRegistroUbicacion').on(
    'change',
    'select[name="area_id"]',
    function () {
      const areaId = $(this).val()
      const $recintoSelect = $(
        '#formRegistroUbicacion select[name="recinto_id"]'
      )
      if (areaId) {
        populateSelect({
          selector: $recintoSelect,
          url: `${baseUrl}api/recintos?area_id=${areaId}`,
          placeholder: 'Seleccione Recinto',
          valueField: 'recinto_id',
          textField: (item) => `${item.codigo_recinto || 'S/C'}`,
          useSelect2: true,
          emptyMessage: 'Esta área no posee recintos',
          messageSelector: '#formRegistroUbicacion .no-options-message',
          select2Options: {
            dropdownParent: $modalUbicacion,
          },
        })
      } else {
        $recintoSelect
          .html('<option value="">Seleccione Área primero</option>')
          .prop('disabled', true)
        if ($recintoSelect.data('select2')) $recintoSelect.select2('destroy')
      }
    }
  )

  // --- FUNCIONES AUXILIARES DE EDICIÓN Y ELIMINACIÓN (Sin cambios) ---

  async function editarAnimal(animalId) {
    try {
      const response = await $.ajax({
        url: api(`animales/${animalId}`), // Usando helper api()
        method: 'GET',
      })

      const data = response.data
      formAnimal.reset()
      window.limpiarErroresDelFormulario?.(formAnimal)

      // Rellenar campos simples
      $('#animal_id').val(data.animal_id)
      $('#identificador').val(data.identificador)
      $('#identificador').attr('data-initial-value', data.identificador)

      // *** MODIFICADO: Quitado el input de texto 'raza' ***
      // $('#raza').val(data.raza)

      $('#fecha_nacimiento').val(data.fecha_nacimiento)

      // Triggers para Selects estáticos
      $('#sexo').val(data.sexo).trigger('change')
      $('#estado').val(data.estado).trigger('change')
      $('#origen').val(data.origen).trigger('change')

      $('#fotografia-preview').attr(
        'src',
        data.fotografia_url
          ? `${baseUrl}${data.fotografia_url}`
          : 'https://placehold.co/200x200?text=Vista+Previa'
      )
      $('#modalAnimalLabel').text('Editar Animal')

      // Cargar Selects de Padre/Madre/Raza
      const modal = $formAnimal
      const madreConfig = {
        selector: '#madre_id',
        url: api('animales?sexo=HEMBRA'),
        valueField: 'animal_id',
        textField: 'identificador',
        placeholder: 'Seleccione una madre (Opcional)',
        useSelect2: true,
        select2Options: { dropdownParent: modal },
        emptyMessage: 'No hay animales para seleccionar',
      }
      const padreConfig = {
        selector: '#padre_id',
        url: api('animales?sexo=MACHO'),
        valueField: 'animal_id',
        textField: 'identificador',
        placeholder: 'Seleccione un padre (Opcional)',
        useSelect2: true,
        select2Options: { dropdownParent: modal },
        emptyMessage: 'No hay animales para seleccionar',
      }

      // *** NUEVO: Configuración para cargar el select de Raza ***
      const razaConfig = {
        selector: '#raza_id',
        // Filtramos por la especie del animal y solo activas
        url: api(`razas?especie=${data.especie}&estado=ACTIVA`),
        valueField: 'raza_id',
        textField: 'nombre',
        placeholder: 'Seleccione una raza...',
        useSelect2: true,
        select2Options: { dropdownParent: modal },
      }

      // Establecer 'especie' ANTES de cargar las razas
      $('#especie').val(data.especie).trigger('change.select2') // Evita disparar el 'change' nuestro

      // Cargar todos los selects en paralelo
      await Promise.all([
        populateSelect(madreConfig),
        populateSelect(padreConfig),
        populateSelect(razaConfig), // Cargar razas
      ])

      // Establecer valores después de cargar
      $('#madre_id').val(data.madre_id).trigger('change')
      $('#padre_id').val(data.padre_id).trigger('change')
      // *** NUEVO: Establecer la raza_id guardada ***
      $('#raza_id').val(data.raza_id).trigger('change')
      // Habilitar el select de raza (ya que tiene una especie)
      $('#raza_id').prop('disabled', false)

      modalAnimal.show()
    } catch (error) {
      console.error('Error al preparar edición de animal:', error)
      showErrorToast(
        error.responseJSON || {
          message: 'No se pudo cargar la información para editar.',
        }
      )
    }
  }

  // (Sin cambios)
  function eliminarAnimal(animalId) {
    Swal.fire({
      title: '¿Estás seguro?',
      text: 'El animal será eliminado lógicamente.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'Sí, eliminar',
      cancelButtonText: 'Cancelar',
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
          url: `${baseUrl}api/animales/${animalId}`,
          method: 'DELETE',
          success: function (response) {
            // *** MODIFICADO: Usar showSuccessToast ***
            showSuccessToast(response)
            $('#tablaAnimales').bootstrapTable('refresh')
          },
          error: function (xhr) {
            showErrorToast(xhr.responseJSON)
          },
        })
      }
    })
  }

  // ==========================================================
  // == *** NUEVO: LÓGICA PARA EL CRUD DE INCIDENCIAS ***
  // ==========================================================

  const $modalRegistroIncidencia = $(formRegistroIncidencia)

  const $contenedorVictimas = $('#lista-victimas')
  const $seccionConsecuencias = $('#seccion-consecuencias')

  function agregarFilaVictima(victimaData = null) {
    // Generar un ID único para los elementos de esta fila
    const index = Date.now() + Math.floor(Math.random() * 1000)

    // Extraer datos si es edición
    const saludId = victimaData ? victimaData.animal_salud_id || '' : ''
    const idAnimal = victimaData ? victimaData.animal_id : ''

    // Limpiar prefijos automáticos del backend para que sea más limpio editar
    let desc = victimaData ? victimaData.descripcion || '' : ''
    desc = desc.replace(/^Consecuencia de Incidencia.*?\.\s*/i, '')

    const sev = victimaData ? victimaData.severidad : 'LEVE'

    const html = `
        <div class="row g-1 mb-2 align-items-center fila-victima bg-white p-1 border rounded" id="row-${index}">
            <input type="hidden" class="input-salud-id" value="${saludId}">

            <div class="col-md-4">
                <select class="form-select form-select-sm select-victima" name="victima_id_${index}"></select>
            </div>
            <div class="col-md-4">
                <input type="text" class="form-control form-control-sm input-desc" 
                       placeholder="Ej. Mordida en oreja" value="${desc}">
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
                <button type="button" class="btn btn-sm btn-link text-danger btn-remove-victima p-0" title="Quitar">
                    <i class="mdi mdi-close-circle fs-5"></i>
                </button>
            </div>
        </div>
    `

    $contenedorVictimas.append(html)

    // Inicializar Select2 en la fila nueva
    const $select = $(`#row-${index} .select-victima`)

    populateSelect({
      selector: $select,
      url: `${baseUrl}api/animales`,
      placeholder: 'Buscar animal...',
      valueField: 'animal_id',
      textField: 'identificador',
      useSelect2: true,
      select2Options: {
        dropdownParent: $modalRegistroIncidencia.parent(), // Fix para que funcione dentro del modal
      },
    }).then(() => {
      // Pre-selección en modo Edición
      if (idAnimal) {
        // Si el animal ya está en las opciones cargadas
        if ($select.find("option[value='" + idAnimal + "']").length) {
          $select.val(idAnimal).trigger('change')
        } else {
          // Si no está (por paginación), creamos la opción manualmente para visualizarlo
          const nombreAnimal =
            victimaData.animal_identificador || 'Animal Seleccionado'
          const option = new Option(nombreAnimal, idAnimal, true, true)
          $select.append(option).trigger('change')
        }
      }
    })
  }

  // Evento para eliminar fila
  $contenedorVictimas.on('click', '.btn-remove-victima', function () {
    $(this).closest('.fila-victima').remove()
  })

  // Evento botón agregar
  $('#btnAgregarVictima').on('click', function () {
    agregarFilaVictima()
  })

  // Lógica para mostrar/ocultar sección según tipo
  $('#incidencia_tipo').on('change', function () {
    const tipo = $(this).val()
    // Tipos que habilitan el registro de salud (consecuencias)
    const tiposConHeridos = ['RIÑA', 'AGRESIVIDAD', 'APLASTAMIENTO']

    if (tiposConHeridos.includes(tipo)) {
      $seccionConsecuencias.removeClass('d-none')
    } else {
      $seccionConsecuencias.addClass('d-none')
      $contenedorVictimas.empty() // Limpiamos si cambian a un tipo que no aplica
    }
  })

  $('#btnRegistrarIncidencia').on('click', function () {
    modalDetallesAnimal.hide()
    formRegistroIncidencia.reset()
    window.limpiarErroresDelFormulario?.(formRegistroIncidencia)

    // Resetear sección dinámica
    $contenedorVictimas.empty()
    $seccionConsecuencias.addClass('d-none')
    $('#incidencia_tipo').val('').trigger('change')

    // Valores por defecto
    $('#incidencia_animal_id').val(currentAnimalIdForDetails)
    $('#incidencia_id').val('') // Vacío = Crear
    $('#modalRegistroIncidenciaLabel').text('Registrar Incidencia')

    // Fecha actual local formateada para input datetime-local
    const now = new Date()
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset())
    $('#incidencia_fecha_evento').val(now.toISOString().slice(0, 16))

    // Cargar Select de Área
    populateSelect({
      selector: '#incidencia_area_id',
      url: `${baseUrl}api/areas`,
      placeholder: 'Ninguna (Usar ubicación actual)',
      valueField: 'area_id',
      textField: (item) =>
        `${item.nombre_personalizado || 'Área'} (${item.numeracion || 'S/N'})`,
      useSelect2: true,
      select2Options: { dropdownParent: $('#formRegistroIncidencia').parent() },
    })

    modalRegistroIncidencia.show()
  })

  // 2. SUBMIT FORMULARIO (CREAR / EDITAR)
  formRegistroIncidencia.addEventListener('validation:success', function (e) {
    const body = e.detail.datos
    const incidenciaId = body.incidencia_id

    // --- Recolectar Consecuencias ---
    let consecuencias = []
    if (!$seccionConsecuencias.hasClass('d-none')) {
      $('.fila-victima').each(function () {
        const $row = $(this)
        const saludId = $row.find('.input-salud-id').val() // ID para edición
        const animalId = $row.find('.select-victima').val()
        const descripcion = $row.find('.input-desc').val()
        const severidad = $row.find('.input-sev').val()

        if (animalId) {
          consecuencias.push({
            animal_salud_id: saludId, // Se envía vacío si es nuevo
            animal_id: animalId,
            descripcion: descripcion,
            severidad: severidad,
          })
        }
      })
    }

    // Agregar al payload solo si hay datos
    if (consecuencias.length > 0) {
      body.consecuencias_salud = consecuencias
    }

    // Definir URL y método
    let url = baseUrl + 'api/incidencias'
    if (incidenciaId) {
      url = `${baseUrl}api/incidencias/${incidenciaId}`
    }

    // Limpiar campos opcionales
    body.area_id = body.area_id || null

    const formData = new FormData()
    const file = $incidenciaFileInput.get(0).files[0] // Obtener el archivo

    // 1. Agregar todos los campos de texto/data al FormData
    for (const key in body) {
      if (body[key] !== null && body[key] !== undefined) {
        // Si el valor es un array (consecuencias_salud), debe ser JSON.stringify
        if (Array.isArray(body[key])) {
          formData.append(key, JSON.stringify(body[key]))
        } else {
          formData.append(key, body[key])
        }
      }
    }

    // 2. Lógica de eliminación o subida
    const fotoExistenteUrl = $incidenciaFotoUrlExistente.val()
    const marcadaParaEliminar = $incidenciaEliminarFotoInput.val() === '1'

    if (file) {
      // Caso A: Subiendo nueva foto (tiene la prioridad)
      formData.append('fotografia', file)
    } else if (incidenciaId && marcadaParaEliminar) {
      // Caso B: Borrando una foto existente (Solo si no hay archivo nuevo)
      formData.append('fotografia_url', '') // String vacío para que el Controller lo interprete como NULL
    } else if (incidenciaId && fotoExistenteUrl && !marcadaParaEliminar) {
      // Caso C: Editando SIN cambiar/borrar la foto.
      // No hacemos nada, el Controller mantendrá la foto actual.
      // NOTA: Es importante que el Controller ignore campos faltantes.
      // Si el Controller lo exige, tendríamos que enviar la URL existente aquí.
      // Pero dado que estamos usando multipart, confiamos en que el Controller lo maneje.
    }

    $.ajax({
      url: url,
      method: 'POST',
      data: formData,
      processData: false, // Evita que jQuery procese el FormData
      contentType: false, // Fundamental: deja que el navegador establezca el Content-Type (multipart)
      success: function (res) {
        modalRegistroIncidencia.hide()
        showSuccessToast(res)
        // Recargar la vista de detalles
        mostrarDetalles(currentAnimalIdForDetails)
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })
  // 3. VER DETALLES DE LA INCIDENCIA
  $('#tablaDetallesIncidencias').on(
    'click',
    '.btn-ver-incidencia',
    function () {
      const id = $(this).data('id')
      $.ajax({
        url: `${baseUrl}api/incidencias/${id}`,
        method: 'GET',
        success: function (res) {
          const d = res.data

          let fotoHtml = ''
          if (d.fotografia_url) {
            const fullUrl = `${baseUrl}${d.fotografia_url}`
            fotoHtml = `<div class="col-12 mt-3 text-center mb-2">
                              <small class="text-muted d-block">Evidencia Fotográfica</small>
                              <img src="${fullUrl}" alt="Evidencia de Incidencia" class="img-fluid rounded border mt-1" style="max-height: 250px;">
                          </div>`
          }

          // Renderizar lista de heridos
          let victimasHtml = ''
          if (d.consecuencias_salud && d.consecuencias_salud.length > 0) {
            victimasHtml = `
            <div class="mt-3 border-top pt-2">
                <h6 class="text-danger"><i class="mdi mdi-hospital-box"></i> Consecuencias de Salud</h6>
                <div class="table-responsive">
                    <table class="table table-sm table-borderless mb-0">
                        <thead class="text-muted small">
                            <tr><th>Animal</th><th>Detalle</th><th>Severidad</th></tr>
                        </thead>
                        <tbody>`
            d.consecuencias_salud.forEach((v) => {
              const colorBadge =
                v.severidad === 'GRAVE'
                  ? 'danger'
                  : v.severidad === 'MODERADA'
                  ? 'warning'
                  : 'success'
              victimasHtml += `
                    <tr>
                        <td class="fw-bold">${v.animal_identificador}</td>
                        <td class="small text-muted">${
                          v.descripcion || '-'
                        }</td>
                        <td><span class="badge bg-${colorBadge}">${
                v.severidad
              }</span></td>
                    </tr>`
            })
            victimasHtml += `</tbody></table></div></div>`
          }

          const bodyHtml = `
          <div class="row">
              <div class="col-6 mb-2"><small class="text-muted">Tipo:</small><br>${tipoIncidenciaFormatter(
                d.tipo
              )}</div>
              <div class="col-6 mb-2"><small class="text-muted">Fecha:</small><br><strong>${fDateTime(
                d.fecha_evento
              )}</strong></div>
              <div class="col-6 mb-2"><small class="text-muted">Ubicación:</small><br>${
                d.area_nombre ||
                '<span class="fst-italic">Ubicación del animal</span>'
              }</div>
              <div class="col-6 mb-2"><small class="text-muted">Responsable:</small><br>${
                d.responsable || '-'
              }</div>
              ${fotoHtml}
          </div>
          <div class="bg-light p-2 rounded border mb-2">
              <small class="text-muted d-block fw-bold">Descripción:</small>
              ${
                d.descripcion ||
                '<span class="text-muted fst-italic">Sin descripción</span>'
              }
          </div>
          ${victimasHtml}
        `

          $('#modalDetallesIncidenciaBody').html(bodyHtml)
          modalDetallesAnimal.hide()
          modalDetallesIncidencia.show()
        },
        error: function (xhr) {
          showErrorToast(xhr.responseJSON)
        },
      })
    }
  )

  // 4. EDITAR INCIDENCIA
  $('#tablaDetallesIncidencias').on(
    'click',
    '.btn-editar-incidencia',
    async function () {
      const id = $(this).data('id')

      try {
        const response = await $.ajax({
          url: `${baseUrl}api/incidencias/${id}`,
          method: 'GET',
        })
        const data = response.data

        formRegistroIncidencia.reset()
        window.limpiarErroresDelFormulario?.(formRegistroIncidencia)
        $contenedorVictimas.empty()

        // Cargar datos básicos
        $('#incidencia_animal_id').val(data.animal_id)
        $('#incidencia_id').val(data.incidencia_id)
        $('#incidencia_responsable').val(data.responsable)
        $('#incidencia_descripcion').val(data.descripcion)

        const fechaEvento = data.fecha_evento
          ? data.fecha_evento.replace(' ', 'T').substring(0, 16)
          : ''
        $('#incidencia_fecha_evento').val(fechaEvento)

        $('#modalRegistroIncidenciaLabel').text('Editar Incidencia')

        // Cargar Select Área
        await populateSelect({
          selector: '#incidencia_area_id',
          url: `${baseUrl}api/areas`,
          placeholder: 'Ninguna (Usar ubicación actual)',
          valueField: 'area_id',
          textField: (item) =>
            `${item.nombre_personalizado || 'Área'} (${
              item.numeracion || 'S/N'
            })`,
          useSelect2: true,
          select2Options: {
            dropdownParent: $('#formRegistroIncidencia').parent(),
          },
        })
        $('#incidencia_area_id').val(data.area_id).trigger('change')

        // Establecer Tipo y disparar evento para mostrar/ocultar consecuencias
        $('#incidencia_tipo').val(data.tipo).trigger('change')

        // Si el tipo permite consecuencias, cargamos las existentes
        const tiposConHeridos = ['RIÑA', 'AGRESIVIDAD', 'APLASTAMIENTO']
        if (
          tiposConHeridos.includes(data.tipo) &&
          data.consecuencias_salud &&
          data.consecuencias_salud.length > 0
        ) {
          data.consecuencias_salud.forEach((v) => {
            agregarFilaVictima(v)
          })
        }

        resetIncidenciaPhotoPreview() // Limpiar el estado del modal de foto

        if (data.fotografia_url) {
          const fullUrl = `${baseUrl}${data.fotografia_url}`
          const filename = data.fotografia_url.substring(
            data.fotografia_url.lastIndexOf('/') + 1
          )

          // Guardar la URL existente en el campo oculto y mostrar vista previa
          $incidenciaFotoUrlExistente.val(data.fotografia_url)
          showIncidenciaPhotoPreview(fullUrl, filename, true)
        }

        modalDetallesAnimal.hide()
        modalRegistroIncidencia.show()
      } catch (error) {
        showErrorToast(
          error.responseJSON || { message: 'Error al cargar datos.' }
        )
      }
    }
  )

  // 5. ELIMINAR INCIDENCIA
  $('#tablaDetallesIncidencias').on(
    'click',
    '.btn-eliminar-incidencia',
    function () {
      const id = $(this).data('id')
      Swal.fire({
        title: '¿Eliminar Incidencia?',
        text: 'Si esta incidencia generó registros de salud (heridas), estos también serán eliminados.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        confirmButtonText: 'Sí, eliminar',
      }).then((result) => {
        if (result.isConfirmed) {
          $.ajax({
            url: `${baseUrl}api/incidencias/${id}`,
            method: 'DELETE',
            success: function (res) {
              showSuccessToast(res)
              mostrarDetalles(currentAnimalIdForDetails)
            },
            error: function (xhr) {
              showErrorToast(xhr.responseJSON)
            },
          })
        }
      })
    }
  )
  // Iniciar mostrar detalles si se encuentra "animal" como parametro en la url
  const urlParams = new URLSearchParams(window.location.search)
  const animalIdParam = urlParams.get('animal')
  if (animalIdParam) {
    mostrarDetalles(animalIdParam)
  }
}) // Fin DOMContentLoaded
