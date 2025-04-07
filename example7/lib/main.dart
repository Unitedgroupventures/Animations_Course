import 'dart:math' show pi, cos, sin;
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
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

/// A custom painter that draws regular polygons with a specified number of sides.
/// The polygon is drawn centered within the available space and automatically
/// scales to fit the container.
class Polygon extends CustomPainter {
  /// The number of sides the polygon should have (e.g., 3 = triangle, 5 = pentagon).
  final int sides;

  Polygon({
    required this.sides,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Configure the painting style
    final paint = Paint()
      ..color = Colors.purpleAccent // Outline color
      ..style = PaintingStyle.stroke // Draw outline only
      ..strokeCap = StrokeCap.round // Rounded line endings
      ..strokeWidth = 3; // Line thickness

    // Create a path to define the polygon shape
    final path = Path();

    // Calculate center point of the drawing area
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate angle between successive vertices (in radians)
    final angleStep = (2 * pi) / sides;

    // Generate list of angles for all polygon vertices
    final angles = List.generate(sides, (index) => index * angleStep);

    // Calculate radius as half the container width (ensures polygon fits)
    final radius = size.width / 2;

    // Start path at the first vertex (rightmost point of the circle)
    path.moveTo(
      center.dx + radius * cos(0), // x = center.x + radius (cos(0) = 1)
      center.dy + radius * sin(0), // y = center.y (sin(0) = 0)
    );

/* 
x = center.x + radius * cos(angle)
y = center.y + radius * sin(angle)
*/

    // Add lines to subsequent vertices
    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle), // Calculate x-coordinate
        center.dy + radius * sin(angle), // Calculate y-coordinate
      );
    }

    // Close the path to complete the polygon shape
    path.close();

    // Draw the path on the canvas with the configured paint
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      // Only repaint if the number of sides changes
      oldDelegate is Polygon && oldDelegate.sides != sides;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _sidesAnimation;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _sidesAnimation = IntTween(
      begin: 3,
      end: 10,
    ).animate(
      _sidesController,
    );

    _radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _radiusAnimation = Tween(
      begin: 20.0,
      end: 400.0,
    )
        .chain(
          CurveTween(
            curve: Curves.bounceInOut,
          ),
        )
        .animate(_radiusController);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotationAnimation = Tween(begin: 0.0, end: 2 * pi)
        .chain(
          CurveTween(
            curve: Curves.easeInOut,
          ),
        )
        .animate(_rotationController);
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sidesController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
            [
              _sidesController,
              _radiusController,
              _rotationController,
            ],
          ),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_rotationAnimation.value)
                ..rotateY(_rotationAnimation.value)
                ..rotateZ(_rotationAnimation.value),
              child: CustomPaint(
                painter: Polygon(sides: _sidesAnimation.value),
                child: SizedBox(
                  width: _radiusAnimation.value,
                  height: _radiusAnimation.value,
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
// class Polygon extends CustomPainter {
//   final int sides;

//   Polygon({
//     required this.sides,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.purpleAccent
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 3;

//     final path = Path();

//     final center = Offset(size.width / 2, size.height / 2);
//     final angle = (2 * pi) / sides;

//     final angles = List.generate(sides, (index) => index * angle);

//     final radius = size.width / 2;

// /* 
// x = center.x + radius * cos(angle)
// y = center.y + radius * sin(angle)
// */

//     path.moveTo(
//       center.dx + radius * cos(0),
//       center.dy + radius * sin(0),
//     );

//     for (final angle in angles) {
//       path.lineTo(
//         center.dx + radius * cos(angle),
//         center.dy + radius * sin(angle),
//       );
//     }

//     path.close();

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) =>
//       oldDelegate is Polygon && oldDelegate.sides != sides;
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
