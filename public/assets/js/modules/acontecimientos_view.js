import { showErrorToast, showSuccessToast, formatDateTime } from "../helpers/helpers.js";

// --- FUNCIONES PARA EL FEED SOCIAL ---

async function loadEvents() {
  const container = document.getElementById("social-feed-container");
  if (!container) return;

  container.innerHTML =
    '<div class="text-center mt-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div></div>';

  try {
    const response = await fetch(`${baseUrl}api/acontecimientos`);
    const result = await response.json();

    if (result.value) {
      // Store events globally for carousel access
      window.currentEvents = result.data;
      renderEvents(result.data);
    } else {
      container.innerHTML = `<div class="alert alert-danger">Error al cargar eventos: ${result.message}</div>`;
    }
  } catch (error) {
    console.error("Error loading events:", error);
    container.innerHTML = `<div class="alert alert-danger">Error de conexión al cargar eventos.</div>`;
  }
}

function renderEvents(events) {
  const container = document.getElementById("social-feed-container");
  container.innerHTML = "";

  if (!events || events.length === 0) {
    container.innerHTML =
      '<div class="text-center mt-3"><p class="text-muted">No hay acontecimientos registrados aún.</p></div>';
    return;
  }

  events.forEach((event, eventIndex) => {
    // Format event date (fecha) - without time
    const eventDate = event.fecha ? new Date(event.fecha).toLocaleDateString('es-ES', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    }) : '';
    
    // Format created_at with time using helper
    const createdAt = event.created_at ? formatDateTime(event.created_at) : '';

    let photosHtml = "";
    if (event.fotos_urls && event.fotos_urls.length > 0) {
      const totalPhotos = event.fotos_urls.length;
      const maxDisplay = 4;
      const photosToShow = Math.min(totalPhotos, maxDisplay);
      const remainingPhotos = totalPhotos - maxDisplay;
      
      photosHtml = '<div class="row g-2 mt-2">';
      
      // Layout based on number of photos
      if (totalPhotos === 1) {
        // Single image - full width
        photosHtml += `
          <div class="col-12">
            <img src="${baseUrl}uploads/acontecimientos/${event.fotos_urls[0]}" 
                 alt="post-img" 
                 class="img-fluid rounded" 
                 style="max-height: 400px; width: 100%; object-fit: cover; cursor: pointer;"
                 onclick="openImageCarousel(${eventIndex}, 0)">
          </div>
        `;
      } else if (totalPhotos === 2) {
        // Two images - side by side
        event.fotos_urls.forEach((photoUrl, photoIndex) => {
          photosHtml += `
            <div class="col-6">
              <img src="${baseUrl}uploads/acontecimientos/${photoUrl}" 
                   alt="post-img" 
                   class="img-fluid rounded" 
                   style="height: 250px; width: 100%; object-fit: cover; cursor: pointer;"
                   onclick="openImageCarousel(${eventIndex}, ${photoIndex})">
            </div>
          `;
        });
      } else if (totalPhotos === 3) {
        // Three images - first full width, next two side by side
        photosHtml += `
          <div class="col-12">
            <img src="${baseUrl}uploads/acontecimientos/${event.fotos_urls[0]}" 
                 alt="post-img" 
                 class="img-fluid rounded" 
                 style="height: 250px; width: 100%; object-fit: cover; cursor: pointer;"
                 onclick="openImageCarousel(${eventIndex}, 0)">
          </div>
        `;
        for (let i = 1; i < 3; i++) {
          photosHtml += `
            <div class="col-6">
              <img src="${baseUrl}uploads/acontecimientos/${event.fotos_urls[i]}" 
                   alt="post-img" 
                   class="img-fluid rounded" 
                   style="height: 200px; width: 100%; object-fit: cover; cursor: pointer;"
                   onclick="openImageCarousel(${eventIndex}, ${i})">
            </div>
          `;
        }
      } else {
        // Four or more images - 2x2 grid
        for (let i = 0; i < photosToShow; i++) {
          const isLast = i === photosToShow - 1 && remainingPhotos > 0;
          photosHtml += `
            <div class="col-6 position-relative">
              <img src="${baseUrl}uploads/acontecimientos/${event.fotos_urls[i]}" 
                   alt="post-img" 
                   class="img-fluid rounded" 
                   style="height: 200px; width: 100%; object-fit: cover; cursor: pointer;"
                   onclick="openImageCarousel(${eventIndex}, ${i})">
              ${isLast ? `
                <div class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center rounded" 
                     style="background-color: rgba(0,0,0,0.6); cursor: pointer;"
                     onclick="openImageCarousel(${eventIndex}, ${i})">
                  <h2 class="text-white mb-0">+${remainingPhotos}</h2>
                </div>
              ` : ''}
            </div>
          `;
        }
      }
      
      photosHtml += "</div>";
    }

    // Status badge
    const statusBadge = event.estado === 'CERRADO' 
      ? '<span class="badge bg-secondary float-end status-badge">CERRADO</span>'
      : '<span class="badge bg-success float-end status-badge">ABIERTO</span>';

    // Action button (only show "Cerrar" if estado is ABIERTO)
    const actionButton = event.estado === 'ABIERTO'
      ? `<button class="btn btn-warning btn-sm mt-2 btn-cerrar-acontecimiento" onclick="cerrarAcontecimiento('${event.acontecimiento_id}')">
           <i class="mdi mdi-check-circle"></i> Cerrar Acontecimiento
         </button>`
      : '';

    const html = `
      <div class="card mb-3 acontecimiento-card" data-acontecimiento-id="${event.acontecimiento_id}">
        <div class="card-body">
          ${statusBadge}
          <div class="d-flex align-items-start mb-3">
            <img class="me-2 avatar-sm rounded-circle" src="${baseUrl}public/assets/images/users/avatar-1.jpg" alt="Generic placeholder image">
            <div class="w-100">
              <h5 class="m-0">${event.created_by_name || "Usuario"}</h5>
              <p class="text-muted mb-0"><small>${createdAt}</small></p>
            </div>
          </div>
          
          <h5 class="text-primary text-uppercase">${event.tipo}</h5>
          ${eventDate ? `<p class="text-muted mb-2"><small><i class="mdi mdi-calendar"></i> ${eventDate}</small></p>` : ''}
          <p>${event.observacion || ""}</p>
          
          ${photosHtml}
          
          <div class="action-buttons-container">
            ${actionButton}
          </div>
        </div>
      </div>
    `;
    container.innerHTML += html;
  });

  // Create carousel modal after rendering all events
  createCarouselModal();
}

