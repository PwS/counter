import 'package:counter_app/cubits/counter_cubit.dart';
import 'package:counter_app/other_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppCubit extends StatelessWidget {
  const MyAppCubit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterCubit>(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'My Counter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePageUsingExtensionContext(),
      ),
    );
  }
}

class MyHomePageUsingCubit extends StatelessWidget {
  const MyHomePageUsingCubit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state.counter == 3) {
            showDialog(
                context: context,
                builder: (counter) => AlertDialog(
                  content: Text('Counter is ${state.counter}'),
                ));
          } else if (state.counter == -1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OtherPage()));
          }
        },
        builder: (context, state) {
          return Center(
            child: Text('${state.counter}'),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).increment();
            },
            child: Icon(Icons.add),
            heroTag: 'Increment',
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              BlocProvider.of<CounterCubit>(context).decrement();
            },
            child: Icon(Icons.remove),
            heroTag: 'Decrement',
          ),
        ],
      ),
    );
  }
}

class MyHomePageUsingExtensionContext extends StatelessWidget {
  const MyHomePageUsingExtensionContext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state.counter == 3) {
            showDialog(
                context: context,
                builder: (counter) => AlertDialog(
                  content: Text('Counter is ${state.counter}'),
                ));
          } else if (state.counter == -1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OtherPage()));
          }
        },
        builder: (context, state) {
          return Center(
            child: Text('${state.counter}'),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CounterCubit>().increment();
            },
            child: Icon(Icons.add),
            heroTag: 'Increment',
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CounterCubit>().decrement();
            },
            child: Icon(Icons.remove),
            heroTag: 'Decrement',
          ),
        ],
      ),
    );
  }
}
