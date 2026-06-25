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
                <button type="button" class="btn btn-success rounded-pill d-none" id="btnExportarExcel">
                    <i class="mdi mdi-file-excel me-1"></i> Exportar a Excel
                </button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
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

                    <div id="accordionDonaciones" class="accordion custom-accordion d-none">
                        <!-- Renderizado por JS -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const baseUrl = "<?php echo BASE_URL; ?>";
</script>
<script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>
<script type="module" src="<?= BASE_URL ?>public/assets/js/modules/admin_donaciones_view.js"></script>