// --- CAROUSEL MODAL FUNCTIONS ---

function createCarouselModal() {
  // Check if modal already exists
  if (document.getElementById('imageCarouselModal')) {
    return;
  }
  
  const modalHtml = `
    <div class="modal fade" id="imageCarouselModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Imágenes del acontecimiento</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body p-0">
            <div id="imageCarousel" class="carousel slide" data-bs-ride="false">
              <div class="carousel-inner">
                <!-- Images will be dynamically inserted here -->
              </div>
              <a class="carousel-control-prev" href="#imageCarousel" role="button" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Anterior</span>
              </a>
              <a class="carousel-control-next" href="#imageCarousel" role="button" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Siguiente</span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  `;
  
  document.body.insertAdjacentHTML('beforeend', modalHtml);
}

function updateCarouselImages(photos) {
  const carouselInner = document.querySelector('#imageCarousel .carousel-inner');
  carouselInner.innerHTML = '';
  
  photos.forEach((photoUrl, index) => {
    const activeClass = index === 0 ? 'active' : '';
    carouselInner.innerHTML += `
      <div class="carousel-item ${activeClass}">
        <img src="${baseUrl}uploads/acontecimientos/${photoUrl}" class="d-block w-100" alt="Imagen ${index + 1}">
      </div>
    `;
  });
}

