import { showErrorToast } from "../helpers/helpers.js";

let planActual = null;

window.responseHandler = function (res) {
    return res.data ?? [];
};

window.accionesFormatter = function (_, row) {
    if (row.estado === 'APLICADO') {
        return '<span class="badge bg-success">Aplicado</span>';
    }

    return `
        <button class="btn btn-sm btn-primary"
            onclick="registrarManual('${row.plan_id}', ${row.ubicacion_id})">
            Registrar
        </button>
    `;
};
let modalRegistroPlan = null;

window.registrarManual = async function (planId, ubicacionId) {
    planActual = { planId, ubicacionId };
    // elimina el modal activo antes de mostrar el nuevo, no uses hide();

    try {
        const res = await fetch(
            `${BASE_URL}api/alimentos_consumo/plan/${planId}`
        );

        const json = await res.json();

        if (!json.value) throw json;

        const data = json.data;

        // Info general del plan
        document.getElementById('detallePlanNombre').textContent = data.nombre;
        document.getElementById('detallePlanUbicacion').textContent = data.ubicacion;
        document.getElementById('detallePlanFecha').textContent = data.fecha;

        const tbody = document.querySelector('#tablaDetallePlan tbody');
        tbody.innerHTML = '';

        data.horarios.forEach(h => {
            const estadoBadge = h.ejecutado
                ? `<span class="badge bg-success">Ejecutado</span>`
                : `<span class="badge bg-warning text-dark">Pendiente</span>`;

            const boton = h.ejecutado
                ? '-'
                : `
                    <button class="btn btn-sm btn-primary"
                        onclick="ejecutarHorario('${h.horario_id}')">
                        Ejecutar
                    </button>
                  `;

            tbody.innerHTML += `
                <tr>
                    <td>${h.hora}</td>
                    <td>${h.cantidad}</td>
                    <td>${estadoBadge}</td>
                    <td class="text-center">${boton}</td>
                </tr>
            `;
        });

         const modalEl = document.getElementById('modalRegistroPlan');

        // ✅ Crear instancia SOLO si no existe
        if (!modalRegistroPlan) {
            modalRegistroPlan = new bootstrap.Modal(modalEl);
        }

        // ✅ Mostrar solo si no está abierto
        if (!modalEl.classList.contains('show')) {
            modalRegistroPlan.show();
        }

    } catch (e) {
        showErrorToast(e.message || 'Error al cargar detalle del plan');
    }
};

document.getElementById('modalRegistroPlan')
    .addEventListener('hidden.bs.modal', () => {
        document.body.classList.remove('modal-open');
        document.querySelectorAll('.modal-backdrop')
            .forEach(b => b.remove());
    });

/**
 * Ejecutar un horario puntual
 */
window.ejecutarHorario = async function (horarioId) {
    try {
       const res = await fetch(
            `${BASE_URL}api/alimentos_consumo/ejecutar-horario` +
            `?plan_id=${planActual.planId}&horario_id=${horarioId}`
        );

        const json = await res.json();

        if (!json.value) throw json;

        // 🔁 Refrescar el modal sin cerrarlo
        await registrarManual(
            planActual.planId,
            planActual.ubicacionId
        );

    } catch (e) {
        showErrorToast(e.message || 'No se pudo ejecutar el horario');
    }
};


document.getElementById('btnConfirmarRegistro')
    .addEventListener('click', async () => {

        const consumos = [...document.querySelectorAll('.consumo')]
            .map(i => ({
                alimento_id: i.dataset.alimento,
                consumo_kg: parseFloat(i.value)
            }));

        try {
            const res = await fetch(
                `${BASE_URL}api/alimentos_consumo/registrar_manual`,
                {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        plan_id: planActual.planId,
                        ubicacion_id: planActual.ubicacionId,
                        consumos
                    })
                }
            );

            const json = await res.json();
            if (!json.value) throw json;

            Swal.fire("¡Éxito!", json.message, "success");
            bootstrap.Modal.getInstance(
                document.getElementById('modalRegistroPlan')
            ).hide();

            $('#tablaConsumo').bootstrapTable('refresh');

        } catch (e) {
            showErrorToast(e);
        }
    });

document.getElementById('btnRegistrarTodos')
    .addEventListener('click', async () => {
        try {
            const res = await fetch(
                `${BASE_URL}api/alimentos_consumo/registrar_todos`,
                { method: 'POST' }
            );
            const json = await res.json();

            if (!json.value) throw json;

            Swal.fire("¡Éxito!", json.message, "success");
            $('#tablaConsumo').bootstrapTable('refresh');

        } catch (e) {
            showErrorToast(e);
        }
    });
