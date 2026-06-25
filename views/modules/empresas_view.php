<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex align-items-center justify-content-between">
                <h4 class="page-title">Empresas</h4>
                <button id="btnNuevaEmpresa" class="btn btn-primary">
                    <i class="mdi mdi-plus"></i> Nueva Empresa
                </button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <table id="tablaEmpresas"
                        data-toggle="table"
                        data-url="<?= BASE_URL ?>api/empresas"
                        data-response-handler="responseHandler"
                        data-search="true"
                        data-pagination="true"
                        data-page-size="15"
                        class="table table-hover">
                        <thead>
                            <tr>
                                <th data-field="nombre" data-sortable="true">Nombre</th>
                                <th data-field="telefono">Teléfono</th>
                                <th data-field="created_at" data-sortable="true" data-formatter="dateFormatter">Creado</th>
                                <th data-field="id" data-formatter="accionesFormatter" data-align="center" data-width="120">Acciones</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal crear / editar (reutilizado) -->
<div class="modal fade" id="modalEmpresa" tabindex="-1" aria-labelledby="modalEmpresaLabel" aria-hidden="true" data-bs-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalEmpresaLabel">Nueva Empresa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="formEmpresa">
                <input type="hidden" id="empresaId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="empresaNombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="empresaNombre" name="nombre" maxlength="150" required>
                    </div>
                    <div class="mb-3">
                        <label for="empresaTelefono" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="empresaTelefono" name="telefono" maxlength="30">
                    </div>
                    <hr>
                    <h6 class="mb-3">Configuración de Cuotas</h6>
                    <div class="mb-3">
                        <label for="empresaCuotas" class="form-label">Cantidad de Cuotas <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="empresaCuotas" min="1" max="24" required>
                    </div>
                    <div id="cuotasContainer" class="row"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary" id="btnGuardarEmpresa">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>const baseUrl = "<?= BASE_URL ?>";</script>
<script type="module" src="<?= BASE_URL ?>public/assets/js/modules/empresas_view.js"></script>

