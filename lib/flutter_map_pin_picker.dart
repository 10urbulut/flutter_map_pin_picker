library flutter_map_pin_picker;

import 'package:flutter/material.dart';

class MapPickerController {
  Function()? mapMoving;
  Function()? mapFinishedMoving;
}

class MapPicker extends StatefulWidget {
  final Widget child;
  final Widget iconWidget;
  final bool? showDot;
  final MapPickerController? mapPickerController;

  const MapPicker({
    Key? key,
    required this.mapPickerController,
    required this.iconWidget,
    this.showDot = true,
    required this.child,
  }) : super(key: key);

  @override
  MapPickerState createState() => MapPickerState();
}

class MapPickerState extends State<MapPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    if (widget.mapPickerController != null) {
      widget.mapPickerController?.mapMoving = mapMoving;
      widget.mapPickerController?.mapFinishedMoving = mapFinishedMoving;
    }
    super.initState();
  }

  void mapMoving() {
    if (!animationController.isCompleted || !animationController.isAnimating) {
      animationController.forward();
    }
  }

  void mapFinishedMoving() {
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        const SizedBox(),
        AnimatedBuilder(
            animation: animationController,
            builder: (context, snapshot) {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -10 * animationController.value),
                      child: widget.iconWidget,
                    ),
                    if (widget.showDot!)
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)),
                      )
                  ],
                ),
              );
            }),
      ],
    );
  }
}
