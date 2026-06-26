<div class="container-fluid" id="adminAuthContainer">
    <div class="row mt-5 justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-lg border-0">
                <div class="card-body p-4 text-center">
                    <i class="mdi mdi-shield-crown text-primary" style="font-size: 4rem;"></i>
                    <h3 class="mt-2 mb-4 fw-bold">Acceso Administrativo</h3>
                    <p class="text-muted">Por favor ingrese el código de autorización para ver todas las donaciones a nivel general.</p>
                    <div class="form-group mb-3 text-start">
                        <label class="form-label fw-bold">Código de Acceso</label>
                        <input type="password" id="adminCode" class="form-control" placeholder="Ingrese el código">
                    </div>
                    <button class="btn btn-primary w-100 rounded-pill" id="btnAuthAdmin">Validar Acceso</button>
                    <p id="authError" class="text-danger mt-2 d-none">Código incorrecto</p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container-fluid d-none" id="adminDataContainer">
    <div class="row mt-4">
        <div class="col-12">
            <div class="page-title-box d-flex justify-content-between align-items-center">
                <h4 class="page-title text-uppercase fw-bold m-0"><i class="mdi mdi-shield-crown text-primary"></i> Administración General de Donaciones</h4>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-warning rounded-pill" id="btnGestionCategorias">
                        <i class="mdi mdi-tag-multiple me-1"></i> Categorías
                    </button>
                    <button type="button" class="btn btn-success rounded-pill d-none" id="btnExportarExcel">
                        <i class="mdi mdi-file-excel me-1"></i> Exportar a Excel
                    </button>
                </div>
            </div>
        </div>
    </div>

    <ul class="nav nav-tabs mb-3 mt-3" id="adminTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="dashboard-tab" data-bs-toggle="tab" data-bs-target="#dashboard" type="button" role="tab">
                <i class="mdi mdi-view-dashboard me-1"></i> Dashboard
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="historial-tab" data-bs-toggle="tab" data-bs-target="#historial" type="button" role="tab">
                <i class="mdi mdi-format-list-bulleted me-1"></i> Historial
            </button>
        </li>
    </ul>

    <div class="tab-content" id="adminTabsContent">
        <div class="tab-pane fade show active" id="dashboard" role="tabpanel">
            <div id="loaderDashboard" class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted">Cargando indicadores...</p>
            </div>
            <div id="dashboardContent" class="d-none">
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">Filtrar por Centro</label>
                        <select class="form-select form-select-sm" id="filtroCentro">
                            <option value="0">Todos los centros</option>
                        </select>
                    </div>
                </div>
                <div class="row" id="kpiCards"></div>
                <div class="row mt-3">
                    <div class="col-md-8 mb-3">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-white fw-bold"><i class="mdi mdi-chart-bar text-primary me-1"></i> Insumos por Categoría</div>
                            <div class="card-body">
                                <canvas id="chartCategorias" height="250"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-white fw-bold"><i class="mdi mdi-chart-donut text-primary me-1"></i> Presentación</div>
                            <div class="card-body">
                                <canvas id="chartPresentacion" height="250"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3 d-none">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-white fw-bold"><i class="mdi mdi-chart-line text-primary me-1"></i> Donaciones por Mes</div>
                            <div class="card-body">
                                <canvas id="chartDonacionesMes" height="220"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="card shadow-sm border-0 h-100">
                            <div class="card-header bg-white fw-bold"><i class="mdi mdi-chart-pie text-primary me-1"></i> Donaciones por Centro</div>
                            <div class="card-body">
                                <canvas id="chartDonacionesCentro" height="220"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="tab-pane fade" id="historial" role="tabpanel">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <div id="loader" class="text-center py-5">
                        <div class="spinner-border text-primary" role="status"></div>
                        <p class="mt-2 text-muted">Cargando todas las donaciones...</p>
                    </div>
                    <div id="noData" class="text-center py-5 d-none">
                        <i class="mdi mdi-inbox-outline text-muted" style="font-size: 4rem;"></i>
                        <h4 class="mt-2 text-muted">No hay donaciones en el sistema</h4>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="buscadorInsumo" placeholder="Buscar insumo por categoría o descripción...">
                        </div>
                    </div>
                    <div id="accordionDonaciones" class="accordion custom-accordion d-none"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalCategorias" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="mdi mdi-tag-multiple text-warning me-1"></i> Gestionar Categorías</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="loaderCats" class="text-center py-3">
                    <div class="spinner-border text-warning" role="status"></div>
                </div>
                <div id="contenidoCats" class="d-none">
                    <p class="text-muted">Haz clic en una categoría para editarla. Los cambios se aplicarán a todos los insumos con esa categoría.</p>
                    <div id="listaCategorias" class="d-flex flex-wrap gap-2"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<script>
    const baseUrl = "<?php echo BASE_URL; ?>";
</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
<script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>
<script type="module" src="<?= BASE_URL ?>public/assets/js/modules/admin_donaciones_view.js"></script>