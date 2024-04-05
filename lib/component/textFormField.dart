import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextForm extends StatelessWidget{
  const CustomTextForm({super.key, required this.hintname, required this.myController,required this.validator});
  final String hintname;
  final TextEditingController myController;
  final String? Function(String?)? validator;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      validator: validator,
      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),

                          filled: true,
                          fillColor: const Color.fromARGB(255, 252, 255, 253),
                          hintText: hintname,

                          border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 237, 229, 229)
                                )),
                                enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromARGB(255, 125, 124, 124)))

                        ),

    );
  }

}