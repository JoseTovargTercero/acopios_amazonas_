const modificarDatos = (obj) =>
  Object.values(obj)
    .reverse()
    .reduce((acc, v, i) => ({ ...acc, [i]: v }), {})

// 1. Declaramos una variable global en el módulo para guardar la instancia
let chartInstance = null

export function cargarGraficoPesos(data) {
  let pesoOptimo = []
  let pesoAnimal = []
  let intervalos = []

  const datos = modificarDatos(data)

  for (const key in datos) {
    const item = datos[key]
    if (item.peso_ideal) {
      pesoOptimo.push(parseInt(item.peso_ideal))
    }
    pesoAnimal.push(parseInt(item.peso_kg))
    intervalos.push(item.edad_dias + ' Dias')
  }

  // 2. Referencia al elemento del DOM
  const chartElement = document.querySelector('#peso-chart')

  // Validación de seguridad por si el modal no está abierto
  if (!chartElement) return

  // 3. ¡EL FIX!: Si ya existe una instancia previa, la destruimos limpiamente
  if (chartInstance) {
    chartInstance.destroy()
  }

  // Colores
  let colors = ['#0acf97', '#727cf5', '#fa5c7c', '#ffbc00']
  // Corregido: Usamos chartElement para obtener el data-colors correctamente
  const dataColors = chartElement.getAttribute('data-colors')
  if (dataColors) colors = dataColors.split(',')

  // Configuración del gráfico
  const options = {
    chart: {
      height: 364,
      type: 'line',
      toolbar: { show: false },
      dropShadow: {
        enabled: true,
        opacity: 0.2,
        blur: 7,
        left: -7,
        top: 7,
      },
    },
    dataLabels: { enabled: false },
    stroke: { curve: 'smooth', width: 4 },
    series: [
      { name: 'Peso Optimo', data: pesoOptimo },
      { name: 'Peso del Animal', data: pesoAnimal },
    ],
    colors: colors,
    zoom: { enabled: false },
    legend: { show: true },
    xaxis: {
      categories: intervalos,
      axisBorder: { show: false },
    },
    yaxis: {
      labels: {
        formatter: (val) => val + ' kg',
        offsetX: -15,
      },
    },
  }

  // 4. Renderizar y guardar la nueva instancia en la variable
  chartInstance = new ApexCharts(chartElement, options)
  chartInstance.render()
}