window.openImageCarousel = function(eventIndex, photoIndex) {
  const modal = new bootstrap.Modal(document.getElementById('imageCarouselModal'));
  const carousel = document.getElementById('imageCarousel');
  const bsCarousel = bootstrap.Carousel.getInstance(carousel) || new bootstrap.Carousel(carousel);
  
  // Get the event data
  const event = window.currentEvents[eventIndex];
  
  // Update carousel with event images
  updateCarouselImages(event.fotos_urls);
  
  // Navigate to the clicked image
  bsCarousel.to(photoIndex);
  
  // Show modal
  modal.show();
};

// --- STATUS UPDATE FUNCTION ---

window.cerrarAcontecimiento = async function(acontecimiento_id) {
  // Use SweetAlert2 for confirmation
  const result = await Swal.fire({
    title: '¿Cerrar acontecimiento?',
    text: 'Esta acción marcará el evento como finalizado.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Sí, cerrar',
    cancelButtonText: 'Cancelar'
  });

  if (!result.isConfirmed) {
    return;
  }
  
  // Get the card element
  const card = document.querySelector(`.acontecimiento-card[data-acontecimiento-id="${acontecimiento_id}"]`);
  if (!card) {
    console.error('Card not found for acontecimiento_id:', acontecimiento_id);
    return;
  }

  // Add loading state to button
  const button = card.querySelector('.btn-cerrar-acontecimiento');
  if (button) {
    button.disabled = true;
    button.innerHTML = '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>Cerrando...';
  }

  // Add pulse animation to card
  card.classList.add('border-warning');
  card.style.animation = 'pulse 0.5s ease-in-out';
  
  try {
    const formData = new FormData();
    formData.append('acontecimiento_id', acontecimiento_id);
    formData.append('estado', 'CERRADO');
    
    const response = await fetch(`${baseUrl}api/acontecimientos/${acontecimiento_id}/estado`, {
      method: 'POST',
      body: formData
    });
    
    const responseData = await response.json();
    
    if (responseData.value) {
      // Success animation
      card.style.animation = 'fadeOutScale 0.5s ease-in-out';
      
      // Wait for animation to complete
      await new Promise(resolve => setTimeout(resolve, 500));
      
      // Update the card content dynamically
      const statusBadge = card.querySelector('.status-badge');
      const actionContainer = card.querySelector('.action-buttons-container');
      
      if (statusBadge) {
        statusBadge.classList.remove('bg-success');
        statusBadge.classList.add('bg-secondary');
        statusBadge.textContent = 'CERRADO';
        statusBadge.style.animation = 'fadeIn 0.5s ease-in-out';
      }
      
      if (actionContainer) {
        actionContainer.style.animation = 'fadeOut 0.3s ease-in-out';
        await new Promise(resolve => setTimeout(resolve, 300));
        actionContainer.innerHTML = '';
      }
      
      // Remove border and reset animation
      card.classList.remove('border-warning');
      card.classList.add('border-success');
      card.style.animation = 'fadeInScale 0.5s ease-in-out';
      
      // Show success message
      await Swal.fire({
        title: '¡Éxito!',
        text: 'Acontecimiento cerrado correctamente',
        icon: 'success',
        timer: 1500,
        showConfirmButton: false
      });
      
      // Remove success border after a moment
      setTimeout(() => {
        card.classList.remove('border-success');
        card.style.animation = '';
      }, 2000);
      
    } else {
      // Reset button on error
      if (button) {
        button.disabled = false;
        button.innerHTML = '<i class="mdi mdi-check-circle"></i> Cerrar Acontecimiento';
      }
      card.classList.remove('border-warning');
      card.style.animation = '';
      
      Swal.fire({
        title: 'Error',
        text: responseData.message || 'Error al cerrar acontecimiento',
        icon: 'error'
      });
    }
  } catch (error) {
    console.error('Error al cerrar acontecimiento:', error);
    
    // Reset button on error
    if (button) {
      button.disabled = false;
      button.innerHTML = '<i class="mdi mdi-check-circle"></i> Cerrar Acontecimiento';
    }
    card.classList.remove('border-warning');
    card.style.animation = '';
    
    Swal.fire({
      title: 'Error',
      text: 'Error al cerrar acontecimiento',
      icon: 'error'
    });
  }
};

// --- INITIALIZATION ---

document.addEventListener("DOMContentLoaded", function () {
  loadEvents();
});
