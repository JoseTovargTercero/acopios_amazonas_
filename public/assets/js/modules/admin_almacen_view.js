import { showErrorToast, showSuccessToast } from "../helpers/helpers.js";

document.addEventListener("DOMContentLoaded", () => {
  const authContainer = document.getElementById("adminAuthContainer");
  const dataContainer = document.getElementById("adminDataContainer");
  const btnAuth = document.getElementById("btnAuthAdmin");
  const codeInput = document.getElementById("adminCode");
  const authError = document.getElementById("authError");

  const loader = document.getElementById("loader");
  const noData = document.getElementById("noData");
  const accordion = document.getElementById("accordionAlmacen");
  const btnExportarExcel = document.getElementById("btnExportarExcel");

  const loaderDash = document.getElementById("loaderDashboard");
  const dashboardContent = document.getElementById("dashboardContent");
  const kpiCards = document.getElementById("kpiCards");
  const filtroCentro = document.getElementById("filtroCentro");

  let almacenData = [];
  let almacenFiltradas = [];
  let charts = {};
  let historialCompleto = [];
  let terminoBusqueda = "";

  const destroyCharts = () => {
    Object.values(charts).forEach((c) => {
      if (c) c.destroy();
    });
    charts = {};
  };

  const formatDate = (dateString) => {
    if (!dateString) return "N/A";
    const d = new Date(dateString);
    return d.toLocaleDateString("es-ES", {
      year: "numeric",
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  const calcularPeso = (ins) => {
    const peso = parseFloat(ins.peso_por_unidad || 0);
    const recibida = parseFloat(ins.cantidad_recibida || 0);
    if (ins.presentacion === "caja") {
      const cajas = parseInt(ins.unidades_por_presentacion || 1);
      return cajas * recibida * peso;
    }
    return recibida * peso;
  };

  const getColors = (n) => {
    const palette = [
      "#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b",
      "#5a5c69", "#858796", "#fd7e14", "#20c997", "#6f42c1",
      "#e83e8c", "#17a2b8", "#28a745", "#dc3545", "#ffc107",
    ];
    return n <= palette.length
      ? palette.slice(0, n)
      : Array.from({ length: n }, (_, i) => `hsl(${(i * 360) / n}, 65%, 55%)`);
  };

  const renderDashboard = (data) => {
    try {
      destroyCharts();

      let totalIngresos = 0;
      let totalInsumos = 0;
      const centrosSet = new Set();
      const conteoCategorias = {};
      const ingresosPorCentro = {};

      data.forEach((item) => {
        totalIngresos++;
        if (item.centro_nombre) centrosSet.add(item.centro_nombre);
        const centro = item.centro_nombre || "Desconocido";
        ingresosPorCentro[centro] = (ingresosPorCentro[centro] || 0) + 1;

        if (item.insumos) {
          item.insumos.forEach((ins) => {
            totalInsumos++;
            const cat = (ins.categoria || "Sin categoría").trim().toUpperCase();
            conteoCategorias[cat] = (conteoCategorias[cat] || 0) + 1;
          });
        }
      });

      const numCentros = centrosSet.size;

      kpiCards.innerHTML = `
        <div class="col-md-3 mb-2">
          <div class="card border-start border-primary border-3 shadow-sm h-100">
            <div class="card-body text-center">
              <h3 class="text-primary fw-bold mb-0">${totalIngresos}</h3>
              <p class="text-muted mb-0 small">Total Ingresos</p>
            </div>
          </div>
        </div>
        <div class="col-md-3 mb-2">
          <div class="card border-start border-success border-3 shadow-sm h-100">
            <div class="card-body text-center">
              <h3 class="text-success fw-bold mb-0">${totalInsumos}</h3>
              <p class="text-muted mb-0 small">Total Insumos</p>
            </div>
          </div>
        </div>
        <div class="col-md-3 mb-2">
          <div class="card border-start border-info border-3 shadow-sm h-100">
            <div class="card-body text-center">
              <h3 class="text-info fw-bold mb-0">${numCentros}</h3>
              <p class="text-muted mb-0 small">Centros</p>
            </div>
          </div>
        </div>
      `;

      const catLabels = Object.keys(conteoCategorias);
      const catValues = Object.values(conteoCategorias);
      const catColors = getColors(catLabels.length);

      if (document.getElementById("chartCategorias")) {
        charts.chartCategorias = new Chart(
          document.getElementById("chartCategorias"),
          {
            type: "bar",
            data: {
              labels: catLabels,
              datasets: [
                {
                  label: "Cantidad",
                  data: catValues,
                  backgroundColor: catColors,
                  borderWidth: 0,
                  borderRadius: 4,
                },
              ],
            },
            options: {
              responsive: true,
              maintainAspectRatio: true,
              plugins: {
                legend: { display: false },
              },
              scales: {
                y: { beginAtZero: true, ticks: { precision: 0 } },
              },
            },
          },
        );
      }

      if (document.getElementById("chartPresentacion")) {
        charts.chartPresentacion = new Chart(
          document.getElementById("chartPresentacion"),
          {
            type: "doughnut",
            data: {
              labels: catLabels,
              datasets: [
                {
                  data: catValues,
                  backgroundColor: catColors,
                  borderWidth: 0,
                },
              ],
            },
            options: {
              responsive: true,
              plugins: {
                legend: { position: "bottom", labels: { padding: 12 } },
                tooltip: {
                  callbacks: {
                    label: function (ctx) {
                      const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
                      const pct = total > 0 ? ((ctx.parsed / total) * 100).toFixed(1) : 0;
                      return ctx.label + ": " + pct + "%";
                    },
                  },
                },
              },
            },
          },
        );
      }

      const centroLabels = Object.keys(ingresosPorCentro);
      const centroValues = Object.values(ingresosPorCentro);
      const centroColors = getColors(centroLabels.length);

      if (document.getElementById("chartCentro")) {
        charts.chartCentro = new Chart(
          document.getElementById("chartCentro"),
          {
            type: "doughnut",
            data: {
              labels: centroLabels,
              datasets: [
                {
                  data: centroValues,
                  backgroundColor: centroColors,
                  borderWidth: 0,
                },
              ],
            },
            options: {
              responsive: true,
              plugins: {
                legend: { position: "bottom", labels: { padding: 12 } },
              },
            },
          },
        );
      }
    } catch (e) {
      console.error("Error renderDashboard:", e);
    } finally {
      loaderDash.classList.add("d-none");
      dashboardContent.classList.remove("d-none");
    }
  };

  const renderHistorial = (data) => {
    loader.classList.add("d-none");

    if (!data || data.length === 0) {
      noData.classList.remove("d-none");
      if (btnExportarExcel) btnExportarExcel.classList.add("d-none");
      return;
    }

    if (btnExportarExcel) btnExportarExcel.classList.remove("d-none");
    accordion.classList.remove("d-none");
    accordion.innerHTML = "";

    data.forEach((item) => {
      const collapseId = `collapseAlmacen${item.id_donacion}`;
      const headerId = `headingAlmacen${item.id_donacion}`;
      const numInsumos = item.insumos ? item.insumos.length : 0;
      const guiaTxt = item.numero_guia_remision || "Sin Guía";
      const centroNombre = item.centro_nombre || "Centro Desconocido";

      let insumosRows = "";
      if (numInsumos > 0) {
        item.insumos.forEach((ins) => {
          insumosRows += `
            <tr>
              <td>${ins.categoria}</td>
              <td>${ins.descripcion_insumo}</td>
              <td class="text-capitalize">${ins.presentacion}</td>
              <td class="text-center">${ins.cantidad_manifestada}</td>
              <td class="text-center">${ins.cantidad_recibida}</td>
              <td class="text-center">${ins.fecha_vencimiento || "N/A"}</td>
              <td class="text-end">${calcularPeso(ins).toFixed(2)}</td>
              <td><span class="badge bg-info">${ins.estado}</span></td>
            </tr>
          `;
        });
      } else {
        insumosRows = `<tr><td colspan="8" class="text-center text-muted">No se registraron insumos</td></tr>`;
      }

      accordion.insertAdjacentHTML(
        "beforeend",
        `
        <div class="card mb-2 border border-primary">
          <div class="card-header bg-light" id="${headerId}">
            <h5 class="m-0">
              <a class="custom-accordion-title d-block py-1 collapsed" data-bs-toggle="collapse" href="#${collapseId}" aria-expanded="false" aria-controls="${collapseId}">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <i class="mdi mdi-warehouse text-primary me-2 fs-4"></i>
                    <strong class="text-primary">${centroNombre.toUpperCase()}</strong> <br>
                    <small class="text-muted ms-4">Guía: ${guiaTxt}</small>
                  </div>
                  <div class="text-end">
                    <span class="badge bg-secondary mb-1"><i class="mdi mdi-calendar"></i> ${formatDate(item.fecha_hora_llegada)}</span><br>
                    <span class="badge bg-success">${numInsumos} insumo(s)</span>
                  </div>
                  <div>
                    <i class="mdi mdi-chevron-down accordion-arrow"></i>
                  </div>
                </div>
              </a>
            </h5>
          </div>
          <div id="${collapseId}" class="collapse" aria-labelledby="${headerId}" data-bs-parent="#accordionAlmacen">
            <div class="card-body">
              <div class="row mb-3">
                <div class="col-md-6">
                  <p class="mb-1"><strong>Transportista:</strong> ${item.nombre_transportista || "N/A"}</p>
                  <p class="mb-1"><strong>Placa:</strong> ${item.placa_vehiculo || "N/A"}</p>
                </div>
                <div class="col-md-6">
                  <p class="mb-1"><strong>Fecha Registro:</strong> ${formatDate(item.created_at)}</p>
                  <p class="mb-1"><strong>ID Sistema:</strong> #${item.id_donacion}</p>
                </div>
              </div>
              <h6 class="text-uppercase fw-bold"><i class="mdi mdi-format-list-bulleted me-1"></i> Detalle de Insumos</h6>
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
                  <tbody>${insumosRows}</tbody>
                </table>
              </div>
            </div>
          </div>
        </div>`,
      );
    });

    document.querySelectorAll("#accordionAlmacen .collapse").forEach((el) => {
      el.addEventListener("show.bs.collapse", () => {
        const arrow = el.closest(".card").querySelector(".accordion-arrow");
        if (arrow) arrow.classList.add("rotated");
      });
      el.addEventListener("hide.bs.collapse", () => {
        const arrow = el.closest(".card").querySelector(".accordion-arrow");
        if (arrow) arrow.classList.remove("rotated");
      });
    });
  };

  const getDateFilterValue = () => {
    const sel = document.getElementById("filtroFecha");
    return sel ? sel.value : "hoy";
  };

  const getCustomDate = () => {
    const input = document.getElementById("filtroFechaInput");
    return input ? input.value : "";
  };

  const filtrarPorFecha = (list) => {
    const mode = getDateFilterValue();
    if (mode === "todas") return list;
    let targetDate;
    if (mode === "hoy") {
      targetDate = new Date().toISOString().slice(0, 10);
    } else {
      targetDate = getCustomDate();
      if (!targetDate) return list;
    }
    return list.filter((d) => {
      const created = (d.created_at || "").slice(0, 10);
      return created === targetDate;
    });
  };

  const aplicarFiltro = () => {
    const id = parseInt(filtroCentro.value);
    let filtradas =
      id === 0
        ? almacenData
        : almacenData.filter((d) => parseInt(d.centro_acopio_id) === id);
    almacenFiltradas = filtrarPorFecha(filtradas);
    renderDashboard(almacenFiltradas);
  };

  const buscarEnHistorial = () => {
    const termino = document.getElementById("buscadorInsumo").value.toLowerCase().trim();
    terminoBusqueda = termino;
    if (!termino) {
      renderHistorial(historialCompleto);
      return;
    }
    const filtradas = historialCompleto
      .map((item) => {
        if (!item.insumos || item.insumos.length === 0) return null;
        const insFiltrados = item.insumos.filter(
          (ins) =>
            (ins.categoria || "").toLowerCase().includes(termino) ||
            (ins.descripcion_insumo || "").toLowerCase().includes(termino),
        );
        if (insFiltrados.length === 0) return null;
        return { ...item, insumos: insFiltrados };
      })
      .filter(Boolean);
    renderHistorial(filtradas);
  };

  const fetchAlmacenGlobal = () => {
    loaderDash.classList.remove("d-none");
    dashboardContent.classList.add("d-none");

    $.ajax({
      url: baseUrl + "api/admin_almacen",
      method: "GET",
      success: (response) => {
        if (response.value && Array.isArray(response.data)) {
          almacenData = response.data;
          historialCompleto = response.data;
          poblarFiltroCentros(almacenData);
          aplicarFiltro();
          renderHistorial(historialCompleto);
        } else {
          showErrorToast(response);
          loaderDash.innerHTML = `<p class="text-danger mt-3">Error: ${response.message || "Sin datos"}</p>`;
          loader.innerHTML = `<p class="text-danger mt-3">Error: ${response.message || "Sin datos"}</p>`;
        }
      },
      error: (xhr) => {
        const msg =
          (xhr.responseJSON && xhr.responseJSON.message) ||
          "Error al conectar con el servidor";
        showErrorToast({ message: msg });
        loaderDash.innerHTML = `<p class="text-danger mt-3">${msg}</p>`;
        loader.innerHTML = `<p class="text-danger mt-3">${msg}</p>`;
      },
    });
  };

  const poblarFiltroCentros = (data) => {
    const centros = {};
    data.forEach((d) => {
      if (d.centro_acopio_id && d.centro_nombre) {
        centros[d.centro_acopio_id] = d.centro_nombre;
      }
    });
    const sorted = Object.entries(centros).sort((a, b) =>
      a[1].localeCompare(b[1]),
    );
    filtroCentro.innerHTML = '<option value="0">Todos los centros</option>';
    sorted.forEach(([id, nombre]) => {
      filtroCentro.innerHTML += `<option value="${id}">${nombre}</option>`;
    });
  };

  btnAuth.addEventListener("click", () => {
    if (codeInput.value.trim() === "g-1351") {
      authError.classList.add("d-none");
      authContainer.classList.add("d-none");
      dataContainer.classList.remove("d-none");
      showSuccessToast({ message: "Acceso Concedido" });
      fetchAlmacenGlobal();
    } else {
      authError.classList.remove("d-none");
      codeInput.value = "";
    }
  });

  codeInput.addEventListener("keypress", (e) => {
    if (e.key === "Enter") btnAuth.click();
  });

  filtroCentro.addEventListener("change", aplicarFiltro);

  const inputBuscar = document.getElementById("buscadorInsumo");
  if (inputBuscar) {
    inputBuscar.addEventListener("input", buscarEnHistorial);
  }

  const selFecha = document.getElementById("filtroFecha");
  const inputFecha = document.getElementById("filtroFechaInput");
  const fechaInputGroup = document.getElementById("filtroFechaInputGroup");

  const onFechaChange = () => {
    if (selFecha.value === "especifica") {
      if (fechaInputGroup) fechaInputGroup.classList.remove("d-none");
      if (inputFecha && !inputFecha.value) {
        inputFecha.value = new Date().toISOString().slice(0, 10);
      }
    } else {
      if (fechaInputGroup) fechaInputGroup.classList.add("d-none");
    }
    aplicarFiltro();
  };

  if (selFecha) selFecha.addEventListener("change", onFechaChange);
  if (inputFecha) inputFecha.addEventListener("change", aplicarFiltro);

  if (inputFecha && !inputFecha.value) {
    inputFecha.value = new Date().toISOString().slice(0, 10);
  }

  if (btnExportarExcel) {
    btnExportarExcel.addEventListener("click", () => {
      if (almacenData.length === 0) return;
      const excelData = [];
      almacenData.forEach((item) => {
        const centro = item.centro_nombre || "Centro Desconocido";
        if (item.insumos && item.insumos.length > 0) {
          item.insumos.forEach((ins) => {
            excelData.push({
              "Centro Acopio": centro,
              "ID Sistema": item.id_donacion,
              "Fecha Llegada": item.fecha_hora_llegada || "",
              Transportista: item.nombre_transportista || "",
              "Placa Vehículo": item.placa_vehiculo || "",
              "Guía Remisión": item.numero_guia_remision || "",
              "Categoría Insumo": ins.categoria || "",
              "Descripción Insumo": ins.descripcion_insumo || "",
              Presentación: ins.presentacion || "",
              "Cant. Manifestada": ins.cantidad_manifestada || 0,
              "Cant. Recibida": ins.cantidad_recibida || 0,
              "Fecha Vencimiento": ins.fecha_vencimiento || "",
              "Peso Calc": parseFloat(calcularPeso(ins).toFixed(2)),
              Estado: ins.estado || "",
            });
          });
        } else {
          excelData.push({
            "Centro Acopio": centro,
            "ID Sistema": item.id_donacion,
            "Fecha Llegada": item.fecha_hora_llegada || "",
            Transportista: item.nombre_transportista || "",
            "Placa Vehículo": item.placa_vehiculo || "",
            "Guía Remisión": item.numero_guia_remision || "",
            "Categoría Insumo": "Sin insumos",
            "Descripción Insumo": "",
            Presentación: "",
            "Cant. Manifestada": "",
            "Cant. Recibida": "",
            "Fecha Vencimiento": "",
            "Peso Calc": "",
            Estado: "",
          });
        }
      });
      const worksheet = XLSX.utils.json_to_sheet(excelData);
      const workbook = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(workbook, worksheet, "Almacen Global");
      XLSX.writeFile(workbook, `Almacen_Global_${new Date().toISOString().slice(0, 10)}.xlsx`);
    });
  }
});
