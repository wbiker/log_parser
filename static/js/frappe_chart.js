// import { Chart } from "frappe-charts/dist/frappe-charts.esm.js";
// import "frappe-charts/dist/frappe-charts.min.css";

// new Chart("#chart", {
//   // or DOM element
//   data: {
//     labels: [
//       "12am-3am",
//       "3am-6am",
//       "6am-9am",
//       "9am-12pm",
//       "12pm-3pm",
//       "3pm-6pm",
//       "6pm-9pm",
//       "9pm-12am"
//     ],

//     datasets: [
//       {
//         name: "Some Data",
//         chartType: "bar",
//         values: [25, 40, 30, 35, 8, 52, 17, -4]
//       },
//       {
//         name: "Another Set",
//         chartType: "bar",
//         values: [25, 50, -10, 15, 18, 32, 27, 14]
//       },
//       {
//         name: "Yet Another",
//         chartType: "line",
//         values: [15, 20, -3, -15, 58, 12, -17, 37]
//       }
//     ],

//     yMarkers: [{ label: "Marker", value: 70, options: { labelPos: "left" } }],
//     yRegions: [
//       { label: "Region", start: -10, end: 50, options: { labelPos: "right" } }
//     ]
//   },

//   title: "My Awesome Chart",
//   type: "axis-mixed", // or 'bar', 'line', 'pie', 'percentage'
//   height: 300,
//   colors: ["purple", "#ffa3ef", "light-blue"],
//   axisOptions: {
//     xAxisMode: "tick",
//     xIsSeries: true
//   },
//   barOptions: {
//     stacked: true,
//     spaceRatio: 0.5
//   },
//   tooltipOptions: {
//     formatTooltipX: (d) => (d + "").toUpperCase(),
//     formatTooltipY: (d) => d + " pts"
//   }
// });

document.addEventListener('DOMContentLoaded', (event) => {
    let project_select = document.getElementById('projects');
    project_select.onchange = get_project_data;
});

async function get_project_data(event) {
    let select = event.target;
    if (select.selectedIndex < 1) {
        return
    }

    let response = await fetch(`/project/${select[select.selectedIndex].value}`);

    if (response.ok) { // if HTTP-status is 200-299
        // get the response body (the method explained below)
        let json = await response.json();
        write_graph(json);
   } else {
        alert("HTTP-Error: " + response.status);
   }
}

async function get_data() {
   let response = await fetch('/data');

   if (response.ok) { // if HTTP-status is 200-299
     // get the response body (the method explained below)
     let json = await response.json();
     write_graph(json);
   } else {
     alert("HTTP-Error: " + response.status);
   }
}

function write_graph(json) {
    console.log(json);

    const data = {
        labels: json.labels,
        datasets: [
            {
                name: "Some Data", chartType: "bar",
                values: json.values,
            }
        ],
        yMarkers: [
            {
                label: "Durchschnitt",
                value: 71.875,
                options: { labelPos: 'left' }
            }
        ]
    }

    const chart = new frappe.Chart("#chart", {  // or a DOM element,
                                                // new Chart() in case of ES6 module with above usage
        title: "My Awesome Chart",
        data: data,
        type: 'axis-mixed', // or 'bar', 'line', 'scatter', 'pie', 'percentage'
        height: 250,
        colors: ['#7cd6fd', '#743ee2']
    })
}