import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TicTacToe());
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToe();
}

class _TicTacToe extends State<TicTacToe> {
  int n = 3;
  List<List<String>> _grid = [
    ['.', '.', '.'],
    ['.', '.', '.'],
    ['.', '.', '.'],
  ];

  bool _oTurn = true;
  String _winner = '';

  void _resetState() {
    setState(() {
      _oTurn = true;
      _grid = [
        ['.', '.', '.'],
        ['.', '.', '.'],
        ['.', '.', '.'],
      ];
      _winner = '';
    });
  }

  bool _isWinner(int row, int col) {
    final String value = _grid[row][col];
    bool rowWin = true;
    bool columnWin = true;
    bool leftDiagWin = row == col;
    bool rightDiagWin = row + col == n - 1;
    for (var i = 0; i < n; i++) {
      if (_grid[i][col] != value) {
        rowWin = false;
      }
      if (_grid[row][i] != value) {
        columnWin = false;
      }
      if (row == col && _grid[i][i] != value) {
        leftDiagWin = false;
      }
      if (row + col == n - 1 && _grid[i][n - i - 1] != value) {
        rightDiagWin = false;
      }
    }
    return rowWin || columnWin || leftDiagWin || rightDiagWin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Tic Tac Toe",
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                _winner == '' ? 'Turn: ${_oTurn ? 'O' : 'X'}' : '$_winner won!',
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(
                width: 300,
                height: 300,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, row) {
                    return SizedBox(
                        width: 300,
                        height: 100,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, col) => InkWell(
                              onTap: () => {
                                    if (_grid[row][col] == '.' && _winner == '')
                                      {
                                        setState(() => _grid[row][col] =
                                            _oTurn ? 'O' : 'X'),
                                        setState(() {
                                          _oTurn = !_oTurn;
                                        }),
                                        if (_isWinner(row, col))
                                          {
                                            setState(() {
                                              _winner = _grid[row][col];
                                            })
                                          }
                                      }
                                  },
                              child: GridCell(value: _grid[row][col])),
                          itemCount: _grid[0].length,
                        ));
                  },
                  itemCount: _grid.length,
                )),
            TextButton(
              onPressed: () => _resetState(),
              child: Text('Restart'),
            ),
          ],
        )));
  }
}

class GridCell extends StatelessWidget {
  const GridCell({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            color: Theme.of(context).colorScheme.inversePrimary),
        width: 100,
        height: 100,
        child: Center(
          child: Text(value == '.' ? '' : value,
              style: Theme.of(context).textTheme.bodyLarge),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
