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

const data = {
    labels: [
    "02.06.2022 00:00",
"02.06.2022 00:15",
"02.06.2022 00:30",
"02.06.2022 00:45",
"02.06.2022 01:00",
"02.06.2022 01:15",
"02.06.2022 01:30",
"02.06.2022 01:45",
"02.06.2022 02:00",
"02.06.2022 02:15",
"02.06.2022 02:30",
"02.06.2022 02:45",
"02.06.2022 03:00",
"02.06.2022 03:15",
"02.06.2022 03:30",
"02.06.2022 03:45",
"02.06.2022 04:00",
"02.06.2022 04:15",
"02.06.2022 04:30",
"02.06.2022 04:45",
"02.06.2022 05:00",
"02.06.2022 05:15",
"02.06.2022 05:30",
"02.06.2022 05:45",
"02.06.2022 06:00",
"02.06.2022 06:15",
"02.06.2022 06:30",
"02.06.2022 06:45",
"02.06.2022 07:00",
"02.06.2022 07:15",
"02.06.2022 07:30",
"02.06.2022 07:45",
"02.06.2022 08:00",
"02.06.2022 08:15",
"02.06.2022 08:30",
"02.06.2022 08:45",
"02.06.2022 09:00",
"02.06.2022 09:15",
"02.06.2022 09:30",
"02.06.2022 09:45",
"02.06.2022 10:00",
"02.06.2022 10:15",
"02.06.2022 10:30",
"02.06.2022 10:45",
"02.06.2022 11:00",
"02.06.2022 11:15",
"02.06.2022 11:30",
"02.06.2022 11:45",
"02.06.2022 12:00",
"02.06.2022 12:15",
"02.06.2022 12:30",
"02.06.2022 12:45",
"02.06.2022 13:00",
"02.06.2022 13:15",
"02.06.2022 13:30",
"02.06.2022 13:45",
"02.06.2022 14:00",
"02.06.2022 14:15",
"02.06.2022 14:30",
"02.06.2022 14:45",
"02.06.2022 15:00",
"02.06.2022 15:15",
"02.06.2022 15:30",
"02.06.2022 15:45",
"02.06.2022 16:00",
"02.06.2022 16:15",
"02.06.2022 16:30",
"02.06.2022 16:45",
"02.06.2022 17:00",
"02.06.2022 17:15",
"02.06.2022 17:30",
"02.06.2022 17:45",
"02.06.2022 18:00",
"02.06.2022 18:15",
"02.06.2022 18:30",
"02.06.2022 18:45",
"02.06.2022 19:00",
"02.06.2022 19:15",
"02.06.2022 19:30",
"02.06.2022 19:45",
"02.06.2022 20:00",
"02.06.2022 20:15",
"02.06.2022 20:30",
"02.06.2022 20:45",
"02.06.2022 21:00",
"02.06.2022 21:15",
"02.06.2022 21:30",
"02.06.2022 21:45",
"02.06.2022 22:00",
"02.06.2022 22:15",
"02.06.2022 22:30",
"02.06.2022 22:45",
"02.06.2022 23:00",
"02.06.2022 23:15",
"02.06.2022 23:30",
"02.06.2022 23:45"
    ],
    datasets: [
        {
            name: "Some Data", chartType: "bar",
            values: [
                38,
42,
44,
32,
36,
25,
38,
36,
54,
34,
43,
41,
32,
451,
95,
80,
54,
67,
344,
66,
40,
47,
76,
87,
85,
54,
68,
100,
67,
60,
41,
31,
26,
35,
31,
52,
39,
47,
27,
32,
29,
28,
44,
78,
49,
35,
47,
27,
51,
223,
425,
155,
43,
51,
52,
56,
38,
40,
27,
34,
40,
63,
39,
36,
44,
29,
35,
24,
38,
106,
76,
78,
171,
44,
211,
84,
436,
287,
60,
69,
57,
64,
58,
35,
42,
32,
40,
23,
47,
42,
42,
65,
62,
33,
24,
35,
],
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