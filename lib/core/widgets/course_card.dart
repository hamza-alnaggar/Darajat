// import 'package:flutter/material.dart';


// class CourseCard extends StatelessWidget {
//   const CourseCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 80,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(Icons.image, color: Colors.grey[400]),
//             ),
//             const SizedBox(width: 16),
            
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
                  
//                   const Text(
//                     'The Complete Python\nBootcamp From Zero to H...',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       height: 1.2,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
                  
//                   Text(
//                     'Jose Portilla, Pierian Training',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
                  
//                   const SizedBox(height: 12),
                  
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber[600], size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         '4.6',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }