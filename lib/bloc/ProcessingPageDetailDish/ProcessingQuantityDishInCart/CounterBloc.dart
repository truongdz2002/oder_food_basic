import 'package:flutter_bloc/flutter_bloc.dart';

import 'CounterEvent.dart';


class CounterBloc extends Bloc<CounterEvent,int>{
  CounterBloc():super(1){
    on<IncreaseEvent>((event, emit) =>_increase(emit) );
    on<DecreaseEvent>((event, emit) => _decrease(emit));
    
  }
  _increase(Emitter emit)
  {
    emit(state+1);
  }

  _decrease(Emitter emit)
  {
    emit(state-1);
  }
  void resetState() {
    emit(1);
  }

}