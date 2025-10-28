// import 'package:flutter/material.dart';

// class ContainerColumn extends StatelessWidget {
//   const ContainerColumn({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0), // Padding around the column
//         child: Center(
//           child: Column(
//             mainAxisAlignment:
//                 MainAxisAlignment.spaceEvenly, // Evenly space containers
//             children: [
//               // Container 1: Gradient Border (Blue to Cyan)
//               _buildGradientBorderContainer(
//                 gradientColors: [Colors.blue, Colors.cyan],
//                 label: 'Gradient Border 1',
//               ),
//               // Container 2: Gradient Border (Red to Pink)
//               _buildGradientBorderContainer(
//                 gradientColors: [Colors.red, Colors.pink],
//                 label: 'Gradient Border 2',
//               ),
//               // Container 3: Gradient Border (Green to Lime)
//               _buildGradientBorderContainer(
//                 gradientColors: [Colors.green, Colors.lime],
//                 label: 'Gradient Border 3',
//               ),
//               // Container 4: Gradient Border (Purple to Indigo)
//               _buildGradientBorderContainer(
//                 gradientColors: [Colors.purple, Colors.indigo],
//                 label: 'Gradient Border 4',
//               ),
//               // Container 5: Gradient Border (Orange to Yellow)
//               _buildGradientBorderContainer(
//                 gradientColors: [Colors.orange, Colors.yellow],
//                 label: 'Gradient Border 5',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build a container with a gradient border
//   Widget _buildGradientBorderContainer({
//     required List<Color> gradientColors,
//     required String label,
//   }) {
//     return Container(
//       height: 80,
//       width: 200,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12), // Rounded corners
//         gradient: LinearGradient(
//           colors: gradientColors, // Gradient colors for the border
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Container(
//         margin:
//             const EdgeInsets.all(3), // Margin creates the "border" thickness
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1), // Inner container background
//           borderRadius: BorderRadius.circular(10), // Slightly smaller radius
//         ),
//         child: Center(
//             child: Text(
//           label,
//           style: TextStyle(color: Colors.white, fontSize: 20),
//         )),
//       ),
//     );
//   }
// }
