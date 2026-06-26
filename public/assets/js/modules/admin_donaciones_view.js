import { showErrorToast, showSuccessToast } from "../helpers/helpers.js";

document.addEventListener("DOMContentLoaded", () => {
  const authContainer = document.getElementById("adminAuthContainer");
  const dataContainer = document.getElementById("adminDataContainer");
  const btnAuth = document.getElementById("btnAuthAdmin");
  const codeInput = document.getElementById("adminCode");
  const authError = document.getElementById("authError");

  const loader = document.getElementById("loader");
  const noData = document.getElementById("noData");
  const accordion = document.getElementById("accordionDonaciones");
  const btnExportarExcel = document.getElementById("btnExportarExcel");

  const loaderDash = document.getElementById("loaderDashboard");
  const dashboardContent = document.getElementById("dashboardContent");
  const kpiCards = document.getElementById("kpiCards");
  const filtroCentro = document.getElementById("filtroCentro");

  let donacionesData = [];
  let donacionesFiltradas = [];
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
      "#4e73df",
      "#1cc88a",
      "#36b9cc",
      "#f6c23e",
      "#e74a3b",
      "#5a5c69",
      "#858796",
      "#fd7e14",
      "#20c997",
      "#6f42c1",
      "#e83e8c",
      "#17a2b8",
      "#28a745",
      "#dc3545",
      "#ffc107",
    ];
    return n <= palette.length
      ? palette.slice(0, n)
      : Array.from({ length: n }, (_, i) => `hsl(${(i * 360) / n}, 65%, 55%)`);
  };

  const renderDashboard = (donaciones) => {
    try {
      destroyCharts();

      let totalInsumos = 0;
      let kilosAlimentos = 0;
      const centrosSet = new Set();
      const conteoCategorias = {};
      const conteoPresentacion = { unidad: 0, caja: 0 };
      const donacionesPorMes = {};
      const donacionesPorCentro = {};
      let donaciones30d = 0;
      const now = new Date();
      const hace30d = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);

      donaciones.forEach((don) => {
        if (don.centro_nombre) centrosSet.add(don.centro_nombre);

        const fecha = new Date(don.fecha_hora_llegada);
        if (fecha >= hace30d) donaciones30d++;

        const mes = fecha.toLocaleString("es-ES", {
          month: "short",
          year: "2-digit",
        });
        donacionesPorMes[mes] = (donacionesPorMes[mes] || 0) + 1;

        const centro = don.centro_nombre || "Desconocido";
        donacionesPorCentro[centro] = (donacionesPorCentro[centro] || 0) + 1;

        if (don.insumos) {
          don.insumos.forEach((ins) => {
            totalInsumos++;
            const cat = (ins.categoria || "Sin categoría").trim().toUpperCase();
            conteoPresentacion[ins.presentacion] =
              (conteoPresentacion[ins.presentacion] || 0) + 1;

            if (cat === "ALIMENTOS") {
              const kg = Math.round(calcularPeso(ins));
              conteoCategorias[cat] = (conteoCategorias[cat] || 0) + kg;
              kilosAlimentos += kg;
            } else {
              conteoCategorias[cat] = (conteoCategorias[cat] || 0) + 1;
            }
          });
        }
      });

      kpiCards.innerHTML = `
        <div class="col-lg-3 mb-3">
          <div class="card border-0 shadow-sm bg-primary text-white h-100">
            <div class="card-body text-center">
              <i class="mdi mdi-truck-delivery" style="font-size:2rem"></i>
              <h3 class="mt-2 fw-bold text-white">${donaciones.length}</h3>
              <small>Total Donaciones</small>
            </div>
          </div>
        </div>
        <div class="col-lg-3 mb-3">
          <div class="card border-0 shadow-sm bg-success text-white h-100">
            <div class="card-body text-center">
              <i class="mdi mdi-package-variant-closed" style="font-size:2rem"></i>
              <h3 class="mt-2 fw-bold text-white">${totalInsumos}</h3>
              <small>Total Insumos</small>
            </div>
          </div>
        </div>
        <div class="col-lg-3 mb-3">
          <div class="card border-0 shadow-sm bg-info text-white h-100">
            <div class="card-body text-center">
              <i class="mdi mdi-domain" style="font-size:2rem"></i>
              <h3 class="mt-2 fw-bold text-white">${centrosSet.size}</h3>
              <small>Centros</small>
            </div>
          </div>
        </div>
        <div class="col-lg-3 mb-3">
          <div class="card border-0 shadow-sm bg-warning text-white h-100">
            <div class="card-body text-center">
              <i class="mdi mdi-scale-balance" style="font-size:2rem"></i>
              <h3 class="mt-2 fw-bold text-white">${Math.round(kilosAlimentos)}</h3>
              <small>Kg Alimentos</small>
            </div>
          </div>
        </div>
        
        </div>
      `;

      if (typeof Chart === "undefined") {
        console.error("Chart.js no está cargado");
        return;
      }

      Chart.defaults.color = "#6c757d";

      const catLabels = Object.keys(conteoCategorias);
      const catValues = Object.values(conteoCategorias);
      const filtroCatsContainer = document.getElementById("filtroCategoriasChart");
      if (document.getElementById("chartCategorias")) {
        const catChartRef = new Chart(
          document.getElementById("chartCategorias"),
          {
            type: "bar",
            data: {
              labels: catLabels,
              datasets: [
                {
                  label: "Cantidad",
                  data: catValues.slice(),
                  backgroundColor: getColors(catLabels.length),
                  borderRadius: 4,
                },
              ],
            },
            options: {
              responsive: true,
              plugins: {
                legend: { display: false },
                tooltip: {
                  callbacks: {
                    label: (ctx) => {
                      const label = ctx.label;
                      const val = ctx.raw;
                      return label === "ALIMENTOS"
                        ? `${val} kg`
                        : `${val} unidades`;
                    },
                  },
                },
              },
              scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } },
            },
          },
        );
        charts.chartCategorias = catChartRef;

        const origValues = catValues.slice();
        const hidden = new Set();
        if (filtroCatsContainer) {
          filtroCatsContainer.innerHTML = catLabels
            .map(
              (lbl) =>
                `<span class="badge rounded-pill cat-toggle active" data-cat="${lbl}" style="cursor:pointer;background:#4e73df;color:#fff;padding:4px 10px;font-size:0.8rem">${lbl}</span>`,
            )
            .join("");
          filtroCatsContainer.querySelectorAll(".cat-toggle").forEach((el) => {
            el.addEventListener("click", () => {
              const lbl = el.dataset.cat;
              const idx = catLabels.indexOf(lbl);
              if (hidden.has(lbl)) {
                hidden.delete(lbl);
                catChartRef.data.datasets[0].data[idx] = origValues[idx];
                el.style.background = "#4e73df";
                el.style.color = "#fff";
              } else {
                hidden.add(lbl);
                catChartRef.data.datasets[0].data[idx] = null;
                el.style.background = "#e9ecef";
                el.style.color = "#6c757d";
              }
              catChartRef.update();
            });
          });
        }
      }

      if (document.getElementById("chartPresentacion")) {
        charts.chartPresentacion = new Chart(
          document.getElementById("chartPresentacion"),
          {
            type: "doughnut",
            data: {
              labels: ["Unidad", "Caja"],
              datasets: [
                {
                  data: [
                    conteoPresentacion.unidad || 0,
                    conteoPresentacion.caja || 0,
                  ],
                  backgroundColor: ["#4e73df", "#1cc88a"],
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

      const meses = Object.keys(donacionesPorMes);
      if (meses.length > 0) {
        meses.sort((a, b) => {
          const parse = (s) => {
            const p = s.split("/");
            return new Date(
              2000 + parseInt(p[1]),
              "ene feb mar abr may jun jul ago sep oct nov dic".indexOf(
                p[0].slice(0, 3).toLowerCase(),
              ),
              1,
            );
          };
          return parse(a) - parse(b);
        });
      }
      if (document.getElementById("chartDonacionesMes")) {
        charts.chartDonacionesMes = new Chart(
          document.getElementById("chartDonacionesMes"),
          {
            type: "line",
            data: {
              labels: meses,
              datasets: [
                {
                  label: "Donaciones",
                  data: meses.map((m) => donacionesPorMes[m]),
                  borderColor: "#4e73df",
                  backgroundColor: "rgba(78, 115, 223, 0.1)",
                  fill: true,
                  tension: 0.3,
                  pointBackgroundColor: "#4e73df",
                  pointRadius: 4,
                },
              ],
            },
            options: {
              responsive: true,
              plugins: { legend: { display: false } },
              scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } },
            },
          },
        );
      }

      const ctrLabels = Object.keys(donacionesPorCentro).sort(
        (a, b) => donacionesPorCentro[b] - donacionesPorCentro[a],
      );
      const ctrValues = ctrLabels.map((c) => donacionesPorCentro[c]);
      if (document.getElementById("chartDonacionesCentro")) {
        charts.chartDonacionesCentro = new Chart(
          document.getElementById("chartDonacionesCentro"),
          {
            type: "bar",
            data: {
              labels: ctrLabels,
              datasets: [
                {
                  label: "Donaciones",
                  data: ctrValues,
                  backgroundColor: getColors(ctrLabels.length),
                  borderRadius: 4,
                },
              ],
            },
            options: {
              indexAxis: "y",
              responsive: true,
              plugins: { legend: { display: false } },
              scales: { x: { beginAtZero: true, ticks: { stepSize: 1 } } },
            },
          },
        );
      }
    } catch (err) {
      console.error("Error renderDashboard:", err);
    } finally {
      loaderDash.classList.add("d-none");
      dashboardContent.classList.remove("d-none");
    }
  };

  const renderHistorial = (donaciones) => {
    loader.classList.add("d-none");
    donacionesData = donaciones;
    historialCompleto = donaciones;

    if (!donaciones || donaciones.length === 0) {
      noData.classList.remove("d-none");
      if (btnExportarExcel) btnExportarExcel.classList.add("d-none");
      return;
    }

    if (btnExportarExcel) btnExportarExcel.classList.remove("d-none");
    accordion.classList.remove("d-none");
    accordion.innerHTML = "";

    donaciones.forEach((don) => {
      const collapseId = `collapseDonacion${don.id_donacion}`;
      const headerId = `headingDonacion${don.id_donacion}`;
      const numInsumos = don.insumos ? don.insumos.length : 0;
      const guiaTxt = don.numero_guia_remision || "Sin Guía";
      const centroNombre = don.centro_nombre || "Centro Desconocido";

      let insumosRows = "";
      if (numInsumos > 0) {
        don.insumos.forEach((ins) => {
          insumosRows += `
            <tr data-insumo-id="${ins.id_insumo}">
              <td class="editable-cat">${ins.categoria}</td>
              <td class="editable-desc">${ins.descripcion_insumo}</td>
              <td class="text-capitalize">${ins.presentacion}</td>
              <td class="text-center">${ins.cantidad_manifestada}</td>
              <td class="text-center">${ins.cantidad_recibida}</td>
              <td class="text-center">${ins.fecha_vencimiento || "N/A"}</td>
              <td class="text-end">${calcularPeso(ins).toFixed(2)}</td>
              <td><span class="badge bg-info">${ins.estado}</span></td>
              <td class="text-center">
                <button type="button" class="btn btn-sm btn-outline-primary btn-editar-insumo" title="Editar">
                  <i class="mdi mdi-pencil"></i>
                </button>
              </td>
            </tr>
          `;
        });
      } else {
        insumosRows = `<tr><td colspan="9" class="text-center text-muted">No se registraron insumos</td></tr>`;
      }

      accordion.insertAdjacentHTML(
        "beforeend",
        `
        <div class="card mb-2 border border-primary" data-donacion-id="${don.id_donacion}">
          <div class="card-header bg-light" id="${headerId}">
            <h5 class="m-0">
              <a class="custom-accordion-title d-block py-1 collapsed" data-bs-toggle="collapse" href="#${collapseId}" aria-expanded="false" aria-controls="${collapseId}">
                <div class="d-flex justify-content-between align-items-center">
                  <div>
                    <i class="mdi mdi-office-building text-primary me-2 fs-4"></i>
                    <strong class="text-primary">${centroNombre.toUpperCase()}</strong> <br>
                    <small class="text-muted ms-4">Donante: ${don.organizacion_donante}</small>
                  </div>
                  <div class="text-end">
                    <span class="badge bg-secondary mb-1"><i class="mdi mdi-calendar"></i> ${formatDate(don.fecha_hora_llegada)}</span><br>
                    <span class="badge bg-success">${numInsumos} insumo(s)</span>
                  </div>
                  <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-sm btn-outline-danger btn-eliminar-donacion" data-id="${don.id_donacion}" title="Eliminar donación">
                      <i class="mdi mdi-delete"></i>
                    </button>
                    <i class="mdi mdi-chevron-down accordion-arrow"></i>
                  </div>
                </div>
              </a>
            </h5>
          </div>
          <div id="${collapseId}" class="collapse" aria-labelledby="${headerId}" data-bs-parent="#accordionDonaciones">
            <div class="card-body">
              <div class="row mb-3">
                <div class="col-md-6">
                  <p class="mb-1"><strong>Transportista:</strong> ${don.nombre_transportista || "N/A"}</p>
                  <p class="mb-1"><strong>Placa:</strong> ${don.placa_vehiculo || "N/A"}</p>
                  <p class="mb-1"><strong>Guía Remisión:</strong> ${guiaTxt}</p>
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
                      <th class="text-center">Acción</th>
                    </tr>
                  </thead>
                  <tbody>${insumosRows}</tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        `,
      );
    });

    document.querySelectorAll(".btn-editar-insumo").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.stopPropagation();
        const tr = e.currentTarget.closest("tr");
        if (!tr) return;
        const tdCat = tr.querySelector(".editable-cat");
        const tdDesc = tr.querySelector(".editable-desc");
        const btnCell = e.currentTarget.closest("td");

        if (tr.classList.contains("editing")) {
          const inputCat = tdCat.querySelector("input");
          const inputDesc = tdDesc.querySelector("input");
          const nuevaCat = inputCat.value.trim();
          const nuevaDesc = inputDesc.value.trim();
          if (!nuevaCat || !nuevaDesc) {
            showErrorToast({ message: "Categoría y descripción no pueden estar vacías." });
            return;
          }

          const idInsumo = parseInt(tr.dataset.insumoId);
          e.currentTarget.disabled = true;
          e.currentTarget.innerHTML = `<span class="spinner-border spinner-border-sm"></span>`;

          $.ajax({
            url: baseUrl + "api/admin_insumos",
            method: "PUT",
            contentType: "application/json",
            data: JSON.stringify({ id_insumo: idInsumo, categoria: nuevaCat, descripcion_insumo: nuevaDesc }),
            success: (response) => {
              if (response.value) {
                showSuccessToast({ message: "Insumo actualizado" });
                tdCat.textContent = nuevaCat;
                tdDesc.textContent = nuevaDesc;
                tr.classList.remove("editing");
                e.currentTarget.innerHTML = `<i class="mdi mdi-pencil"></i>`;
                e.currentTarget.disabled = false;
              } else {
                showErrorToast(response);
                e.currentTarget.innerHTML = `<i class="mdi mdi-pencil"></i>`;
                e.currentTarget.disabled = false;
              }
            },
            error: (xhr) => {
              showErrorToast(xhr.responseJSON || { message: "Error al actualizar" });
              e.currentTarget.innerHTML = `<i class="mdi mdi-pencil"></i>`;
              e.currentTarget.disabled = false;
            },
          });
        } else {
          const catOrig = tdCat.textContent;
          const descOrig = tdDesc.textContent;
          tdCat.innerHTML = `<input type="text" class="form-control form-control-sm" value="${catOrig}">`;
          tdDesc.innerHTML = `<input type="text" class="form-control form-control-sm" value="${descOrig}">`;
          tr.classList.add("editing");
          e.currentTarget.innerHTML = `<i class="mdi mdi-content-save"></i>`;
          tdCat.querySelector("input").focus();
        }
      });
    });

    document.querySelectorAll(".btn-eliminar-donacion").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        e.stopPropagation();
        const id = parseInt(e.currentTarget.dataset.id);
        if (
          confirm(
            "¿Estás seguro de eliminar esta donación y todos sus insumos?",
          )
        ) {
          eliminarDonacion(id);
        }
      });
    });
  };

  const buscarEnHistorial = () => {
    const termino = document.getElementById("buscadorInsumo").value.toLowerCase().trim();
    terminoBusqueda = termino;
    if (!termino) {
      renderHistorial(historialCompleto);
      return;
    }
    const filtradas = historialCompleto
      .map((don) => {
        if (!don.insumos || don.insumos.length === 0) return null;
        const insFiltrados = don.insumos.filter(
          (ins) =>
            (ins.categoria || "").toLowerCase().includes(termino) ||
            (ins.descripcion_insumo || "").toLowerCase().includes(termino),
        );
        if (insFiltrados.length === 0) return null;
        return { ...don, insumos: insFiltrados };
      })
      .filter(Boolean);
    renderHistorial(filtradas);
  };

  const eliminarDonacion = (id) => {
    const card = document.querySelector(`[data-donacion-id="${id}"]`);
    if (card) card.style.opacity = "0.4";

    $.ajax({
      url: baseUrl + "api/admin_donaciones/" + id,
      method: "DELETE",
      success: (response) => {
        if (response.value) {
          showSuccessToast({
            message: response.message || "Donación eliminada",
          });
          donacionesData = donacionesData.filter((d) => d.id_donacion !== id);
          aplicarFiltro();
          renderHistorial(donacionesData);
        } else {
          showErrorToast(response);
          if (card) card.style.opacity = "1";
        }
      },
      error: (xhr) => {
        showErrorToast(xhr.responseJSON || { message: "Error al eliminar" });
        if (card) card.style.opacity = "1";
      },
    });
  };

  const poblarFiltroCentros = (donaciones) => {
    const centros = {};
    donaciones.forEach((d) => {
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

  const aplicarFiltro = () => {
    const id = parseInt(filtroCentro.value);
    donacionesFiltradas =
      id === 0
        ? donacionesData
        : donacionesData.filter((d) => parseInt(d.centro_acopio_id) === id);
    renderDashboard(donacionesFiltradas);
  };

  const fetchDonacionesGlobales = () => {
    loaderDash.classList.remove("d-none");
    dashboardContent.classList.add("d-none");

    $.ajax({
      url: baseUrl + "api/admin_donaciones",
      method: "GET",
      success: (response) => {
        if (response.value && Array.isArray(response.data)) {
          donacionesData = response.data;
          poblarFiltroCentros(donacionesData);
          aplicarFiltro();
          renderHistorial(donacionesData);
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

  btnAuth.addEventListener("click", () => {
    if (codeInput.value.trim() === "g-1351") {
      authError.classList.add("d-none");
      authContainer.classList.add("d-none");
      dataContainer.classList.remove("d-none");
      showSuccessToast({ message: "Acceso Concedido" });
      fetchDonacionesGlobales();
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

  const btnGestionCats = document.getElementById("btnGestionCategorias");
  const modalCats = document.getElementById("modalCategorias");
  let bsModalCats = null;
  if (modalCats) bsModalCats = new bootstrap.Modal(modalCats);

  const cargarCategorias = () => {
    const loaderCats = document.getElementById("loaderCats");
    const contenidoCats = document.getElementById("contenidoCats");
    const listaCats = document.getElementById("listaCategorias");
    loaderCats.classList.remove("d-none");
    contenidoCats.classList.add("d-none");

    $.ajax({
      url: baseUrl + "api/admin_categorias",
      method: "GET",
      success: (response) => {
        loaderCats.classList.add("d-none");
        contenidoCats.classList.remove("d-none");
        if (!response.value || !Array.isArray(response.data)) {
          listaCats.innerHTML = `<p class="text-muted">No hay categorías registradas.</p>`;
          return;
        }
        listaCats.innerHTML = response.data
          .map(
            (cat) =>
              `<span class="badge bg-light text-dark border p-2 d-flex align-items-center gap-2" style="font-size:0.95rem;cursor:pointer" data-categoria="${cat}">
                ${cat}
                <i class="mdi mdi-pencil text-primary"></i>
              </span>`,
          )
          .join("");

        listaCats.querySelectorAll("[data-categoria]").forEach((el) => {
          el.addEventListener("click", () => {
            const vieja = el.dataset.categoria;
            const nueva = prompt(`Renombrar categoría "${vieja}" a:`, vieja);
            if (!nueva || nueva.trim() === "" || nueva.trim() === vieja) return;
            el.style.opacity = "0.5";
            $.ajax({
              url: baseUrl + "api/admin_categorias/renombrar",
              method: "PUT",
              contentType: "application/json",
              data: JSON.stringify({ vieja, nueva: nueva.trim() }),
              success: (res) => {
                if (res.value) {
                  showSuccessToast({ message: res.message });
                  cargarCategorias();
                  fetchDonacionesGlobales();
                } else {
                  showErrorToast(res);
                  el.style.opacity = "1";
                }
              },
              error: (xhr) => {
                showErrorToast(xhr.responseJSON || { message: "Error al renombrar" });
                el.style.opacity = "1";
              },
            });
          });
        });
      },
      error: () => {
        loaderCats.innerHTML = `<p class="text-danger">Error al cargar categorías.</p>`;
      },
    });
  };

  if (btnGestionCats && bsModalCats) {
    btnGestionCats.addEventListener("click", () => {
      bsModalCats.show();
      cargarCategorias();
    });
  }

  if (btnExportarExcel) {
    btnExportarExcel.addEventListener("click", () => {
      if (donacionesData.length === 0) return;
      const excelData = [];
      donacionesData.forEach((don) => {
        const centro = don.centro_nombre || "Centro Desconocido";
        if (don.insumos && don.insumos.length > 0) {
          don.insumos.forEach((ins) => {
            excelData.push({
              "Centro Acopio": centro,
              "ID Sistema": don.id_donacion,
              "Fecha Llegada": don.fecha_hora_llegada || "",
              Donante: don.organizacion_donante || "",
              Transportista: don.nombre_transportista || "",
              "Placa Vehículo": don.placa_vehiculo || "",
              "Guía Remisión": don.numero_guia_remision || "",
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
            "ID Sistema": don.id_donacion,
            "Fecha Llegada": don.fecha_hora_llegada || "",
            Donante: don.organizacion_donante || "",
            Transportista: don.nombre_transportista || "",
            "Placa Vehículo": don.placa_vehiculo || "",
            "Guía Remisión": don.numero_guia_remision || "",
            "Categoría Insumo": "Sin insumos registrados",
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
      worksheet["!cols"] = [
        { wch: 30 },
        { wch: 12 },
        { wch: 18 },
        { wch: 35 },
        { wch: 25 },
        { wch: 15 },
        { wch: 20 },
        { wch: 25 },
        { wch: 40 },
        { wch: 15 },
        { wch: 18 },
        { wch: 15 },
        { wch: 18 },
        { wch: 15 },
        { wch: 20 },
      ];
      const workbook = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(workbook, worksheet, "Donaciones Globales");
      XLSX.writeFile(
        workbook,
        `Donaciones_Globales_${new Date().toISOString().slice(0, 10)}.xlsx`,
      );
    });
  }
});
