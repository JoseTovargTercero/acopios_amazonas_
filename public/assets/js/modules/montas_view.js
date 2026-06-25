import { showErrorToast } from "../helpers/helpers.js";

// --- HELPERS Y FORMATTERS PARA LA TABLA ---

/**
 * Adapta la respuesta de la API al formato que Bootstrap Table espera.
 */
window.responseHandler = function (res) {
  return {
    rows: res.data,
    total: res.data.length, // O idealmente un valor desde la API si hay paginación del lado del servidor
  };
};

/**
 * Formatea la columna de acciones con los botones.
 */
window.accionesFormatter = function (value, row) {
  return `
  <div class="btn-group gap-1">
      <button class="btn btn-info btn-sm btn-ver" data-id="${value}" title="Ver Detalles">
          <i class="mdi mdi-eye"></i>
      </button>
     
      ${
        row.estado_periodo === "ABIERTO"
          ? `
      <button class="btn btn-success btn-sm btn-editar" data-id="${value}" title="Agregar servicio">
          <i class="mdi mdi-pencil-plus"></i>
      </button>

      <button class="btn btn-info text-white btn-sm btn-revision-periodo" data-id="${value}" title="Pasar a revisión">
          <i class="mdi mdi-send-check"></i>
      </button>
      <button class="btn btn-danger btn-sm btn-eliminar" data-id="${value}" title="Eliminar">
          <i class="mdi mdi-delete"></i>
      </button>`
          : ""
      }

  </div>`;
};

window.estatusFomatter = function (value, row) {
  let status = "";
  if (row.estatuss.PENDIENTE == 0 && value === "ABIERTO") {
    status = `<span class="badge bg-danger">PASAR A REVISIÓN</span>`;
  } else if (value === "ABIERTO") {
    status = `<span class="badge bg-success">ABIERTO</span>`;
  } else if (value === "SEGUIMIENTO") {
    status = `<span class="badge bg-info">EN SEGUIMIENTO</span>`;
  }else if (value === "CERRADO") {
    status = `<span class="badge bg-danger">CERRADO</span>`;
  }

  return `
  <div class="gap-1">
    ${status}
  </div>`;
};

// resultados: ENTRO_EN_CELO, SOSPECHA_PREÑEZ, CONFIRMADA_PREÑEZ, SIN_SEÑALES
window.resultadoFormatter = function (value, row) {
  let status = "";
  if (value === "ENTRO_EN_CELO") {
    status = `<span class="badge bg-danger">ENTRO EN CELO</span>`;
  } else if (value === "SOSPECHA_PREÑEZ") {
    status = `<span class="badge bg-info">SOSPECHA PREÑEZ</span>`;
  } else if (value === "CONFIRMADA_PREÑEZ") {
    status = `<span class="badge bg-success">CONFIRMADA PREÑEZ</span>`;
  } else if (value === "SIN_SEÑALES") {
    status = `<span class="badge bg-warning">SIN SEÑALES</span>`;
  }

  return `
  <div class="gap-1">
    ${status}
  </div>`;
};

// TODO: --- LÓGICA PRINCIPAL ---

