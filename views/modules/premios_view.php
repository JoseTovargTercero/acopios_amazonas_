<div class="container-fluid">
    <div class="row"><div class="col-12"><div class="page-title-box d-flex justify-content-between align-items-center">
        <h4 class="page-title">Premios</h4>
        <button class="btn btn-primary" onclick="window.p.add()">+ Nuevo</button>
    </div></div></div>
    
    <div class="card"><div class="card-body">
        <table id="pTabla" class="table table-hover" data-toggle="table" data-url="<?= BASE_URL ?>api/premios" data-response-handler="window.p.resp" data-search="true" data-pagination="true" data-page-size="15">
            <thead><tr>
                <th data-field="foto" data-formatter="window.p.fFoto">Foto</th>
                <th data-field="nombre" data-sortable="true">Nombre</th>
                <th data-field="valor" data-sortable="true" data-formatter="window.p.fVal">Valor</th>
                <th data-field="empresa_nombre" data-sortable="true">Empresa</th>
                <th data-formatter="window.p.fAcc">Acciones</th>
            </tr></thead>
        </table>
    </div></div>
</div>

<div class="modal fade" id="pModal" tabindex="-1"><div class="modal-dialog"><div class="modal-content">
    <form id="pForm" onsubmit="window.p.save(event)">
        <div class="modal-header"><h5 class="modal-title">Premio</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <div class="modal-body">
            <input type="hidden" id="pId">
            <input type="hidden" id="pFotoActual">
            
            <div class="mb-2">
                <label for="pEmp" class="form-label">Empresa</label>
                <select class="form-control" id="pEmp" required><option value="">Empresa...</option></select>
            </div>
            <div class="mb-2">
                <label for="pNombre" class="form-label">Nombre</label>
                <input class="form-control" id="pNombre" placeholder="Nombre del premio" required>
            </div>
            <div class="mb-2">
                <label for="pFoto" class="form-label">Foto</label>
                <input type="file" class="form-control" id="pFoto" accept="image/*">
            </div>
            <div class="mb-2">
                <label for="pValor" class="form-label">Valor</label>
                <input type="number" step="0.01" class="form-control" id="pValor" placeholder="0.00" required>
            </div>
        </div>
        <div class="modal-footer"><button type="submit" class="btn btn-primary">Guardar</button></div>
    </form>
</div></div></div>

<script>
window.p = {
    api: '<?= BASE_URL ?>api/premios',
    apiE: '<?= BASE_URL ?>api/empresas',
    emps: [],
    resp: (res) => ({ rows: res.data || [], total: res.data?.length || 0 }),
    fFoto: (v) => v ? `<img src="<?= BASE_URL ?>${v}" width="50">` : 'Sin foto',
    fVal: (v) => `$${v}`,
    fAcc: (v, x) => {
        let xJ = JSON.stringify(x).replace(/'/g, "&apos;");
        return `<button class="btn btn-sm btn-info" onclick='window.p.edit(${xJ})'>Editar</button>
                <button class="btn btn-sm btn-danger" onclick="window.p.del('${x.id}')">Borrar</button>`;
    },
    init() {
        fetch(this.apiE).then(r=>r.json()).then(d=>{
            this.emps=d.data||[];
            let s = '<option value="">Empresa...</option>';
            this.emps.forEach(e => s += `<option value="${e.id}">${e.nombre}</option>`);
            document.getElementById('pEmp').innerHTML = s;
        });
    },
    add() {
        document.getElementById('pForm').reset();
        document.getElementById('pId').value = '';
        document.getElementById('pFotoActual').value = '';
        document.getElementById('pEmp').disabled = false;
        new bootstrap.Modal(document.getElementById('pModal')).show();
    },
    edit(x) {
        document.getElementById('pId').value = x.id;
        document.getElementById('pFotoActual').value = x.foto;
        document.getElementById('pEmp').value = x.empresa_id;
        document.getElementById('pEmp').disabled = true;
        document.getElementById('pNombre').value = x.nombre;
        document.getElementById('pFoto').value = '';
        document.getElementById('pValor').value = x.valor;
        new bootstrap.Modal(document.getElementById('pModal')).show();
    },
    async save(e) {
        e.preventDefault();
        let i = document.getElementById('pId').value;
        let fd = new FormData();
        fd.append('nombre', document.getElementById('pNombre').value);
        fd.append('valor', document.getElementById('pValor').value);
        fd.append('foto_actual', document.getElementById('pFotoActual').value);
        if(!i) fd.append('empresa_id', document.getElementById('pEmp').value);
        let f = document.getElementById('pFoto').files[0];
        if(f) fd.append('foto', f);

        await fetch(this.api+(i?'/'+i:''), {method:'POST', body:fd});
        bootstrap.Modal.getInstance(document.getElementById('pModal')).hide();
        $('#pTabla').bootstrapTable('refresh');
    },
    async del(i) {
        if(!confirm('¿Borrar?')) return;
        await fetch(this.api+'/'+i, {method:'DELETE'});
        $('#pTabla').bootstrapTable('refresh');
    }
};
document.addEventListener('DOMContentLoaded', () => window.p.init());
</script>
