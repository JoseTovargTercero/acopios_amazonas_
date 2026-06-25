export function getBaseUrl() {
  // Usa la variable global definida dinámicamente por PHP, o determina la URL base desde window.location
  if (window.baseUrl) {
    return window.baseUrl.replace(/\/+$/, '')
  }
  const pathParts = window.location.pathname.split('/')
  // Toma el primer segmento de la ruta como base (ej: /colecciones/ o /ERP_SISUPP/)
  const base = pathParts[1] || ''
  return window.location.origin + '/' + base
}

export async function handleRequestFetch(
  url,
  method,
  data = null,
  showAlerts = true
) {
  // showLoader()
  try {
    // Obtenemos la URL base correcta
    const baseUrl = getBaseUrl()

    // Construimos la URL completa
    const fullUrl = `${baseUrl}${url}`

    const options = {
      method: method,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    }

    if (data) {
      options.body = JSON.stringify(data)
    }

    const response = await fetch(fullUrl, options)

    if (!response.ok) {
      const errorResponse = await response.text() // Evita fallos si no es JSON
      throw {
        status: errorResponse.status,
        statusText: errorResponse.statusText,
        response: errorResponse,
        url: fullUrl,
      }
    }

    // let clone = response.clone()
    // let text = await clone.text()
    // console.log(text)
    // console.log(baseUrl, url)

    const result = await response.json()

    // console.log(result)

    // Asegura la estructura esperada
    if (result.hasOwnProperty('value')) {
      if (result.hasOwnProperty('message') && result.message !== '')
        if (showAlerts) showAlert(result.value, result.message)

      return {
        ...result,
        value: result.value,
        message: result.message || '',
        data: result.data || null,
        labels: result.labels || null,
      }
    } else {
      throw new Error('Estructura de respuesta no válida')
    }
  } catch (error) {
    console.log(error)

    if (showAlerts)
      showAlert(false, error.message || 'No se pudo procesar la solicitud')
    return {
      value: false,
      message: error.message || 'Error desconocido',
      data: null,
      url: url,
    }
  } finally {
    // hideLoader()
  }
}
