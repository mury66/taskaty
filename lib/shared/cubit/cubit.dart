// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task/shared/cubit/states.dart';
import '../../modules/archived_tasks/archived_tasks.dart';
import '../../modules/done_tasks/done_tasks.dart';
import '../../modules/new_tasks/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(super.AppInitialState);

  static AppCubit get(context) => BlocProvider.of(context);

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();

  late Database database;

  int current = 0;

  bool isEditing = false;

  IconData fabIcon = Icons.edit;

  List<Map> newTasks = [];

  List<Map> doneTasks = [];

  List<Map> archivedTasks = [];

  List<String> titles = [
    "New tasks",
    "Done tasks",
    "Archived tasks",
  ];

  List<Widget> screens = [
    const new_tasks(),
    const done_tasks(),
    const archived_tasks()
  ];

  void changeIndex(int index) {
    current = index;
    emit(AppChangeBottomNavBarState());
  }

  void clearAll(){
       titleController.text = "";
       timeController.text = "";
       dateController.text = "";
       emit(emptyFieldsState());
  }

  void changeBottomSheetState({required bool Editing, required IconData icon}) {
    isEditing = Editing;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        print("DB created succesfully");
        database
            .execute(
                "CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT )")
            .then((value) {
          print("table created succesfully");
        }).catchError((error) {
          print("error ${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print("DB opened succesfully");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertIntoDatabase({required String title,required String time,required String date}) async {
    await database.transaction((txn) async{
      txn
          .rawInsert(
              "INSERT INTO tasks (title, date, time, status) VALUES ('$title','$date','$time','new') ")
          .then((value) {
        print("$value data inserted successfully");
        emit(AppInsertDatabaseState());
        getDataFromDataBase(database);
      }).catchError((error) {
        print("error while inserting new record ${error.toString()}");
      });
    });
  }

  deleteData({required int id}){
    database
        .rawDelete('DELETE FROM tasks WHERE id = ?', ['$id'])
    .then((value) {
    getDataFromDataBase(database);

    print("deleted");
    emit(AppDeleteDatabaseState());
  });
  }

  void getDataFromDataBase(database)  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery("SELECT * FROM tasks").then((value) {
      value.forEach((element) {
        if(element["status"]=="new") {
          newTasks.add(element);
        }
        else if(element["status"]=="done") {
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }

      });
      emit(AppGetDatabaseState());
      print(newTasks);
      print(doneTasks);
      print(archivedTasks);


    });
  }

  void updateData({required String status,required int id}) async{
    database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',[status, '$id']
     ).then((value)
     {
       getDataFromDataBase(database);
       emit(AppUpdateDatabaseState());
     });
  }
}
