import { showErrorToast } from "../helpers/helpers.js";

window.accionesFormatter = function (_, row) {
    return `
        <button class="btn btn-sm btn-primary"
            onclick="verDetalle('${row.created_at}')">
            Ver detalle
        </button>
    `;
};

window.responseHandler = function (res) {
    if (!res || res.value !== true) {
        return [];
    }
    return res.data;
};

window.verDetalle = async function (createdAt) {
    try {
        const res = await fetch(`${BASE_URL}api/beneficios/${createdAt}`);
        const json = await res.json();

        console.log(json)
        if (!json.value) throw json;

        const tbody = document.getElementById('detalleBeneficioBody');
        tbody.innerHTML = '';

        json.data.forEach(a => {
            tbody.innerHTML += `
                <tr>
                    <td>${a.identificador}</td>
                    <td>${a.especie}</td>
                    <td>${a.sexo}</td>
                    <td>${a.ultimo_peso}</td>
                </tr>
            `;
        });

        new bootstrap.Modal('#modalDetalleBeneficio').show();

    } catch (e) {
        showErrorToast(e);
    }
};

// Gráfico
(async function cargarGrafico() {
    try {
        const res = await fetch(`${BASE_URL}api/beneficios/grafico/resumen`);
        const json = await res.json();
        if (!json.value) throw json;

        const meses = json.data.map(d => d.mes);
        const kg = json.data.map(d => parseFloat(d.kg));
        const ingreso = json.data.map(d => parseFloat(d.ingreso));

        const options = {
            chart: { type: 'bar', height: 350 },
            series: [
                { name: 'Kilogramos', data: kg },
                { name: 'Ingresos', data: ingreso }
            ],
            xaxis: { categories: meses }
        };

        new ApexCharts(
            document.querySelector("#graficoBeneficios"),
            options
        ).render();

    } catch (e) {
        showErrorToast(e);
    }
})();
