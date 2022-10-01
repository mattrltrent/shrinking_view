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

// Ensure you use either SingleTickerProviderStateMixin or TickerProviderStateMixin.
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late ShrinkingViewController controller; // <--- Create a ShrinkingViewController.

  @override
  void initState() {
    controller = ShrinkingViewController(
        tickerProvider: this,
        expandingAnimationDuration: const Duration(milliseconds: 500),
        shrinkingAnimationDuration: const Duration(milliseconds: 850)); // <-- Initialize it with a TickerProvider
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShrinkingView(
      // <--- Wrap your widget (usually a Scaffold) with the ShrinkingView.
      borderRadiusValue: 65,
      scaleMultiplier: 0.05,
      // shrinkingAnimationCurve: Curves.bounceOut,
      expandingAnimationCurve: Curves.bounceOut,
      // topRightSquared: true,
      // topLeftSquared: true,
      verticalTranslateMultiplier: .1,
      controller: controller, // <--- Pass it the controller.
      backgroundColorWhileAnimating: Colors.black,
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
                onPressed: () => controller.expand(), // <--- Expand the ShrinkingView
                child: const Text("Expand (action)"),
              ),
              TextButton(
                onPressed: () => controller.shrink(), // <--- Shrink the ShrinkingView
                child: const Text("Shrink (action)"),
              ),
              TextButton(
                onPressed: () => print(controller.isShrunk()), // <--- Is it shrunk?
                child: const Text("Is shrunk? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isExpanded()), // <--- Is it expanded?
                child: const Text("Is expanded? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isAnimating()), // <--- Is it animating?
                child: const Text("Is animating? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isShrinkingCurrently()), // <--- Is it currently shrinking?
                child: const Text("Is currently shrinking? (bool)"),
              ),
              TextButton(
                onPressed: () => print(controller.isExpandingCurrently()), // <--- Is it currently expanding?
                child: const Text("Is currently expanding? (bool)"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
