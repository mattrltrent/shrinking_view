# A simple, lightweight, and fully customizable widget designed to shrink and expand a view/screen/widget programmatically. ✨

_Similar to how iOS shrinks pages behind content in the foreground. Mainly intended to wrap Scaffold widgets._

-> Submit an issue [here](https://github.com/mattrltrent/shrinking_view/issues).
-> Create a pull request [here](https://github.com/mattrltrent/shrinking_view/pulls).
-> Contact me via email [here](mailto:me@matthewtrent.me).

## Features 🔥

- Shrinks and expands a view/screen/widget.
- Controlled programmatically with a `ShrinkingViewController`.
- Requires only a few lines of code - simplicity is beautiful.

## Gif Demos 📸

<img src="https://github.com/mattrltrent/shrinking_view/blob/main/resources/demo1.gif?raw=true" width="200" height="" style="display: inline"/>
<img src="https://github.com/mattrltrent/shrinking_view/blob/main/resources/demo2.gif?raw=true" width="200" height="" style="display: inline"/>
<img src="https://github.com/mattrltrent/shrinking_view/blob/main/resources/demo4.gif?raw=true" width="200" height="" style="display: inline"/>
<img src="https://github.com/mattrltrent/shrinking_view/blob/main/resources/demo3.gif?raw=true" width="200" height="" style="display: inline"/>

## Getting Started 📜

1.  Install and import the package.
    <br>

    ```
    $ flutter pub add shrinking_view

    import 'package:shrinking_view/shrinking_view.dart';
    ```

    <br>

2.  In your app, create a `ShrinkingViewController` to pass to the `ShrinkingView` like so:
    <br>

    ```dart
    late ShrinkingViewController controller; // <--- Create a ShrinkingViewController.

        @override
        void initState() {
            controller = ShrinkingViewController(tickerProvider: this); // <-- Initialize it with a TickerProvider.
            super.initState();
        }
    ```

    **Note:** Make sure your class is using either a `SingleTickerProviderStateMixin` or `TickerProviderStateMixin` so you can pass in `this` as the `TickerProvider` as required by the `ShrinkingViewController`.
    <br>

3.  Wrap your `Scaffold` (or any widget, but `Scaffold` is recommended) inside the `ShrinkingView`, passing in the `controller` you just created.
    <br>

    ```dart
    return ShrinkingView(
      controller: controller,
      child: const Scaffold(
        body: <YOUR_APP>,
      ),
    );
    ```

    <br>

4.  You're done! You can now call `controller.<SOME_METHOD>` to control your `ShrinkingView`! 🎉

## `ShrinkingViewController` Methods 🛠️

- `shrink() => void`: Starts the shrinking animation.
  <br>
- `expand() => void`: Starts the expanding animation.
  <br>
- `isShrunk() => bool`: Returns `true` if the last static state was shrunk. For example, if the `ShrinkingView` is currently animating, this will reflect the state before the animation began.
  <br>
- `isExpanded() => bool`: Returns `true` if the last static state was expanded. For example, if the `ShrinkingView` is currently animating, this will reflect the state before the animation began.
  <br>
- `isAnimating() => bool`: Returns `true` if the `ShrinkingView` is currently animating.
  <br>
- `isShrinkingCurrently() => bool`: Returns `true` if the `ShrinkingView` is currently shrinking.
  <br>
- `isExpandingCurrently() => bool`: Returns `true` if the `ShrinkingView` is currently expanding.

## `ShrinkingView` Properties 🛠️

- (required) `controller`: The `ShrinkingViewController` you must pass in order to control the `ShrinkingView`. No default value, as it's a required field.
  <br>
- (required) `child`: The `Widget` you must pass that wraps what you want to be shrunk/expanded. Usually, this is a `Scaffold`. No default value, as it's a required field.
  <br>
- `topLeftSquared`: Whether the top left of the widget should have no `BorderRadius` applied. Default: `false`.
  <br>
- `topRightSquared`: Whether the top right of the widget should have no `BorderRadius` applied. Default: `false`.
  <br>
- `bottomRightSquared`: Whether the bottom right of the widget should have no `BorderRadius` applied. Default: `true`.
  <br>
- `bottomLeftSquared`: Whether the bottom left of the widget should have no `BorderRadius`. Default: `true`.
  <br>
- `safeAreaTop`: Whether the widget should automatically add a top `SafeArea`. Default: `false`.
  <br>
- `safeAreaBottom`: Whether the widget should automatically add a bottom `SafeArea`. Default: `false`.
  <br>
- `safeAreaLeft`: Whether the widget should automatically add a left `SafeArea`. Default: `false`.
  <br>
- `safeAreaRight`: Whether the widget should automatically add a right `SafeArea`. Default: `false`.
  <br>
- `backgroundColorWhileAnimating`: The background `Color` behind the passed `child` widget that is (usually; depending on your implementation) displayed when a shrinking/expanding animation is occuring. Default: `Colors.black`.
  <br>
- `maintainBottomViewPadding`: Specifies whether the `SafeArea` should maintain the bottom `MediaQueryData.viewPadding` instead of the bottom `MediaQueryData.padding`. Default: `true`.
  <br>
- `shrinkingAnimationCurve`: The `Animation` `Curve` that's used when a shrinking animation is occuring. Default: `Curves.decelerate`.
  <br>
- `expandingAnimationCurve`: The `Animation` `Curve` that's used when an expanding animation is occuring. Default: `Curves.linear`.
  <br>
- `verticalTranslateMultiplier`: The factor by how much down the `child` should translate. This is proportionate to the screen height (translation down: screen height \* `verticalTranslateMultiplier`). Default: `0.055`.
  <br>
- `scaleMultiplier`: The factor by how much smaller the `child` should get while shrinking. Example: `0.5` means the `child` would get 50% smaller, `0.25` means it would get 25% smaller. Default: `0.04`.
  <br>
- `borderRadiusValue`: The circular `BorderRadius` value each of the 4 corners can animate to (if their respective `<Their_Side>Squared` property is `false`). Default: `50.0`.

## Example ✍️

```dart
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
    controller = ShrinkingViewController(tickerProvider: this); // <-- Initialize it with a TickerProvider.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShrinkingView(
      // <--- Wrap your widget (usually a Scaffold) with the ShrinkingView.
      controller: controller, // <--- Pass it the controller.
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
                onPressed: () => controller.expand(), // <--- Expand the ShrinkingView.
                child: const Text("Expand (void)"),
              ),
              TextButton(
                onPressed: () => controller.shrink(), // <--- Shrink the ShrinkingView.
                child: const Text("Shrink (void)"),
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

```

## Additional information 📣

The package is always open to improvements and suggestions! Hope you enjoy :)

![analytics](https://hidden-coast-90561-45544df95b1b.herokuapp.com/api/v1/analytics/?kind=package-shrinking-view)
