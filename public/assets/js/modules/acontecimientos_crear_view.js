import { showErrorToast, showSuccessToast } from "../helpers/helpers.js";

// Objeto global para almacenar las instancias de TomSelect
const tomSelectInstances = {};

document.addEventListener("DOMContentLoaded", function () {
  // Modo de selección de animales
  const animalesSeleccion = document.getElementById("animales_seleccion");
  const secciones_animales = document.querySelectorAll(".sections_select");

  if (animalesSeleccion) {
    animalesSeleccion.addEventListener("change", function () {
      const tipo = this.value;

      // Ocultar todas las secciones_animales
      secciones_animales.forEach((sec) => sec.classList.add("hide"));

      // Mostrar solo la sección correspondiente
      switch (tipo) {
        case "fincas":
          document.getElementById("sect_fincas").classList.remove("hide");
          break;
        case "apriscos":
          document.getElementById("sect_apriscos").classList.remove("hide");
          break;
        case "areas":
          document.getElementById("sect_areas").classList.remove("hide");
          break;
        case "manual":
          document.getElementById("sect_animales").classList.remove("hide");
          break;
      }
    });
  }

  // Mostrar campos específicos según tipo de acontecimiento
  const tipoSelect = document.getElementById("tipo");
  const secciones = document.querySelectorAll('[id^="campos-"]');

  if (tipoSelect) {
    tipoSelect.addEventListener("change", function () {
      // Oculta todos los bloques
      secciones.forEach((sec) => sec.classList.add("hide"));
      // Muestra el que corresponde
      const id = this.value ? `campos-${this.value}` : null;
      if (id) {
        const element = document.getElementById(id);
        if (element) element.classList.remove("hide");
      }

      // Muestra u oculta la sección de animales involucrados
      const animalesSection = document.getElementById("animales_involucrados");
      if (animalesSection) {
        if (this.value !== "limpieza") {
          animalesSection.classList.remove("hide");
        } else {
          animalesSection.classList.add("hide");
        }
      }
    });
  }

  // Cargar selects
  populateSelect(
    '#formAcontecimiento select[name="animales"]',
    `${baseUrl}api/animales?estado=ACTIVO`,
    "Seleccione Animal",
    "animal_id",
    (item) => `${item.identificador} - (${item.raza || "N/A"})`
  );
  populateSelect(
    '#formAcontecimiento select[name="fincas"]',
    `${baseUrl}api/fincas`,
    "Seleccione la finca",
    "finca_id",
    (item) => `${item.nombre}`
  );
  populateSelect(
    '#formAcontecimiento select[name="apriscos"]',
    `${baseUrl}api/apriscos`,
    "Seleccione el aprisco",
    "aprisco_id",
    (item) => `${item.nombre} - (Finca: ${item.nombre_finca})`
  );
  populateSelect(
    '#formAcontecimiento select[name="areas"]',
    `${baseUrl}api/areas`,
    "Seleccione el area",
    "area_id",
    (item) =>
      `${item.numeracion} - ${item.nombre_personalizado} - (Aprisco: ${item.nombre_aprisco}, Finca: ${item.nombre_finca})`
  );
  populateSelect(
    '#formAcontecimiento select[name="limpieza_area"]',
    `${baseUrl}api/areas`,
    "Seleccione el area",
    "area_id",
    (item) =>
      `${item.numeracion} - ${item.nombre_personalizado} - (Aprisco: ${item.nombre_aprisco}, Finca: ${item.nombre_finca})`
  );

  // Image preview functionality
  setupImagePreview();
});

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
  if ($select.length === 0) return;

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
      const id_select = $select[0].id;
      $select.html(options).prop("disabled", false);

      const select = document.querySelector("#" + id_select);

      if (select && !tomSelectInstances[id_select]) {
        tomSelectInstances[id_select] = new TomSelect(select, {
          plugins: ["remove_button"],
          create: false,
          placeholder: "Buscar o seleccionar...",
        });
      }
    },
    error: function () {
      $select
        .html(`<option value="">Error al cargar</option>`)
        .prop("disabled", true);
    },
  });
}

// --- IMAGE PREVIEW FUNCTIONALITY ---

