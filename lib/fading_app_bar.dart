import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FadingAppBar extends StatefulWidget implements PreferredSizeWidget {
  const FadingAppBar(
      {super.key, required this.visibility, required this.fileTime});

  final bool visibility;
  final DateTime? fileTime;

  @override
  State<FadingAppBar> createState() => _FadingAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}

class _FadingAppBarState extends State<FadingAppBar>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  computeDay(DateTime? dateTime) {
    final DateTime definedDateTime = dateTime ?? DateTime.now();

    if (DateFormat.MMMd().format(definedDateTime) ==
        DateFormat.MMMd().format(DateTime.now())) {
      return 'Today';
    }
    return DateFormat.MMMMd().format(definedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visibility) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return FadeTransition(
      opacity: _animation,
      child: AppBar(
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        title: Text(widget.fileTime != null ? computeDay(widget.fileTime) : ''),
      ),
    );
  }
}
