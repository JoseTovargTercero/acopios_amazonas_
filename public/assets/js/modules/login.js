import { showErrorToast, Toast } from '../helpers/helpers.js'

document.addEventListener('DOMContentLoaded', function () {
  const formLogin = document.getElementById('formLogin')

  if (formLogin) {
    formLogin.addEventListener('submit', function (e) {
      e.preventDefault()

      const btn = this.querySelector('button[type="submit"]')
      const originalHtml = btn.innerHTML

      btn.disabled = true
      btn.innerHTML = `<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Ingresando...`

      // El select tiene name="email" con value = nombre del centro
      // El input contraseña tiene name="password"
      const payload = {
        nombre: this.email.value.trim(),
        codigo: this.password.value.trim(),
      }

      $.ajax({
        url: baseUrl + 'auth/login',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(payload),
        success: function (response) {
          if (response.value) {
            Toast.fire({ icon: 'success', title: response.message }).then(() => {
              window.location.href = baseUrl + 'perfil'
            })
          } else {
            showErrorToast(response)
          }
        },
        error: function (xhr) {
          showErrorToast(xhr.responseJSON)
        },
        complete: function () {
          btn.disabled = false
          btn.innerHTML = originalHtml
        },
      })
    })
  }
})
