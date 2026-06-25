// ponytail: un solo modal, un solo form, funciones reutilizables
const api  = (path) => `${baseUrl}api/${path}`;
const modal = () => bootstrap.Modal.getOrCreateInstance(document.getElementById('modalEmpresa'));

// ── Formatters para bootstrap-table ──────────────────────────────────────────
window.responseHandler = (res) => ({ rows: res.data ?? [], total: res.data?.length ?? 0 });

window.dateFormatter = (v) => v ? new Date(v).toLocaleDateString('es-VE') : '-';

window.accionesFormatter = (id, row) => {
  const rJ = JSON.stringify(row).replace(/'/g, "&apos;");
  return `
  <div class="btn-group btn-group-sm">
    <button class="btn btn-warning btn-editar" data-row='${rJ}' title="Editar">
      <i class="mdi mdi-pencil"></i>
    </button>
    <button class="btn btn-danger btn-eliminar" data-id="${id}" data-nombre="${row.nombre}" title="Eliminar">
      <i class="mdi mdi-delete"></i>
    </button>
  </div>`;
};

// ── Fetch helpers ─────────────────────────────────────────────────────────────
const fetchJSON = (url, opts = {}) =>
  fetch(url, { headers: { 'Content-Type': 'application/json' }, ...opts })
    .then(r => r.json());

const toast = (msg, ok = true) =>
  Swal.fire({ toast: true, position: 'top-end', icon: ok ? 'success' : 'error',
    title: msg, showConfirmButton: false, timer: 2500, timerProgressBar: true });

// ── Estado del modal ─────────────────────────────────────────────────────────
const renderCuotas = (cantidad, values = []) => {
  const container = document.getElementById('cuotasContainer');
  if(!container) return;
  container.innerHTML = '';
  for(let i=0; i<cantidad; i++) {
    const val = values[i] !== undefined ? values[i] : (100/cantidad).toFixed(2);
    container.innerHTML += `
    <div class="col-md-4 mb-2">
        <label class="form-label">Cuota ${i+1} (%)</label>
        <input type="number" step="0.01" min="0" max="100" class="form-control cuota-input" required value="${val}">
    </div>`;
  }
};

const abrirModal = (row = {}) => {
  document.getElementById('empresaId').value        = row.id || '';
  document.getElementById('empresaNombre').value    = row.nombre || '';
  document.getElementById('empresaTelefono').value  = row.telefono || '';
  document.getElementById('empresaCuotas').value    = row.cantidad_cuotas || '';
  renderCuotas(row.cantidad_cuotas || 0, row.cuotas || []);
  document.getElementById('modalEmpresaLabel').textContent = row.id ? 'Editar Empresa' : 'Nueva Empresa';
  modal().show();
};

// ── Init ──────────────────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  // Abrir modal vacío
  document.getElementById('btnNuevaEmpresa').addEventListener('click', () => abrirModal());

  // Delegación de eventos para editar / eliminar
  document.getElementById('tablaEmpresas').addEventListener('click', (e) => {
    const editar   = e.target.closest('.btn-editar');
    const eliminar = e.target.closest('.btn-eliminar');

    if (editar) {
      const row = JSON.parse(editar.getAttribute('data-row'));
      abrirModal(row);
    }

    if (eliminar) {
      const { id, nombre } = eliminar.dataset;
      Swal.fire({
        title: `¿Eliminar "${nombre}"?`,
        text: 'Esta acción no se puede deshacer.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar',
        confirmButtonColor: '#d33',
      }).then(({ isConfirmed }) => {
        if (!isConfirmed) return;
        fetchJSON(api(`empresas/${id}`), { method: 'DELETE' })
          .then(r => {
            toast(r.message, r.value);
            if (r.value) $('#tablaEmpresas').bootstrapTable('refresh');
          });
      });
    }
  });

  // Validar cuotas dinámicas y renderizar
  const inputCuotas = document.getElementById('empresaCuotas');
  if (inputCuotas) {
    inputCuotas.addEventListener('input', (e) => {
      renderCuotas(parseInt(e.target.value) || 0);
    });
  }

  // Submit form (crear / actualizar)
  document.getElementById('formEmpresa').addEventListener('submit', (e) => {
    e.preventDefault();
    const id       = document.getElementById('empresaId').value;
    
    // Recoger cuotas
    const cuotasInputs = document.querySelectorAll('.cuota-input');
    const cuotas = Array.from(cuotasInputs).map(inp => parseFloat(inp.value));

    // Validar suma = 100%
    if (cuotas.length > 0) {
      const suma = cuotas.reduce((a, b) => a + b, 0);
      if (Math.abs(suma - 100) > 0.1) {
        toast(`La suma de las cuotas debe ser 100%. Actual: ${suma.toFixed(2)}%`, false);
        return;
      }
    }

    const payload  = {
      nombre:   document.getElementById('empresaNombre').value.trim(),
      telefono: document.getElementById('empresaTelefono').value.trim(),
      cantidad_cuotas: parseInt(document.getElementById('empresaCuotas').value) || 0,
      cuotas: cuotas
    };
    const url    = id ? api(`empresas/${id}`) : api('empresas');
    const method = 'POST';

    fetchJSON(url, { method, body: JSON.stringify(payload) })
      .then(r => {
        toast(r.message, r.value);
        if (r.value) {
          modal().hide();
          $('#tablaEmpresas').bootstrapTable('refresh');
        }
      });
  });
});

