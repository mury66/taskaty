abstract class counterStates {}

class counterInitialState extends counterStates {}

class counterPlusState extends counterStates {
  final int counter;

  counterPlusState(this.counter);
}

class counterMinusState extends counterStates {
  final int counter;

  counterMinusState(this.counter);
}
