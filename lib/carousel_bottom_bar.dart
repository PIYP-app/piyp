import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:piyp/source.dart';
import 'package:share_plus/share_plus.dart';

class CarouselBottomBar extends StatefulWidget implements PreferredSizeWidget {
  const CarouselBottomBar({
    super.key,
    required this.visibility,
    required this.file,
  });

  final bool visibility;
  final SourceFile file;

  @override
  State<CarouselBottomBar> createState() => _CarouselBottomBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}

class _CarouselBottomBarState extends State<CarouselBottomBar>
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
      child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 246, 246, 246),
              border: Border(
                  top: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
          height: 73,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: const Icon(color: Colors.blue, CupertinoIcons.share),
                onTap: () async {
                  final downloadImage = await DefaultCacheManager()
                      .getFileFromCache(
                          '${widget.file.server.getBaseUrl()}/${widget.file.name}');

                  if (downloadImage == null) {
                    return;
                  }
                  final box = context.findRenderObject() as RenderBox?;
                  final result = await Share.shareXFiles(
                      [XFile(downloadImage.file.path)],
                      fileNameOverrides: [downloadImage.file.basename],
                      sharePositionOrigin:
                          box!.localToGlobal(Offset.zero) & box.size);

                  if (result.status == ShareResultStatus.success) {
                    return;
                  }
                },
              ),
            ],
          )),
    );
  }
}
