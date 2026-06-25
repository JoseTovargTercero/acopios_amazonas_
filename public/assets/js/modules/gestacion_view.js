import {
  showErrorToast,
  showSuccessToast,
  formatDate,
} from '../helpers/helpers.js'
import { populateSelect } from '../helpers/populateSelect.js'

// --- VARIABLES GLOBALES DEL MÓDULO ---
let currentHembraId = null
let currentPeriodoId = null
let currentCamadaData = null // Almacenará los datos de la camada gestionada

// --- HELPERS Y FORMATTERS ---
const api = (path) => `${baseUrl}api/${path}`
const $formAnimal = $(document.getElementById('formAnimal')) // Necesario para Select2

// Handler para Bootstrap Table
window.responseHandler = function (res) {
  return {
    rows: res.data,
    total: res.data.length, // Asumiendo que la API no pagina por ahora
  }
}

// Formatter para fecha (ya importado, pero lo re-declaramos localmente por si acaso)
window.fDate = (dateString) => {
  if (!dateString) return 'N/A'
  return formatDate(dateString, false) // false = no hora
}

// Formatter para tabla GESTANTES
window.gestantesAccionesFormatter = function (value, row) {
  // value es el periodo_id
  return `
    <button class="btn btn-primary btn-sm btn-registrar-parto" 
            data-periodo-id="${value}" 
            data-hembra-id="${row.hembra_id}" 
            title="Registrar Parto">
        <i class="mdi mdi-baby-carriage"></i> Registrar Parto
    </button>`
}

// Formatter para tabla CAMADAS (Acciones)
window.camadasAccionesFormatter = function (value, row) {
  // value es el camada_id
  return `
    <button class="btn btn-info btn-sm btn-gestionar-camada" 
            data-camada-id="${value}" 
            title="Gestionar Camada">
        <i class="mdi mdi-pencil"></i> Gestionar
    </button>`
}

// Formatter para tabla CAMADAS (Pendientes)
window.pendientesFormatter = function (value, row) {
  const pendientes = parseInt(value, 10)
  const total = parseInt(row.cantidad_inicial, 10)
  const porcentaje = total > 0 ? ((total - pendientes) / total) * 100 : 0

  if (pendientes > 0) {
    return `
      <div class="d-flex flex-column align-items-center">
        <strong class="fs-5 text-primary">${pendientes}</strong>
        <div class="progress" style="width: 80px; height: 10px;">
          <div class="progress-bar" role="progressbar" style="width: ${porcentaje}%;" 
               aria-valuenow="${porcentaje}" aria-valuemin="0" aria-valuemax="100">
          </div>
        </div>
        <small>${total - pendientes} de ${total}</small>
      </div>`
  } else {
    return `<span class="badge bg-success">Completada</span>`
  }
}

// --- LÓGICA PRINCIPAL ---

