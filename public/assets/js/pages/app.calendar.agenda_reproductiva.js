document.addEventListener("DOMContentLoaded", function () {
  let calendarEl = document.getElementById("calendar");
  let eventModalRevision = new bootstrap.Modal(
    document.getElementById("eventModalRevision")
  );
  let currentEvent = null;

  let calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: "dayGridMonth",
    themeSystem: "bootstrap5",
    locale: "es",
    buttonText: {
      today: "Hoy",
      month: "Mes",
      week: "Semana",
      day: "Dia",
      list: "Lista",
      prev: "Previo",
      next: "Siguiente",
    },

    headerToolbar: {
      left: "prev,next today",
      center: "title",
      right: "dayGridMonth,timeGridWeek,timeGridDay,listMonth",
    },

    events: function (info, successCallback, failureCallback) {
      $.ajax({
        url: baseUrl + "api/agenda_reproductiva",
        method: "GET",
        dataType: "json",
        data: {
          start: info.startStr,
          end: info.endStr,
        },
        success: function (response) {
          successCallback(response.data);
        },
        error: function () {
          failureCallback();
        },
      });
    },

    eventClick: function (info) {
      currentEvent = info.event;
      if (currentEvent.title === "Revisión Servicio") {
        accionRevision(currentEvent);
      }
    },
  });

  calendar.render();
  let idRevisionActual = null;

  // Guardar formulario personalizado
  $("#btnSaveCustom").on("click", function () {
    const resultado = {
      revision_id: idRevisionActual,
      observaciones: $("#eventNotes").val(),
      resultado: $("#eventStatus").val(),
    };

    // enviar al back
    $.ajax({
      url: baseUrl + "api/revisiones-servicio/" + idRevisionActual,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(resultado),
      success: function (response) {
        console.log(response);
          Swal.fire("¡Éxito!", response.message, "success");
          eventModalRevision.hide();
          // TODO: actualizar los eventos del calendario
          calendar.refetchEvents();
      },
      error: function () {
        alert("Error al guardar la revisión.");
      },
    });
  });

  function accionRevision(evento) {
    const datos = evento._def.extendedProps.detalles;
    idRevisionActual = evento._def.publicId;
    renderPeriodo(datos);

    eventModalRevision.show();
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
  function renderPeriodo(data) {
    const d = data;

    $("#hembraIdent").html(d.hembra_identificador || "—");
    $("#verracoIdent").html(d.verraco_identificador || "—");
    $("#fechaInicio").html(formatDate(d.fecha_inicio) || "—");

    // Llenar tabla de servicios
    const filas = (d.servicios || [])
      .slice()
      .sort((a, b) => a.numero_monta - b.numero_monta);
    const $tbody = $("#tablaServicios tbody").empty();
    if (filas.length === 0) {
      $tbody.append(
        '<tr><td colspan="3" class="text-center text-muted py-3">No hay servicios</td></tr>'
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
    </tr>`
      );
      $tbody.append($tr);
    });
  }

  function accionParto(params) {}
});
