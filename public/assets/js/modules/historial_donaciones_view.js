import { showErrorToast } from '../helpers/helpers.js';

document.addEventListener('DOMContentLoaded', () => {
    const loader = document.getElementById('loader');
    const noData = document.getElementById('noData');
    const accordion = document.getElementById('accordionDonaciones');
    const btnExportarExcel = document.getElementById('btnExportarExcel');
    
    let donacionesData = [];

    // Formateador de fechas
    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        const d = new Date(dateString);
        return d.toLocaleDateString('es-ES', { 
            year: 'numeric', month: 'short', day: 'numeric',
            hour: '2-digit', minute:'2-digit'
        });
    };

    // Función para renderizar el historial
    const renderHistorial = (donaciones) => {
        loader.classList.add('d-none');
        donacionesData = donaciones;

        if (!donaciones || donaciones.length === 0) {
            noData.classList.remove('d-none');
            if (btnExportarExcel) btnExportarExcel.classList.add('d-none');
            return;
        }

        if (btnExportarExcel) btnExportarExcel.classList.remove('d-none');
        accordion.classList.remove('d-none');
        accordion.innerHTML = '';

        donaciones.forEach((don, index) => {
            const collapseId = `collapseDonacion${don.id_donacion}`;
            const headerId = `headingDonacion${don.id_donacion}`;
            const numInsumos = don.insumos ? don.insumos.length : 0;
            const guiaTxt = don.numero_guia_remision || 'Sin Guía';

            let insumosRows = '';
            if (numInsumos > 0) {
                don.insumos.forEach(ins => {
                    const esCaja = ins.presentacion === 'caja';
                    const numCajas = esCaja ? parseInt(ins.unidades_por_presentacion || 1) : 1;
                    const pTotal = (parseFloat(ins.peso_por_unidad || 0) * numCajas) * parseFloat(ins.cantidad_recibida || 0);

                    insumosRows += `
                        <tr>
                            <td>${ins.categoria}</td>
                            <td>${ins.descripcion_insumo}</td>
                            <td class="text-capitalize">${ins.presentacion}</td>
                            <td class="text-center">${ins.cantidad_manifestada}</td>
                            <td class="text-center">${ins.cantidad_recibida}</td>
                            <td class="text-center">${ins.fecha_vencimiento || 'N/A'}</td>
                            <td class="text-end">${pTotal.toFixed(2)}</td>
                            <td><span class="badge bg-info">${ins.estado}</span></td>
                        </tr>
                    `;
                });
            } else {
                insumosRows = `<tr><td colspan="8" class="text-center text-muted">No se registraron insumos</td></tr>`;
            }

            const html = `
                <div class="card mb-2 border">
                    <div class="card-header" id="${headerId}">
                        <h5 class="m-0">
                            <a class="custom-accordion-title d-block py-1 collapsed" data-bs-toggle="collapse" href="#${collapseId}" aria-expanded="false" aria-controls="${collapseId}">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <i class="mdi mdi-gift text-primary me-2 fs-4"></i>
                                        <strong>Donante:</strong> ${don.organizacion_donante} <br>
                                        <small class="text-muted"><i class="mdi mdi-calendar"></i> Llegada: ${formatDate(don.fecha_hora_llegada)}</small>
                                    </div>
                                    <div class="text-end">
                                        <span class="badge bg-secondary mb-1">Guía: ${guiaTxt}</span><br>
                                        <span class="badge bg-success">${numInsumos} insumo(s)</span>
                                    </div>
                                    <i class="mdi mdi-chevron-down accordion-arrow"></i>
                                </div>
                            </a>
                        </h5>
                    </div>

                    <div id="${collapseId}" class="collapse" aria-labelledby="${headerId}" data-bs-parent="#accordionDonaciones">
                        <div class="card-body bg-light">
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Transportista:</strong> ${don.nombre_transportista || 'N/A'}</p>
                                    <p class="mb-1"><strong>Placa:</strong> ${don.placa_vehiculo || 'N/A'}</p>
                                </div>
                                <div class="col-md-6">
                                    <p class="mb-1"><strong>Fecha Registro:</strong> ${formatDate(don.created_at)}</p>
                                    <p class="mb-1"><strong>ID Sistema:</strong> #${don.id_donacion}</p>
                                </div>
                            </div>

                            <h6 class="text-uppercase fw-bold"><i class="mdi mdi-format-list-bulleted me-1"></i> Detalle de Insumos Recibidos</h6>
                            <div class="table-responsive">
                                <table class="table table-sm table-bordered table-striped bg-white mb-0">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Categoría</th>
                                            <th>Descripción</th>
                                            <th>Present.</th>
                                            <th class="text-center">Manif.</th>
                                            <th class="text-center">Recib.</th>
                                            <th class="text-center">Vencimiento</th>
                                            <th class="text-end">Peso Calc (Kg)</th>
                                            <th>Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        ${insumosRows}
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </div>
            `;
            accordion.insertAdjacentHTML('beforeend', html);
        });
    };

    // Petición AJAX para obtener las donaciones
    const fetchDonaciones = () => {
        $.ajax({
            url: baseUrl + 'api/donaciones',
            method: 'GET',
            success: function(response) {
                if (response.value) {
                    renderHistorial(response.data);
                } else {
                    showErrorToast(response);
                    loader.innerHTML = `<p class="text-danger mt-3">Error: ${response.message}</p>`;
                }
            },
            error: function(xhr) {
                showErrorToast(xhr.responseJSON || { message: "Error al cargar historial" });
                loader.innerHTML = `<p class="text-danger mt-3">Ocurrió un error al cargar el historial.</p>`;
            }
        });
    };

    fetchDonaciones();

    // Exportar a Excel (Usando SheetJS)
    if (btnExportarExcel) {
        btnExportarExcel.addEventListener('click', () => {
            if (donacionesData.length === 0) return;

            const excelData = [];

            donacionesData.forEach(don => {
                const id = don.id_donacion;
                const fecha = don.fecha_hora_llegada || '';
                const donante = don.organizacion_donante || '';
                const transp = don.nombre_transportista || '';
                const placa = don.placa_vehiculo || '';
                const guia = don.numero_guia_remision || '';

                if (don.insumos && don.insumos.length > 0) {
                    don.insumos.forEach(ins => {
                        const esCaja = ins.presentacion === 'caja';
                        const numCajas = esCaja ? parseInt(ins.unidades_por_presentacion || 1) : 1;
                        const pTotal = (parseFloat(ins.peso_por_unidad || 0) * numCajas) * parseFloat(ins.cantidad_recibida || 0);

                        excelData.push({
                            "ID Sistema": id,
                            "Fecha Llegada": fecha,
                            "Donante": donante,
                            "Transportista": transp,
                            "Placa Vehículo": placa,
                            "Guía Remisión": guia,
                            "Categoría Insumo": ins.categoria || '',
                            "Descripción Insumo": ins.descripcion_insumo || '',
                            "Presentación": ins.presentacion || '',
                            "Cant. Manifestada": ins.cantidad_manifestada || 0,
                            "Cant. Recibida": ins.cantidad_recibida || 0,
                            "Fecha Vencimiento": ins.fecha_vencimiento || '',
                            "Peso Calc": parseFloat(pTotal.toFixed(2)),
                            "Estado": ins.estado || ''
                        });
                    });
                } else {
                    excelData.push({
                        "ID Sistema": id,
                        "Fecha Llegada": fecha,
                        "Donante": donante,
                        "Transportista": transp,
                        "Placa Vehículo": placa,
                        "Guía Remisión": guia,
                        "Categoría Insumo": "Sin insumos registrados",
                        "Descripción Insumo": "",
                        "Presentación": "",
                        "Cant. Manifestada": "",
                        "Cant. Recibida": "",
                        "Fecha Vencimiento": "",
                        "Peso Calc": "",
                        "Estado": ""
                    });
                }
            });

            // Crear Worksheet y Workbook de SheetJS
            const worksheet = XLSX.utils.json_to_sheet(excelData);
            
            // Auto-ajustar ancho de las columnas (wch = Width Characters)
            const columnWidths = [
                { wch: 12 }, // ID Sistema
                { wch: 18 }, // Fecha Llegada
                { wch: 35 }, // Donante
                { wch: 25 }, // Transportista
                { wch: 15 }, // Placa
                { wch: 20 }, // Guia
                { wch: 25 }, // Categoría
                { wch: 40 }, // Descripción
                { wch: 15 }, // Presentación
                { wch: 18 }, // Manifestada
                { wch: 15 }, // Recibida
                { wch: 18 }, // Vencimiento
                { wch: 15 }, // Peso Calc
                { wch: 20 }  // Estado
            ];
            worksheet['!cols'] = columnWidths;

            const workbook = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(workbook, worksheet, "Historial Donaciones");

            // Generar archivo real .xlsx y forzar descarga
            XLSX.writeFile(workbook, `Historial_Donaciones_${new Date().toISOString().slice(0,10)}.xlsx`);
        });
    }
});
