<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex justify-content-between align-items-center">
                <h4 class="page-title">Asignaciones de Colecciones</h4>
                <button class="btn btn-primary" onclick="window.a.showForm()">+ Nueva Asignación</button>
            </div>
        </div>
    </div>

    <!-- Tabla listado -->
    <div id="aListView">
        <div class="card">
            <div class="card-body">
                <table id="aTabla" class="table table-hover"
                    data-toggle="table"
                    data-url="<?= BASE_URL ?>api/asignaciones"
                    data-response-handler="window.a.resp"
                    data-search="true" data-pagination="true" data-page-size="15">
                    <thead>
                        <tr>
                            <th data-field="vendedor" data-formatter="window.a.fVendedor" data-sortable="true">Vendedor</th>
                            <th data-field="coleccion" data-formatter="window.a.fColeccion" data-sortable="true">Colección</th>
                            <th data-field="coleccion_tipo" data-formatter="window.a.fTipo">Tipo</th>
                            <th data-field="precio_venta_vendedor" data-formatter="window.a.fMonto">Monto</th>
                            <th data-field="fecha_asignacion" data-sortable="true">Fecha</th>
                            <th data-field="estado" data-formatter="window.a.fEstado">Estado</th>
                            <th data-formatter="window.a.fAcc" data-align="center">Acciones</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>

    <!-- Formulario Wizard -->
    <div id="aFormView" style="display:none">
        <div class="card">
            <div class="card-body">
                <!-- Steps -->
                <ul class="nav nav-pills mb-4 justify-content-center" id="aWizardSteps">
                    <li class="nav-item">
                        <a class="nav-link active" data-step="1" href="javascript:void(0)" onclick="window.a.goStep(1)">
                            <i class="bx bx-user me-1"></i> Vendedor
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-step="2" href="javascript:void(0)" onclick="window.a.goStep(2)">
                            <i class="bx bx-collection me-1"></i> Colección
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-step="3" href="javascript:void(0)" onclick="window.a.goStep(3)">
                            <i class="bx bx-credit-card me-1"></i> Cuotas
                        </a>
                    </li>
                </ul>

                <!-- Step 1: Vendedor -->
                <div class="wizard-step" id="aWStep1">
                    <div class="row justify-content-center">
                        <div class="col-lg-6">
                            <h5 class="mb-3 text-center">Selecciona el Vendedor</h5>
                            <div class="mb-3">
                                <label for="aVendedor" class="form-label">Vendedor <span class="text-danger">*</span></label>
                                <select class="form-select" id="aVendedor" required>
                                    <option value="">Seleccione vendedor...</option>
                                </select>
                            </div>
                            <div class="text-center mt-4">
                                <button class="btn btn-primary px-4" onclick="window.a.goStep(2)">
                                    Siguiente <i class="bx bx-chevron-right"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 2: Colección + Temporada -->
                <div class="wizard-step" id="aWStep2" style="display:none">
                    <div class="row justify-content-center">
                        <div class="col-lg-6">
                            <h5 class="mb-3 text-center">Colección y Temporada</h5>
                            <div class="mb-3">
                                <label for="aEmpresa" class="form-label">Empresa <span class="text-danger">*</span></label>
                                <select class="form-select" id="aEmpresa" required>
                                    <option value="">Seleccione empresa...</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="aColeccion" class="form-label">Colección/Combo <span class="text-danger">*</span></label>
                                <select class="form-select" id="aColeccion" required>
                                    <option value="">Primero seleccione empresa...</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="aTemporada" class="form-label">Temporada <span class="text-danger">*</span></label>
                                <select class="form-select" id="aTemporada" required>
                                    <option value="">Seleccione temporada...</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="aFechaAsig" class="form-label">Fecha de Asignación <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="aFechaAsig" required>
                            </div>
                            <div class="text-center mt-4 d-flex justify-content-between">
                                <button class="btn btn-secondary" onclick="window.a.goStep(1)">
                                    <i class="bx bx-chevron-left"></i> Anterior
                                </button>
                                <button class="btn btn-primary px-4" onclick="window.a.goStep(3)">
                                    Siguiente <i class="bx bx-chevron-right"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 3: Cuotas + Resumen -->
                <div class="wizard-step" id="aWStep3" style="display:none">
                    <h5 class="mb-3 text-center">Configuración de Cuotas</h5>
                    <div class="row justify-content-center mb-3">
                        <div class="col-lg-3">
                            <label for="aCalculo" class="form-label">Cálculo <span class="text-danger">*</span></label>
                            <select class="form-select" id="aCalculo" onchange="window.a.onCalcChange()">
                                <option value="automatico">Automático</option>
                                <option value="manual">Manual</option>
                            </select>
                        </div>
                        <div id="aAutoFields" class="col-lg-3">
                            <label for="aFechaPrimera" class="form-label">Primera Cuota <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="aFechaPrimera">
                        </div>
                        <div id="aIntervaloField" class="col-lg-3">
                            <label for="aIntervalo" class="form-label">Intervalo</label>
                            <select class="form-select" id="aIntervalo">
                                <option value="mensual">Mensual</option>
                                <option value="quincenal">Quincenal</option>
                            </select>
                        </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <button class="btn btn-warning w-100 mb-3" onclick="window.a.calcular()">
                                <i class="bx bx-calculator"></i> Calcular Cuotas
                            </button>
                        </div>
                    </div>

                    <div id="aResumenCard" style="display:none">
                        <div id="aResumenInfo" class="mb-3"></div>
                        <div class="table-responsive">
                            <div id="aCuotasDetalle"></div>
                        </div>
                        <div class="row justify-content-center mt-4">
                            <div class="col-lg-6 d-flex justify-content-between">
                                <button class="btn btn-secondary" onclick="window.a.goStep(2)">
                                    <i class="bx bx-chevron-left"></i> Anterior
                                </button>
                                <div>
                                    <button class="btn btn-secondary me-2" onclick="window.a.hideForm()">Cancelar</button>
                                    <button class="btn btn-primary" onclick="window.a.guardar()">
                                        <i class="bx bx-save"></i> Guardar Asignación
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="aResumenEmpty" style="display:block">
                        <div class="text-center py-4 text-muted">
                            <i class="bx bx-calculator fs-1"></i>
                            <p class="mt-2">Presiona "Calcular Cuotas" para ver el resumen.</p>
                        </div>
                        <div class="text-center">
                            <button class="btn btn-secondary" onclick="window.a.goStep(2)">
                                <i class="bx bx-chevron-left"></i> Anterior
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Ver Cuotas -->
<div class="modal fade" id="aCuotasModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cuotas de la Asignación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                    <table class="table table-sm table-bordered mb-0">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>%</th>
                                <th>Monto</th>
                                <th>Fecha Pago</th>
                                <th>Vencimiento</th>
                                <th>Estatus</th>
                                <th>Comprobante</th>
                            </tr>
                        </thead>
                        <tbody id="aCuotasModalBody">
                            <tr><td colspan="7" class="text-center text-muted">Cargando...</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<script>
