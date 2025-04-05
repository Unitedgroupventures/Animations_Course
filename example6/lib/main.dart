import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      // theme: ThemeData(brightness: Brightness.dark),
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   appBarTheme: const AppBarTheme(
      //     centerTitle: true,
      //   ),
      // ),
      // themeMode: ThemeMode.dark,
      themeMode:
          ThemeMode.system, // Automatically switch based on system settings
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
    );
  }
}

/// A custom clipper class that defines a clipping shape using an oval or circular path.
class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();

  /// The `getClip` method is responsible for defining the clipping path.
  /// It takes the size of the widget as input and returns a `Path` object
  /// that describes the shape to clip.
  @override
  Path getClip(Size size) {
    // Create a new Path object to define the clipping shape.
    var path = Path();

    // Define a rectangle that represents the bounding box for the oval.
    // The rectangle is centered at the middle of the widget and its radius
    // is half of the widget's width (to create a perfect circle or oval).
    final rect = Rect.fromCircle(
      center: Offset(
        size.width /
            2, // X-coordinate of the circle's center (horizontal center of the widget).
        size.height /
            2, // Y-coordinate of the circle's center (vertical center of the widget).
      ),
      radius: size.width /
          2, // Radius of the circle (half the width of the widget).
    );

    // Add an oval (or circle) to the path using the defined rectangle.
    path.addOval(rect);

    // Return the path to be used for clipping.
    return path;
  }

  /// The `shouldReclip` method determines whether the clip needs to be recalculated
  /// when the widget is rebuilt. Returning `false` means no recalculation is needed,
  /// as this clipper does not depend on dynamic properties.
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// This function generates a random color by combining a base color (0xFF000000) with a random RGB value
Color getRandomColor() => Color(
      0xFF000000 + // Base color with full opacity (Alpha = FF)
          math.Random().nextInt(
            // Generate a random integer
            0x00FFFFFF, // Maximum value for RGB (white color)
          ),
    );

Color getRandomColorOpacity({double opacity = 1.0}) {
  final random = math.Random();
  return Color.fromRGBO(
    random.nextInt(256), // Random red value (0-255)
    random.nextInt(256), // Random green value (0-255)
    random.nextInt(256), // Random blue value (0-255)
    opacity.clamp(0.0, 1.0), // Clamp opacity between 0.0 and 1.0
  );
}

const kAnimationDuration = Duration(seconds: 1);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _color = getRandomColor();
  // var _color = getRandomColorOpacity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: const CircleClipper(),
          child: TweenAnimationBuilder(
            tween: ColorTween(
              begin: getRandomColor(),
              end: _color,
            ),
            onEnd: () {
              setState(() {
                // Update the color to a new random color when the animation ends.
                _color = getRandomColor();
              });
            },
            duration: kAnimationDuration,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: Colors.orange,
            ),
            builder: (context, Color? color, child) {
              // Fallback to transparent if null
              final effectiveColor = color ?? Colors.transparent;

              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                  effectiveColor,
                  BlendMode.srcATop,
                ),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}













//* This function generates a random color by combining a base color (0xFF000000) with a random RGB value
// Color getRandomColor() => Color(
//       0xFF000000 + 
//           math.Random().nextInt( 
//             0x00FFFFFF, 
//           ),
//     );

// Explanation
// Color Constructor:
// The Color class is used to create a color from a 32-bit integer value, where the format is ARGB (Alpha, Red, Green, Blue).
// The 0xFF000000 part sets the alpha channel to FF (fully opaque) and initializes the RGB values to 000000 (black).

// math.Random().nextInt(0x00FFFFFF):
// The math.Random() class generates random numbers.
// The nextInt(max) method generates a random integer between 0 (inclusive) and max (exclusive).
// Here, the maximum value is 0x00FFFFFF, which represents the largest possible RGB value (white).
// This ensures that the generated color is within the range of valid RGB values.

// Adding the Random RGB Value:
// The random RGB value generated by math.Random().nextInt(0x00FFFFFF) is added to the base color 0xFF000000.
// This results in a random color with full opacity and random red, green, and blue components.

// How It Works
// Base Color (0xFF000000):
// Sets the alpha channel to fully opaque (FF) and initializes the red, green, and blue channels to zero (000000).
// Random RGB Value (math.Random().nextInt(0x00FFFFFF)):
// Generates a random 24-bit integer representing a combination of red, green, and blue values.

// Addition:
// Adding the base color (0xFF000000) to the random RGB value ensures that the alpha channel remains fully opaque
// while the RGB channels vary randomly.


//* ORIGINAL CODES
// class CustomShapeClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();

//     final rect = Rect.fromCircle(
//       center: Offset(
//         size.width / 2,
//         size.height / 2,
//       ),
//       radius: size.width / 2,
//     );

//     path.addOval(rect);

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }


// ——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-

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
