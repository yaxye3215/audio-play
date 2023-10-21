import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlay = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
// when use local audios
  // Future setAudio() async {
  //   //repeat song when complete
  //   audioPlayer.setReleaseMode(ReleaseMode.loop);
  //   final result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     final file = File(result.files.single.path ?? '');
  //     final player = AudioCache(prefix: "assets/");
  //     final url = await player.load("audio.mp3");
  //     audioPlayer.setSourceUrl(file.path);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlay = state == PlayerState.playing;
      });
    });
    // listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  // String formatTime(double time) {
  //   Duration duration = Duration(milliseconds: time.round());
  //   return [duration.inHours, duration.inMinutes, duration.inSeconds]
  //       .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
  //       .join(':');
  // }
  String formatTime(Duration duration) {
    var date = duration.toString().split(":");
    var hrs = date[0];
    var mns = date[1];
    var sds = date[2].split(".")[0];
    return "$hrs:$mns:$sds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("audio play"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://images.pexels.com/photos/18664914/pexels-photo-18664914/free-photo-of-a-woman-with-a-large-hat-on-her-head.jpeg",
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const Text(
              "the audio",
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioPlayer.seek(position);
                //optional
                await audioPlayer.resume();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration - position)),
              ],
            ),
            CircleAvatar(
              radius: 40,
              child: IconButton(
                onPressed: () async {
                  if (isPlay) {
                    await audioPlayer.pause();
                  } else {
                    String url =
                        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';
                    await audioPlayer.play(UrlSource(url));
                    // await audioPlayer.resume();
                  }
                },
                icon: Icon(
                  isPlay ? Icons.pause : Icons.play_circle,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
