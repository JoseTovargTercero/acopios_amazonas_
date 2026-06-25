<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="page-title-box d-flex justify-content-between align-items-center">
                <h4 class="page-title">Colecciones y Combos</h4>
                <button class="btn btn-primary" onclick="window.c.add()">+ Nuevo</button>
            </div>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <table id="cTabla" class="table table-hover" data-toggle="table" data-url="<?= BASE_URL ?>api/colecciones" data-response-handler="window.c.resp" data-search="true" data-pagination="true" data-page-size="15">
                <thead>
                    <tr>
                        <th data-field="foto" data-formatter="window.c.fFoto">Foto</th>
                        <th data-field="nombre" data-sortable="true">Nombre</th>
                        <th data-field="tipo" data-sortable="true">Tipo</th>
                        <th data-field="precio_base" data-sortable="true" data-formatter="window.c.fVal">Precio Base</th>
                        <th data-field="precio_venta_vendedor" data-sortable="true" data-formatter="window.c.fValV">Precio Vendedor</th>
                        <th data-field="ganancia_vendedor" data-sortable="true" data-formatter="window.c.fVal">Ganancia Vendedor</th>
                        <th data-field="empresa_id" data-sortable="true" data-formatter="window.c.fEmp">Empresa</th>
                        <th data-formatter="window.c.fAcc">Acciones</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="cModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="cForm" onsubmit="window.c.save(event)">
                <div class="modal-header">
                    <h5 class="modal-title">Colección/Combo</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="cNombre" class="form-label">Nombre</label>
                        <input class="form-control mb-2" id="cNombre" placeholder="Nombre" required>
                    </div>

                    <div class="mb-3">
                        <label for="cFoto" class="form-label">Foto</label>
                        <input type="file" class="form-control mb-2" id="cFoto" accept="image/*">
                        <input type="hidden" id="cFotoActual">
                    </div>

                    <div class="mb-3">
                        <label for="cTipo" class="form-label">Tipo</label>
                        <select class="form-control mb-2" id="cTipo" onchange="window.c.tg()" required>
                            <option value="coleccion">Colección</option>
                            <option value="combo">Combo</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="cPb" class="form-label">Precio de la empresa</label>
                        <input type="number" step="0.01" class="form-control mb-2" id="cPb" placeholder="Precio Base" required>
                    </div>

                    <div class="mb-3">
                        <label for="cPvv" class="form-label">Precio al entregar al vendedor</label>
                        <input type="number" step="0.01" class="form-control mb-2" id="cPvv" placeholder="Precio Venta Vendedor">
                    </div>

                    <div class="mb-3">
                        <label for="cGv" class="form-label">Ganancia del vendedor</label>
                        <input type="number" step="0.01" class="form-control mb-2" id="cGv" placeholder="Ganancia Vendedor">
                    </div>
                    <div class="mb-3">
                        <label for="cEmp" class="form-label">Empresa</label>
                        <select class="form-control mb-2" id="cEmp" required>
                            <option value="">Empresa...</option>
                        </select>
                    </div>
                    <input type="hidden" id="cId">
                </div>
                <div class="modal-footer"><button type="submit" class="btn btn-primary">Guardar</button></div>
            </form>
        </div>
    </div>
</div>

