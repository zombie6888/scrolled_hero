import 'package:flutter/material.dart';

class PreviewModalRoute<T> extends MaterialPageRoute<T> with MaterialRouteTransitionMixin {
  PreviewModalRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = true,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override  
  Duration get transitionDuration => const Duration(seconds: 2);          

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return _FadeTransitionBuilder(routeAnimation: animation, child: child);
  }
}

class _FadeTransitionBuilder extends StatelessWidget {
  _FadeTransitionBuilder({
    Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  final Animation<double> _opacityAnimation;
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return 
    
    FadeTransition(
        opacity: _opacityAnimation,
        child: GestureDetector(
            onTap: () {                
              Navigator.of(context).pop('OK');             
            },
            child: Material(color: Colors.black, child: child)));
  }
}
