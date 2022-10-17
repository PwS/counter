import 'package:flutter/material.dart';
import 'package:counter_reactive/state_management/counter_rx/counter_rx.dart';

class MyHomePage extends StatelessWidget {
  final String title;
  final CounterRx counterRx;

  MyHomePage({Key? key, required this.title, CounterRx? counterRx})
      : counterRx = counterRx ?? CounterRx(initialCount: 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              StreamBuilder(
                  stream: counterRx.counterObservable,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    return Text('${snapshot.data}',
                        style: Theme.of(context).textTheme.displaySmall);
                  })
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: counterRx.increment,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              )),
          FloatingActionButton(
            onPressed: counterRx.decrement,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ]));
  }
}
