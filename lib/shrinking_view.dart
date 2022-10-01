library shrinking_view;

import 'package:flutter/material.dart';

class ShrinkingViewController extends ChangeNotifier {
  /// The [TickerProvider] that manages the animation for the [ShrinkingView].
  ///
  /// Add the mixin [SingleTickerProviderStateMixin] or [TickerProviderStateMixin] to your class that
  /// the [ShrinkingView] resides in, then add "this" as the parameter for [tickerProvider].
  final TickerProvider tickerProvider;
  late AnimationController _animController;

  /// The time it takes to complete the shrink animation.
  ///
  /// Defaults to 175 milliseconds.
  late Duration? shrinkingAnimationDuration;

  /// The time it takes to complete the expand animation.
  ///
  /// Defaults to 175 milliseconds.
  late Duration? expandingAnimationDuration;

  ShrinkingViewController(
      {required this.tickerProvider, Duration? shrinkingAnimationDuration, Duration? expandingAnimationDuration}) {
    shrinkingAnimationDuration = shrinkingAnimationDuration ?? const Duration(milliseconds: 175);
    expandingAnimationDuration = expandingAnimationDuration ?? const Duration(milliseconds: 175);
    _animController = AnimationController(
      vsync: tickerProvider,
      duration: shrinkingAnimationDuration,
      reverseDuration: expandingAnimationDuration,
    );
  }

  /// Starts the expanding animation.
  void expand() => _animController.reverse();

  /// Starts the shrinking animation.
  void shrink() => _animController.forward();

  /// Checks if the LAST STATIC state of the view was shrunk. This means
  /// that if the [ShrinkingView] is currently animating, this could be incorrect. Instead,
  /// check [isAnimating], [isShrinkingCurrently], or [isExpandingCurrently] for a more accurate
  /// depication of what's happening.
  ///
  /// If so, returns true. Else, returns false.
  bool isShrunk() => _animController.isCompleted;

  /// Checks if the LAST STATIC state of the view was expanded. This means
  /// that if the [ShrinkingView] is currently animating, this could be incorrect. Instead,
  /// check [isAnimating], [isShrinkingCurrently], or [isExpandingCurrently] for a more accurate
  /// depication of what's happening.
  ///
  /// If so, returns true. Else, returns false.
  bool isExpanded() => !_animController.isCompleted;

  /// Checks if view is currently animating.
  ///
  /// If so, returns true. Else, returns false.
  bool isAnimating() => _animController.isAnimating;

  /// Checks if view is currently shrinking.
  ///
  /// If so, returns true. Else, returns false.
  bool isShrinkingCurrently() => _animController.velocity > 0;

  /// Checks if view is currently expanding.
  ///
  /// If so, returns true. Else, returns false.
  bool isExpandingCurrently() => _animController.velocity < 0;
}

class ShrinkingView extends StatefulWidget {
  const ShrinkingView({
    required this.controller,
    required this.child,
    this.safeAreaBottom = false,
    this.safeAreaTop = false,
    this.safeAreaLeft = false,
    this.safeAreaRight = false,
    this.topLeftSquared = false,
    this.topRightSquared = false,
    this.bottomLeftSquared = true,
    this.bottomRightSquared = true,
    this.backgroundColorWhileAnimating = Colors.black,
    this.maintainBottomViewPadding = true,
    this.expandingAnimationCurve = Curves.linear,
    this.shrinkingAnimationCurve = Curves.decelerate,
    this.scaleMultiplier = .04,
    this.verticalTranslateMultiplier = .055,
    this.borderRadiusValue = 50.0,
    super.key,
  });

  /// Controller that allows you to manage the [ShrinkingView].
  ///
  /// Includes methods to shrink and expand the [child], alongside check
  /// a bunch of information about the state of the shrinking/expanding.
  final ShrinkingViewController controller;

  /// The child this widget wraps.
  final Widget child;

  /// Should the top left corner be squared (no border radius)?
  final bool topLeftSquared;

  /// Should the top right corner be squared (no border radius)?
  final bool topRightSquared;

  /// Should the bottom right corner be squared (no border radius)?
  final bool bottomRightSquared;

  /// Should the bottom left corner be squared (no border radius)?
  final bool bottomLeftSquared;

  /// Should this widget apply a top [SafeArea]?
  final bool safeAreaTop;

  /// Should this widget apply a bottom [SafeArea]?
  final bool safeAreaBottom;

  /// Should this widget apply a left [SafeArea]?
  final bool safeAreaLeft;

  /// Should this widget apply a right [SafeArea]?
  final bool safeAreaRight;

  /// The background color behind the [child] while it's being animated and is
  /// less than the size it was to start.
  final Color backgroundColorWhileAnimating;

  /// Specifies whether the [SafeArea] should maintain the
  /// bottom [MediaQueryData.viewPadding] instead of the bottom
  /// [MediaQueryData.padding].
  final bool maintainBottomViewPadding;

  /// The curve the animation uses while shrinking.
  final Curve shrinkingAnimationCurve;

  /// The curve the animation uses while expanding.
  final Curve expandingAnimationCurve;

  /// The factor by how much down the [child] should translate.
  ///
  /// Is proportionate to the screen height (translation down: screen height * [verticalTranslateMultiplier]).
  final double verticalTranslateMultiplier;

  /// The factor by how much smaller the [child] should get while shrinking.
  ///
  /// Example: 0.5 means it would get 50% smaller, 0.25 means it would get 25% smaller.
  final double scaleMultiplier;

  /// The [BorderRadius] value each of the 4 corners can animate to.
  final double borderRadiusValue;

  @override
  State<ShrinkingView> createState() => _ShrinkingViewState();
}

class _ShrinkingViewState extends State<ShrinkingView> with SingleTickerProviderStateMixin {
  late Animation _anim;

  @override
  void initState() {
    // Initializes the CurvedAnimation.
    _anim = CurvedAnimation(
      parent: widget.controller._animController,
      curve: widget.expandingAnimationCurve,
      reverseCurve: widget.shrinkingAnimationCurve,
    );
    // Starts listening to changes to the animation in order to update state.
    _anim.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller._animController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColorWhileAnimating,
      child: Transform.scale(
        scale: -_anim.value * widget.scaleMultiplier + 1,
        child: Transform.translate(
          offset: Offset(0, _anim.value * MediaQuery.of(context).size.height * widget.verticalTranslateMultiplier),
          child: SafeArea(
            top: widget.safeAreaTop,
            bottom: widget.safeAreaBottom,
            left: widget.safeAreaLeft,
            right: widget.safeAreaRight,
            maintainBottomViewPadding: widget.maintainBottomViewPadding,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.topLeftSquared ? 0 : _anim.value * widget.borderRadiusValue),
                topRight: Radius.circular(widget.topRightSquared ? 0 : _anim.value * widget.borderRadiusValue),
                bottomLeft: Radius.circular(widget.bottomLeftSquared ? 0 : _anim.value * widget.borderRadiusValue),
                bottomRight: Radius.circular(widget.bottomRightSquared ? 0 : _anim.value * widget.borderRadiusValue),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
