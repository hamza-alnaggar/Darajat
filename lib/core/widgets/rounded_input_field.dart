// import 'package:flutter/material.dart';
// import 'package:learning_management_system/core/widgets/text_field_container.dart';
// class RoundedInputField extends StatelessWidget {
//   const RoundedInputField({super.key,this.initialValue,  this.hintText, this.icon = Icons.person,this.controller,required this.validator});
//   final String? hintText;
//   final IconData icon;
//   final TextEditingController? controller;
//   final Function(String?) validator;
//   final String? initialValue;

//   @override
//   Widget build(BuildContext context) {
//     return TextFieldContainer(
//       child: TextFormField(
//         cursorColor: primaryColor,
//         validator: (value) {
//         return validator(value);
//       },
//       controller: controller,
//      // initialValue: initialValue,
//         decoration: InputDecoration(
//             icon: Icon(
//               icon,
//               color:primaryColor,
//             ),
//             hintText: hintText,
//             hintStyle: const TextStyle(fontFamily: 'OpenSans'),
//             border: InputBorder.none),
//       ),
//     );
//   }
// }
