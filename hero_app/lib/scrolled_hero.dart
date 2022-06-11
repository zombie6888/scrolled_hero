import 'package:flutter/material.dart';
import 'package:hero_app/insets_clipper.dart';

class VerticalScrollOffsetTransition extends AnimatedWidget {
  final double topOffset;
  final double bottomOffset;
  final double paddingTop;
  final Animation<double> animation;
  final Widget child;
  final RectTween heroRectTween;
  final Size overlaySize;

  const VerticalScrollOffsetTransition(
      {Key? key,
      required this.animation,
      required this.child,
      required this.overlaySize,
      required this.paddingTop,
      required this.bottomOffset,
      required this.topOffset,
      required this.heroRectTween})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Rect rect = heroRectTween.evaluate(animation)!;
    final RelativeRect offsets = RelativeRect.fromSize(rect, overlaySize);

    return ClipRect(
        clipper: InsetsClipper(
          EdgeInsets.only(
              top: topOffset + paddingTop - offsets.top,
              bottom: bottomOffset - offsets.bottom),
        ),
        child: child);
  }
}

class ScrolledHero extends StatelessWidget {
  final double topOffset;
  final double bottomOffset;
  final Object tag;
  final Tween<Rect?> Function(Rect?, Rect?)? createRectTween;
  final Widget Function(BuildContext, Animation<double>, HeroFlightDirection,
      BuildContext, BuildContext)? flightShuttleBuilder;
  final Widget Function(BuildContext, Size, Widget)? placeholderBuilder;
  final bool transitionOnUserGestures;
  final Widget child;
  const ScrolledHero(
      {Key? key,
      required this.tag,
      this.createRectTween,
      this.flightShuttleBuilder,
      this.placeholderBuilder,
      this.transitionOnUserGestures = false,
      required this.bottomOffset,
      required this.topOffset,
      required this.child})
      : super(key: key);

  Rect _boundingBoxFor(BuildContext context, BuildContext? ancestorContext) {
    assert(ancestorContext != null);
    final RenderBox box = context.findRenderObject()! as RenderBox;
    assert(box.hasSize && box.size.isFinite);
    return MatrixUtils.transformRect(
      box.getTransformTo(ancestorContext?.findRenderObject()),
      Offset.zero & box.size,
    );
  }

  Widget scrolledShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final Hero toHero = toHeroContext.widget as Hero;

    final fromRouteContext = Navigator.of(fromHeroContext).context;
    final toRouteContext = Navigator.of(toHeroContext).context;

    final mediaQueryData = MediaQuery.of(
        flightDirection == HeroFlightDirection.push
            ? toHeroContext
            : fromHeroContext);
    final scrolledScreenSize = mediaQueryData.size;
    // generally, status bar height
    final paddingTop = mediaQueryData.padding.top;

    final Rect fromHeroLocation =
        _boundingBoxFor(fromHeroContext, fromRouteContext);
    final Rect toHeroLocation = _boundingBoxFor(toHeroContext, toRouteContext);

    final heroRectTween =
        RectTween(begin: fromHeroLocation, end: toHeroLocation);

    final proxyAnimation = flightDirection == HeroFlightDirection.push
        ? animation
        : ReverseAnimation(animation);

    return VerticalScrollOffsetTransition(
        bottomOffset: bottomOffset,
        topOffset: topOffset,
        paddingTop: paddingTop,
        heroRectTween: heroRectTween,
        overlaySize: scrolledScreenSize,
        animation: proxyAnimation,
        child: toHero.child);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder ?? scrolledShuttleBuilder,
      child: child,
    );
  }
}
