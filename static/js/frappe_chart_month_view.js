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

    get_project_data({ "target": project_select });

    let test_file_select = document.getElementById('test_files');
    test_file_select.onchange = get_test_file_data;
});

async function get_project_data(event) {
    let select = event.target;
    select.disabled = true;

    let response = await fetch(`/project/${select[select.selectedIndex].value}`);

    if (response.ok) { // if HTTP-status is 200-299
        // get the response body (the method explained below)
        let json = await response.json();
        write_graph(json);
        fill_test_table(json);
        fill_test_files_select(json);
    } else {
        alert("HTTP-Error: " + response.status);
    }
    select.disabled = false;
}

function write_graph(json) {
    console.log(json);

    const data = {
        labels: json.labels,
        datasets: [
            {
                name: "Fail count", chartType: "bar",
                values: json.values,
            }
        ],
        // yMarkers: [
        //     {
        //         label: "Durchschnitt",
        //         value: 71.875,
        //         options: { labelPos: 'left' }
        //     }
        // ]
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

function fill_test_table(json) {
    let table_body = document.getElementById('test_table_body');

    while(table_body.hasChildNodes()) {
        table_body.removeChild(table_body.firstChild);
    }

    json.tests.forEach((test) => {
        let row = document.createElement("tr");
        let td_name = document.createElement("td");
        td_name.innerHTML = test.name;
        row.appendChild(td_name);
        table_body.appendChild(row);

        test.tests.forEach((test_numbers) => {
            let row = document.createElement("tr");
            row.appendChild(document.createElement("td"));

            let td_test_number = document.createElement("td");
            td_test_number.setAttribute('style', 'text-align: center;');
            td_test_number.innerHTML = test_numbers[0];
            row.appendChild(td_test_number);

            let td_test_dates = document.createElement("td");
            td_test_dates.innerHTML = test_numbers[1];
            row.appendChild(td_test_dates);

            table_body.appendChild(row);
        });
    });
}

async function get_test_file_data(event) {
    let select = event.target;
    if(select[select.selectedIndex].value == 'Test file') {
        return;
    }

    select.disabled = true;

    let response = await fetch(`/test_files/${select[select.selectedIndex].value}`);

    if (response.ok) { // if HTTP-status is 200-299
        // get the response body (the method explained below)
        let json = await response.json();
        write_graph(json);
        fill_test_table(json);
    } else {
        alert("HTTP-Error: " + response.status);
    }
    select.disabled = false;
}

function fill_test_files_select(json) {
    let test_file_select = document.getElementById('test_files');
    test_file_select.options.length = 0;
    let default_option = document.createElement('option');
    default_option.innerHTML = 'Test file';
    test_file_select.options.add(default_option);

    json.test_files.forEach((test_file) => {
        let option = document.createElement('option');
        option.setAttribute('value', test_file.id);
        option.innerHTML = test_file.name;
        test_file_select.options.add(option);
    });
}