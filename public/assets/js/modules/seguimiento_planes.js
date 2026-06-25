import { showErrorToast } from "../helpers/helpers.js";

const modal = new bootstrap.Modal(document.getElementById("modalPlan"));
const tabla = $("#tablaPlanes");

window.responseHandler = res => res.value ? res.data : [];

window.activoFormatter = v =>
    v ? '<span class="badge bg-success">Sí</span>' : '<span class="badge bg-danger">No</span>';

window.accionesFormatter = (_, row) => `
    <button class="btn btn-sm btn-danger" onclick="eliminar(${row.id})">Eliminar</button>
`;

document.getElementById("btnNuevoPlan").onclick = () => {
    document.getElementById("formPlan").reset();
    document.getElementById("detallePlan").innerHTML = "";
    document.getElementById("plan_id").value = "";
    cargarUbicaciones();
    modal.show();
};

document.getElementById("btnAgregarHorario").onclick = () => {
    document.getElementById("detallePlan").insertAdjacentHTML("beforeend", `
        <div class="row mb-2 detalle">
            <div class="col-md-4">
                <input type="time" class="form-control hora" required>
            </div>
            <div class="col-md-4">
                <select class="form-select alimento_id"></select>
            </div>
            <div class="col-md-3">
                <input type="number" step="0.01" class="form-control consumo" placeholder="Kg" required>
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-danger btn-sm btnEliminar">X</button>
            </div>
        </div>
    `);
    cargarAlimentos();
};

document.getElementById("detallePlan").addEventListener("click", e => {
    if (e.target.classList.contains("btnEliminar")) {
        e.target.closest(".detalle").remove();
    }
});

document.getElementById("formPlan").onsubmit = async e => {
    e.preventDefault();

    const detalles = [...document.querySelectorAll(".detalle")].map(d => ({
        hora: d.querySelector(".hora").value,
        alimento_id: d.querySelector(".alimento_id").value,
        consumo_diario_kg: d.querySelector(".consumo").value
    }));

    const payload = {
        ubicacion_id: ubicacion_id.value,
        nombre: nombre.value,
        observacion: observacion.value,
        cantidad_animales_estimados: cantidad_animales_estimados.value,
        detalles
    };

    try {
        const res = await fetch(BASE_URL + "api/alimentos_planes", {
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
};

async function cargarUbicaciones() {
    const res = await fetch(BASE_URL + "api/areas");
    const data = await res.json();
    ubicacion_id.innerHTML = data.data.map(a =>
        `<option value="${a.area_id}">${a.nombre_personalizado} - ${a.tipo_area}</option>`
    ).join("");
}

async function cargarAlimentos() {
    const res = await fetch(BASE_URL + "api/alimentos");
    const data = await res.json();
    document.querySelectorAll(".alimento_id").forEach(s => {
        s.innerHTML = data.data.map(a =>
            `<option value="${a.id}">${a.nombre}</option>`
        ).join("");
    });
}

window.ver = async function (id) {
    try {
        const res = await fetch(BASE_URL + "api/alimentos_planes/" + id);
        const response = await res.json();

        if (!response.value) throw response;

        const plan = response.data;

        let html = `
            <p><b>Ubicación:</b> ${plan.ubicacion_id}</p>
            <p><b>Animales estimados:</b> ${plan.cantidad_animales_estimados}</p>
            <hr>
        `;

        plan.detalles.forEach(d => {
            html += `
                <p>
                    <b>${d.hora}</b> - ${d.alimento} :
                    ${d.consumo_diario_kg} kg
                </p>
            `;
        });

        Swal.fire({
            title: plan.nombre || "Detalle del plan",
            html,
            width: 600
        });

    } catch (xhr) {
        showErrorToast(xhr.responseJSON || xhr);
    }
};
