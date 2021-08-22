import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final channel = MethodChannel('com.burakomer.kumaApp');

  void _initFlutterChannel() {
    channel.setMethodCallHandler(
      (call) async {
        // Receive data from Native
        switch (call.method) {
          case "sendCounterToFlutter":
            _counter = call.arguments["data"]["counter"];
            _incrementCounter();
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initFlutterChannel();
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    await channel.invokeMethod("flutterToWatch", {"method": "sendCounterToNative", "data": _counter});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
