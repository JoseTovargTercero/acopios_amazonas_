import { showErrorToast, Toast } from "../helpers/helpers.js";

document.addEventListener("DOMContentLoaded", () => {
  const btnNextStep = document.getElementById("btnNextStep");
  const btnPrevStep = document.getElementById("btnPrevStep");
  const btnFinalizar = document.getElementById("btnFinalizar");
  const btnAddInsumo = document.getElementById("btnAddInsumo");
  const formWizard = document.getElementById("formDonacionWizard");
  const inputFechaHora = document.getElementById("fecha_hora_llegada");
  const tabStep2Link = document.getElementById("tabStep2");
  const tablaInsumos = document.getElementById("tablaInsumos");

  const selPresentacion = document.getElementById("ins_presentacion");
  const divSoloCaja = document.getElementById("solo_para_caja");
  const inputUnidades = document.getElementById("ins_unidades");
  const lblMan = document.getElementById("lbl-man");

  function actualizarLabels() {
    if (selPresentacion.value === "caja") {
      lblMan.childNodes[0].textContent = "Cajas ";
      divSoloCaja.style.display = "";
    } else {
      lblMan.childNodes[0].textContent = "Unidades ";
      divSoloCaja.style.display = "none";
      inputUnidades.value = "1";
    }
  }

  if (selPresentacion && divSoloCaja && inputUnidades && lblMan) {
    actualizarLabels();
    selPresentacion.addEventListener("change", actualizarLabels);
  }

  let insumos = [];
  let dataAlmacen = {};

  if (inputFechaHora && !inputFechaHora.value) {
    const now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    inputFechaHora.value = now.toISOString().slice(0, 16);
  }

  const switchTab = (targetId) => {
    const triggerEl = document.querySelector(`a[href="${targetId}"]`);
    if (triggerEl) {
      triggerEl.classList.remove("disabled");
      const tab = new bootstrap.Tab(triggerEl);
      tab.show();
    }
  };

  if (btnNextStep && formWizard) {
    btnNextStep.addEventListener("click", () => {
      if (!formWizard.checkValidity()) {
        formWizard.classList.add("was-validated");
        return;
      }

      const formData = new FormData(formWizard);
      dataAlmacen = {
        fecha_hora_llegada: formData.get("fecha_hora_llegada"),
        numero_guia_remision: "N/A",
        nombre_transportista: formData.get("nombre_transportista"),
        placa_vehiculo: "N/A",
      };

      switchTab("#step2");
    });
  }

  if (btnPrevStep) {
    btnPrevStep.addEventListener("click", () => {
      switchTab("#step1");
    });
  }

  const renderTable = () => {
    if (insumos.length === 0) {
      tablaInsumos.innerHTML = `<tr><td colspan="6" class="text-center text-muted py-3">Aún no se han agregado insumos.</td></tr>`;
      btnFinalizar.disabled = true;
      return;
    }

    btnFinalizar.disabled = false;
    tablaInsumos.innerHTML = "";

    insumos.forEach((item, index) => {
      const tr = document.createElement("tr");
      tr.innerHTML = `
                <td>${item.categoria}</td>
                <td>${item.descripcion_insumo}</td>
                <td class="text-capitalize">${item.presentacion}</td>
                <td class="text-center">${item.cantidad_manifestada}</td>
                <td>${item.estado}</td>
                <td class="text-center">
                    <button type="button" class="btn btn-sm btn-danger btn-delete-insumo" data-index="${index}">
                        <i class="mdi mdi-delete"></i>
                    </button>
                </td>
            `;
      tablaInsumos.appendChild(tr);
    });

    document.querySelectorAll(".btn-delete-insumo").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        const idx = parseInt(e.currentTarget.getAttribute("data-index"));
        insumos.splice(idx, 1);
        renderTable();
      });
    });
  };

  const selCategoria = document.getElementById("ins_categoria");
  const inputCategoriaOtro = document.getElementById("ins_categoria_otro");

  if (selCategoria && inputCategoriaOtro) {
    selCategoria.addEventListener("change", () => {
      inputCategoriaOtro.classList.toggle(
        "d-none",
        selCategoria.value !== "otro",
      );
      if (selCategoria.value !== "otro") inputCategoriaOtro.value = "";
    });
  }

  if (btnAddInsumo) {
    btnAddInsumo.addEventListener("click", async () => {
      const rawCategoria = selCategoria.value;
      const categoria =
        rawCategoria === "otro"
          ? inputCategoriaOtro.value.trim()
          : rawCategoria;
      const descripcion = document
        .getElementById("ins_descripcion")
        .value.trim();
      const presentacion = document.getElementById("ins_presentacion").value;
      const unidades =
        parseInt(document.getElementById("ins_unidades").value) || 1;
      const peso = parseFloat(document.getElementById("ins_peso").value) || 0.0;
      const vencimiento = document.getElementById("ins_vencimiento").value;
      const manifestada =
        parseInt(document.getElementById("ins_manifestada").value) || 0;
      const estado = document.getElementById("ins_estado").value.trim();

      if (!categoria || !descripcion || !estado) {
        showErrorToast({
          message: "La categoría, descripción y estado son obligatorios.",
        });
        return;
      }

      if (manifestada < 0) {
        showErrorToast({
          message: "La cantidad no puede ser negativa.",
        });
        return;
      }

      if (peso > 1) {
        const confirm = await Swal.fire({
          title: "¿ Confirmas el peso?",
          html: `<b>El peso unitario es mayor a un KILO</b><br><br>
¿Vas a ingresar gramos? Usa decimales: <b>0.${peso}</b><br><br>
¡Atención! Debes registrar el peso individual de cada producto, no el peso total de la caja o paca..`,
          icon: "question",
          showCancelButton: true,
          confirmButtonText: "Confirmar",
          cancelButtonText: "Cancelar",
        });
        if (!confirm.isConfirmed) return;
      }

      insumos.push({
        categoria,
        descripcion_insumo: descripcion,
        presentacion,
        unidades_por_presentacion: unidades,
        peso_por_unidad: peso,
        cantidad_manifestada: manifestada,
        cantidad_recibida: manifestada,
        estado,
        fecha_vencimiento: vencimiento || null,
      });

      document.getElementById("ins_descripcion").value = "";
      document.getElementById("ins_manifestada").value = "1";
      document.getElementById("ins_descripcion").focus();

      renderTable();
    });
  }

  if (btnFinalizar) {
    btnFinalizar.addEventListener("click", () => {
      if (insumos.length === 0) return;

      const payload = {
        almacen: dataAlmacen,
        insumos: insumos,
      };

      btnFinalizar.disabled = true;
      btnFinalizar.innerHTML = `<span class="spinner-border spinner-border-sm me-1"></span> Guardando...`;

      $.ajax({
        url: baseUrl + "api/almacen",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(payload),
        success: function (response) {
          if (response.value) {
            Toast.fire({ icon: "success", title: response.message }).then(
              () => {
                window.location.reload();
              },
            );
          } else {
            showErrorToast(response);
            btnFinalizar.disabled = false;
            btnFinalizar.innerHTML = `<i class="mdi mdi-check-circle me-1"></i> Finalizar y Guardar`;
          }
        },
        error: function (xhr) {
          showErrorToast(
            xhr.responseJSON || { message: "Error interno del servidor" },
          );
          btnFinalizar.disabled = false;
          btnFinalizar.innerHTML = `<i class="mdi mdi-check-circle me-1"></i> Finalizar y Guardar`;
        },
      });
    });
  }
});
