import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String _currentFortune = "";
  String _emoji = "";

  late AnimationController _controller;
  late Animation<double> _animation;

  final _fortuneList = [
    "You will be rich",
    "You will be poor",
    "You will be happy",
    "You will be sad",
    "You will be healthy",
    "You will be sick",
    "You will be lucky",
    "You will be unlucky",
    "You will be successful",
    "You will be a failure",
  ];

  final _emojiList = [
    "\ud83d\udcb0", // Money bag
    "\ud83d\udcb8", // Banknote
    "\ud83d\ude0a", // Smiling face
    "\ud83d\ude22", // Crying face
    "\ud83d\udc68\u200d\ud83c\udf3e", // Farmer (healthy)
    "\ud83e\udec0", // Hospital
    "\ud83c\udf89", // Party popper
    "\ud83d\udc80", // Skull
    "\ud83c\udf1f", // Star
    "\u26a0\ufe0f" // Warning
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );
      _animation =
          Tween<double>(begin: -100, end: MediaQuery.of(context).size.height)
              .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      );

      _controller.addListener(() {
        setState(() {});
      });

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _emoji = ""; // Clear emoji after animation ends
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _randomFortune() {
    var random = Random();
    int fortuneIndex = random.nextInt(_fortuneList.length);

    setState(() {
      _currentFortune = _fortuneList[fortuneIndex];
      _emoji = _emojiList[fortuneIndex];
    });

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/fortune-cookie.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Your fortune is:",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _currentFortune,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _randomFortune,
                  child: const Text("Get Fortune"),
                ),
              ],
            ),
          ),
          if (_emoji.isNotEmpty)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: _animation.value,
                  left: MediaQuery.of(context).size.width / 2 - 20,
                  child: Text(
                    _emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
