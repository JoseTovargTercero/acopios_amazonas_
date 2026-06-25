/**
 * Popula un elemento <select> con datos de una URL y opcionalmente lo inicializa con Select2.
 *
 * @param {object} config - Objeto de configuración.
 * @param {string} config.selector - El selector CSS o objeto jQuery para el <select>.
 * @param {string} config.url - La URL para obtener los datos en formato JSON.
 * @param {string} config.valueField - El nombre del campo del objeto de datos para el `value` de la opción.
 * @param {string|Function} config.textField - El nombre del campo para el texto de la opción, o una función que recibe el item y retorna el texto.
 * @param {string|null} [config.placeholder='Seleccione una opción'] - El texto del placeholder. Si es `null`, no se añade una opción vacía.
 * @param {boolean} [config.useSelect2=false] - Si es `true`, inicializa el select con Select2.
 * @param {object} [config.select2Options={}] - Un objeto con opciones para pasar a Select2 (ej. { dropdownParent: $('#myModal') }).
 * @param {string|null} [config.messageSelector=null] - Un selector CSS (hermano del select) para mostrar un mensaje si no hay datos.
 * @param {string} [config.emptyMessage='No hay opciones disponibles'] - El mensaje a mostrar si no hay datos.
 *
 * @returns {Promise} Una promesa que se resuelve con la respuesta de la API en caso de éxito.
 */
export function populateSelect({
  selector,
  url,
  valueField,
  textField,
  placeholder = 'Seleccione una opción',
  useSelect2 = false,
  select2Options = {},
  messageSelector = null,
  emptyMessage = 'No hay opciones disponibles',
}) {
  const $select = $(selector)
  const $message = messageSelector ? $select.siblings(messageSelector) : null

  if ($select.data('select2')) {
    $select.select2('destroy')
  }

  $select.html(`<option value="">Cargando...</option>`).prop('disabled', true)
  $message?.hide().text('')

  // Devolvemos una Promesa para poder usar await y try...catch
  return new Promise((resolve, reject) => {
    $.ajax({
      url: url,
      method: 'GET',
      dataType: 'json',
      success: function (response) {
        let options = ''
        // Añadir placeholder solo si no es null
        if (placeholder !== null) {
          options = `<option value="">${placeholder}</option>`
        }

        const data = response?.data ?? []

        if (data.length > 0) {
          data.forEach((item) => {
            const text =
              typeof textField === 'function'
                ? textField(item)
                : item[textField]
            options += `<option value="${item[valueField]}">${text}</option>`
          })
          // Habilitar y poblar
          $select.html(options).prop('disabled', false)
          $message?.hide().text('')
        } else {
          // No hay datos: deshabilitar y mostrar mensaje si aplica
          $select.html(options).prop('disabled', true)
          $message?.text(emptyMessage).show()
        }

        if (useSelect2) {
          const modalParent = $select.closest('.modal')
          let finalSelect2Options = {
            width: '100%', // Estándar para Bootstrap
            ...select2Options,
          }

          // Auto-detectar modal para el dropdownParent si no se proveyó
          if (modalParent.length > 0 && !finalSelect2Options.dropdownParent) {
            finalSelect2Options.dropdownParent = modalParent
          }
          $select.select2(finalSelect2Options)
        }
        // Resolver la promesa con los datos
        resolve(response)
      },
      error: function (jqXHR, textStatus, errorThrown) {
        console.error(
          'Error al cargar datos para el select:',
          textStatus,
          errorThrown
        )
        $select
          .html(`<option value="">Error al cargar</option>`)
          .prop('disabled', true)
        $message?.text('Error al cargar datos.').show()
        // Rechazar la promesa con un error
        reject(new Error(errorThrown || 'Error de red al cargar select'))
      },
    })
  })
}
