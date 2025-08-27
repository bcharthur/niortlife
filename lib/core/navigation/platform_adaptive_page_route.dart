import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A platform-adaptive page route that keeps the default iOS/Android
/// UX while giving us a single place to wrap pages with performance helpers.
class PlatformAdaptivePageRoute<T> extends PageRoute<T> {
  PlatformAdaptivePageRoute({
    required this.builder,
    RouteSettings? settings,
    this.maintain = true,
    this.fullscreenDialog = false,
  }) : super(settings: settings);

  final WidgetBuilder builder;
  final bool maintain;
  @override
  final bool fullscreenDialog;

  // Keep default transition durations (Material: 300ms, Cupertino: 400ms)
  @override
  Duration get transitionDuration =>
      _isCupertino ? const Duration(milliseconds: 400) : const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration => transitionDuration;

  bool get _isCupertino => (Platform.isIOS || Platform.isMacOS);

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => maintain;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // RepaintBoundary isolates the incoming page during transition to reduce jank.
    final child = RepaintBoundary(child: builder(context));
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (_isCupertino) {
      // Use platform-true cupertino transitions
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: true,
        child: child,
      );
    }

    // Use the same default Material fade-upwards transition used by MaterialPageRoute
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.05),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        )),
        child: child,
      ),
    );
  }
}