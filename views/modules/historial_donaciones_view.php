<div class="container-fluid">
    <div class="row mt-4">
        <div class="col-12">
            <div class="page-title-box d-flex justify-content-between align-items-center">
                <h4 class="page-title text-uppercase fw-bold m-0"><i class="mdi mdi-format-list-bulleted text-primary"></i> Historial de Donaciones</h4>
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
                        <p class="mt-2 text-muted">Cargando historial...</p>
                    </div>

                    <div id="noData" class="text-center py-5 d-none">
                        <i class="mdi mdi-inbox-outline text-muted" style="font-size: 4rem;"></i>
                        <h4 class="mt-2 text-muted">Aún no hay donaciones registradas</h4>
                        <a href="<?= BASE_URL ?>perfil" class="btn btn-primary mt-3 rounded-pill"><i class="mdi mdi-plus-circle me-1"></i> Registrar una ahora</a>
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
<script type="module" src="<?= BASE_URL ?>public/assets/js/modules/historial_donaciones_view.js"></script>