function setupImagePreview() {
  const fileInput = document.querySelector('input[name="photo[]"]');
  const previewContainer = document.getElementById('image-preview-container');
  
  if (!fileInput || !previewContainer) return;

  fileInput.addEventListener('change', function(e) {
    const files = Array.from(e.target.files);
    previewContainer.innerHTML = '';
    
    if (files.length === 0) return;

    files.forEach((file, index) => {
      if (!file.type.startsWith('image/')) return;

      const reader = new FileReader();
      reader.onload = function(e) {
        const col = document.createElement('div');
        col.className = 'col-md-3 mb-2';
        col.innerHTML = `
          <div class="position-relative">
            <img src="${e.target.result}" class="img-fluid rounded" style="height: 150px; width: 100%; object-fit: cover;">
            <button type="button" class="btn btn-danger btn-sm position-absolute top-0 end-0 m-1" onclick="removeImage(${index})">
              <i class="mdi mdi-close"></i>
            </button>
          </div>
        `;
        previewContainer.appendChild(col);
      };
      reader.readAsDataURL(file);
    });
  });
}

/**
 * Aplica validación decimal:
 * - solo números
 * - un punto decimal
 * - máximo 2 decimales
 */
function aplicarFormatoDecimal(selector) {
    const inputs = document.querySelectorAll(selector);

    inputs.forEach(input => {

        input.addEventListener('input', function () {
            let value = this.value;

            // Quitar caracteres inválidos
            value = value.replace(/[^0-9.]/g, '');

            // Permitir solo un punto
            const parts = value.split('.');
            if (parts.length > 2) {
                value = parts[0] + '.' + parts.slice(1).join('');
            }

            // Limitar a 2 decimales
            if (parts[1]?.length > 2) {
                value = parts[0] + '.' + parts[1].substring(0, 2);
            }

            this.value = value;
        });

        // Opcional: forzar 2 decimales al salir del campo
        input.addEventListener('blur', function () {
            if (this.value !== '') {
                this.value = parseFloat(this.value).toFixed(2);
            }
        });

    });
}

// Aplicar a los dos campos
aplicarFormatoDecimal('#ingreso, #kilogramos');



window.removeImage = function(index) {
  const fileInput = document.querySelector('input[name="photo[]"]');
  const previewContainer = document.getElementById('image-preview-container');
  
  if (!fileInput) return;

  const dt = new DataTransfer();
  const files = Array.from(fileInput.files);
  
  files.forEach((file, i) => {
    if (i !== index) {
      dt.items.add(file);
    }
  });
  
  fileInput.files = dt.files;
  
  // Rebuild preview
  previewContainer.innerHTML = '';
  Array.from(fileInput.files).forEach((file, i) => {
    const reader = new FileReader();
    reader.onload = function(e) {
      const col = document.createElement('div');
      col.className = 'col-md-3 mb-2';
      col.innerHTML = `
        <div class="position-relative">
          <img src="${e.target.result}" class="img-fluid rounded" style="height: 150px; width: 100%; object-fit: cover;">
          <button type="button" class="btn btn-danger btn-sm position-absolute top-0 end-0 m-1" onclick="removeImage(${i})">
            <i class="mdi mdi-close"></i>
          </button>
        </div>
      `;
      previewContainer.appendChild(col);
    };
    reader.readAsDataURL(file);
  });
};

// --- FORM SUBMISSION ---