document.addEventListener('DOMContentLoaded', function () {
  const $partoPreviewContainer = $('#parto-foto-preview-container')
  const $partoPreviewImage = $('#parto-foto-preview')
  const $partoPreviewFilename = $('#parto-foto-filename')
  const $partoBtnEliminarFoto = $('#btn-eliminar-parto-foto')
  const $partoFileInput = $('#parto_fotografia')

  /** Limpia la vista previa y el campo de archivo. */
  const resetPartoPhotoPreview = () => {
    $partoPreviewContainer
      .addClass('d-none')
      .removeClass('bg-warning-light border-warning')
    $partoPreviewImage.attr('src', '#')
    $partoPreviewFilename.text('')
    $partoFileInput.val('')
  }

  /** Muestra la vista previa (Solo modo creación para Partos) */
  const showPartoPhotoPreview = (source, filename) => {
    $partoPreviewContainer.removeClass('d-none')
    $partoPreviewImage.attr('src', source)
    $partoPreviewFilename.text(filename)
  }

  // A. Cambio en Input File
  $partoFileInput.on('change', function () {
    if (this.files && this.files[0]) {
      const file = this.files[0]
      const reader = new FileReader()
      reader.onload = (e) => {
        showPartoPhotoPreview(e.target.result, file.name)
      }
      reader.readAsDataURL(file)
    } else {
      resetPartoPhotoPreview()
    }
  })

  // B. Botón Eliminar (Quitar selección actual)
  $partoBtnEliminarFoto.on('click', function () {
    resetPartoPhotoPreview()
  })
  // --- INSTANCIAS DE MODALES ---
  const modalRegistrarParto = new bootstrap.Modal(
    document.getElementById('modalRegistrarParto')
  )
  const modalGestionarCamada = new bootstrap.Modal(
    document.getElementById('modalGestionarCamada')
  )
  const modalAnimal = new bootstrap.Modal(
    document.getElementById('modalAnimal')
  )
  const modalReportarBaja = new bootstrap.Modal(
    document.getElementById('modalReportarBaja')
  )

  // --- FORMULARIOS ---
  const formRegistrarParto = document.getElementById('formRegistrarParto')
  const formAnimalLechon = document.getElementById('formAnimal')
  const formReportarBaja = document.getElementById('formReportarBaja')

  // --- REFERENCIAS A TABLAS ---
  const $tablaGestantes = $('#tablaGestantes')
  const $tablaCamadas = $('#tablaCamadas')

  // --- INICIALIZACIÓN ---

  // Recargar tabla de camadas cuando se muestra esa pestaña
  $('#tab-camadas-link').on('shown.bs.tab', function () {
    $tablaCamadas.bootstrapTable('refresh')
  })

  // === 1. FLUJO: REGISTRAR PARTO ===

  // Abrir modal de Registrar Parto
  $tablaGestantes.on('click', '.btn-registrar-parto', async function () {
    const $btn = $(this)
    currentPeriodoId = $btn.data('periodo-id')
    currentHembraId = $btn.data('hembra-id')

    formRegistrarParto.reset()
    window.limpiarErroresDelFormulario?.(formRegistrarParto)

    resetPartoPhotoPreview()

    // Mostrar loader y ocultar formulario
    const $modalBody = $(formRegistrarParto).find('.modal-body-content')
    const $modalLoader = $(formRegistrarParto).find('.modal-body-loader')
    $modalBody.hide()
    $modalLoader.show()
    modalRegistrarParto.show() // Mostrar modal vacío mientras carga

    $('#parto_periodo_id').val(currentPeriodoId)
    $('#parto_hembra_id').val(currentHembraId)
    $('#parto_fecha_parto').val(new Date().toISOString().slice(0, 10))
    $('#parto_estado_parto').val('NORMAL').trigger('change')
    $('#parto_crias_machos').val(0)
    $('#parto_crias_hembras').val(0)

    try {
      // 1. BUSCAR UBICACIÓN DE ORIGEN (ACTUAL DE LA MADRE)
      // Usamos el endpoint GET /animal_ubicaciones/actual/{animal_id}
      const response = await $.ajax({
        url: `${baseUrl}api/animal_ubicaciones/actual/${currentHembraId}`,
        method: 'GET',
        dataType: 'json',
      })

      const ubicacionActual = response.data

      // 2. RELLENAR CAMPOS OCULTOS DE ORIGEN
      $('#parto_finca_origen_id').val(ubicacionActual.finca_id || '')
      $('#parto_aprisco_origen_id').val(ubicacionActual.aprisco_id || '')
      $('#parto_area_origen_id').val(ubicacionActual.area_id || '')
      $('#parto_recinto_id_origen').val(ubicacionActual.recinto_id || '')

      // 3. Inicializar selectores de ubicación (destino)
      inicializarSelectsUbicacion('#formRegistrarParto', $(formRegistrarParto))

      // 4. Mostrar formulario y ocultar loader
      $modalLoader.hide()
      $modalBody.show()
    } catch (error) {
      // Error si la madre no tiene ubicación activa (404)
      modalRegistrarParto.hide()
      if (error.status === 404) {
        showErrorToast({
          message:
            'Error: La madre no tiene una ubicación activa registrada. No se puede realizar la transferencia.',
        })
      } else {
        showErrorToast(
          error.responseJSON || {
            message: 'No se pudo cargar la ubicación actual de la madre.',
          }
        )
      }
    }
  })

  formRegistrarParto.addEventListener('validation:success', function (e) {
    const datosCompletos = e.detail.datos // Aquí ya viene 'peso_promedio_kg' gracias al validador

    // 1. Validaciones extra de origen (se mantiene igual)
    if (
      !datosCompletos.animal_id ||
      (!datosCompletos.finca_origen_id && !datosCompletos.recinto_id_origen)
    ) {
      showErrorToast({
        message: 'Error: Se perdieron los datos de origen. Recargue.',
      })
      return
    }

    const formData = new FormData()

    // 2. AGREGAR TODOS LOS DATOS (Texto, Números, IDs ocultos)
    // Este bucle es clave: Mete fecha, estado, crias, PESO PROMEDIO, y los IDs de origen/destino
    for (const key in datosCompletos) {
      // Filtramos nulls o undefined, pero permitimos 0
      if (datosCompletos[key] !== null && datosCompletos[key] !== undefined) {
        formData.append(key, datosCompletos[key])
      }
    }

    // 3. AGREGAR FOTO SI EXISTE
    // Usamos jQuery para obtener el input file por ID definido en el HTML nuevo
    const fileInput = $('#parto_fotografia')[0]
    if (fileInput && fileInput.files.length > 0) {
      formData.append('fotografia', fileInput.files[0])
    }

    // 4. ENVÍO
    $.ajax({
      url: `${baseUrl}api/partos`,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function (res) {
        showSuccessToast(res)
        modalRegistrarParto.hide()
        $tablaGestantes.bootstrapTable('refresh')
        $('#tab-camadas-link').tab('show')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // === 2. FLUJO: GESTIONAR CAMADA ===

  // Abrir modal de Gestionar Camada
  $tablaCamadas.on('click', '.btn-gestionar-camada', function () {
    const camadaId = $(this).data('camada-id')
    mostrarGestionCamada(camadaId)
  })

  // Función principal para cargar el modal de gestión
  function mostrarGestionCamada(camadaId) {
    $('#camada-content').addClass('d-none')
    $('#camada-loader').removeClass('d-none')
    modalGestionarCamada.show()

    const endpoints = {
      camada: `${baseUrl}api/camadas/${camadaId}`,
      lechones: `${baseUrl}api/animales?camada_id=${camadaId}&limit=500`,
      bajas: `${baseUrl}api/camadas/${camadaId}/bajas`,
    }

    const requests = Object.values(endpoints).map((url) =>
      $.ajax({ url: url, method: 'GET' })
    )

    Promise.all(requests)
      .then((responses) => {
        const [camadaRes, lechonesRes, bajasRes] = responses

        currentCamadaData = camadaRes.data // Guardar datos globalmente
        populateGestionModal(camadaRes.data, lechonesRes.data, bajasRes.data)

        $('#camada-loader').addClass('d-none')
        $('#camada-content').removeClass('d-none')
      })
      .catch((error) => {
        modalGestionarCamada.hide()
        showErrorToast(
          error.responseJSON || {
            message: 'Error cargando los detalles de la camada.',
          }
        )
      })
  }

  // Función para poblar el modal de gestión
  function populateGestionModal(camada, lechones, bajas) {
    const $fotoContainer = $('#gestion_foto_container')
    const $fotoImg = $('#gestion_foto_parto')

    if (camada.fotografia_url) {
      // Construimos la URL completa. Asumimos que camada.fotografia_url viene como '/uploads/...'
      // Asegúrate de que 'baseUrl' tenga o no slash final según tu configuración global.
      // Generalmente baseUrl ya incluye el dominio base.
      const fullUrl = `${baseUrl}${camada.fotografia_url}`

      $fotoImg.attr('src', fullUrl)
      $fotoContainer.removeClass('d-none')
    } else {
      $fotoContainer.addClass('d-none')
      $fotoImg.attr('src', '#')
    }
    // Info Resumen
    $('#gestion_madre').text(camada.madre_identificador)
    $('#gestion_padre').text(camada.padre_identificador || 'N/A')
    $('#gestion_fecha_parto').text(fDate(camada.fecha_parto))
    $('#gestion_total_nacidos').text(camada.cantidad_inicial)
    $('#gestion_total_registrados').text(camada.registrados_count)
    $('#gestion_total_bajas').text(camada.bajas_count)
    $('#gestion_total_pendientes').text(camada.pendientes_count)

    // Habilitar/Deshabilitar botones
    const hayPendientes = camada.pendientes_count > 0
    $('#btnAbrirRegistroLechon').prop('disabled', !hayPendientes)
    $('#btnAbrirReportarBaja').prop('disabled', !hayPendientes)

    // Tabla Lechones Registrados
    let lechonesHtml =
      lechones.length === 0
        ? '<tr><td colspan="3" class="text-center">No hay lechones registrados.</td></tr>'
        : ''
    lechones.forEach((a) => {
      lechonesHtml += `
        <tr>
          <td><a href="${baseUrl}animales?animal=${a.animal_id}" target="_blank">${a.identificador}</a></td>
          <td>${a.sexo}</td>
          <td><span class="badge bg-success">${a.estado}</span></td>
        </tr>`
    })
    $('#tablaLechonesRegistrados').html(lechonesHtml)

    // Tabla Bajas Reportadas
    let bajasHtml =
      bajas.length === 0
        ? '<tr><td colspan="4" class="text-center">No hay bajas reportadas.</td></tr>'
        : ''
    bajas.forEach((b) => {
      const actaHtml = b.documento_acta_url
        ? `<a href="${baseUrl}${b.documento_acta_url}" target="_blank" class="btn btn-xs btn-info"><i class="mdi mdi-file-document-outline"></i></a>`
        : 'N/A'
      bajasHtml += `
        <tr>
          <td>${fDate(b.fecha_baja)}</td>
          <td>${b.cantidad}</td>
          <td>${b.causa_deceso}</td>
          <td>${actaHtml}</td>
        </tr>`
    })
    $('#tablaBajasReportadas').html(bajasHtml)
  }

  // === 3. FLUJO: REGISTRAR LECHÓN (desde Modal Gestión) ===

  // Abrir modal de Registrar Lechón
  $('#btnAbrirRegistroLechon').on('click', function () {
    if (!currentCamadaData) return

    formAnimalLechon.reset()
    window.limpiarErroresDelFormulario?.(formAnimalLechon)
    $('#modalAnimalLabel').text('Registrar Nuevo Lechón de Camada')

    // Setear campos clave
    $('#animal_camada_id').val(currentCamadaData.camada_id)
    $('#fecha_nacimiento')
      .val(currentCamadaData.fecha_parto)
      .prop('readonly', true)
    $('#origen').val('NACIMIENTO').prop('readonly', true)
    $('#especie').val('PORCINO').prop('readonly', true)

    // Resetear selects de Select2
    $('#madre_id, #padre_id, #raza_id').html('').prop('disabled', true)

    // Precargar Madre
    if (currentCamadaData.madre_id) {
      const $madreSelect = $('#madre_id')
      const option = new Option(
        currentCamadaData.madre_identificador,
        currentCamadaData.madre_id,
        true,
        true
      )
      $madreSelect.append(option).trigger('change').prop('disabled', true)
    }

    // Precargar Padre
    if (currentCamadaData.padre_id) {
      const $padreSelect = $('#padre_id')
      const option = new Option(
        currentCamadaData.padre_identificador,
        currentCamadaData.padre_id,
        true,
        true
      )
      $padreSelect.append(option).trigger('change').prop('disabled', true)
    }

    // Cargar y Habilitar selector de Raza (basado en 'PORCINO')
    $('#raza_id').prop('disabled', false)
    populateSelect({
      selector: '#raza_id',
      url: api(`razas?especie=PORCINO&estado=ACTIVA`),
      valueField: 'raza_id',
      textField: 'nombre',
      placeholder: 'Seleccione una raza (Opcional)',
      useSelect2: true,
      select2Options: { dropdownParent: '.modal .modal-body' },
      allowClear: true,
    }).then(() => {
      $('#raza_id').val(currentCamadaData.madre_raza_id).trigger('change')
    })

    console.log(currentCamadaData)

    $('#fotografia-preview').attr(
      'src',
      'https://placehold.co/200x200?text=Vista+Previa'
    )

    modalGestionarCamada.hide()
    modalAnimal.show()
  })

  // Enviar formulario de Registrar Lechón
  formAnimalLechon.addEventListener('validation:success', function (e) {
    const animalId = $('#animal_id').val() // Debería estar vacío
    if (animalId) {
      showErrorToast({ message: 'Error: El formulario no se reseteó.' })
      return
    }

    const formData = e.detail.formData

    // El 'camada_id' ya está en el formData gracias al input hidden

    $.ajax({
      url: `${baseUrl}api/animales`,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function (response) {
        showSuccessToast(response)
        modalAnimal.hide()
        // Refrescar todo
        mostrarGestionCamada(currentCamadaData.camada_id)
        $tablaCamadas.bootstrapTable('refresh')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // Botón Cancelar de Registrar Lechón
  $('#btnCancelarAnimal').on('click', function () {
    // No cierra el modal automáticamente (data-bs-dismiss está), pero al ocultarse...
    // Re-mostramos el modal de gestión
    setTimeout(() => {
      if (currentCamadaData) {
        modalGestionarCamada.show()
      }
    }, 500) // Esperar que se cierre el modal de animal
  })

  // === 4. FLUJO: REPORTAR BAJA (desde Modal Gestión) ===

  // Abrir modal de Reportar Baja
  $('#btnAbrirReportarBaja').on('click', function () {
    if (!currentCamadaData) return

    formReportarBaja.reset()
    window.limpiarErroresDelFormulario?.(formReportarBaja)

    $('#baja_fecha_baja').val(new Date().toISOString().slice(0, 10))
    $('#baja_cantidad').val(1)

    // --- LÍNEA AÑADIDA ---
    // Asegura que el select muestre el placeholder "Seleccione..."
    $('#baja_causa_deceso').val('').trigger('change')
    // --- FIN DE LÍNEA AÑADIDA ---

    modalGestionarCamada.hide()
    modalReportarBaja.show()
  })

  // Enviar formulario de Reportar Baja
  formReportarBaja.addEventListener('validation:success', function (e) {
    const formData = e.detail.formData // Es multipart/form-data
    const camadaId = currentCamadaData.camada_id

    $.ajax({
      url: `${baseUrl}api/camadas/${camadaId}/bajas`,
      method: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function (response) {
        showSuccessToast(response)
        modalReportarBaja.hide()
        // Refrescar todo
        mostrarGestionCamada(camadaId)
        $tablaCamadas.bootstrapTable('refresh')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // Botón Cancelar de Reportar Baja
  $('#btnCancelarBaja').on('click', function () {
    setTimeout(() => {
      if (currentCamadaData) {
        modalGestionarCamada.show()
      }
    }, 500)
  })

  // --- HELPERS DE SELECTS DINÁMICOS (Para Modal Parto) ---

  // Esta función es una adaptación de la de 'animales_view.js'
  function inicializarSelectsUbicacion(formSelector, $modalContainer) {
    const $form = $(formSelector)

    const resetSelect = (selector, placeholder) => {
      const $select = $form.find(selector)
      $select
        .html(`<option value="">${placeholder}</option>`)
        .prop('disabled', true)
      if ($select.data('select2')) $select.select2('destroy')
      $select.select2({
        placeholder: placeholder,
        dropdownParent: $modalContainer,
        allowClear: true,
      })
      return $select
    }

    const $apriscoSelect = resetSelect(
      'select[name="aprisco_destino_id"]',
      'Seleccione Finca primero'
    )
    const $areaSelect = resetSelect(
      'select[name="area_destino_id"]',
      'Seleccione Aprisco primero'
    )
    const $recintoSelect = resetSelect(
      'select[name="recinto_id_destino"]',
      'Seleccione Área primero'
    )

    // 1. Cargar Fincas
    populateSelect({
      selector: `${formSelector} select[name="finca_destino_id"]`,
      url: `${baseUrl}api/fincas`,
      placeholder: 'Seleccione Finca Destino',
      valueField: 'finca_id',
      textField: 'nombre',
      useSelect2: true,
      select2Options: { dropdownParent: $modalContainer, allowClear: true },
    })

    // 2. Finca -> Aprisco
    $form.on('change', 'select[name="finca_destino_id"]', function () {
      const fincaId = $(this).val()
      resetSelect(
        'select[name="area_destino_id"]',
        'Seleccione Aprisco primero'
      )
      resetSelect(
        'select[name="recinto_id_destino"]',
        'Seleccione Área primero'
      )

      if (fincaId) {
        populateSelect({
          selector: $apriscoSelect,
          url: `${baseUrl}api/apriscos?finca_id=${fincaId}`,
          placeholder: 'Seleccione Aprisco Destino',
          valueField: 'aprisco_id',
          textField: 'nombre',
          useSelect2: true,
          select2Options: { dropdownParent: $modalContainer, allowClear: true },
        })
      } else {
        resetSelect(
          'select[name="aprisco_destino_id"]',
          'Seleccione Finca primero'
        )
      }
    })

    // 3. Aprisco -> Área
    $form.on('change', 'select[name="aprisco_destino_id"]', function () {
      const apriscoId = $(this).val()
      resetSelect(
        'select[name="recinto_id_destino"]',
        'Seleccione Área primero'
      )

      if (apriscoId) {
        populateSelect({
          selector: $areaSelect,
          url: `${baseUrl}api/areas?aprisco_id=${apriscoId}`,
          placeholder: 'Seleccione Área Destino',
          valueField: 'area_id',
          textField: (item) =>
            `${item.nombre_personalizado || 'Área'} (${
              item.numeracion || 'S/N'
            }) [${item.tipo_area}]`, // <-- Sugerencia: mostrar tipo
          useSelect2: true,
          select2Options: { dropdownParent: $modalContainer, allowClear: true },
        })
      } else {
        resetSelect(
          'select[name="area_destino_id"]',
          'Seleccione Aprisco primero'
        )
      }
    })

    // 4. Área -> Recinto
    $form.on('change', 'select[name="area_destino_id"]', function () {
      const areaId = $(this).val()
      if (areaId) {
        populateSelect({
          selector: $recintoSelect,
          url: `${baseUrl}api/recintos?area_id=${areaId}`,
          placeholder: 'Seleccione Recinto Destino',
          valueField: 'recinto_id',
          textField: 'codigo_recinto',
          useSelect2: true,
          select2Options: { dropdownParent: $modalContainer, allowClear: true },
        })
      } else {
        resetSelect(
          'select[name="recinto_id_destino"]',
          'Seleccione Área primero'
        )
      }
    })
  }

  // --- Lógica para el modal de Registrar Lechón (Selects) ---
  // (Copiado de animales_view.js para el modal 'formAnimal')
  $formAnimal.on('change', '#especie', function () {
    const especieSeleccionada = $(this).val()
    const $razaSelect = $('#raza_id')

    $razaSelect.val(null).trigger('change')

    if (especieSeleccionada) {
      populateSelect({
        selector: $razaSelect,
        url: api(`razas?especie=${especieSeleccionada}&estado=ACTIVA`),
        valueField: 'raza_id',
        textField: 'nombre',
        placeholder: 'Seleccione una raza...',
        useSelect2: true,
        select2Options: { dropdownParent: $formAnimal },
      }).then(() => {
        const optionsCount = $razaSelect.find('option[value!=""]').length
        if (optionsCount > 0) {
          $razaSelect.prop('disabled', false)
        } else {
          $razaSelect.prop('disabled', true).select2({
            placeholder: 'No hay razas para esta especie',
            dropdownParent: $formAnimal,
          })
        }
      })
    } else {
      $razaSelect.prop('disabled', true).select2({
        placeholder: 'Seleccione una especie primero...',
        dropdownParent: $formAnimal,
      })
    }
  })

  $('#fotografia').on('change', function () {
    if (this.files && this.files[0]) {
      const reader = new FileReader()
      reader.onload = function (e) {
        $('#fotografia-preview').attr('src', e.target.result)
      }
      reader.readAsDataURL(this.files[0])
    }
  })
}) // Fin DOMContentLoaded
