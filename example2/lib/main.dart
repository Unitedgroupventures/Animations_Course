import 'dart:math' show pi;

import 'package:flutter/material.dart';

void main() {
  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
    );
  }
}

enum CircleSide {
  left,
  right,
}

// Define an extension on the CircleSide enum to add functionality.
extension ToPath on CircleSide {
  /// Converts the `CircleSide` into a `Path` object that represents
  /// a semi-circular arc, either on the left or right side of a rectangle.
  ///
  /// The `toPath` method takes the `Size` of the rectangle as input and
  /// generates a path that corresponds to the specified side of the circle.
  Path toPath(Size size) {
    // Create an empty path object to store the semi-circular arc.
    final path = Path();

    // Declare variables for the offset (end point of the arc) and
    // whether the arc should be drawn clockwise or counterclockwise.
    late Offset offset;
    late bool clockwise;

    // Use a switch statement to handle different sides of the circle.
    switch (this) {
      case CircleSide.left:
        // If the side is "left":
        // Move the starting point of the path to the top-right corner of the rectangle.
        path.moveTo(size.width, 0);

        // Set the end point (offset) to the bottom-right corner of the rectangle.
        offset = Offset(size.width, size.height);

        // Draw the arc counterclockwise (false).
        clockwise = false;
        break;

      case CircleSide.right:
        // If the side is "right":
        // The starting point defaults to (0, 0), which is already at the top-left corner.

        // Set the end point (offset) to the bottom-left corner of the rectangle.
        offset = Offset(0, size.height);

        // Draw the arc clockwise (true).
        clockwise = true;
        break;
    }

    // Draw an arc from the current position to the specified offset.
    path.arcToPoint(
      offset, // End point of the arc
      radius: Radius.elliptical(
          size.width / 2, size.height / 2), // Defines an elliptical radius
      clockwise: clockwise, // Whether to draw clockwise or counterclockwise
    );

    // Close the path to create a complete shape (semi-circle in this case).
    path.close();

    // Return the constructed path.
    return path;
  }
}

/// A custom clipper that clips a widget into a half-circle shape
/// on either the left or right side, based on the provided `CircleSide`.
class HalfCircleClipper extends CustomClipper<Path> {
  /// Determines which side of the widget to clip (left or right).
  final CircleSide side;

  /// Constructor that requires the `side` property to be specified.
  HalfCircleClipper({
    required this.side, // The side to clip (left or right).
  });

  /// This method generates the clipping path for the widget.
  ///
  /// The `size` parameter represents the dimensions of the widget being clipped.
  /// It delegates the path generation to the `toPath` extension method on `CircleSide`.
  @override
  Path getClip(Size size) {
    // Use the CircleSide's `toPath` method to generate the path.
    return side.toPath(size);
  }

  /// Determines whether Flutter should recalculate and redraw the clipping path.
  ///
  /// This method is called whenever Flutter needs to decide whether to reapply
  /// the clip. If it returns `true`, Flutter will recalculate the clip; if it
  /// returns `false`, Flutter will reuse the existing clip.
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Always return true in this implementation, which forces Flutter
    // to recalculate and redraw the clipping path every time the widget rebuilds.
    //
    // This is simple but not optimal for performance. In cases where the clipping
    // logic depends on properties that rarely change, you can add conditional logic
    // to avoid unnecessary recalculations
    //* (see optimized version below).

