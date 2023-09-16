// ignore_for_file: non_constant_identifier_names, unnecessary_const

import 'package:flutter/material.dart';
import 'package:task/shared/cubit/cubit.dart';

Widget defaultinputform({
  IconData? sufix,
  bool isPassword = false,
  Function()? suffixOnPressed,
  bool isClickable = true,
  //required Function() validate,
  required Function submitted,
  Function()? tapped,
  required TextInputType type,
  required IconData prefix,
  required TextEditingController controller,
  //required String label,
  required String hint,
}) =>
    TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        validator: (value) {
          if (value!.isEmpty) {
            return "this field can not be empty";
          }
          return null;
        },
        onFieldSubmitted: submitted(),
        onTap: tapped,
        cursorColor: const Color.fromARGB(255, 0, 0, 0),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 119, 119, 119),
            ),
            iconColor: Colors.white,
            //labelText: label,
            border: const OutlineInputBorder(),
            //enabledBorder: const UnderlineInputBorder() ,
            prefixIcon: Icon(prefix),
            suffixIcon: IconButton(
              icon: Icon(sufix),
              onPressed: suffixOnPressed,
            )));

Widget buildTaskItem(Map model, context) => Dismissible(
    key: Key(model["id"].toString()),
    background: Container(
      color: Colors.red,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(320, 35, 0, 0),
        child: Text(
          "delete",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ),
    secondaryBackground: Container(
      color: Colors.red,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(320, 35, 0, 0),
        child: Text(
          "delete",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    ),
    onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model["id"]);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 35, child: Text("${model['time']}")),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${model['title']}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${model['date']}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: "archived", id: model["id"]);
              },
              icon: const Icon(Icons.archive_outlined),
              color: const Color.fromARGB(121, 197, 197, 197)),
          const SizedBox(
            width: 5,
          ),
          IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: "done", id: model["id"]);
              },
              icon: const Icon(Icons.check_box_outlined),
              color: const Color.fromARGB(121, 197, 197, 197)),
        ],
      ),
    ));
