import { showErrorToast } from "../helpers/helpers.js";

const modal = new bootstrap.Modal(document.getElementById("modalAlimento"));
const tabla = $("#tablaAlimentos");

window.responseHandler = function (res) {
    return res.value ? res.data : [];
};

window.activoFormatter = (value) =>
    value ? '<span class="badge bg-success">Sí</span>' : '<span class="badge bg-danger">No</span>';

window.accionesFormatter = (_, row) => `
    <button class="btn btn-sm btn-warning" onclick="editar(${row.id})">Editar</button>
    <button class="btn btn-sm btn-danger" onclick="eliminar(${row.id})">Eliminar</button>
`;

document.getElementById("btnNuevoAlimento").addEventListener("click", () => {
    document.getElementById("formAlimento").reset();
    document.getElementById("alimento_id").value = "";
    modal.show();
});

document.getElementById("formAlimento").addEventListener("submit", async (e) => {
    e.preventDefault();

    const id = document.getElementById("alimento_id").value;
    const payload = {
        nombre: document.getElementById("nombre").value,
        tipo: document.getElementById("tipo").value,
        stock_minimo_kg: document.getElementById("stock_minimo_kg").value
    };

    try {
        const res = await fetch(BASE_URL + "api/alimentos" + (id ? `/${id}` : ""), {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });

        const response = await res.json();
        if (!response.value) throw response;

        Swal.fire("¡Éxito!", response.message, "success");
        modal.hide();
        tabla.bootstrapTable("refresh");
    } catch (xhr) {
        showErrorToast(xhr.responseJSON || xhr);
    }
});

window.editar = async (id) => {
    const res = await fetch(BASE_URL + `api/alimentos/${id}`);
    const response = await res.json();
    if (!response.value) return showErrorToast(response);

    const a = response.data;
    document.getElementById("alimento_id").value = a.id;
    document.getElementById("nombre").value = a.nombre;
    document.getElementById("tipo").value = a.tipo;
    document.getElementById("stock_minimo_kg").value = a.stock_minimo_kg;

    modal.show();
};

window.eliminar = async (id) => {
    if (!(await Swal.fire({ title: "¿Eliminar?", showCancelButton: true })).isConfirmed) return;

    const res = await fetch(BASE_URL + `api/alimentos/${id}`, { method: "DELETE" });
    const response = await res.json();

    response.value
        ? Swal.fire("¡Éxito!", response.message, "success")
        : showErrorToast(response);

    tabla.bootstrapTable("refresh");
};

// Lógica para registrar ingreso
const modalIngreso = new bootstrap.Modal(document.getElementById("modalIngreso"));
const ingresoForm = document.getElementById("formIngreso");
const ingresoSelect = document.getElementById("ingreso_alimento_id");

document.getElementById("btnRegistrarIngreso").addEventListener("click", async () => {
    ingresoForm.reset();
    
    // Cargar alimentos en el select
    try {
        ingresoSelect.innerHTML = '<option value="">Cargando...</option>';
        const res = await fetch(BASE_URL + "api/alimentos");
        const response = await res.json();
        
        const alimentos = response.value ? response.data : [];
        
        let options = '<option value="">Seleccione...</option>';
        alimentos.forEach(a => {
            options += `<option value="${a.id}">${a.nombre} (Stock: ${a.stock_kg} kg)</option>`;
        });
        ingresoSelect.innerHTML = options;
        
        modalIngreso.show();
    } catch (e) {
        showErrorToast("Error al cargar alimentos: " + e.message);
    }
});

ingresoForm.addEventListener("submit", async (e) => {
    e.preventDefault();
    
    const alimentoId = ingresoSelect.value;
    const cantidad = parseFloat(document.getElementById("ingreso_cantidad").value);

    if (!alimentoId) return showErrorToast("Seleccione un alimento");
    if (isNaN(cantidad) || cantidad < 1) return showErrorToast("La cantidad debe ser mayor o igual a 1");

    try {
        const res = await fetch(BASE_URL + "api/alimentos/ingreso", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                alimento_id: alimentoId,
                cantidad_kg: cantidad
            })
        });

        const response = await res.json();
        if (!response.value) throw response;

        Swal.fire("¡Éxito!", response.message, "success");
        modalIngreso.hide();
        tabla.bootstrapTable("refresh");
    } catch (xhr) {
        showErrorToast(xhr.responseJSON || xhr);
    }
});
