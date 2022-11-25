import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/music_list.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:lottie/lottie.dart';
import 'package:page_animation_transition/animations/top_to_bottom_transition.dart';
import 'package:provider/provider.dart';
import 'Changer.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:flutter_share/flutter_share.dart';


final assetsAudioPlayer = AssetsAudioPlayer();

class now_playing extends StatefulWidget {
  final String? Path;
  final int? Song_Id;
  final String? Song_Name;
  final String? Artist_Name;

  const now_playing(
      {Key? key, this.Path, this.Song_Id, this.Song_Name, this.Artist_Name})
      : super(key: key);

  @override
  State<now_playing> createState() => _now_playingState();
}

class _now_playingState extends State<now_playing> {
  String _Song_Name = '';
  String _Song_Artist = '';
  int _Song_Id = 0;

  Duration? Song_duration;
  bool _isPlaying = true;
  bool LoopModeON = false;
  Color LoopModeColor = Colors.white;




  void Play_Song(String Path) async {
    _Song_Name = widget.Song_Name!;
    _Song_Artist = widget.Artist_Name!;
    _Song_Id = widget.Song_Id!;

    await assetsAudioPlayer.open(
      Audio.file(Path),
      notificationSettings: NotificationSettings(),
      showNotification: true,
    );
    assetsAudioPlayer.play();
    _isPlaying = true;
    Song_duration = assetsAudioPlayer.current.value?.audio.duration;
    setState(() {});
  }

  void Set_User_Back() {
    final Playing? playing = assetsAudioPlayer.current.value;
    if (widget.Path != playing?.audio.assetAudioPath) {
      Play_Song(widget.Path!);
    } else {
      _Song_Name = widget.Song_Name!;
      _Song_Artist = widget.Artist_Name!;
      _Song_Id = widget.Song_Id!;
      Song_duration = assetsAudioPlayer.current.value?.audio.duration;
      setState(() {});
    }
  }

  Future<void> shareFile() async {
    print('so what ? ');
    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: widget.Path!,
    );
  }

  @override
  void initState() {
    if (!assetsAudioPlayer.isPlaying.value) {
      Play_Song(widget.Path!);
    } else {
      Set_User_Back();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff212121),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: height / 10,
        backgroundColor: Color(0xff212121),
        flexibleSpace: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: (){
                  shareFile();
                },
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: (){
                  LoopModeON = !LoopModeON;
                  if(LoopModeON){
                    assetsAudioPlayer.setLoopMode(LoopMode.single);
                    LoopModeColor = Colors.yellowAccent;
                    setState(() {});
                  }else{
                    assetsAudioPlayer.setLoopMode(LoopMode.none);
                    LoopModeColor = Colors.white;
                    setState(() {});
                  }

                },
                child: Icon(
                  Icons.loop,
                  color: LoopModeColor,
                  size: 25,
                ),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop(PageAnimationTransition(page: const music_list(), pageAnimationType: TopToBottomTransition()));
                },
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5, left: 15, right: 15),
              child: QueryArtworkWidget(
                artworkHeight: height * 2 / 5,
                artworkWidth: width,
                artworkBorder: BorderRadius.circular(15),
                artworkQuality: FilterQuality.high,
                artworkFit: BoxFit.fill,
                id: _Song_Id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Lottie.asset('assets/music.json',
                    width: width, height: height * 2 / 5, reverse: true),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
              height: height * 1.5 / 10,
              width: width,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    width: width,
                    child: Center(
                      child: Text(
                        _Song_Name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width,
                    child: Center(
                      child: Text(
                        _Song_Artist,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 1 / 10,
              child: Column(
                children: [
                  PlayerBuilder.currentPosition(
                      player: assetsAudioPlayer,
                      builder: (context, duration) {
                        String sDuration =
                            "${duration.inHours}:${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
                        return Text(
                          sDuration,
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        );
                      }),
                  PlayerBuilder.currentPosition(
                      player: assetsAudioPlayer,
                      builder: (context, duration) {
                        return SliderTheme(
                          
                          data: SliderThemeData(
                              activeTrackColor: Colors.white,
                            valueIndicatorColor: Colors.white,

                              thumbColor: Colors.white,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
                          child: Slider(
                            value: duration.inSeconds.toDouble(),
                            min: 0,
                            max: Song_duration!.inSeconds.toDouble(),
                            onChanged: (val) {
                              assetsAudioPlayer.seek(
                                Duration(seconds: val.toInt()),
                              );
                            },
                          ),
                        );
                      }),
                ],
              ),
            ),
            Container(
              height: height * 2 / 10,
              width: width,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        assetsAudioPlayer.seekBy(Duration(seconds: -10));
                      },
                      icon: Center(
                          child: Icon(
                            Icons.fast_forward,
                            color: Colors.white,
                            size: 50,
                          )),
                    ),
                    SizedBox(
                      width: width / 5,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (_isPlaying) {
                          assetsAudioPlayer.pause();
                          Provider.of<Changer>(context, listen: false)
                              .ChangeValue();
                          _isPlaying = !_isPlaying;
                        } else {
                          assetsAudioPlayer.play();
                          Provider.of<Changer>(context, listen: false)
                              .ChangeValue();
                          _isPlaying = !_isPlaying;
                        }
                        setState(() {});
                      },
                      icon: _isPlaying
                          ? Center(
                              child: Icon(
                              Icons.pause_circle_filled,
                              color: Colors.white,
                              size: 50,
                            ))
                          : Center(
                              child: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 50,
                            )),
                    ),
                    SizedBox(
                      width: width / 5,
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        assetsAudioPlayer.seekBy(Duration(seconds: 10));
                      },
                      icon: Center(
                          child: Icon(
                            Icons.fast_rewind_rounded,
                            color: Colors.white,
                            size: 50,
                          )),
                    ),

                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
