import { showErrorToast, showSuccessToast } from '../helpers/helpers.js'

// === FUNCIONES GLOBALES REQUERIDAS POR BOOTSTRAP-TABLE (Sin cambios) ===
window.responseHandler = (res) => ({ rows: res.data, total: res.data.length })

window.dragHandleFormatter = () =>
  '<i class="mdi mdi-drag-vertical" style="cursor: grab;"></i>'

window.rowAttrFunc = (row, index) => ({ 'data-id': row.menu_id || row.nombre })

window.nombreCategoriaFormatter = (value, row) => {
  const count = row.item_count || 0
  const badgeColor = count > 0 ? 'bg-secondary' : 'bg-light text-dark'

  return `
        <div class="d-flex justify-content-between align-items-center">
            <strong class="text-primary text-uppercase">${value}</strong>
            <span class="badge rounded-pill ${badgeColor}">${count} ítems</span>
        </div>
    `
}

window.accionesCategoriaFormatter = (value) => `
    <button class="btn btn-info btn-sm btn-gestionar-items" data-categoria="${value}">
        <i class="mdi mdi-format-list-bulleted-square"></i> Gestionar Ítems
    </button>`

window.accionesItemFormatter = (value, row) => `
    <div class="btn-group">
        <button class="btn btn-warning btn-sm btn-editar-item" data-id="${value}" title="Editar"><i class="mdi mdi-pencil"></i></button>
        <button class="btn btn-danger btn-sm btn-eliminar-item" data-id="${value}" title="Eliminar"><i class="mdi mdi-delete"></i></button>
    </div>`

// === LÓGICA PRINCIPAL DEL DOCUMENTO ===
document.addEventListener('DOMContentLoaded', () => {
  // Referencias a los elementos del DOM
  const $tablaCategorias = $('#tablaCategorias')
  const $tablaItems = $('#tablaItems')
  const modalItems = new bootstrap.Modal(document.getElementById('modalItems'))
  const modalFormularioItem = new bootstrap.Modal(
    document.getElementById('modalFormularioItem')
  )
  const formItem = document.getElementById('formItem')

  // --- GESTIÓN DE CATEGORÍAS (VISTA PRINCIPAL) (Sin cambios) ---

  $tablaCategorias.on('reorder-row.bs.table', (e, newOrder) => {
    const orderedNombres = newOrder.map((row) => row.nombre)
    $.ajax({
      url: `${baseUrl}api/menus-categorias/reordenar`,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(orderedNombres),
      success: (res) => showSuccessToast(res.message),
      error: (xhr) => {
        showErrorToast(xhr.responseJSON)
        $tablaCategorias.bootstrapTable('refresh')
      },
    })
  })

  $tablaCategorias.on('click', '.btn-gestionar-items', function () {
    const categoriaNombre = $(this).data('categoria')
    $('#modalItems').data('categoria', categoriaNombre)
    $('#btnNuevoItem').data('categoria', categoriaNombre)
    $('#modalItemsLabel').html(
      `Ítems de la categoría: <strong class="text-primary text-uppercase">${categoriaNombre}</strong>`
    )
    $tablaItems.bootstrapTable('destroy')
    $tablaItems.bootstrapTable({
      url: `${baseUrl}api/menus?categoria=${categoriaNombre}`,
      responseHandler: window.responseHandler,
      classes: 'table table-hover',
      sidePagination: 'client',
    })
    modalItems.show()
  })

  // --- GESTIÓN DE ÍTEMS (DENTRO DEL MODAL) ---

  // Reordenar ítems (Sin cambios)
  $tablaItems.on('reorder-row.bs.table', (e, newOrder) => {
    const orderedIds = newOrder.map((row) => row.menu_id)
    $.ajax({
      url: `${baseUrl}api/menus-reordenar`,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(orderedIds),
      success: (res) => showSuccessToast(res.message),
      error: (xhr) => {
        showErrorToast(xhr.responseJSON)
        $tablaItems.bootstrapTable('refresh')
      },
    })
  })

  // ✅ CAMBIO: Botón "Nuevo Ítem" ahora limpia errores
  $('#btnNuevoItem').on('click', function () {
    formItem.reset()
    // Limpiar errores de validación
    window.limpiarErroresDelFormulario?.(formItem)

    $('#menu_id').val('')
    const categoria = $(this).data('categoria')
    $('#categoria').val(categoria)
    $('#modalFormularioItemLabel').text('Crear Nuevo Ítem')
    modalFormularioItem.show()
  })

  // ✅ CAMBIO: Acciones de Editar y Eliminar para los ítems
  $tablaItems.on('click', 'button', function () {
    const action = $(this).attr('class')
    const itemId = $(this).data('id')

    if (action.includes('btn-editar-item')) {
      // Limpiar errores antes de cargar datos
      window.limpiarErroresDelFormulario?.(formItem)

      $.get(`${baseUrl}api/menus/${itemId}`, (response) => {
        const data = response.data
        $('#menu_id').val(data.menu_id)
        $('#nombre').val(data.nombre)
        $('#url').val(data.url)
        $('#icono').val(data.icono)
        $('#user_level').val(data.user_level)
        $('#orden').val(data.orden)
        $('#categoria').val(data.categoria)
        $('#modalFormularioItemLabel').text('Editar Ítem')
        modalFormularioItem.show()
      }).fail((xhr) => showErrorToast(xhr.responseJSON)) // Añadido manejo de error
    } else if (action.includes('btn-eliminar-item')) {
      // (Sin cambios)
      Swal.fire({
        title: '¿Estás seguro?',
        text: 'El ítem será eliminado.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        confirmButtonText: 'Sí, eliminar',
      }).then((result) => {
        if (result.isConfirmed) {
          $.ajax({
            url: `${baseUrl}api/menus/${itemId}`,
            method: 'DELETE',
            success: (res) => {
              Swal.fire('Eliminado', res.message, 'success')
              $tablaItems.bootstrapTable('refresh')
            },
            error: (xhr) => showErrorToast(xhr.responseJSON),
          })
        }
      })
    }
  })

  // ✅ CAMBIO: Envío del formulario de crear/editar ítem
  formItem.addEventListener('validation:success', function (e) {
    const menuId = $('#menu_id').val()
    let url = `${baseUrl}api/menus`
    if (menuId) {
      url = `${baseUrl}api/menus/${menuId}`
    }

    // Obtener datos validados del evento
    const formData = e.detail.datos

    $.ajax({
      url: url,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify(formData),
      success: (res) => {
        modalFormularioItem.hide()
        Swal.fire('¡Éxito!', res.message, 'success')
        $tablaItems.bootstrapTable('refresh') // Refrescar la tabla de ítems
        $tablaCategorias.bootstrapTable('refresh') // Refrescar la tabla de categorías (para el contador)
      },
      error: (xhr) => showErrorToast(xhr.responseJSON),
    })
  })
})
