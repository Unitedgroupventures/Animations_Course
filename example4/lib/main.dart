import 'package:flutter/material.dart';

void main() {
  runApp(
    const App(),
  );
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

const people = [
  Person(name: 'Apple', age: 20, emoji: '👧'),
  Person(name: 'Axe', age: 21, emoji: '👱'),
  Person(name: 'Angel', age: 22, emoji: '👱🏽‍♀️'),
];

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        useMaterial3: false,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DetailsPage(
                      person: person,
                    );
                  },
                ),
              );
            },
            leading: Hero(
              tag: person.name,
              child: Text(
                person.emoji,
                style: const TextStyle(
                  fontSize: 40.0,
                ),
              ),
            ),
            title: Text(person.name),
            subtitle: Text(
              '${person.age} years old',
            ),
            trailing: const Icon(
              Icons.arrow_forward,
            ),
          );
        },
      ),
    );
  }
}

// A stateless widget that displays detailed information about a person.
class DetailsPage extends StatelessWidget {
  // The `Person` object passed to this page, containing details like name, age, and emoji.
  final Person person;

  // Constructor to initialize the `DetailsPage` with a required `Person` object.
  const DetailsPage({
    super.key, // Key for widget identification (used for optimization).
    required this.person, // Marks the `person` parameter as required.
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Provides a basic structure for the page, including an app bar and body.
      appBar: AppBar(
        // The title of the app bar is wrapped in a Hero widget for smooth transitions.
        title: Hero(
          // Customizes how the hero transition animation behaves during navigation.
          flightShuttleBuilder: (
            flightContext,
            animation,
            flightDirection,
            fromHeroContext,
            toHeroContext,
          ) {
            // Switches behavior based on whether the animation is a "push" or "pop".
            switch (flightDirection) {
              case HeroFlightDirection.push:
                // Defines how the hero widget transitions when navigating forward (push).
                return Material(
                  color: Colors
                      .transparent, // Makes the transition background transparent.
                  child: ScaleTransition(
                    scale: animation.drive(
                      Tween<double>(
                        begin: 0.0, // Starts at scale 0 (invisible).
                        end: 1.0, // Ends at scale 1 (full size).
                      ).chain(
                        CurveTween(
                          curve: Curves
                              .fastOutSlowIn, // Adds a smooth easing curve.
                        ),
                      ),
                    ),
                    child: toHeroContext
                        .widget, // Uses the destination hero widget during transition.
                  ),
                );
              case HeroFlightDirection.pop:
                // Defines how the hero widget transitions when navigating backward (pop).
                return Material(
                  color: Colors.transparent,
                  child: fromHeroContext
                      .widget, // Uses the source hero widget during transition.
                );
            }
          },
          tag: person.name, // Unique tag to identify this hero across routes.
          child: Text(
            person.emoji, // Displays the person's emoji as the hero content.
            style: const TextStyle(
              fontSize: 50.0, // Makes the emoji large and visually prominent.
            ),
          ),
        ),
      ),
      body: Center(
        // Centers content vertically and horizontally within the body of the page.
        child: Column(
          children: [
            const SizedBox(
                height: 20.0), // Adds spacing above the first text widget.

            Text(
              person.name, // Displays the person's name.
              style: const TextStyle(
                fontSize: 20.0, // Sets text size for readability.
              ),
            ),

            const SizedBox(
                height: 20.0), // Adds spacing between name and age text.

            Text(
              '${person.age} years old', // Displays the person's age dynamically.
              style: const TextStyle(
                fontSize:
                    20.0, // Sets text size for consistency with name text.
              ),
            ),
          ],
        ),
      ),
    );
  }
}








// ——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-

// Detailed Breakdown
// 1. Hero Widget
// Purpose:
// The Hero widget enables smooth animations between screens by transitioning its content from one route to another using matching tags.

// Key Properties:
// tag: A unique identifier linking two Hero widgets across routes. In this case,
// person.name ensures that this hero corresponds to another hero in a different route displaying the same person's details.
// flightShuttleBuilder: Customizes how the hero transitions between routes.
// It allows you to define animations like scaling (ScaleTransition) or other effects.

// 2. flightShuttleBuilder
// Push Direction (HeroFlightDirection.push):
// When navigating forward (e.g., tapping on a list item),
// it animates scaling up from invisible (scale = 0) to full size (scale = 1) using a smooth curve (Curves.fastOutSlowIn).
// Pop Direction (HeroFlightDirection.pop):
// When navigating backward (e.g., pressing back), it simply returns to its original state without additional animations.

// 3. Scaffold
// Provides structure for the page:
// AppBar: Contains a title that uses a Hero widget for animated transitions.
// Body: Displays detailed information about the person in a vertically centered column.

// 4. Column
// Organizes content vertically:
// Displays:
// The person's name (Text(person.name)).
// Their age (Text('${person.age} years old')).
// Adds spacing between elements using SizedBox.

// 5. Styling
// Uses consistent font sizes (TextStyle(fontSize: ...)) for readability and visual appeal.

// How Hero Animations Work
// 1. A source Hero exists in one route (e.g., list view).
// 2. A destination Hero exists in another route (e.g., details view).
// 3. The Navigator matches these heroes by their tags and animates their transition using an overlay.

// During navigation:
// Flutter calculates bounds and animates size/position changes using default or custom tweens (like scaling in this example).

// Practical Example
// If you have a list of people with their emojis displayed as heroes in one screen,
// tapping on an emoji triggers navigation to this DetailsPage.
// The emoji smoothly scales up during navigation and scales back down when returning.

// Enhancements
// 1. Add more details about the person dynamically (e.g., bio or hobbies).
// 2. Customize animations further with other transitions like fades or rotations.


// ——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-——-

//* ORIGINAL CODES
// class DetailsPage extends StatelessWidget {
//   final Person person;
//   const DetailsPage({
//     super.key,
//     required this.person,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Hero(
//           flightShuttleBuilder: (
//             flightContext,
//             animation,
//             flightDirection,
//             fromHeroContext,
//             toHeroContext,
//           ) {
//             switch (flightDirection) {
//               case HeroFlightDirection.push:
//                 return Material(
//                   color: Colors.transparent,
//                   child: ScaleTransition(
//                       scale: animation.drive(Tween<double>(
//                         begin: 0.0,
//                         end: 1.0,
//                       ).chain(
//                         CurveTween(
//                           curve: Curves.fastOutSlowIn,
//                         ),
//                       )),
//                       child: toHeroContext.widget),
//                 );
//               case HeroFlightDirection.pop:
//                 return Material(
//                   color: Colors.transparent,
//                   child: fromHeroContext.widget,
//                 );
//             }
//           },
//           tag: person.name,
//           child: Text(
//             person.emoji,
//             style: const TextStyle(
//               fontSize: 50.0,
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20.0,
//             ),
//             Text(
//               person.name,
//               style: const TextStyle(
//                 fontSize: 20.0,
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             Text(
//               '${person.age} years old',
//               style: const TextStyle(
//                 fontSize: 20.0,
//               ),
//             ),
//           ],
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