document.addEventListener("DOMContentLoaded", function () {
  // --- INSTANCIAS DE MODALES ---
  const modalServicio = new bootstrap.Modal(
    document.getElementById("modalServicio")
  );
  const modalDetalles = new bootstrap.Modal(
    document.getElementById("modalDetalles")
  );

  // secciones
  const divPeriodoServicio = document.getElementById("divPeriodoServicio");
  const tablaPrincipal = document.getElementById("tablaPrincipal");

  // --- FORMULARIOS ---
  const formPeriodoServicio = document.getElementById("formPeriodoServicio");
  const formServicio = document.getElementById("formServicio");

  // --- MANEJO DE LA VISTA PRINCIPAL (TABLA Y CREACIÓN) ---

  // Abrir modal para registrar un nuevo periodo
  $("#btnNuevoPeriodo").on("click", function () {
    formPeriodoServicio.reset();
    new bootstrap.Tab(document.querySelector("#paso1-tab")).show();

    tablaPrincipal.classList.add("hide");
    divPeriodoServicio.classList.remove("hide");
  });

  // Abrir modal para crear nuevo animal
  $("#cancelarRegistroBtn").on("click", function () {
    tablaPrincipal.classList.remove("hide");
    divPeriodoServicio.classList.add("hide");
  });

  // Registrar periodo de servicios (periodo de montas)
  $(formPeriodoServicio).on("submit", function (e) {
    e.preventDefault();
    let url = baseUrl + "api/periodos_servicios";
    let method = "POST";

    const formData = new FormData(this);
    $.ajax({
      url: url,
      method: method,
      data: formData,
      processData: false,
      contentType: false,
      success: function (response) {
        tablaPrincipal.classList.remove("hide");
        divPeriodoServicio.classList.add("hide");
        Swal.fire("¡Éxito!", response.message, "success");
        $("#tablaPeriodosMonta").bootstrapTable("refresh");
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON);
      },
    });
  });

  // Registrar monta
  $(formServicio).on("submit", function (e) {
    e.preventDefault();
    let url = baseUrl + "api/servicios";
    let method = "POST";

    if (periodoId == null || numeroServicio == null || fechaServicio == null) {
      showErrorToast({
        message: "Error interno: datos del periodo de monta no definidos.",
      });
      return;
    }

    const formData = new FormData(this);
    // agrega numeroServicio
    formData.append("numero_servicio", numeroServicio);
    formData.append("fecha", fechaServicio);

    // envia formData a la consola para debug
    $.ajax({
      url: url,
      method: method,
      data: formData,
      processData: false,
      contentType: false,
      success: function (response) {
        modalServicio.hide();

        periodoId = null;
        numeroServicio = null;
        fechaServicio = null;
        Swal.fire("¡Éxito!", response.message, "success");
        $("#tablaPeriodosMonta").bootstrapTable("refresh");
      },
      error: function (xhr) {
        showErrorToast(xhr.responseJSON);
      },
    });
  });

  // Cargar animales por sexo
  populateSelect(
    '#formPeriodoServicio select[name="hembra_id"]',
    `${baseUrl}api/animales?sexo=HEMBRA&estado=ACTIVO`,
    "Seleccione Animal (Hembra)",
    "animal_id",
    (item) => `${item.identificador} - (${item.raza || "N/A"})`
  );

  populateSelect(
    '#formPeriodoServicio select[name="verraco_id"]',
    `${baseUrl}api/animales?sexo=MACHO&estado=ACTIVO`,
    "Seleccione Animal (MACHO)",
    "animal_id",
    (item) => `${item.identificador} - (${item.raza || "N/A"})`
  );

  // Acciones de los botones en la tabla (Ver, Editar, Eliminar)
  $("#tablaPeriodosMonta").on("click", "button", function () {
    const action = $(this).attr("class");
    const periodo_id = $(this).data("id");

    if (action.includes("btn-editar")) {
      agregarSevicio(periodo_id);
    } else if (action.includes("btn-revision-periodo")) {
      pasarRevision(periodo_id);
    } else if (action.includes("btn-ver")) {
      consultarPeriodo(periodo_id);
    } else if (action.includes("btn-eliminar")) {
      eliminarPeriodo(periodo_id);
    }
  });

  // --- LÓGICA DE DETALLES Y REGISTROS ANIDADOS ---
  let amimalesVerifiacados = false;

  // --- Wizard ---
  document.getElementById("btnSiguientePaso").addEventListener("click", () => {
    if (
      !document.getElementById("verraco_id").value ||
      !document.getElementById("hembra_id").value
    ) {
      Swal.fire("Error", "Debe seleccionar un verraco y una hembra.", "error");
      return;
    }
    if (!amimalesVerifiacados) {
      Swal.fire(
        "Atención",
        `El cruce seleccionado presenta parentesco genético directo. 
            Por favor, elija animales sin relación para evitar problemas de consanguinidad.`,
        "warning"
      );
    }
    const paso2Tab = new bootstrap.Tab(document.querySelector("#paso2-tab"));
    paso2Tab.show();
  });

  document.getElementById("btnAnteriorPaso").addEventListener("click", () => {
    const paso1Tab = new bootstrap.Tab(document.querySelector("#paso1-tab"));
    paso1Tab.show();
  });

  function fitTreeToView(svg, vis, nodes, width, height) {
    if (!nodes || nodes.length === 0) return;

    // Calcula límites del árbol
    const xValues = nodes.map((d) => d.x);
    const yValues = nodes.map((d) => -d.y + 320);

    const minX = Math.min(...xValues);
    const maxX = Math.max(...xValues);
    const minY = Math.min(...yValues);
    const maxY = Math.max(...yValues);

    const treeWidth = maxX - minX;
    const treeHeight = maxY - minY;

    // Margen interno
    const margin = 40;

    // Escala para que quepa en la vista
    const scaleX = (width - margin * 2) / treeWidth;
    const scaleY = (height - margin * 2) / treeHeight;
    const scale = Math.min(scaleX, scaleY, 1.0); // no exagerar zoom

    // Centrar
    const translateX = (width - treeWidth * scale) / 2 - minX * scale;
    const translateY = (height - treeHeight * scale) / 2 - minY * scale;

    vis
      .transition()
      .duration(700)
      .attr(
        "transform",
        `translate(${translateX},${translateY}) scale(${scale})`
      );

    // Ajusta zoom behavior si lo necesitas
    if (svg.__zoom) {
      svg.__zoom.translate = [translateX, translateY];
      svg.__zoom.scale = scale;
    }
  }

  function generarArbolD3(
    data,
    divSelector,
    duplicados = [],
    onNodeClick = null
  ) {
    const width = 600,
      height = 400;

    // ======================================
    // LIMPIAR CONTENIDO PREVIO
    // ======================================
    d3.select(divSelector).selectAll("*").remove();

    // ======================================
    // CREAR SVG Y TOOLBAR
    // ======================================
    const container = d3.select(divSelector);

    // Barra de herramientas con botón Reset
    const toolbar = container
      .append("div")
      .style("text-align", "right")
      .style("margin-bottom", "5px");

    const svg = container
      .append("svg")
      .attr("width", width)
      .attr("height", height)
      .style("border", "1px solid #ddd");

    const vis = svg.append("g").attr("transform", "translate(60, 20)");

    // ======================================
    // ZOOM Y PAN
    // ======================================
    const zoom = d3.behavior
      .zoom()
      .scaleExtent([0.5, 3])
      .on("zoom", function () {
        vis.attr(
          "transform",
          "translate(" + d3.event.translate + ") scale(" + d3.event.scale + ")"
        );
      });

    svg.call(zoom).on("dblclick.zoom", null);

    // ======================================
    // LAYOUT DEL ÁRBOL
    // ======================================
    const tree = d3.layout
      .tree()
      .size([width - 150, height - 100])
      .separation((a, b) => (a.parent === b.parent ? 2 : 3));

    const diagonal = d3.svg.diagonal().projection((d) => [d.x, -d.y + 320]);

    const nodes = tree.nodes(data);
    const links = tree.links(nodes);

    /*const fitBtn = toolbar
      .append("button")
      .text("Mostrar todo el árbol")
      .style("padding", "4px 8px")
      .style("margin-left", "5px")
      .style("font-size", "12px")
      .style("cursor", "pointer");

    fitBtn.on("click", function () {*/
    fitTreeToView(svg, vis, nodes, width, height);
    // });

    fitTreeToView(svg, vis, nodes, width, height);

    // ======================================
    // ENLACES
    // ======================================
    vis
      .selectAll("path.link")
      .data(links)
      .enter()
      .append("path")
      .attr("class", "link")
      .attr("d", diagonal)
      .style("fill", "none")
      .style("stroke", "#ccc")
      .style("stroke-width", "1.5px");

    // ======================================
    // NODOS
    // ======================================
    const node = vis
      .selectAll("g.node")
      .data(nodes)
      .enter()
      .append("g")
      .attr("class", "node")
      .attr("transform", (d) => `translate(${d.x}, ${-d.y + 320})`)
      .style("cursor", "pointer")
      .on("click", function (event, d) {
        if (d.meta && d.meta.animal_id && typeof onNodeClick === "function") {
          onNodeClick(d.meta.animal_id);
          alert(d.meta.animal_id);
        }
      });

    node
      .append("circle")
      .attr("r", 5)
      .style("fill", "#fff")
      .style("stroke", "#000");

    // ======================================
    // ETIQUETAS DINÁMICAS (NO SOBREPUESTAS)
    // ======================================
    const labelGroup = node
      .append("foreignObject")
      .attr("x", (d) => (d.children ? -80 : 8))
      .attr("y", -10)
      .attr("width", (d) => {
        const text = `${d.name || ""}`;
        return Math.min(160, Math.max(60, text.length * 6)); // ancho dinámico
      })
      .attr("height", 40)
      .append("xhtml:div")
      .attr("class", "node-label")
      .style("font-size", "5px")
      .style("background", "rgb(224, 224, 224, 0.5)")
      .style("border-radius", "6px")
      .style("padding", "2px 2px")
      .style("text-align", "center")
      .style("box-shadow", "0 1px 3px rgba(0,0,0,0.2)")
      .html((d) => `${d.name || ""} (${d.meta.sexo[0]})`);

    // Evitar superposición vertical leve ajustando dy según profundidad
    node.attr("transform", (d) => {
      const offsetY = -d.y + 320 + d.depth * 5; // separa niveles
      return `translate(${d.x}, ${offsetY})`;
    });

    // ======================================
    // COLORES DUPLICADOS
    // ======================================
    if (Array.isArray(duplicados) && duplicados.length > 0) {
      duplicados.forEach(({ id_animal, color }) => {
        vis
          .selectAll("g.node")
          .filter((d) => d.meta && d.meta.animal_id === id_animal)
          .select("circle")
          .style("fill", color);
      });
    }
  }

  // VERIFICAR CRUCE
  function verificarArbolGenealogico(verraco, hembra) {
    if (verraco && hembra) {
      $.ajax({
        url: `${baseUrl}api/animales-verificar-cruce`,
        method: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify({
          animal_a: verraco,
          animal_b: hembra,
        }),
        success: function (response) {
          if (response.value == false) {
            amimalesVerifiacados = false;
            $("#infoCruce").show();
            ArbolGenealogicos(verraco, hembra);
          } else {
            d3.select("viz").selectAll("*").remove();
            d3.select("viz2").selectAll("*").remove();
            $("#viz").html("");
            $("#viz2").html("");
            $("#infoCruce").hide();

            amimalesVerifiacados = true;
          }
        },
        error: function (xhr) {
          console.error("Error AJAX:", xhr);
          showErrorToast(
            xhr.responseJSON?.message || "Error inesperado al verificar cruce."
          );
        },
      });
    }
  }

  $(
    '#formPeriodoServicio select[name="verraco_id"], #formPeriodoServicio select[name="hembra_id"]'
  ).on("change", function () {
    const verracoId = $('#formPeriodoServicio select[name="verraco_id"]').val();
    const hembraId = $('#formPeriodoServicio select[name="hembra_id"]').val();
    verificarArbolGenealogico(verracoId, hembraId);
  });

  function obtenerAnimalIds(arbol) {
    const ids = [];

    function recorrer(nodo) {
      if (!nodo || typeof nodo !== "object") return;

      // Si existe meta y tiene animal_id, lo guardamos
      if (nodo.meta && nodo.meta.animal_id) {
        ids.push(nodo.meta.animal_id);
      }

      // Si existen hijos, recorrerlos
      if (Array.isArray(nodo.children)) {
        nodo.children.forEach(recorrer);
      }
    }

    recorrer(arbol);
    return ids;
  }

  function colorRandom() {
    let color, r, g, b, brightness;
    do {
      r = Math.floor(Math.random() * 256);
      g = Math.floor(Math.random() * 256);
      b = Math.floor(Math.random() * 256);
      brightness = 0.299 * r + 0.587 * g + 0.114 * b;
    } while (brightness > 210);
    color =
      "#" + [r, g, b].map((v) => v.toString(16).padStart(2, "0")).join("");
    return color;
  }

  function obtenerDuplicadosTotales(lista1, lista2) {
    // Convierte la segunda lista a Set para búsquedas rápidas
    const set2 = new Set(lista2);

    // Filtra los elementos de la primera que están en la segunda
    const duplicados = lista1.filter((item) => set2.has(item));

    // Elimina posibles duplicados repetidos dentro del mismo array
    return [...new Set(duplicados)];
  }
  function ArbolGenealogicos(verraco, hembra) {
    $.ajax({
      url: `${baseUrl}api/animales/arbol_d3/1`,
      method: "POST",
      contentType: "application/json",
      dataType: "json",
      data: JSON.stringify({
        animal_id: verraco,
        animal_id_2: hembra,
      }),
      success: function (response) {
        const ids1 = obtenerAnimalIds(response.data[1]);
        const ids2 = obtenerAnimalIds(response.data[0]);
        const duplicados = obtenerDuplicadosTotales(ids1, ids2);

        const duplicadosColors = duplicados.map((id) => ({
          id_animal: id,
          color: colorRandom(),
        }));

        generarArbolD3(
          response.data[0],
          "#viz",
          duplicadosColors,
          function (id) {
            console.log("Nodo clickeado:");
          }
        );
        generarArbolD3(
          response.data[1],
          "#viz2",
          duplicadosColors,
          function (id) {
            console.log("Nodo clickeado:");
          }
        );
      },
      error: function (xhr) {
        console.error("Error AJAX:", xhr);
        showErrorToast(
          xhr.responseJSON?.message || "Error inesperado al verificar cruce."
        );
      },
    });
  }

  let currentAnimalIdForDetails = null; // Variable para guardar el ID del animal en vista

  // --- FUNCIONES Y LÓGICA PARA SELECTS DINÁMICOS ---

  /**
   * Populates a select input with data from an API endpoint.
   * @param {string} selector - The jQuery selector for the <select> element.
   * @param {string} url - The API endpoint URL.
   * @param {string} placeholder - The text for the default/placeholder option.
   * @param {string} valueField - The name of the field to use for the option value.
   * @param {string|Function} textField - The name of the field for the option text, or a function to generate it.
   */
  function populateSelect(selector, url, placeholder, valueField, textField) {
    const $select = $(selector);
    $select
      .html(`<option value="">Cargando...</option>`)
      .prop("disabled", true);

    $.ajax({
      url: url,
      method: "GET",
      success: function (response) {
        let options = `<option value="">${placeholder}</option>`;
        if (response.data && response.data.length > 0) {
          response.data.forEach((item) => {
            const text =
              typeof textField === "function"
                ? textField(item)
                : item[textField];
            options += `<option value="${item[valueField]}">${text}</option>`;
          });
        }
        $select.html(options).prop("disabled", false);
      },
      error: function () {
        $select
          .html(`<option value="">Error al cargar</option>`)
          .prop("disabled", true);
      },
    });
  }

  let periodoId = null;
  let numeroServicio = null;
  let fechaServicio = null;
  // --- FUNCIONES AUXILIARES DE EDICIÓN Y ELIMINACIÓN ---
  // --- FUNCIONES AUXILIARES DE EDICIÓN Y ELIMINACIÓN ---
  async function agregarSevicio(animalId) {
    formServicio.reset();

    periodoId = animalId;
    const proximoServicio = await ultimoServicio(periodoId);
    fechaServicio = proximoServicio.data.fecha_siguiente_monta;
    numeroServicio = proximoServicio.data.siguiente_monta;

    let fechaHtml = new Date(fechaServicio).toLocaleDateString("es-ES", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
    });
    document.getElementById("fecha_servicio").value = fechaHtml;
    document.getElementById("periodo_id").value = periodoId;

    modalServicio.show();
  }

  async function ultimoServicio(periodo) {
    return $.ajax({
      url: `${baseUrl}api/servicios/${periodo}/ultimo_servicio`,
      method: "GET",
    });
  }

  // Consultar periodo de monta
  let periodoActual = null;
  function consultarPeriodo(id = null) {
    periodoActual = id ?? periodoActual;

    $.ajax({
      url: `${baseUrl}api/periodos_servicios/${id}`,
      method: "GET",
      success: function (response) {
        //document.write("<pre>" + JSON.stringify(response, null, 2) + "</pre>");
        console.log(response);
        modalDetalles.show();
        renderPeriodo(response);
      },
      error: function (xhr) {
        console.log(xhr);
        showErrorToast(xhr.responseJSON);
      },
    });
  }

  function renderPeriodo(data) {
    const d = data.data;

    $("#hembraIdent").html(d.hembra_identificador || "—");
    $("#verracoIdent").html(d.verraco_identificador || "—");
    $("#fechaInicio").html(formatDate(d.fecha_inicio) || "—");
    setEstadoPeriodo(d.estado_periodo || "—");

    // Llenar tabla de servicios
    const filas = (d.servicios || [])
      .slice()
      .sort((a, b) => a.numero_monta - b.numero_monta);
    const $tbody = $("#tablaServicios tbody").empty();
    if (filas.length === 0) {
      $tbody.append(
        '<tr><td colspan="4" class="text-center text-muted py-3">No hay servicios</td></tr>'
      );
    }

    filas.forEach((s) => {
      const badgeClass =
        s.estatus === "REALIZADO"
          ? "bg-success"
          : s.estatus === "CANCELADO"
          ? "bg-danger"
          : "bg-warning ";
      const $tr = $(
        `<tr data-monta-id="${s.monta_id}">
    <td><strong>${s.numero_monta}</strong></td>
    <td>${formatDate(s.fecha_monta)} - ${d.hora_servicio}</td>
    <td><span class="badge ${badgeClass} status-badge" data-estatus="${
          s.estatus
        }">${s.estatus}</span></td>
        <td>${s.estatus === "REALIZADO" ? "" : s.estado_servicio}</td>
    <td class="text-end">
    ${
      s.estatus === "REALIZADO"
        ? ""
        : `<button class="btn btn-sm btn-outline-primary btn-min btn-toggle-estatus" data-monta-id="${s.monta_id}" title="Cambiar estatus">
    <i class="bi bi-check2-circle"></i>
    </button>`
    }
    </td>
    </tr>`
      );
      $tbody.append($tr);
    });
  }

  document.addEventListener("click", function (event) {
    if (event.target.closest(".btn-toggle-estatus")) {
      const button = event.target.closest(".btn-toggle-estatus");
      const montaId = button.getAttribute("data-monta-id");
      actualizarMonta(montaId);
    }
  });

  function actualizarMonta(montaId) {
    $.ajax({
      url: `${baseUrl}api/servicios/${montaId}`,
      method: "POST",
      contentType: "application/json",
      dataType: "json",
      data: JSON.stringify({
        // aquí podrías enviar datos adicionales si tu controlador los necesita
        montaId: montaId, // ejemplo opcional
      }),
      success: function (response) {
        // gestiona resupesta, response.value == true y con el toast muestra message
        if (response.value == true) {
          Swal.fire("¡Éxito!", response.message, "success");
          consultarPeriodo(periodoActual); // refresca la vista del periodo
          $("#tablaPeriodosMonta").bootstrapTable("refresh");
        }
      },
      error: function (xhr, status, error) {
        console.error("❌ Error en la solicitud:", xhr.responseText || error);
        alert("Ocurrió un error al actualizar la monta.");
      },
    });
  }

  function formatDate(iso) {
    if (!iso) return "—";

    // Acepta formato YYYY-MM-DD o YYYY-MM-DD HH:MM:SS
    const fecha = new Date(iso);
    if (isNaN(fecha)) return iso;

    // Opciones de formato en español
    const opciones = {
      day: "numeric",
      month: "long",
      year: "numeric",
    };

    return fecha.toLocaleDateString("es-ES", opciones);
  }
  function setEstadoPeriodo(estado) {
    const $b = $("#estadoPeriodo");
    $b.text(estado || "—");
    $b.removeClass(
      "bg-secondary bg-success bg-danger bg-info bg-warning text-dark text-white"
    );
    if (estado === "ABIERTO") $b.addClass("bg-success text-white");
    else if (estado === "CERRADO") $b.addClass("bg-secondary text-white");
    else if (estado === "SUSPENDIDO") $b.addClass("bg-warning text-dark");
    else $b.addClass("bg-info text-white");
  }

  // Cerrar periodo de monta
  function pasarRevision(periodo) {
    Swal.fire({
      title: "¿Estás seguro?",
      text: "El periodo de monta pasara a revisión y no podrá ser modificado desde este modulo.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#3085d6",
      confirmButtonText: "Sí, cambiar estatus",
      cancelButtonText: "Cancelar",
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
          url: `${baseUrl}api/periodos_servicios/${periodo}/revision`,
          method: "POST",
          success: function (response) {
            console.log("RESPONSE " + response); // 👀 Mira qué llega
            Swal.fire("Cerrado", response.mensaje, "success");
            $("#tablaPeriodosMonta").bootstrapTable("refresh");
          },
          error: function (xhr) {
            showErrorToast(xhr.responseJSON);
          },
        });
      }
    });
  }

  function eliminarPeriodo(periodo) {
    Swal.fire({
      title: "¿Estás seguro?",
      text: "El periodo de monta se eliminara definitivamente.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#3085d6",
      confirmButtonText: "Sí, cerrar",
      cancelButtonText: "Cancelar",
    }).then((result) => {
      if (result.isConfirmed) {
        $.ajax({
          url: `${baseUrl}api/periodos_servicios/${periodo}`,
          method: "delete",
          success: function (response) {
            Swal.fire("Eliminado", response.mensaje, "success");
            $("#tablaPeriodosMonta").bootstrapTable("refresh");
          },
          error: function (xhr) {
            showErrorToast(xhr.responseJSON);
          },
        });
      }
    });
  }
});

// here
