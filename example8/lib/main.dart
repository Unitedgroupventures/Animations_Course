import 'dart:math' show pi;

import 'package:flutter/material.dart';

void main() {
  runApp(
    const App(),
  );
}

class MyDrawer extends StatefulWidget {
  final Widget child; // The main content of the screen (e.g., app body)
  final Widget drawer; // The custom drawer content

  const MyDrawer({
    super.key,
    required this.child,
    required this.drawer,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
  // Animation controllers for managing animations
  late AnimationController
      _xControllerForChild; // Controls main content animation
  late Animation<double>
      _yRotationAnimationForChild; // Rotation animation for main content

  late AnimationController _xControllerForDrawer; // Controls drawer animation
  late Animation<double>
      _yRotationAnimationForDrawer; // Rotation animation for drawer

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for the main content (child)
    _xControllerForChild = AnimationController(
      vsync: this, // Synchronizes with screen refresh rate
      duration: const Duration(milliseconds: 500), // Animation duration
    );

    // Define rotation animation for the main content (child)
    _yRotationAnimationForChild = Tween<double>(
      begin: 0.0, // No rotation when closed
      end: -pi / 2, // Rotate -90 degrees (fold outward)
    ).animate(_xControllerForChild);

    // Initialize animation controller for the drawer
    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Define rotation animation for the drawer
    _yRotationAnimationForDrawer = Tween<double>(
      begin: pi / 2.7, // Start at 66.67 degrees (folded inward)
      end: 0.0, // No rotation when fully opened
    ).animate(_xControllerForDrawer);
  }

  @override
  void dispose() {
    // Dispose of animation controllers to free resources
    _xControllerForChild.dispose();
    _xControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final maxDrag =
        screenWidth * 0.8; // Maximum drag distance (80% of screen width)

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Handle horizontal drag gestures to update animations interactively
        final delta = details.delta.dx / maxDrag; // Normalize drag distance
        _xControllerForChild.value += delta; // Update child animation value
        _xControllerForDrawer.value += delta; // Update drawer animation value
      },
      onHorizontalDragEnd: (details) {
        // Decide whether to open or close the drawer based on drag position
        if (_xControllerForChild.value < 0.5) {
          _xControllerForChild.reverse(); // Close main content animation
          _xControllerForDrawer.reverse(); // Close drawer animation
        } else {
          _xControllerForChild.forward(); // Open main content animation
          _xControllerForDrawer.forward(); // Open drawer animation
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _xControllerForChild, // Listen to child animation changes
          _xControllerForDrawer, // Listen to drawer animation changes
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: const Color(
                    0xFF1a1b26), // Background color behind the drawer and child
              ),

              // Main Content (child) with folding effect
              Transform(
                alignment: Alignment
                    .centerLeft, // Rotate around the left edge of the screen
                transform: Matrix4.identity()
                  ..setEntry(3, 2,
                      0.001) // Add perspective transformation for depth effect
                  ..translate(_xControllerForChild.value *
                      maxDrag) // Slide horizontally as it rotates
                  ..rotateY(_yRotationAnimationForChild
                      .value), // Apply Y-axis rotation (fold outward)
                child: widget.child, // Main content widget passed from parent
              ),

              // Drawer with folding effect
              Transform(
                alignment: Alignment
                    .centerRight, // Rotate around the right edge of the screen (drawer side)
                transform: Matrix4.identity()
                  ..setEntry(3, 2,
                      0.001) // Add perspective transformation for depth effect (slightly stronger)
                  ..translate(
                      -screenWidth + // Start off-screen on the left side (-screenWidth)
                          _xControllerForDrawer.value *
                              maxDrag) // Slide into view as it rotates inward
                  ..rotateY(_yRotationAnimationForDrawer
                      .value), // Apply Y-axis rotation (fold inward)
                child: widget.drawer, // Drawer widget passed from parent
              ),
            ],
          );
        },
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        useMaterial3: false,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MyDrawer(
      drawer: Material(
        child: Container(
          color: const Color(0xff24283b),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(100, 50, 100, 0),
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item $index'),
              );
            },
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drawer'),
        ),
        body: Container(
          color: const Color(0xff414868),
        ),
      ),
    );
  }
}







// class MyDrawer extends StatefulWidget {
//   final Widget child;
//   final Widget drawer;

//   const MyDrawer({
//     super.key,
//     required this.child,
//     required this.drawer,
//   });

//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
// }

// class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {
//   late AnimationController _xControllerForChild;
//   late Animation<double> _yRotationAnimationForChild;

//   late AnimationController _xControllerForDrawer;
//   late Animation<double> _yRotationAnimationForDrawer;

//   @override
//   void initState() {
//     super.initState();
//     _xControllerForChild = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     _yRotationAnimationForChild = Tween<double>(
//       begin: 0.0, // Start with no rotation
//       end: -pi / 2, // Rotate by -90 degrees
//     ).animate(_xControllerForChild);

//     _xControllerForDrawer = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     _yRotationAnimationForDrawer = Tween<double>(
//       begin: -pi / 2.7,
//       end: 0.0,
//     ).animate(_xControllerForDrawer);
//   }

//   @override
//   void dispose() {
//     _xControllerForChild.dispose();
//     _xControllerForDrawer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final maxDrag = screenWidth * 0.8;

//     return GestureDetector(
//       onHorizontalDragUpdate: (details) {
//         final delta = details.delta.dx / maxDrag;
//         _xControllerForChild.value += delta;
//         _xControllerForDrawer.value += delta;
//       },
//       onHorizontalDragEnd: (details) {
//         if (_xControllerForChild.value < 0.5) {
//           _xControllerForChild.reverse();
//           _xControllerForDrawer.reverse();
//         } else {
//           _xControllerForChild.forward();
//           _xControllerForDrawer.forward();
//         }
//       },
//       child: AnimatedBuilder(
//         animation: Listenable.merge(
//           [
//             _xControllerForChild,
//             _xControllerForDrawer,
//           ],
//         ),
//         builder: (context, child) {
//           return Stack(
//             children: [
//               Container(
//                 color: const Color(0xFF1a1b26),
//               ),
//               Transform(
//                 alignment: Alignment.centerLeft,
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.001)
//                   ..translate(_xControllerForChild.value * maxDrag)
//                   ..rotateY(_yRotationAnimationForChild.value),
//                 child: widget.child,
//               ),
//               Transform(
//                 alignment: Alignment.centerRight,
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.01)
//                   ..translate(
//                       -screenWidth + _xControllerForDrawer.value * maxDrag)
//                   ..rotateY(_yRotationAnimationForDrawer.value),
//                 child: widget.drawer,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
