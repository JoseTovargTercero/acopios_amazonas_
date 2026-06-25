import { handleRequestFetch, getBaseUrl } from './apiConfig.js'
import { formatDateTime } from './helpers.js'

// En apiConfig.js

const NotificationController = {
  // --- ESTADO ---
  _notifications: [], // Almacena las notificaciones cargadas
  _currentFilter: 'unread', // 'unread' o 'all'
  _limit: 10, // Cuántas cargar por página
  _offset: 0, // El offset actual de la paginación
  _hasMore: true, // Si hay más notificaciones por cargar
  _isLoading: false, // Flag para evitar cargas múltiples (scroll)
  _isInitialLoadDone: false, // Si ya se cargó algo al menos una vez
  _hasNewNotifications: false, // Flag del contador 'new'

  // --- INICIALIZACIÓN ---
  init() {
    this._cacheDOMElements()
    this._bindEvents()

    // Carga inicial de *solo los contadores*
    this.checkNewCounts()

    // Sondeo (polling) de *solo los contadores* cada 30 segundos
    setInterval(() => this.checkNewCounts(), 3000)
  },

  _cacheDOMElements() {
    this.dom = {
      alertCount: document.getElementById('alert-count'),
      unreadCount: document.getElementById('unread-count'),
      container: document.getElementById('alerts-container'),
      allTab: document.getElementById('all-tab'),
      unreadTab: document.getElementById('unread-tab'),
      clearAllBtn: document.getElementById('clear-all-alerts'),
      dropdownToggle: document.querySelector(
        '#notification-dropdown-toggle'
      ),
      scrollContainer: document.getElementById('alerts-scroll-container'),
      dropdownContainer: document.getElementById('dropdown-container'),
    }
  },

  // --- MANEJO DE EVENTOS ---
  _bindEvents() {
    // Al abrir el dropdown
    this.dom.dropdownToggle.addEventListener('show.bs.dropdown', () => {
      // Si es la primera vez que se abre, carga las notificaciones
      if (!this._isInitialLoadDone) {
        this.resetAndLoadNotifications(true)
      }
      // Marcar todas como vistas (new=0) al abrir si hay nuevas
      if (this._hasNewNotifications) {
        this._markAllAsSeen()
      }
    })

    // Clic en pestaña "Todas"
    this.dom.allTab.addEventListener('click', (e) => {
      e.stopPropagation()
      if (this._currentFilter === 'all') return // No hacer nada si ya está activa
      this._currentFilter = 'all'
      this._updateActiveTab()
      this.resetAndLoadNotifications(true) // Recargar desde la página 0
    })

    // Clic en pestaña "No leídas"
    this.dom.unreadTab.addEventListener('click', (e) => {
      e.stopPropagation()
      if (this._currentFilter === 'unread') return // No hacer nada si ya está activa
      this._currentFilter = 'unread'
      this._updateActiveTab()
      this.resetAndLoadNotifications(true) // Recargar desde la página 0
    })

    // Clic en "Marcar Como Leídas"
    this.dom.clearAllBtn.addEventListener('click', (e) => {
      e.preventDefault()
      e.stopPropagation()
      this._markAllAsRead()
    })

    // Clic en una notificación individual
    this.dom.container.addEventListener('click', (e) => {
      const target = e.target.closest('.notification-item')
      if (target) {
        e.preventDefault()
        this._handleNotificationClick(target)
      }
    })

    // Evento de Scroll para paginación (infinite scroll)
    this.dom.scrollContainer.addEventListener('scroll', () => {
      // ---
      this._handleScroll()
    })
  },

  // --- API LOCAL CON FETCH ---

  // Obtiene una PÁGINA de notificaciones
  async _apiGetNotificationPage() {
    const { _limit, _offset, _currentFilter } = this
    const route = `/api/notifications/mias?limit=${_limit}&offset=${_offset}&filtro=${_currentFilter}`
    return await handleRequestFetch(route, 'GET', null, false)
  },

  // Obtiene SÓLO LOS CONTEOS
  async _apiGetCounts() {
    return await handleRequestFetch(
      '/api/notifications/mias/conteos',
      'GET',
      null,
      false
    )
  },

  async _apiSetNotificationRead(data) {
    const route = `/api/notifications/${data.id}/flag/read_unread`
    const payload = { valor: data.value }
    return await handleRequestFetch(route, 'POST', payload, false)
  },

  async _apiMarkAllAsSeen() {
    return await handleRequestFetch(
      '/api/notifications/marcar_todas_vistas',
      'POST',
      {},
      false
    )
  },

  async _apiMarkAllAsRead() {
    return await handleRequestFetch(
      '/api/notifications/marcar_todas_leidas',
      'POST',
      {},
      false
    )
  },

  // --- LÓGICA DE DATOS Y API ---

  /**
   * Carga la SIGUIENTE página de notificaciones y las AÑADE al DOM.
   */
  async loadNotifications(showLoader = true) {
    if (this._isLoading || !this._hasMore) return // Evita cargas duplicadas o innecesarias

    this._isLoading = true
    if (showLoader && this._offset === 0) {
      this._showLoader() // Muestra loader principal solo en la primera página
    }

    try {
      const response = await this._apiGetNotificationPage()

      if (response.value && Array.isArray(response.data)) {
        // --- INICIO DE LA CORRECCIÓN ---

        const receivedData = response.data // 1. Guardar los datos recibidos

        const CARACAS_ZONE = 'America/Caracas'
        const nowInCaracas = luxon.DateTime.now().setZone(CARACAS_ZONE)

        // 2. Filtrar fechas futuras (lógica que ya tenías)
        const newNotifications = receivedData

        // 3. Comprobar si hay más basándose en los DATOS RECIBIDOS
        if (receivedData.length < this._limit) {
          this._hasMore = false
        }

        // 4. Incrementar el offset basándose en los DATOS RECIBIDOS
        this._offset += receivedData.length

        // 5. Añadir solo las notificaciones FILTRADAS al estado
        this._notifications.push(...newNotifications)

        // 6. Renderizar solo las notificaciones FILTRADAS
        newNotifications.forEach((n) => {
          this.dom.container.insertAdjacentHTML(
            'beforeend',
            this._createNotificationHTML(n)
          )
        })

        // --- FIN DE LA CORRECCIÓN ---

        feather.replace() // Refresca iconos

        this._isInitialLoadDone = true
      } else {
        this._hasMore = false // No hay más datos o hubo un error
      }

      // Si después de todo el array está vacío, muestra estado "vacío"
      if (this._notifications.length === 0) {
        this.dom.container.innerHTML = this._getEmptyStateHTML()
      }
    } catch (error) {
      console.error('Failed to load notifications:', error)
      if (this._offset === 0) {
        this.dom.container.innerHTML = this._getErrorStateHTML()
      }
    } finally {
      this._isLoading = false
      if (showLoader) this._hideLoader()
    }
  },
  /**
   * Resetea el estado de paginación y carga la primera página.
   * Se usa al abrir por primera vez o al cambiar de pestaña.
   */
  async resetAndLoadNotifications(showLoader = true) {
    this._notifications = []
    this._offset = 0
    this._hasMore = true
    this._isLoading = false
    this.dom.container.innerHTML = '' // Limpia el contenedor visualmente
    await this.loadNotifications(showLoader)
  },

  /**
   * Función de sondeo (polling) que solo pide contadores.
   */
  async checkNewCounts() {
    try {
      const response = await this._apiGetCounts()
      if (response.value && response.data) {
        const { new_count, unread_count } = response.data

        this.dom.alertCount.textContent = new_count
        this.dom.unreadCount.textContent = unread_count

        this.dom.alertCount.style.display = new_count > 0 ? 'flex' : 'none'
        this._hasNewNotifications = new_count > 0
      }
    } catch (error) {
      console.error('Failed to check counts:', error)
      // No mostrar error en la UI, es un chequeo silencioso
    }
  },

  /**
   * Maneja el scroll infinito.
   */
  _handleScroll() {
    if (this._isLoading || !this._hasMore) return

    // --- MODIFICAR ESTA LÍNEA ---
    const { scrollTop, scrollHeight, clientHeight } = this.dom.scrollContainer
    // ---

    // Cargar más cuando se esté al 90% del final del scroll (es más seguro que 80%)
    if (scrollTop + clientHeight >= scrollHeight * 0.9) {
      this.loadNotifications(false) // Carga la siguiente página sin loader principal
    }
  },

  async _handleNotificationClick(target) {
    const route = target.dataset.route
    if (route && route !== 'null') {
      this._showGlobalLoader()
    }

    try {
      const id = target.dataset.id
      const isUnread = target.dataset.isUnread === '1'

      if (isUnread) {
        await this._apiSetNotificationRead({ id, value: 1 })

        // Actualiza el estado local
        const notification = this._notifications.find(
          (n) => n.notifications_id === id
        )
        if (notification) notification.read_unread = 1

        // Actualiza el DOM directamente (sin _render() total)
        target.classList.remove('unread')
        target.dataset.isUnread = '0'

        // Si estamos en la pestaña "No leídas", oculta el item
        if (this._currentFilter === 'unread') {
          target.style.display = 'none'
        }

        // Decrementa el contador visualmente
        const currentUnread = parseInt(this.dom.unreadCount.textContent, 10)
        if (!isNaN(currentUnread) && currentUnread > 0) {
          this.dom.unreadCount.textContent = currentUnread - 1
        }
      }

      if (route && route !== 'null') {
        window.location.href = `${getBaseUrl()}${route}`
      }
    } catch (error) {
      console.error('Failed to handle notification click:', error)
      if (route && route !== 'null') {
        // Asegurarse de ocultar el loader global si falla
        const loader = this._getGlobalLoader()
        if (loader) loader.style.display = 'none'
      }
    }
  },

  async _markAllAsSeen() {
    try {
      const response = await this._apiMarkAllAsSeen()
      if (response.value) {
        this._notifications.forEach((n) => (n.new = 0))
        // Actualiza el contador visual de "nuevas"
        this.dom.alertCount.textContent = 0
        this.dom.alertCount.style.display = 'none'
        this._hasNewNotifications = false
      }
    } catch (error) {
      console.error('Failed to mark all as seen:', error)
    }
  },

  async _markAllAsRead() {
    const unreadCount = parseInt(this.dom.unreadCount.textContent, 10)
    if (isNaN(unreadCount) || unreadCount === 0) return

    this._showLoader()
    try {
      const response = await this._apiMarkAllAsRead()
      if (response.value) {
        // Recarga la lista desde cero
        this.resetAndLoadNotifications(false)
        // Actualiza el contador visual a 0
        this.dom.unreadCount.textContent = 0
      }
    } catch (error) {
      console.error('Failed to mark all as read:', error)
      this.dom.container.innerHTML = this._getErrorStateHTML()
    } finally {
      this._hideLoader()
    }
  },

  // --- RENDERIZADO Y ACTUALIZACIONES DE UI ---

  // _render() ya no se usa para renderizar la lista completa,
  // se hace por "append" en loadNotifications
  // Se mantiene por si se usa en otro lado, pero su lógica está deprecada.
  _render() {
    console.warn(
      '_render() fue llamado, pero la lógica ahora es por apendizaje.'
    )
    // Si necesitas forzar un re-renderizado total, usa esto:
    // const scrollTop = this.dom.container.scrollTop
    // this.dom.container.innerHTML = ''
    // this._notifications.forEach((n) => {
    //   if (this._currentFilter === 'all' || n.read_unread == 0) {
    //     this.dom.container.insertAdjacentHTML('beforeend', this._createNotificationHTML(n))
    //   }
    // })
    // feather.replace()
    // this.dom.container.scrollTop = scrollTop
  },

  // _updateCounts() fue reemplazado por checkNewCounts()
  // _updateCounts() {},

  _updateActiveTab() {
    if (this._currentFilter === 'all') {
      this.dom.allTab.classList.add('active')
      this.dom.unreadTab.classList.remove('active')
    } else {
      this.dom.unreadTab.classList.add('active')
      this.dom.allTab.classList.remove('active')
    }
  },

  _getTimeAgo(dateString) {
    const CARACAS_ZONE = 'America/Caracas'
    const notificationDate = luxon.DateTime.fromSQL(dateString, {
      zone: CARACAS_ZONE,
    })
    const nowInCaracas = luxon.DateTime.now().setZone(CARACAS_ZONE)
    return notificationDate.toRelative({ base: nowInCaracas, locale: 'es' })
  },

  // --- PLANTILLAS HTML Y AYUDANTES ---
  _createNotificationHTML(n) {
    const isUnread = n.read_unread == 0
    const icon = this._getIconForModule(n.module)
    const badgeClass = this._getBadgeClassForModule(n.module)

    return `
        <a href="#" 
           class="dropdown-item p-2 notification-item ${
             isUnread ? 'unread' : ''
           }" 
           data-id="${n.notifications_id}"
           data-route="${n.route || ''}"
           data-is-unread="${isUnread ? '1' : '0'}">
            <div class="d-flex align-items-start">
                <div class="flex-shrink-0">
                    <i class="${icon} text-secondary" style="font-size: 22px;"></i>
                </div>

                <div class="flex-grow-1 ms-2">
                  <h6 class="my-0 fw-semibold text-wrap">${
                    n.template_render.title
                  }</h6>
                    <small class="text-wrap" style="white-space: pre-wrap;">${
                      n.template_render.desc || ''
                    }</small>
                    <div class="d-flex justify-content-between align-items-center mt-1 flex-wrap gap-1">
                        <span class="badge ${badgeClass}">${n.module}</span>
    <span class="badge bg-primary">${this._getTimeAgo(n.created_at)}</span>

                    </div>
                </div>
            </div>
        </a>`
  },

  _getEmptyStateHTML() {
    return `<div class="text-center my-4 "><i class="dripicons-checkmark color-1" style="font-size: 48px;"></i><h6 class="mt-2">Sin notificaciones</h6><p class="text-muted small">No hay notificaciones para mostrar.</p></div>`
  },

  _getErrorStateHTML() {
    return `<div class="text-center my-4"><i class="dripicons-warning color-1" style="font-size: 48px;"></i><h6 class="mt-2">Error</h6><p class="text-muted small">No se pudieron cargar las notificaciones.</p></div>`
  },

  _getGlobalLoader() {
    return document.getElementById('global-loader')
  },

  _showGlobalLoader() {
    const loader = this._getGlobalLoader()
    if (loader) loader.style.display = 'flex'
  },

  _getIconForModule(module) {
    const map = {
      users: 'user',
      work_orders: 'truck',
      inventory: 'archive',
      customers: 'briefcase',
      security: 'shield',
      workers: 'users',
      incidencias: 'alert-triangle',
      incidencias: 'dripicons-warning',
    }
    return map[module] || 'dripicons-information'
  },

  _getBadgeClassForModule(module) {
    return `badge bg-info text-capitalize`
  },

  _showLoader() {
    this.dom.container.innerHTML = `<div class="notification-loader-container"><div class="notification-spinner"></div></div>`
  },

  _hideLoader() {
    const loader = this.dom.container.querySelector(
      '.notification-loader-container'
    )
    if (loader) loader.remove()
  },
}

NotificationController.init()
