import 'dart:developer';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_dishes/src/consts/assets.dart';

class WErrorWidget extends StatefulWidget {
  const WErrorWidget({Key? key, required this.exception}) : super(key: key);
  final FlutterErrorDetails exception;

  @override
  State<WErrorWidget> createState() => _WErrorWidgetState();
}

class _WErrorWidgetState extends State<WErrorWidget> {
  int selectedIndex = 0;
  List<String> gifs = [
    Assets.assets1,
    Assets.assets2,
    Assets.assets3,
    Assets.assets4,
    Assets.assets5,
    Assets.assets6,
    Assets.assets7,
    Assets.assets8,
    Assets.assets9,
    Assets.assets10,
    Assets.assets11,
    Assets.assets12,
    Assets.assets13,
    Assets.assets14,
    Assets.assets15,
    Assets.assets16,
    Assets.assets17,
    Assets.assets18,
    Assets.assets19,
    Assets.assetsNever,
  ];
  final player = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    math.Random randomized = math.Random();
    selectedIndex = randomized.nextInt(20);
    if (!kDebugMode) {
      if (selectedIndex == 19) {
        player.play(AssetSource(Assets.assetsNeverSong));
      } else {
        player.play(AssetSource(Assets.assetsAmore));
      }
      player.setReleaseMode(ReleaseMode.loop);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.stop().whenComplete(() => player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log("ErrorWidget", error: widget.exception);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Something went wrong during presentation.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Me not panicking right now:",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .popUntil((route) => !route.hasActiveRouteBelow);
                },
                child: Image.asset(
                  gifs[selectedIndex],
                  width: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (kDebugMode)
              Expanded(
                // height: 200,
                child: SingleChildScrollView(
                  child: SelectableText(
                    widget.exception.exception.toString(),
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
