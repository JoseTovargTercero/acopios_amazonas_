<?php

$userName = $_SESSION['nombre'] ?? 'Invitado';
$userType = $_SESSION['codigo'] ?? '';
?>

<nav
    class="layout-navbar container-fluid navbar navbar-expand-xl navbar-detached align-items-center bg-navbar-theme"
    id="layout-navbar">
    <div class="layout-menu-toggle navbar-nav align-items-xl-center me-3 me-xl-0 d-xl-none">
        <a class="nav-item nav-link px-0 me-xl-4" href="javascript:void(0)">
            <i class="bx bx-menu bx-sm"></i>
        </a>
    </div>

    <div class="navbar-nav-right d-flex align-items-center" id="navbar-collapse">
        <!-- Search -->
        <div class="navbar-nav align-items-center">
            <div class="nav-item d-flex align-items-center">
                <i class="bx bx-search fs-4 lh-0"></i>
                <input
                    type="text"
                    class="form-control border-0 shadow-none"
                    placeholder="Buscar..."
                    aria-label="Buscar..." />
            </div>
        </div>

        <ul class="navbar-nav flex-row align-items-center ms-auto">

            <!-- Download App -->
            <li class="nav-item lh-1 me-2" id="download-app-li" style="display: none;">
                <a class="nav-link" href="#" id="download-app-button" title="Descargar Aplicación">
                    <i class="bx bx-download bx-sm"></i>
                </a>
            </li>

            <!-- Notifications -->
            <li class="nav-item dropdown me-2">
                <a class="nav-link dropdown-toggle hide-arrow" href="#" data-bs-toggle="dropdown" id="notification-dropdown-toggle">
                    <i class="bx bx-bell bx-sm"></i>
                    <span class="badge bg-danger rounded-pill badge-notifications" id="alert-count">0</span>
                </a>
                <div class="dropdown-menu dropdown-menu-end dropdown-lg py-0" id="dropdown-container">
                    <div class="p-2 border-top-0 border-start-0 border-end-0 border-dashed border">
                        <div class="row align-items-center">
                            <div class="col">
                                <h6 class="m-0 fw-semibold">Notificaciones</h6>
                            </div>
                            <div class="col-auto">
                                <a href="javascript:void(0);" id="clear-all-alerts" class="text-decoration-underline">
                                    <small>Marcar Como Leídas</small>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="p-2">
                        <div class="d-flex gap-1" id="notification-tabs" role="tablist">
                            <button class="btn btn-outline-primary btn-sm" id="all-tab" type="button">Todas</button>
                            <button class="btn btn-outline-primary btn-sm active" id="unread-tab" type="button">
                                No leídas (<span id="unread-count">0</span>)
                            </button>
                        </div>
                    </div>

                    <div class="px-1 overflow-auto" style="max-height: 300px;" data-simplebar="init" id="alerts-scroll-container">
                        <div class="simplebar-content" style="padding: 0px 6px;" id="alerts-container"></div>
                    </div>

                    <a href="notifications" class="dropdown-item text-center notify-item border-top py-2">
                        Ver notificaciones
                    </a>
                </div>
            </li>

            <!-- User -->
            <li class="nav-item navbar-dropdown dropdown-user dropdown">
                <a class="nav-link dropdown-toggle hide-arrow" href="javascript:void(0);" data-bs-toggle="dropdown">
                    <div class="avatar avatar-online">
                        <img src="<?= BASE_URL ?>public/assets/images/users/avatar-1.jpg" alt class="w-px-40 h-auto rounded-circle" />
                    </div>
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                        <a class="dropdown-item" href="#">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3">
                                    <div class="avatar avatar-online">
                                        <img src="<?= BASE_URL ?>public/assets/images/users/avatar-1.jpg" alt class="w-px-40 h-auto rounded-circle" />
                                    </div>
                                </div>
                                <div class="flex-grow-1">
                                    <span class="fw-semibold d-block"><?= $userName ?></span>
                                    <small class="text-muted"><?= $userType ?></small>
                                </div>
                            </div>
                        </a>
                    </li>
                    <li><div class="dropdown-divider"></div></li>
                    <li>
                        <a class="dropdown-item" href="<?= BASE_URL ?>perfil">
                            <i class="bx bx-user me-2"></i>
                            <span class="align-middle">Mi Perfil</span>
                        </a>
                    </li>
                    <li><div class="dropdown-divider"></div></li>
                    <li>
                        <a class="dropdown-item" href="<?= BASE_URL ?>api/logout">
                            <i class="bx bx-power-off me-2"></i>
                            <span class="align-middle">Cerrar Sesión</span>
                        </a>
                    </li>
                </ul>
            </li>
            <!--/ User -->
        </ul>
    </div>
</nav>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const userAgent = navigator.userAgent;
        const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(userAgent);
        const downloadLi = document.getElementById('download-app-li');
        const downloadButton = document.getElementById('download-app-button');

        if (isMobile) {
            downloadLi.style.display = 'list-item';
            downloadButton.addEventListener('click', function(e) {
                e.preventDefault();
                Swal.fire({
                    title: '¿Descargar Aplicación?',
                    text: "Se descargará el archivo de instalación para Android.",
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'Sí, descargar',
                    cancelButtonText: 'Cancelar',
                }).then((result) => {
                    if (result.isConfirmed) {
                        const downloadUrl = '<?= BASE_URL ?>downloads/app.txt';
                        const link = document.createElement('a');
                        link.href = downloadUrl;
                        link.setAttribute('download', 'app.apk');
                        document.body.appendChild(link);
                        link.click();
                        document.body.removeChild(link);
                    }
                });
            });
        }

        // Menu toggle
        document.querySelectorAll('.layout-menu-toggle').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                document.body.classList.toggle('layout-menu-collapsed');
            });
        });
    });
</script>
