// Import the math library for mathematical operations (e.g., pi)
import 'dart:math';

// Import the Flutter material design library
import 'package:flutter/material.dart';

// The main function, entry point of the Flutter app
void main() {
  runApp(
    const App(), // Run the App widget
  );
}

// The root widget of the application
class App extends StatelessWidget {
  const App({super.key}); // Constructor with optional key parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark), // Set light theme to dark
      darkTheme: ThemeData(brightness: Brightness.dark), // Set dark theme
      themeMode: ThemeMode.dark, // Force dark theme
      debugShowCheckedModeBanner: false, // Remove debug banner
      debugShowMaterialGrid: false, // Disable material grid overlay
      home: const HomePage(), // Set HomePage as the initial route
    );
  }
}

// HomePage widget, which is stateful to manage animations
class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Constructor with optional key parameter

  @override
  State<HomePage> createState() =>
      _HomePageState(); // Create the state for HomePage
}

// The state class for HomePage
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Mixin for single ticker animations
  late AnimationController _controller; // Controller for the animation
  late Animation<double> _animation; // The animation itself

  @override
  void initState() {
    super.initState(); // Call the parent's initState method
    _controller = AnimationController(
      vsync: this, // Use this object as the vsync
      duration:
          const Duration(seconds: 2), // Set animation duration to 2 seconds
    );
    _animation = Tween(
      begin: 0.0,
      end: 2 * pi, // Animate from 0 to 2π (full rotation)
    ).animate(_controller);

    _controller.repeat(); // Start the animation and make it repeat indefinitely
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Clean up the controller when the widget is disposed
    super.dispose(); // Call the parent's dispose method
  }

  /*
  0.0 = 0 degree
  0.5 = 180 degree
  1.0 = 360 degree
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller, // Listen to the controller for rebuilds
          builder: (context, child) {
            return Transform(
              alignment:
                  Alignment.center, // Set the transform origin to the center
              transform: Matrix4.identity()
                ..rotateY(
                  _animation
                      .value, // Apply Y-axis rotation based on the animation value
                ),
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.purpleAccent, // Set the container color
                  borderRadius:
                      BorderRadius.circular(10.0), // Round the corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.5), // Semi-transparent black shadow
                      spreadRadius: 5, // Extend the shadow
                      blurRadius: 7, // Blur the shadow
                      offset:
                          const Offset(0, 3), // Move the shadow down slightly
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}









//* ORIGINAL CODES
// import 'dart:math';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(
//     const App(),
//   );
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(brightness: Brightness.dark),
//       darkTheme: ThemeData(brightness: Brightness.dark),
//       themeMode: ThemeMode.dark,
//       debugShowCheckedModeBanner: false,
//       debugShowMaterialGrid: false,
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     _animation = Tween(
//       begin: 0.0,
//       end: 2 * pi,
//     ).animate(_controller);

//     _controller.repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   /*
//   0.0 = 0 degree
//   0.5 = 180 degree
//   1.0 = 360 degree
//    */
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _controller,
//           builder: (context, child) {
//             return Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()
//                 ..rotateY(
//                   _animation.value,
//                 ),
//               child: Container(
//                 width: 100.0,
//                 height: 100.0,
//                 decoration: BoxDecoration(
//                   color: Colors.purpleAccent,
//                   borderRadius: BorderRadius.circular(10.0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.5),
//                       spreadRadius: 5,
//                       blurRadius: 7,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
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