window.a = {
    api:   '<?= BASE_URL ?>api/asignaciones',
    apiE:  '<?= BASE_URL ?>api/empresas',
    apiV:  '<?= BASE_URL ?>api/vendedores',
    apiT:  '<?= BASE_URL ?>api/temporadas',
    apiC:  '<?= BASE_URL ?>api/colecciones',
    BASE:  '<?= BASE_URL ?>',
    empresas: [], colecciones: [], temporadas: [], cuotasCalc: [],

    resp: (r) => ({ rows: r.data || [], total: r.data?.length || 0 }),

    fVendedor(v, row) {
        return `<div class="d-flex align-items-center gap-2">
                    <div class="avatar avatar-sm">
                        <span class="avatar-initial rounded-circle bg-primary">${(row.vendedor_nombre||'?')[0]}</span>
                    </div>
                    <div>
                        <div class="fw-semibold">${row.vendedor_nombre}</div>
                        <small class="text-muted">${row.vendedor_cedula}</small>
                    </div>
                </div>`;
    },

    fColeccion(v, row) {
        return `<div>
                    <div class="fw-semibold">${row.coleccion_nombre}</div>
                    <small class="text-muted">${row.temporada_nombre}</small>
                </div>`;
    },

    fTipo: (v) => v === 'combo'
        ? '<span class="badge bg-info">Combo</span>'
        : '<span class="badge bg-success">Colección</span>',

    fEstado: (v) => {
        const m = {activa: 'primary', inactiva: 'secondary', cancelada: 'danger'};
        return `<span class="badge bg-${m[v]||'secondary'}">${v}</span>`;
    },

    fMonto: (v) => `$${parseFloat(v||0).toFixed(2)}`,

    fAcc: (v, row) => {
        return `<div class="d-flex gap-1 justify-content-center">
                    <button class="btn btn-sm btn-outline-info" onclick="window.a.verCuotas('${row.id}')" title="Ver Cuotas">
                        <i class="bx bx-list-ul"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-danger" onclick="window.a.del('${row.id}')" title="Eliminar">
                        <i class="bx bx-trash"></i>
                    </button>
                </div>`;
    },

    async init() {
        const [re, rv, rt, rc] = await Promise.all([
            fetch(this.apiE).then(r=>r.json()),
            fetch(this.apiV).then(r=>r.json()),
            fetch(this.apiT).then(r=>r.json()),
            fetch(this.apiC).then(r=>r.json()),
        ]);
        this.empresas    = re.data || [];
        this.temporadas  = rt.data || [];
        this.colecciones = rc.data || [];

        this._fillSelect('aEmpresa', this.empresas, e => ({ v: e.id, l: e.nombre, data: e }));
        this._fillSelect('aVendedor', rv.data||[], v => ({ v: v.id, l: `${v.nombre} — ${v.cedula}` }));
        this._fillSelect('aTemporada', this.temporadas, t => ({ v: t.id, l: t.nombre }));

        document.getElementById('aEmpresa').addEventListener('change', () => this.onEmpresaChange());
    },

    _fillSelect(id, items, mapper, empty='Seleccione...') {
        const el = document.getElementById(id);
        el.innerHTML = `<option value="">${empty}</option>` +
            items.map(i => { const m=mapper(i); return `<option value="${m.v}"${m.data?` data-row='${JSON.stringify(m.data).replace(/'/g,"&apos;")}'`:''}>${m.l}</option>`; }).join('');
    },

    onEmpresaChange() {
        const empId = document.getElementById('aEmpresa').value;
        const emp   = this.empresas.find(e => e.id === empId);
        this.cfgCuotas = emp || null;

        const cols = this.colecciones.filter(c => c.empresa_id === empId);
        this._fillSelect('aColeccion', cols, c => ({ v: c.id, l: `${c.nombre} (${c.tipo})`, data: c }), 'Seleccione colección...');

        const temps = this.temporadas.filter(t => t.empresa_id === empId);
        this._fillSelect('aTemporada', temps, t => ({ v: t.id, l: t.nombre }), 'Seleccione temporada...');

        document.getElementById('aResumenCard').style.display = 'none';
        document.getElementById('aResumenEmpty').style.display = 'block';
        this.cuotasCalc = [];
    },

    onCalcChange() {
        const manual = document.getElementById('aCalculo').value === 'manual';
        document.getElementById('aAutoFields').style.display = manual ? 'none' : '';
        document.getElementById('aIntervaloField').style.display = manual ? 'none' : '';
        document.getElementById('aResumenCard').style.display = 'none';
        document.getElementById('aResumenEmpty').style.display = 'block';
        this.cuotasCalc = [];
    },

    goStep(n) {
        document.querySelectorAll('.wizard-step').forEach(el => el.style.display = 'none');
        document.getElementById('aWStep' + n).style.display = '';
        document.querySelectorAll('#aWizardSteps .nav-link').forEach(el => {
            el.classList.toggle('active', parseInt(el.dataset.step) === n);
        });
    },

    calcular() {
        const empId    = document.getElementById('aEmpresa').value;
        const colOpt   = document.getElementById('aColeccion').selectedOptions[0];
        const calculo  = document.getElementById('aCalculo').value;
        const fechaAsig = document.getElementById('aFechaAsig').value;

        if (!empId || !colOpt?.value || !fechaAsig) {
            Swal.fire({ icon: 'warning', title: 'Campos incompletos', text: 'Complete empresa, colección y fecha de asignación.' });
            return;
        }

        const emp = this.empresas.find(e => e.id === empId);
        if (!emp || !emp.cantidad_cuotas) {
            Swal.fire({ icon: 'warning', title: 'Sin configuración', text: 'La empresa no tiene configuración de cuotas.' });
            return;
        }

        const colData = JSON.parse(colOpt.getAttribute('data-row') || '{}');
        const monto   = parseFloat(colData.precio_venta_vendedor || 0);
        const cuotas  = Array.isArray(emp.cuotas) ? emp.cuotas : [];
        const n       = parseInt(emp.cantidad_cuotas);

        this.cuotasCalc = [];

        if (calculo === 'automatico') {
            const fechaPrimera = document.getElementById('aFechaPrimera').value;
            const intervalo    = document.getElementById('aIntervalo').value;
            if (!fechaPrimera) { Swal.fire({ icon: 'warning', title: 'Fecha requerida', text: 'Indique la fecha de la primera cuota.' }); return; }

            for (let i = 0; i < n; i++) {
                const pct   = parseFloat(cuotas[i] || (100/n));
                const mt    = (monto * pct / 100);
                const fecha = this._sumarIntervalo(fechaPrimera, intervalo, i);
                this.cuotasCalc.push({ numero: i+1, porcentaje: pct, monto: mt, fecha_pago: fecha });
            }
        } else {
            for (let i = 0; i < n; i++) {
                const pct = parseFloat(cuotas[i] || (100/n));
                const mt  = (monto * pct / 100);
                this.cuotasCalc.push({ numero: i+1, porcentaje: pct, monto: mt, fecha_pago: '' });
            }
        }

        this._renderResumen(monto, calculo);
    },

    _sumarIntervalo(base, intervalo, i) {
        const d = new Date(base + 'T00:00:00');
        if (intervalo === 'mensual')    d.setMonth(d.getMonth() + i);
        else                            d.setDate(d.getDate() + 15 * i);
        return d.toISOString().slice(0, 10);
    },

    _renderResumen(monto, calculo) {
        const total = this.cuotasCalc.reduce((s,c) => s + c.monto, 0);
        document.getElementById('aResumenInfo').innerHTML = `
            <div class="row text-center g-2">
                <div class="col-4"><div class="p-3 bg-light rounded"><small class="text-muted">Monto Total</small><div class="fw-bold fs-5">$${monto.toFixed(2)}</div></div></div>
                <div class="col-4"><div class="p-3 bg-light rounded"><small class="text-muted">Cuotas</small><div class="fw-bold fs-5">${this.cuotasCalc.length}</div></div></div>
                <div class="col-4"><div class="p-3 bg-light rounded"><small class="text-muted">Total Calculado</small><div class="fw-bold fs-5">$${total.toFixed(2)}</div></div></div>
            </div>`;

        let rows = '';
        this.cuotasCalc.forEach((c, idx) => {
            const fechaInput = calculo === 'manual'
                ? `<input type="date" class="form-control form-control-sm cuota-fecha" data-idx="${idx}" required>`
                : `<span class="fw-medium">${c.fecha_pago}</span>`;
            rows += `<tr>
                <td class="fw-medium">${c.numero}</td>
                <td>${c.porcentaje.toFixed(2)}%</td>
                <td class="fw-medium">$${c.monto.toFixed(2)}</td>
                <td>${fechaInput}</td>
                <td>${calculo === 'manual' ? '' : this._sumarFecha(c.fecha_pago, 3)}</td>
            </tr>`;
        });

        document.getElementById('aCuotasDetalle').innerHTML = `
            <table class="table table-sm table-bordered table-striped mb-0">
                <thead class="table-light">
                    <tr><th>#</th><th>%</th><th>Monto</th><th>Fecha Pago</th><th>Vencimiento</th></tr>
                </thead>
                <tbody>${rows}</tbody>
            </table>`;

        document.querySelectorAll('.cuota-fecha').forEach(inp => {
            inp.addEventListener('change', e => {
                const idx = parseInt(e.target.getAttribute('data-idx'));
                this.cuotasCalc[idx].fecha_pago = e.target.value;
                const td = e.target.closest('tr').querySelector('td:last-child');
                if (td) td.textContent = this._sumarFecha(e.target.value, 3);
            });
        });

        document.getElementById('aResumenCard').style.display = '';
        document.getElementById('aResumenEmpty').style.display = 'none';
    },

    _sumarFecha(fecha, dias) {
        if (!fecha) return '';
        const d = new Date(fecha + 'T00:00:00');
        d.setDate(d.getDate() + dias);
        return d.toISOString().slice(0, 10);
    },

    async guardar() {
        if (!this.cuotasCalc.length) { Swal.fire({ icon: 'warning', title: 'Sin cuotas', text: 'Calcule las cuotas primero.' }); return; }

        const incompletas = this.cuotasCalc.filter(c => !c.fecha_pago);
        if (incompletas.length) { Swal.fire({ icon: 'warning', title: 'Fechas incompletas', text: 'Complete las fechas de todas las cuotas.' }); return; }

        const payload = {
            vendedor_id:      document.getElementById('aVendedor').value,
            coleccion_id:     document.getElementById('aColeccion').value,
            temporada_id:     document.getElementById('aTemporada').value,
            fecha_asignacion: document.getElementById('aFechaAsig').value,
            cuotas: this.cuotasCalc
        };

        try {
            const res = await fetch(this.api, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(payload)
            });
            const data = await res.json();
            if (data.value) {
                Swal.fire({ icon: 'success', title: 'Guardado', text: 'Asignación creada correctamente.', timer: 1500, showConfirmButton: false });
                this.hideForm();
                $('#aTabla').bootstrapTable('refresh');
            } else {
                Swal.fire({ icon: 'error', title: 'Error', text: data.message });
            }
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Error', text: 'Error al guardar la asignación.' });
        }
    },

    async del(id) {
        const result = await Swal.fire({ icon: 'question', title: '¿Eliminar?', text: 'Esta acción eliminará la asignación y sus cuotas.', showCancelButton: true, confirmButtonText: 'Sí, eliminar', cancelButtonText: 'Cancelar' });
        if (!result.isConfirmed) return;
        try {
            await fetch(this.api + '/' + id, { method: 'DELETE' });
            $('#aTabla').bootstrapTable('refresh');
            Swal.fire({ icon: 'success', title: 'Eliminado', timer: 1000, showConfirmButton: false });
        } catch (e) {
            Swal.fire({ icon: 'error', title: 'Error', text: 'Error al eliminar.' });
        }
    },

    async verCuotas(id) {
        const tbody = document.getElementById('aCuotasModalBody');
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">Cargando...</td></tr>';
        const modal = new bootstrap.Modal(document.getElementById('aCuotasModal'));
        modal.show();

        try {
            const res = await fetch(`${this.api}/${id}/cuotas`);
            const data = await res.json();
            if (data.value && data.data?.length) {
                const estatusBadge = {
                    pendiente: 'secondary',
                    pagada: 'success',
                    vencida: 'danger',
                    cancelada: 'warning'
                };
                tbody.innerHTML = data.data.map(c => `
                    <tr>
                        <td class="fw-medium">${c.numero_cuota}</td>
                        <td>${parseFloat(c.porcentaje).toFixed(2)}%</td>
                        <td class="fw-medium">$${parseFloat(c.monto_a_pagar).toFixed(2)}</td>
                        <td>${c.fecha_pago}</td>
                        <td>${c.fecha_vencimiento}</td>
                        <td><span class="badge bg-${estatusBadge[c.estatus_pago]||'secondary'}">${c.estatus_pago}</span></td>
                        <td>${c.comprobante || '<span class="text-muted">—</span>'}</td>
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">Sin cuotas registradas.</td></tr>';
            }
        } catch (e) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">Error al cargar cuotas.</td></tr>';
        }
    },

    showForm() {
        document.getElementById('aListView').style.display = 'none';
        document.getElementById('aFormView').style.display = '';
        document.getElementById('aResumenCard').style.display = 'none';
        document.getElementById('aResumenEmpty').style.display = 'block';
        this.cuotasCalc = [];
        this.goStep(1);
    },

    hideForm() {
        document.getElementById('aFormView').style.display = 'none';
        document.getElementById('aListView').style.display = '';
    }
};

document.addEventListener('DOMContentLoaded', () => window.a.init());
</script>
