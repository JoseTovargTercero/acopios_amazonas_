// public/assets/js/modules/animal_pesos_view.js

import {
  showErrorToast,
  showSuccessToast,
  formatDate,
} from '../helpers/helpers.js'
import { cargarGraficoPesos } from '../helpers/curva_peso_graficos.js'

// --- FORMATTERS ---

window.responseHandler = function (res) {
  return { rows: res.data, total: res.data.length }
}

window.pesoMainFormatter = function (value) {
  return value
    ? `<span class="badge bg-primary fs-6">${parseFloat(value).toFixed(
        2
      )} kg</span>`
    : '<span class="text-muted">-</span>'
}

window.edadFormatter = function (value) {
  if (!value) return 'N/A'
  // Si quieres usar la misma lógica de cálculo rápido en cliente para la tabla principal
  const birth = new Date(value)
  const now = new Date()
  const diffDays = Math.floor((now - birth) / (1000 * 60 * 60 * 24))
  if (diffDays < 30) return `${diffDays} días`
  const months = Math.floor(diffDays / 30)
  if (months < 12) return `${months} meses`
  return `${Math.floor(months / 12)} años`
}

window.accionesPesoFormatter = function (value, row) {
  return `
    <div class="btn-group">
        <button class="btn btn-info btn-sm btn-historial" 
                data-id="${value}" 
                data-identificador="${row.identificador}"
                title="Ver Historial y Gráfica">
            <i class="mdi mdi-chart-line"></i> Historial
        </button>
        <button class="btn btn-success btn-sm btn-registrar" 
                data-id="${value}" 
                data-identificador="${row.identificador}"
                title="Agregar Nuevo Peso">
            <i class="mdi mdi-plus"></i> Peso
        </button>
    </div>`
}

document.addEventListener('DOMContentLoaded', function () {
  const $table = $('#tablaAnimalesPesos')
  const modalRegistro = new bootstrap.Modal(
    document.getElementById('modalRegistroPeso')
  )
  const modalHistorial = new bootstrap.Modal(
    document.getElementById('modalHistorialPesos')
  )
  const formRegistro = document.getElementById('formRegistroPeso')

  // --- REGISTRAR PESO ---
  $table.on('click', '.btn-registrar', function () {
    const id = $(this).data('id')
    const identificador = $(this).data('identificador')
    formRegistro.reset()
    window.limpiarErroresDelFormulario?.(formRegistro)
    $('#peso_animal_id').val(id)
    $('#lbl_animal_identificador').text(identificador)
    $('#fecha_peso').val(new Date().toISOString().slice(0, 10))
    modalRegistro.show()
  })

  formRegistro.addEventListener('validation:success', function (e) {
    const data = e.detail.datos
    if (data.unidad === 'LB') {
      data.peso_kg = (parseFloat(data.peso_kg) * 0.453592).toFixed(2)
      data.unidad = 'KG'
    }
    $.ajax({
      url: `${baseUrl}api/animal_pesos`,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(data),
      success: function (response) {
        modalRegistro.hide()
        showSuccessToast(response)
        $table.bootstrapTable('refresh')
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  // --- VER HISTORIAL (SIMPLIFICADO) ---
  $table.on('click', '.btn-historial', function () {
    const id = $(this).data('id')
    const identificador = $(this).data('identificador')

    $('#historial_titulo_animal').text(identificador)
    $('#tablaHistorialBody').html(
      '<tr><td colspan="6" class="text-center"><div class="spinner-border spinner-border-sm"></div> Cargando...</td></tr>'
    )
    $('#peso-chart').html('') // Limpiar contenedor gráfico

    modalHistorial.show()

    // Solo una petición
    $.ajax({
      url: `${baseUrl}api/animal_pesos?animal_id=${id}`,
      method: 'GET',
      success: function (res) {
        renderHistorial(res.data)
      },
      error: function (xhr) {
        $('#tablaHistorialBody').html(
          '<tr><td colspan="6" class="text-center text-danger">Error cargando datos.</td></tr>'
        )
        showErrorToast(xhr.responseJSON)
      },
    })
  })

  function renderHistorial(pesos) {
    const tbody = $('#tablaHistorialBody')
    tbody.empty()

    if (!pesos || pesos.length === 0) {
      tbody.html(
        '<tr><td colspan="6" class="text-center">No hay registros de peso.</td></tr>'
      )
      return
    }

    // 1. Gráfico: Pasamos los datos directos (ya traen peso_ideal y edad_dias)
    cargarGraficoPesos(pesos)

    // 2. Tabla: (Orden descendente por fecha para la tabla)
    const pesosTabla = [...pesos].sort(
      (a, b) => new Date(b.fecha_peso) - new Date(a.fecha_peso)
    )

    let html = ''
    pesosTabla.forEach((p, index) => {
      // Ganancia vs Anterior
      let gananciaHtml = '<span class="text-muted">-</span>'
      if (index < pesosTabla.length - 1) {
        const actual = parseFloat(p.peso_kg)
        const previo = parseFloat(pesosTabla[index + 1].peso_kg)
        const diff = actual - previo
        const color = diff >= 0 ? 'text-success' : 'text-danger'
        const icon = diff >= 0 ? 'mdi-arrow-up' : 'mdi-arrow-down'
        gananciaHtml = `<span class="${color}"><i class="mdi ${icon}"></i> ${diff.toFixed(
          2
        )}</span>`
      }

      html += `
                <tr>
                    <td>${formatDate(p.fecha_peso, false)}</td>
                    <td class="fw-bold">${parseFloat(p.peso_kg).toFixed(2)}</td>
                    <td>${gananciaHtml}</td>
                    <td><small>${p.metodo || 'N/A'}</small></td>
                    <td><small class="text-muted text-truncate" style="max-width: 150px; display:block;">${
                      p.observaciones || ''
                    }</small></td>
                    <td>
                        <button class="btn btn-xs btn-outline-danger btn-eliminar-peso" data-id="${
                          p.animal_peso_id
                        }"><i class="mdi mdi-delete"></i></button>
                    </td>
                </tr>
            `
    })
    tbody.html(html)
  }

  // ELIMINAR
  $('#tablaHistorialBody').on('click', '.btn-eliminar-peso', function () {
    const pesoId = $(this).data('id')
    Swal.fire({
      title: '¿Eliminar?',
      text: 'Se eliminará este registro de peso.',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Sí, eliminar',
      confirmButtonColor: '#d33',
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
          url: `${baseUrl}api/animal_pesos/${pesoId}`,
          method: 'DELETE',
          success: function (res) {
            showSuccessToast(res)
            modalHistorial.hide()
            $table.bootstrapTable('refresh')
          },
          error: function (xhr) {
            showErrorToast(xhr.responseJSON)
          },
        })
      }
    })
  })
})