const formAcontecimiento = document.getElementById("formAcontecimiento");
if (formAcontecimiento) {
  formAcontecimiento.addEventListener("submit", async function (e) {
    e.preventDefault();

    const form = e.target;
    const tipo = form.tipo.value;
    if (!tipo) {
      showErrorToast({ message: "Seleccione un tipo de acontecimiento." });
      return;
    }

    const formData = new FormData();
    formData.append("tipo", tipo);

    // Campos específicos según tipo
    const camposPorTipo = {
      vacunacion: ["vacuna_nombre", "vacuna_fecha", "vacuna_dosis"],
      decesos: ["deceso_cantidad", "deceso_causa", "deceso_fecha"],
      revision: ["revision_veterinario", "revision_fecha"],
      cuarentena: ["cuarentena_inicio", "cuarentena_fin", "cuarentena_motivo"],
      tratamiento: ["tratamiento_medicamento", "tratamiento_dosis"],
      brote: ["brote_tipo", "brote_afectados", "brote_severidad"],
      limpieza: ["limpieza_area", "limpieza_fecha"],
      beneficios: ["ingreso", "kilogramos"]
    };

    if (camposPorTipo[tipo]) {
      for (const campo of camposPorTipo[tipo]) {
        const input = document.getElementById(campo);
        if (input && input.value.trim() !== "") {
          formData.append(campo, input.value.trim());
        } else {
          showErrorToast({ message: `El campo ${campo.replace(/_/g, " ")} es obligatorio.` });
          return;
        }
      }
    }

    // Si tipo != limpieza → recuperar animales involucrados
    if (tipo !== "limpieza") {
      const animalesSel = document.getElementById("animales_seleccion");
      const modoSeleccion = animalesSel ? animalesSel.value : "";
      if (!modoSeleccion) {
        showErrorToast({ message: "Seleccione el modo de selección de animales involucrados." });
        return;
      }
      formData.append("animales_seleccion", modoSeleccion);

      // Campos según modo de selección
      const camposModo = {
        fincas: "fincas",
        apriscos: "apriscos",
        areas: "areas",
        manual: "animales",
      };

      const campo = camposModo[modoSeleccion];
      const input = document.getElementById(campo);
      if (input) {
        if (input.multiple) {
          const selected = Array.from(input.selectedOptions).map(
            (opt) => opt.value
          );
          if (selected.length === 0) {
            showErrorToast({ message: `Debe seleccionar al menos un valor en ${campo}.` });
            return;
          }
          selected.forEach((v) => formData.append(`${campo}[]`, v));
        } else if (input.value.trim() === "") {
          showErrorToast({ message: `El campo ${campo} es obligatorio.` });
          return;
        } else {
          formData.append(campo, input.value.trim());
        }
      }
    } else {
      // si es limpieza, recuperar limpieza_area
      const limpiezaAreaSelect = document.getElementById("limpieza_area");
      const selectedAreas = Array.from(limpiezaAreaSelect.selectedOptions).map(
        (opt) => opt.value
      );
      if (selectedAreas.length === 0) {
        showErrorToast({ message: "Debe seleccionar al menos un área en limpieza." });
        return;
      }
      selectedAreas.forEach((v) => formData.append("limpieza_area[]", v));
    }

    // Fotos (no obligatorio)
    const fotos = form.querySelector('input[name="photo[]"]');
    if (fotos && fotos.files.length > 0) {
      for (const file of fotos.files) {
        formData.append("photo[]", file);
      }
    }

    // Observación
    formData.append("observacion", form.observacion.value.trim() || "");

    // Envío AJAX
    try {
      const response = await fetch(`${baseUrl}api/acontecimientos`, {
        method: "POST",
        body: formData,
      });

      let resultText = await response.text();

      let result;
      try {
        result = JSON.parse(resultText);
      } catch {
        result = null;
      }

      if (response.ok) {
        console.log("Respuesta completa del servidor:", result || resultText);
        showSuccessToast({ message: "Acontecimiento guardado correctamente." });

        // Limpiar formulario
        form.reset();

        // Ocultar secciones
        document
          .querySelectorAll(".sections_select")
          .forEach((sec) => sec.classList.add("hide"));
        document
          .querySelectorAll('[id^="campos-"]')
          .forEach((sec) => sec.classList.add("hide"));

        // Limpiar todos los TomSelect cargados
        for (const id in tomSelectInstances) {
          if (tomSelectInstances[id]) {
            tomSelectInstances[id].clear();
          }
        }

        // Limpiar select principal de modo de animales
        const animalesSeleccion = document.getElementById("animales_seleccion");
        if (animalesSeleccion) animalesSeleccion.value = "";
        
        // Limpiar preview de imagenes
        const previewContainer = document.getElementById('image-preview-container');
        if (previewContainer) {
            previewContainer.innerHTML = '';
        }

        // Redirigir al muro después de 1.5 segundos
        setTimeout(() => {
          window.location.href = `${baseUrl}acontecimientos`;
        }, 1500);
      } else {
        console.error("Error del servidor:", result || resultText);
        showErrorToast({ message: (result && result.message) || resultText || "Error desconocido" });
      }
    } catch (err) {
      console.error("💥 Error en fetch:", err);
      showErrorToast({ message: "Error cargando los datos" });
    }
  });
}
