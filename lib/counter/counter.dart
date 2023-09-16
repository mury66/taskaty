// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/counter/cubit/states.dart';
import 'cubit/cubit.dart';

class Counter extends StatelessWidget {
  const Counter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => counterCubit(counterInitialState()),
      child: BlocConsumer<counterCubit, counterStates>(
        listener: (context, state) {
          if (state is counterPlusState) print("plus state ${state.counter}");
          if (state is counterMinusState) print("minus state ${state.counter}");
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      counterCubit.get(context).minus();
                    },
                    child: const Text(
                      "MINUS",
                      style: TextStyle(fontSize: 40),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${counterCubit.get(context).counter}",
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {
                      counterCubit.get(context).plus();
                    },
                    child: const Text(
                      "PLUS",
                      style: TextStyle(fontSize: 40),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
