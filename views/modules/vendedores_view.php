<div class="container-fluid">
    <div class="row"><div class="col-12"><div class="page-title-box d-flex justify-content-between align-items-center">
        <h4 class="page-title">Vendedores</h4>
        <button class="btn btn-primary" onclick="window.v.add()">+ Nuevo</button>
    </div></div></div>
    
    <div class="card"><div class="card-body">
        <table id="vTabla" class="table table-hover" data-toggle="table" data-url="<?= BASE_URL ?>api/vendedores" data-response-handler="window.v.resp" data-search="true" data-pagination="true" data-page-size="15">
            <thead><tr>
                <th data-field="nombre" data-sortable="true">Nombre</th>
                <th data-field="cedula" data-sortable="true">Cédula</th>
                <th data-field="telefono" data-sortable="true">Teléfono</th>
                <th data-field="nivel" data-sortable="true" data-formatter="window.v.fNivel">Nivel</th>
                <th data-formatter="window.v.fAcc" data-align="center">Acciones</th>
            </tr></thead>
        </table>
    </div></div>
</div>

<div class="modal fade" id="vModal" tabindex="-1"><div class="modal-dialog"><div class="modal-content">
    <form id="vForm" onsubmit="window.v.save(event)">
        <div class="modal-header"><h5 class="modal-title">Vendedor</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <div class="modal-body">
            <input type="hidden" id="vId">
            <div class="mb-2">
                <label for="vNombre" class="form-label">Nombre</label>
                <input class="form-control" id="vNombre" placeholder="Nombre completo" required>
            </div>
            <div class="mb-2">
                <label for="vCedula" class="form-label">Cédula</label>
                <input class="form-control" id="vCedula" placeholder="Cédula de identidad" required>
            </div>
            <div class="mb-2">
                <label for="vTelefono" class="form-label">Teléfono</label>
                <input class="form-control" id="vTelefono" placeholder="Teléfono">
            </div>
            <div class="mb-2">
                <label for="vNivel" class="form-label">Nivel</label>
                <select class="form-control" id="vNivel" required>
                    <option value="1">1 - Inicial</option>
                    <option value="2">2 - Básico</option>
                    <option value="3">3 - Intermedio</option>
                    <option value="4">4 - Avanzado</option>
                </select>
            </div>
        </div>
        <div class="modal-footer"><button type="submit" class="btn btn-primary">Guardar</button></div>
    </form>
</div></div></div>

<script>
window.v = {
    api: '<?= BASE_URL ?>api/vendedores',
    resp: (res) => ({ rows: res.data || [], total: res.data?.length || 0 }),
    fNivel: (v) => `<span class="badge bg-secondary">Nivel ${v}</span>`,
    fAcc: (val, x) => {
        let xJ = JSON.stringify(x).replace(/'/g, "&apos;");
        return `<button class="btn btn-sm btn-info" onclick='window.v.edit(${xJ})'>Editar</button>
                <button class="btn btn-sm btn-danger" onclick="window.v.del('${x.id}')">Borrar</button>`;
    },
    add() {
        document.getElementById('vForm').reset();
        document.getElementById('vId').value = '';
        new bootstrap.Modal(document.getElementById('vModal')).show();
    },
    edit(x) {
        document.getElementById('vId').value = x.id;
        document.getElementById('vNombre').value = x.nombre;
        document.getElementById('vCedula').value = x.cedula;
        document.getElementById('vTelefono').value = x.telefono;
        document.getElementById('vNivel').value = x.nivel;
        new bootstrap.Modal(document.getElementById('vModal')).show();
    },
    async save(e) {
        e.preventDefault();
        let i = document.getElementById('vId').value;
        let b = {
            nombre: document.getElementById('vNombre').value,
            cedula: document.getElementById('vCedula').value,
            telefono: document.getElementById('vTelefono').value,
            nivel: document.getElementById('vNivel').value
        };
        await fetch(this.api+(i?'/'+i:''), {
            method: 'POST', 
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(b)
        });
        bootstrap.Modal.getInstance(document.getElementById('vModal')).hide();
        $('#vTabla').bootstrapTable('refresh');
    },
    async del(i) {
        if(!confirm('¿Borrar?')) return;
        await fetch(this.api+'/'+i, {method:'DELETE'});
        $('#vTabla').bootstrapTable('refresh');
    }
};
</script>
