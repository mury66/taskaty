// ignore_for_file: camel_case_types, avoid_print, use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task/shared/components/components.dart';
import '../shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';

class homeLayout extends StatelessWidget {
  // late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AppCubit(AppInitialState())..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state)
          {
            if(state is AppInsertDatabaseState)
              {
              Navigator.pop(context);
              }
          },
          builder: (context, state) {
            AppCubit Cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              backgroundColor: const Color.fromARGB(255, 45, 50, 67),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 45, 50, 67),
                elevation: .5,
                title: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    Cubit.titles[Cubit.current],
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                actions: [],
              ),
              body:state is AppGetDatabaseLoadingState?
              const Center(child: CircularProgressIndicator(),):
              Cubit.screens[Cubit.current],



              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (Cubit.isEditing) {
                    if (formKey.currentState!.validate()) {
                      Cubit.insertIntoDatabase(
                        title: Cubit.titleController.text,
                        time: Cubit.timeController.text,
                        date: Cubit.dateController.text,
                      );
                      //.then((value) {
                      //     titleController.text = "";
                      //     timeController.text = "";
                      //     dateController.text = "";
                      //     Cubit.getDataFromDataBase(Cubit.database).then((value) {
                      //       // setState(() {
                      //       //   isEditing = false;
                      //       //   fabIcon = Icons.edit;
                      //       //   tasks = value;
                      //       //   print(tasks);
                      //       // });
                      //     });
                      //   });
                      // }
                    }
                  } else {
                    scaffoldKey.currentState!.showBottomSheet(
                            (context) => Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 239, 239, 239),
                                  ),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        defaultinputform(
                                            submitted: () {},
                                            type: TextInputType.text,
                                            prefix: Icons.label_outline,
                                            sufix: Icons.clear,
                                            suffixOnPressed: ()
                                            {
                                              Cubit.titleController.text="";
                                            },
                                            controller: Cubit.titleController,
                                            hint: "title"),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        defaultinputform(
                                            submitted: () {},
                                            type: TextInputType.datetime,
                                            prefix: Icons.timer_outlined,
                                            controller: Cubit.timeController,
                                            sufix: Icons.clear,
                                            suffixOnPressed: ()
                                            {
                                              Cubit.timeController.text="";
                                            },
                                            hint: "time",
                                            tapped: () {
                                              showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now())
                                                  .then((value) {
                                                Cubit.timeController.text = value!
                                                    .format(context)
                                                    .toString();
                                                print(value.format(context));
                                              });
                                            }),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        defaultinputform(
                                            submitted: () {},
                                            type: TextInputType.datetime,
                                            sufix: Icons.clear,
                                            suffixOnPressed: ()
                                            {
                                              Cubit.dateController.text="";
                                            },
                                            prefix:
                                                Icons.calendar_today_outlined,
                                            controller: Cubit.dateController,
                                            hint: "date",
                                            tapped: () {
                                              showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.parse(
                                                          '2030-12-31'))
                                                  .then((value) {
                                                print(DateFormat.yMMMd()
                                                    .format(value!));
                                                Cubit.dateController.text =
                                                    DateFormat.yMMMd()
                                                        .format(value);
                                              });
                                            }),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Cubit.clearAll();
                                            },
                                            child: const Text(
                                              "clear all",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                            elevation: 200)
                        .closed
                        .then((value) {
                      Cubit.changeBottomSheetState(
                          icon: Icons.edit, Editing: false);
                    });
                    Cubit.changeBottomSheetState(
                        icon: Icons.save_outlined, Editing: true);
                    print(Cubit.isEditing);
                  }

                },
                backgroundColor: const Color.fromARGB(255, 57, 147, 225),
                child: Icon(
                  Cubit.fabIcon,
                  color: Colors.white,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: Cubit.current,
                onTap: (index) {
                  Cubit.changeIndex(index);
                },
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                showSelectedLabels: false,
                selectedItemColor: const Color.fromARGB(255, 57, 147, 225),
                backgroundColor: const Color.fromARGB(255, 45, 50, 67),
                unselectedItemColor: Colors.white,
                iconSize: 33,
                items: const [
                  BottomNavigationBarItem(
                      backgroundColor: Colors.white,
                      label: "Current tasks",
                      icon: Icon(Icons.list)),
                  BottomNavigationBarItem(
                      label: "done", icon: Icon(Icons.done)),
                  BottomNavigationBarItem(
                      label: "archived", icon: Icon(Icons.archive_outlined)),
                ],
              ),
            );
          }),
    );
  }

  // Future<String> getName() async {
  //   return "MURY";
  // }
}
