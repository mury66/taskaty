import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class archived_tasks extends StatelessWidget {
  const archived_tasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener:(context,state){},
        builder:(context,state)
        {
          var tasks = AppCubit.get(context).archivedTasks;
          return ConditionalBuilder(
              condition:tasks.isNotEmpty ,
              builder: (context) => ListView.separated(itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
                  separatorBuilder: (context,index)=>Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(width: double.infinity,height: 1,color: const Color.fromARGB(255, 57, 147, 225)),
                  ),
                  itemCount: tasks.length),
              fallback: (BuildContext context) => const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu,color: Colors.white,size: 100,) ,
                      Text("no tasks yet, let's add some",style: TextStyle(color: Colors.white,fontSize: 20),)]),
              )
          );
        }
    ) ;
  }
}