    return true;
  }

  //* Optimized Implementation
  //* If your clipping logic depends on static properties that rarely change
  //* (e.g., a fixed side), you can optimize this method by comparing relevant properties
  //* between the current and previous clippers.
  //*   @override
  //* bool shouldReclip(covariant HalfCircleClipper oldClipper) {
  //*   // Recalculate only if the 'side' property has changed.
  //*   return oldClipper.side != side;
  //* }

  //* How It Works:
  //* Compares whether the current instance's side property is different from that of the previous instance (oldClipper.side).
  //* If they are different, it returns true, forcing a reclip; otherwise, it returns false.
  //* Why Use This:
  //* Improves performance by avoiding unnecessary recalculations when nothing has changed.
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Extending the functionality of VoidCallback using an extension.
/// VoidCallback is a type that represents a function with no parameters and no return value.
extension on VoidCallback {
  /// Adds a method to execute the callback after a specified delay.
  ///
  /// [duration]: The amount of time to wait before executing the callback.
  /// Returns: A Future that completes after the callback is executed.
  Future<void> delayed(Duration duration) {
    // Use Future.delayed to schedule the callback execution after the given duration.
    return Future.delayed(
      duration, // The delay duration before executing the callback.
      this, // The callback function that will be executed.
    );
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    _counterClockwiseRotationAnimation = Tween<double>(
      begin: 0.0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    // flip animation

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );

    // status listeners

    _counterClockwiseRotationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _flipAnimation = Tween<double>(
            begin: _flipAnimation.value,
            end: _flipAnimation.value + pi,
          ).animate(
            CurvedAnimation(
              parent: _flipController,
              curve: Curves.bounceOut,
            ),
          );

          // reset the flip controller and start the animation
          _flipController
            ..reset()
            ..forward();
        }
      },
    );

    _flipController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _counterClockwiseRotationAnimation = Tween<double>(
            begin: _counterClockwiseRotationAnimation.value,
            end: _counterClockwiseRotationAnimation.value + -(pi / 2),
          ).animate(
            CurvedAnimation(
              parent: _counterClockwiseRotationController,
              curve: Curves.bounceOut,
            ),
          );
          _counterClockwiseRotationController
            ..reset()
            ..forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseRotationController
      ..reset() // Reset the animation controller to its initial state (progress = 0).
      ..forward.delayed(
        // Delay the execution of 'forward()' by 1 second.
        const Duration(
            seconds: 1), // Wait for 1 second before starting the animation.
      );

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _counterClockwiseRotationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(
                  _counterClockwiseRotationAnimation.value,
                ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()
                            ..rotateY(
                              _flipAnimation.value,
                            ),
                          child: ClipPath(
                            clipper: HalfCircleClipper(
                              side: CircleSide.left,
                            ),
                            child: Container(
                              height: 100.0,
                              width: 100.0,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      // The animation that drives the AnimatedBuilder.
                      animation: _flipAnimation,
                      // The builder function defines how the widget tree should rebuild during the animation.
                      builder: (context, child) {
                        return Transform(
                          // Alignment specifies where the rotation should pivot from.
                          alignment: Alignment.centerLeft,
                          // Apply a Matrix4 transformation to rotate the widget around the Y-axis.
                          transform: Matrix4.identity()
                            ..rotateY(
                              _flipAnimation
                                  .value, // Rotation angle in radians (animated value).
                            ),
                          // The child of the Transform widget is clipped into a half-circle shape.
                          child: ClipPath(
                            // Use a custom clipper to clip the widget into a half-circle shape.
                            clipper: HalfCircleClipper(
                              side: CircleSide
                                  .right, // Specifies which side of the circle to clip (right half-circle).
                            ),
                            // The clipped widget is a red square container.
                            child: Container(
                              height: 100.0, // Height of the container.
                              width: 100.0, // Width of the container.
                              color: Colors
                                  .red, // Background color of the container.
                            ),
                          ),
                        );
                      },
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

// ——————————————————————————————————————————————————————————————————————————————————————
//* ORIGINAL CODE
// extension on VoidCallback {
//   Future<void> delayed(Duration duration) => Future.delayed(
//         duration,
//         this,
//       );
// }

// ——————————————————————————————————————————————————————————————————————————————————————
//* ORIGINAL CODE
// class HalfCircleClipper extends CustomClipper<Path> {
//   final CircleSide side;

//   HalfCircleClipper({
//     required this.side,
//   });

//   @override
//   Path getClip(Size size) => side.toPath(size);

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
// }

// ——————————————————————————————————————————————————————————————————————————————————————
//* ORIGINAL CODE
// extension ToPath on CircleSide {
//   Path toPath(Size size) {
//     final path = Path();

//     late Offset offset;
//     late bool clockwise;

//     switch (this) {
//       case CircleSide.left:
//         path.moveTo(size.width, 0);
//         offset = Offset(size.width, size.height);
//         clockwise = false;
//         break;

//       case CircleSide.right:
//         offset = Offset(0, size.height);
//         clockwise = true;
//         break;
//     }

//     path.arcToPoint(
//       offset,
//       radius: Radius.elliptical(size.width / 2, size.height / 2),
//       clockwise: clockwise,
//     );

//     path.close();
//     return path;
//   }
// }

// ——————————————————————————————————————————————————————————————————————————————————————

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
