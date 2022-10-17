import 'package:rxdart/rxdart.dart';

class CounterRx {

  int initialCount; //if the data is not passed by paramether it initializes with 0
  late BehaviorSubject<int> _subjectCounter;

  CounterRx({this.initialCount=0}){
    _subjectCounter = BehaviorSubject<int>.seeded(initialCount); //initializes the subject with element already
  }

  Stream<int> get counterObservable => _subjectCounter.stream;

  void increment(){
    initialCount++;
    _subjectCounter.sink.add(initialCount);
  }

  void decrement(){
    initialCount--;
    _subjectCounter.sink.add(initialCount);
  }

  void dispose(){
    _subjectCounter.close();
  }

}