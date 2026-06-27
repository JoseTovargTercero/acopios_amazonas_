<div class="container-fluid">
    <div class="row mt-4">
        <div class="col-12">
            <h2 class="page-title text-uppercase fw-bold">
                <i class="mdi mdi-storefront text-primary"></i>
                <?= htmlspecialchars($_SESSION['nombre'] ?? 'Centro de Acopio') ?>
            </h2>
            <p class="text-muted fs-5">Gestión y control de ingresos a almacén</p>
        </div>
    </div>

    <div class="row mt-3">
        <div class="col-12">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white d-flex align-items-center">
                    <h5 class="card-title text-white mb-0"><i class="mdi mdi-clipboard-plus-outline me-2"></i> Registrar Nuevo Ingreso a Almacén</h5>
                </div>
                <div class="card-body p-4">
                    <!-- Wizard Nav -->
                    <ul class="nav nav-pills nav-justified form-wizard-header mb-4" id="wizardNav">
                        <li class="nav-item">
                            <a href="#step1" data-bs-toggle="tab" class="nav-link active rounded-pill">
                                <span class="number">1</span>
                                <span class="d-none d-sm-inline">Datos de Recepción</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#step2" data-bs-toggle="tab" class="nav-link rounded-pill disabled" id="tabStep2">
                                <span class="number">2</span>
                                <span class="d-none d-sm-inline">Insumos Recibidos</span>
                            </a>
                        </li>
                    </ul>

                    <form id="formDonacionWizard" class="needs-validation" novalidate>
                        <div class="tab-content">
                            <!-- Paso 1 -->
                            <div class="tab-pane show active" id="step1">
                                <h5 class="mb-4">Información de Llegada y Transporte</h5>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="fecha_hora_llegada" class="form-label fw-bold">Fecha y Hora de Llegada <span class="text-danger">*</span></label>
                                        <input type="datetime-local" class="form-control" id="fecha_hora_llegada" name="fecha_hora_llegada" required>
                                        <div class="invalid-feedback">Por favor, indique la fecha y hora.</div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="nombre_transportista" class="form-label fw-bold">Nombre del Transportista</label>
                                        <input type="text" class="form-control" id="nombre_transportista" name="nombre_transportista" maxlength="100" placeholder="Nombre del conductor">
                                    </div>
                                </div>

                                <div class="text-end mt-4">
                                    <button type="button" class="btn btn-primary px-4 rounded-pill fw-bold" id="btnNextStep">Siguiente Paso <i class="mdi mdi-arrow-right ms-1"></i></button>
                                </div>
                            </div>

                            <!-- Paso 2 -->
                            <div class="tab-pane" id="step2">
                                <div class="row mb-3 align-items-end bg-light p-3 rounded mx-0 border">
                                    <h5 class="mb-3 text-primary"><i class="mdi mdi-package-variant-closed me-2"></i>Agregar Insumo</h5>

                                    <div class="col-md-4 mb-2">
                                        <label class="form-label fw-bold">Categoría <span class="text-danger">*</span></label>
                                        <select class="form-select form-select-sm" id="ins_categoria">
                                            <option value="">Seleccione</option>
                                            <option value="ALIMENTOS">Alimentos</option>
                                            <option value="ALIMENTO ANIMAL">Alimento animal</option>
                                            <option value="ARTÍCULOS DE LIMPIEZA">Artículos de limpieza</option>
                                            <option value="HIGIENE PERSONAL">Higiene personal</option>

                                            <option value="MEDICAMENTOS">Medicamentos</option>
                                            <option value="INSUMOS MÉDICOS">Insumos médicos</option>
                                            <option value="BEBIDAS">Bebidas</option>
                                            <option value="LENCERÍAS">Lencerías</option>
                                            <option value="MOSQUITEROS">Mosquiteros</option>
                                            <option value="PRODUCTOS PLÁSTICOS">Productos plásticos</option>
                                            <option value="HERRAMIENTAS MENORES">Herramientas menores</option>
                                            <option value="EQUIPOS DE PROTECCIÓN PERSONAL">Equipos de protección personal</option>
                                            <option value="ROPA">Ropa</option>
                                            <option value="AGUA">Agua</option>
                                            <option value="otro">Otro</option>
                                        </select>
                                        <input type="text" class="form-control form-control-sm mt-1 d-none" id="ins_categoria_otro" placeholder="Especifique la categoría">
                                    </div>
                                    <div class="col-md-8 mb-2">
                                        <label class="form-label fw-bold">Descripción del insumo <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control form-control-sm" id="ins_descripcion" placeholder="Ej: Arroz, Paracetamol 500mg...">
                                    </div>

                                    <div class="col-md-3 mb-2">
                                        <label class="form-label fw-bold">Presentación <span class="text-danger">*</span></label>
                                        <select class="form-select form-select-sm" id="ins_presentacion">
                                            <option value="unidad">Unidad</option>
                                            <option value="caja">Caja</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 mb-2" id="solo_para_caja" style="display: none;">
                                        <label class="form-label fw-bold" id="">Unid. por caja. <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control form-control-sm" id="ins_unidades" value="1" min="1">
                                    </div>
                                    <div class="col-md-3 mb-2">
                                        <label class="form-label fw-bold">Peso unitario (kg)</label>
                                        <input type="number" step="0.01" class="form-control form-control-sm" id="ins_peso" value="0.00" min="0">
                                    </div>
                                    <div class="col-md-3 mb-2">
                                        <label class="form-label fw-bold">Fecha de Vencimiento</label>
                                        <input type="date" class="form-control form-control-sm" id="ins_vencimiento">
                                    </div>

                                    <div class="col-md-3 mb-2">
                                        <label class="form-label fw-bold" id="lbl-man">Cant. Manifestada <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control form-control-sm" id="ins_manifestada" value="1" min="0">
                                    </div>
                                    <div class="col-md-4 mb-2">
                                        <label class="form-label fw-bold">Estado <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control form-control-sm" id="ins_estado" placeholder="Ej: Buen estado" value="Buen estado">
                                    </div>
                                    <div class="col-md-2 mb-2 d-flex">
                                        <button type="button" class="btn btn-success btn-sm w-100" id="btnAddInsumo">
                                            <i class="mdi mdi-plus fw-bold"></i> Agregar
                                        </button>
                                    </div>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-bordered table-striped table-hover mb-0">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>Categoría</th>
                                                <th>Descripción</th>
                                                <th>Present.</th>
                                                <th class="text-center">Cant. Manif.</th>
                                                <th>Estado</th>
                                                <th class="text-center">Acción</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tablaInsumos">
                                            <tr>
                                                <td colspan="6" class="text-center text-muted">Aún no se han agregado insumos.</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="d-flex justify-content-between mt-4">
                                    <button type="button" class="btn btn-outline-secondary px-4 rounded-pill" id="btnPrevStep"><i class="mdi mdi-arrow-left me-1"></i> Anterior</button>
                                    <button type="button" class="btn btn-primary px-4 rounded-pill fw-bold" id="btnFinalizar" disabled>
                                        <i class="mdi mdi-check-circle me-1"></i> Finalizar y Guardar
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const baseUrl = "<?php echo BASE_URL; ?>";
</script>
<script type="module" src="<?= BASE_URL ?>public/assets/js/modules/perfil_almacen_view.js"></script>