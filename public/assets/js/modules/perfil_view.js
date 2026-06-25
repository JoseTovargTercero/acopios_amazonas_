import { showErrorToast, Toast } from '../helpers/helpers.js';

document.addEventListener('DOMContentLoaded', () => {
    // Referencias a elementos
    const btnNextStep = document.getElementById('btnNextStep');
    const btnPrevStep = document.getElementById('btnPrevStep');
    const btnFinalizar = document.getElementById('btnFinalizar');
    const btnAddInsumo = document.getElementById('btnAddInsumo');
    const formDonacionWizard = document.getElementById('formDonacionWizard');
    const inputFechaHora = document.getElementById('fecha_hora_llegada');
    const tabStep2Link = document.getElementById('tabStep2');
    const tablaInsumos = document.getElementById('tablaInsumos');

    const selPresentacion = document.getElementById('ins_presentacion');
    const divSoloCaja = document.getElementById('solo_para_caja');
    const inputUnidades = document.getElementById('ins_unidades');
    const lblMan = document.getElementById('lbl-man');
    const lblRec = document.getElementById('lbl-rec');

    function actualizarLabels() {
        if (selPresentacion.value === 'caja') {
            lblMan.childNodes[0].textContent = 'Cajas Manifestadas ';
            lblRec.childNodes[0].textContent = 'Cajas Recibidas ';
            divSoloCaja.style.display = '';
        } else {
            lblMan.childNodes[0].textContent = 'Unidades Manifestadas ';
            lblRec.childNodes[0].textContent = 'Unidades Recibidas ';
            divSoloCaja.style.display = 'none';
            inputUnidades.value = '1';
        }
    }

    if (selPresentacion && divSoloCaja && inputUnidades && lblMan && lblRec) {
        actualizarLabels();
        selPresentacion.addEventListener('change', actualizarLabels);
    }

    let insumos = []; // Arreglo para almacenar los productos
    let dataDonacion = {}; // Datos del paso 1

    // Prellenar fecha al cargar la vista
    if (inputFechaHora && !inputFechaHora.value) {
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        inputFechaHora.value = now.toISOString().slice(0, 16);
    }

    // Helper para cambiar de pestaña en el wizard
    const switchTab = (targetId) => {
        const triggerEl = document.querySelector(`a[href="${targetId}"]`);
        if (triggerEl) {
            triggerEl.classList.remove('disabled');
            const tab = new bootstrap.Tab(triggerEl);
            tab.show();
        }
    };

    // Validación y paso al siguiente
    if (btnNextStep && formDonacionWizard) {
        btnNextStep.addEventListener('click', () => {
            if (!formDonacionWizard.checkValidity()) {
                formDonacionWizard.classList.add('was-validated');
                return;
            }
            
            // Recopilar datos del Paso 1
            const formData = new FormData(formDonacionWizard);
            dataDonacion = {
                fecha_hora_llegada: formData.get('fecha_hora_llegada'),
                numero_guia_remision: formData.get('numero_guia_remision'),
                organizacion_donante: formData.get('organizacion_donante'),
                nombre_transportista: formData.get('nombre_transportista'),
                placa_vehiculo: formData.get('placa_vehiculo')
            };

            switchTab('#step2');
        });
    }

    // Volver al paso anterior
    if (btnPrevStep) {
        btnPrevStep.addEventListener('click', () => {
            switchTab('#step1');
        });
    }

    // Renderizar la tabla de insumos en el Paso 2
    const renderTable = () => {
        if (insumos.length === 0) {
            tablaInsumos.innerHTML = `<tr><td colspan="7" class="text-center text-muted py-3">Aún no se han agregado insumos.</td></tr>`;
            btnFinalizar.disabled = true;
            return;
        }

        btnFinalizar.disabled = false;
        tablaInsumos.innerHTML = '';
        
        insumos.forEach((item, index) => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.categoria}</td>
                <td>${item.descripcion_insumo}</td>
                <td class="text-capitalize">${item.presentacion}</td>
                <td class="text-center">${item.cantidad_manifestada}</td>
                <td class="text-center">${item.cantidad_recibida}</td>
                <td>${item.estado}</td>
                <td class="text-center">
                    <button type="button" class="btn btn-sm btn-danger btn-delete-insumo" data-index="${index}">
                        <i class="mdi mdi-delete"></i>
                    </button>
                </td>
            `;
            tablaInsumos.appendChild(tr);
        });

        // Eventos para eliminar fila
        document.querySelectorAll('.btn-delete-insumo').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const idx = parseInt(e.currentTarget.getAttribute('data-index'));
                insumos.splice(idx, 1);
                renderTable();
            });
        });
    };

    // Agregar nuevo insumo al arreglo
    if (btnAddInsumo) {
        btnAddInsumo.addEventListener('click', () => {
            const categoria = document.getElementById('ins_categoria').value.trim();
            const descripcion = document.getElementById('ins_descripcion').value.trim();
            const presentacion = document.getElementById('ins_presentacion').value;
            const unidades = parseInt(document.getElementById('ins_unidades').value) || 1;
            const peso = parseFloat(document.getElementById('ins_peso').value) || 0.0;
            const vencimiento = document.getElementById('ins_vencimiento').value;
            const manifestada = parseInt(document.getElementById('ins_manifestada').value) || 0;
            const recibida = parseInt(document.getElementById('ins_recibida').value) || 0;
            const estado = document.getElementById('ins_estado').value.trim();

            if (!categoria || !descripcion || !estado) {
                showErrorToast({ message: "La categoría, descripción y estado son obligatorios." });
                return;
            }

            if (manifestada < 0 || recibida < 0) {
                showErrorToast({ message: "Las cantidades manifestadas o recibidas no pueden ser negativas." });
                return;
            }

            insumos.push({
                categoria,
                descripcion_insumo: descripcion,
                presentacion,
                unidades_por_presentacion: unidades,
                peso_por_unidad: peso,
                cantidad_manifestada: manifestada,
                cantidad_recibida: recibida,
                estado,
                fecha_vencimiento: vencimiento || null
            });

            // Limpiar inputs clave para carga ágil
            document.getElementById('ins_descripcion').value = '';
            document.getElementById('ins_manifestada').value = '1';
            document.getElementById('ins_recibida').value = '1';
            document.getElementById('ins_descripcion').focus();

            renderTable();
        });
    }

    // Finalizar proceso (POST al Backend)
    if (btnFinalizar) {
        btnFinalizar.addEventListener('click', () => {
            if (insumos.length === 0) return;

            const payload = {
                donacion: dataDonacion,
                insumos: insumos
            };

            btnFinalizar.disabled = true;
            btnFinalizar.innerHTML = `<span class="spinner-border spinner-border-sm me-1"></span> Guardando...`;

            $.ajax({
                url: baseUrl + 'api/donaciones',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(payload),
                success: function (response) {
                    if (response.value) {
                        Toast.fire({ icon: 'success', title: response.message }).then(() => {
                            window.location.reload();
                        });
                    } else {
                        showErrorToast(response);
                        btnFinalizar.disabled = false;
                        btnFinalizar.innerHTML = `<i class="mdi mdi-check-circle me-1"></i> Finalizar y Guardar`;
                    }
                },
                error: function (xhr) {
                    showErrorToast(xhr.responseJSON || { message: "Error interno del servidor" });
                    btnFinalizar.disabled = false;
                    btnFinalizar.innerHTML = `<i class="mdi mdi-check-circle me-1"></i> Finalizar y Guardar`;
                }
            });
        });
    }
});