<script>
    window.c = {
        api: '<?= BASE_URL ?>api/colecciones',
        apiE: '<?= BASE_URL ?>api/empresas',
        emps: [],
        resp: (res) => ({
            rows: res.data || [],
            total: res.data?.length || 0
        }),
        fFoto: (v) => v ? `<img src="<?= BASE_URL ?>${v}" width="50">` : 'Sin foto',
        fVal: (v) => `$${v}`,
        fValV: (v, x) => `$${x.tipo=='combo'?x.precio_base:v}`,
        fEmp: (v) => window.c.emps.find(e => e.id == v)?.nombre || '',
        fAcc: (v, x) => {
            let xJ = JSON.stringify(x).replace(/'/g, "&apos;");
            return `<button class="btn btn-sm btn-info" onclick='window.c.edit(${xJ})'>Editar</button>
                    <button class="btn btn-sm btn-danger" onclick="window.c.del('${x.id}')">Borrar</button>`;
        },
        init() {
            fetch('<?= BASE_URL ?>').then(r => r.json()).then(d => {
                this.emps = d.data || [];
                $('#cEmp').html('<option value="">Seleccione...</option>' + this.emps.map(e => `<option value="${e.id}">${e.nombre}</option>`).join(''));
            });
        },
        tg() {

            if (cTipo && cPvv) {
                let t = cTipo.value == 'combo';
                cPvv.style.display = !t ? '' : 'none';
                if (t) cPvv.value = '';
            }
        },
        add() {
            const cForm = document.getElementById('cForm');
            if (cForm) cForm.reset();

            if (document.getElementById('cId')) document.getElementById('cId').value = '';
            if (document.getElementById('cFotoActual')) document.getElementById('cFotoActual').value = '';

            const cEmp = document.getElementById('cEmp');
            if (cEmp) cEmp.disabled = false;

            this.tg();
            new bootstrap.Modal(document.getElementById('cModal')).show();
        },
        edit(x) {
            if (document.getElementById('cId')) document.getElementById('cId').value = x.id;
            if (document.getElementById('cFotoActual')) document.getElementById('cFotoActual').value = x.foto;

            const cEmp = document.getElementById('cEmp');
            if (cEmp) {
                cEmp.value = x.empresa_id;
                cEmp.disabled = true;
            }

            if (document.getElementById('cNombre')) document.getElementById('cNombre').value = x.nombre;
            if (document.getElementById('cTipo')) document.getElementById('cTipo').value = x.tipo;
            if (document.getElementById('cFoto')) document.getElementById('cFoto').value = '';
            if (document.getElementById('cPb')) document.getElementById('cPb').value = x.precio_base;
            if (document.getElementById('cPvv')) document.getElementById('cPvv').value = x.precio_venta_vendedor;
            if (document.getElementById('cGv')) document.getElementById('cGv').value = x.ganancia_vendedor;

            this.tg();
            new bootstrap.Modal(document.getElementById('cModal')).show();
        },
        async save(e) {
            e.preventDefault();

            let i = document.getElementById('cId')?.value || '',
                t = document.getElementById('cTipo')?.value || '';

            let fd = new FormData();
            fd.append('nombre', document.getElementById('cNombre')?.value || '');
            fd.append('tipo', t);
            fd.append('precio_base', document.getElementById('cPb')?.value || '');
            fd.append('ganancia_vendedor', document.getElementById('cGv')?.value || '');
            fd.append('precio_venta_vendedor', t == 'combo' ? (document.getElementById('cPb')?.value || '') : (document.getElementById('cPvv')?.value || ''));
            fd.append('foto_actual', document.getElementById('cFotoActual')?.value || '');

            if (!i) {
                fd.append('empresa_id', document.getElementById('cEmp')?.value || '');
            }

            // Reemplazo nativo de $('#cFoto')[0].files[0]
            const cFotoInput = document.getElementById('cFoto');
            if (cFotoInput && cFotoInput.files && cFotoInput.files[0]) {
                fd.append('foto', cFotoInput.files[0]);
            }

            // Se mantiene POST ya que viaja un archivo vía FormData
            await fetch(this.api + (i ? '/' + i : ''), {
                method: 'POST',
                body: fd
            });

            const modalEl = document.getElementById('cModal');
            if (modalEl) {
                bootstrap.Modal.getInstance(modalEl).hide();
            }
            this.load();
        },
        async del(i) {
            if (!confirm('¿Borrar?')) return;
            await fetch(this.api + '/' + i, {
                method: 'DELETE'
            });
            this.load();
        }
    };

    document.addEventListener('DOMContentLoaded', () => window.c.init());
</script>