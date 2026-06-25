<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex justify-content-between align-items-center">
                <h4 class="page-title">Temporadas</h4>
                <button class="btn btn-primary" onclick="window.t.add()">+ Nueva</button>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <table id="tTabla" class="table table-hover" data-toggle="table" data-url="<?= BASE_URL ?>api/temporadas" data-response-handler="window.t.resp" data-search="true" data-pagination="true" data-page-size="15">
                <thead>
                    <tr>
                        <th data-field="nombre" data-sortable="true">Nombre</th>
                        <th data-field="fecha_inicio" data-sortable="true">Inicio</th>
                        <th data-field="fecha_fin" data-sortable="true">Fin</th>
                        <th data-field="empresa_id" data-sortable="true" data-formatter="window.t.fEmp">Empresa</th>
                        <th data-formatter="window.t.fAcc">Acciones</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="tModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="tForm" onsubmit="window.t.save(event)">
                <div class="modal-header">
                    <h5 class="modal-title">Temporada</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="tId">
                    <div class="mb-3">
                        <label for="tNombre" class="form-label">Nombre</label>
                        <input class="form-control mb-2" id="tNombre" placeholder="Nombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="tFi" class="form-label">Inicio</label>
                        <input type="date" class="form-control mb-2" id="tFi" required>
                    </div>
                    <div class="mb-3">
                        <label for="tFf" class="form-label">Fin</label>
                        <input type="date" class="form-control mb-2" id="tFf" required>
                    </div>
                    <div class="mb-3">
                        <label for="tEmp" class="form-label">Empresa</label>
                        <select class="form-control mb-2" id="tEmp" required>
                            <option value="">Empresa...</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Guardar</button></div>
            </form>
        </div>
    </div>
</div>

<script>
    window.t = {
        api: '<?= BASE_URL ?>api/temporadas',
        apiE: '<?= BASE_URL ?>api/empresas',
        emps: [],
        resp: (res) => ({ rows: res.data || [], total: res.data?.length || 0 }),
        fEmp: (v) => window.t.emps.find(e=>e.id==v)?.nombre || '',
        fAcc: (v, x) => {
            let xJ = JSON.stringify(x).replace(/'/g, "&apos;");
            return `<button class="btn btn-sm btn-info" onclick='window.t.edit(${xJ})'>Editar</button>
                    <button class="btn btn-sm btn-danger" onclick="window.t.del('${x.id}')">Borrar</button>`;
        },
        init() {
            fetch(this.apiE).then(r => r.json()).then(d => {
                this.emps = d.data || [];

                const tEmp = document.getElementById('tEmp');
                if (tEmp) {
                    tEmp.innerHTML = '<option value="">Empresa...</option>' +
                        this.emps.map(e => `<option value="${e.id}">${e.nombre}</option>`).join('');
                }
                $('#tTabla').bootstrapTable('refresh');
            });
        },
        add() {
            const tForm = document.getElementById('tForm');
            if (tForm) tForm.reset();

            const tId = document.getElementById('tId');
            if (tId) tId.value = '';

            const tEmp = document.getElementById('tEmp');
            if (tEmp) tEmp.disabled = false;

            new bootstrap.Modal(document.getElementById('tModal')).show();
        },
        edit(x) {
            if (document.getElementById('tId')) document.getElementById('tId').value = x.id;
            if (document.getElementById('tNombre')) document.getElementById('tNombre').value = x.nombre;
            if (document.getElementById('tFi')) document.getElementById('tFi').value = x.fecha_inicio;
            if (document.getElementById('tFf')) document.getElementById('tFf').value = x.fecha_fin;
            if (document.getElementById('tEmp')) {
                document.getElementById('tEmp').value = x.empresa_id;
                document.getElementById('tEmp').disabled = true;
            }

            new bootstrap.Modal(document.getElementById('tModal')).show();
        },
        async save(e) {
            e.preventDefault();

            let i = document.getElementById('tId')?.value || '',
                fi = document.getElementById('tFi')?.value || '',
                ff = document.getElementById('tFf')?.value || '';

            if (fi >= ff) return alert('Fecha inicio debe ser menor a fin.');

            let b = {
                nombre: document.getElementById('tNombre')?.value || '',
                fecha_inicio: fi,
                fecha_fin: ff
            };
            if (!i) b.empresa_id = document.getElementById('tEmp')?.value || '';

            await fetch(this.api + (i ? '/' + i : ''), {
                method: i ? 'PUT' : 'POST',
                body: JSON.stringify(b)
            });

            // Bootstrap nativo para ocultar la instancia actual del modal
            const modalEl = document.getElementById('tModal');
            if (modalEl) {
                bootstrap.Modal.getInstance(modalEl).hide();
            }
            $('#tTabla').bootstrapTable('refresh');
        },
        async del(i) {
            if (!confirm('¿Borrar?')) return;
            await fetch(this.api + '/' + i, {
                method: 'DELETE'
            });
            $('#tTabla').bootstrapTable('refresh');
        }
    };

    // Reemplazo de $(() => window.t.init()) -> Equivalente nativo a DOMContentLoaded
    document.addEventListener('DOMContentLoaded', () => window.t.init());
</script>