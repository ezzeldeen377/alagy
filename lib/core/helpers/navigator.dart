import 'package:flutter/material.dart';

extension NavigatorExtension on BuildContext {
  /// Get the navigator state
  NavigatorState get navigator => Navigator.of(this);

  /// Push a new route onto the navigator
  Future<T?> push<T extends Object?>(Widget page) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push a named route onto the navigator
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replace the current route with a new one
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) {
    return navigator.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
      result: result,
    );
  }

  /// Replace the current named route with a new named route
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigator.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Push a new route and remove all the previous routes until a condition is met
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) {
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  /// Push a named route and remove all the previous routes until a condition is met
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return navigator.pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Pop the current route off the navigator
  void pop<T extends Object?>([T? result]) {
    return navigator.pop<T>(result);
  }

  /// Pop routes until a condition is met
  void popUntil(bool Function(Route<dynamic>) predicate) {
    return navigator.popUntil(predicate);
  }

  /// Check if the navigator can pop
  bool canPop() => navigator.canPop();

  /// Get the arguments passed to the current route
  T? getArguments<T>() {
    return ModalRoute.of(this)?.settings.arguments as T?;
  }

  /// Pop all routes except the first route
  void popToFirst() {
    return navigator.popUntil((route) => route.isFirst);
  }

  /// Pop until a named route is found
  void popUntilNamed(String routeName) {
    return navigator.popUntil(ModalRoute.withName(routeName));
  }

  /// Push a new route and remove all existing routes
  Future<T?> pushAndRemoveAll<T extends Object?>(Widget page) {
    return pushAndRemoveUntil<T>(page, (_) => false);
  }

  /// Push a named route and remove all existing routes
  Future<T?> pushNamedAndRemoveAll<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }
}