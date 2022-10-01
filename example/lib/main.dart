import 'package:flutter/material.dart';
import 'package:shrinking_view/shrinking_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'shrinking_view package',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late ShrinkingViewController controller;

  @override
  void initState() {
    controller = ShrinkingViewController(tickerProvider: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShrinkingView(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("shrinking_view example"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => controller.expand(),
                child: const Text("Expand (action)"),
              ),
              TextButton(
                onPressed: () => controller.shrink(),
                child: const Text("Shrink (action)"),
              ),
              TextButton(
                onPressed: () => print(controller.isShrunk()),
                child: const Text("Is shrunk? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isExpanded()),
                child: const Text("Is expanded? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isAnimating()),
                child: const Text("Is animating? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isShrinkingCurrently()),
                child: const Text("Is currently shrinking? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isExpandingCurrently()),
                child: const Text("Is currently expanding? (bool)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
