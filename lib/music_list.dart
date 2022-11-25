import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music_player/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:miniplayer/miniplayer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';
import 'Changer.dart';

class music_list extends StatefulWidget {
  const music_list({Key? key}) : super(key: key);

  @override
  State<music_list> createState() => _music_listState();
}

class _music_listState extends State<music_list> {
  int playing_song_id = 0;
  String playing_song_name = '';
  String playing_song_artist = '';
  String playing_song_path = '';

  final OnAudioQuery _audioQuery = OnAudioQuery();

  requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  List<SongModel> SONGS = [];
  Future<List<SongModel>> fetchData() async {
    var Result = await _audioQuery.querySongs(
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    return Result;
  }

  @override
  void initState() {
    requestPermission();
    fetchData().then((value) {
      setState(() {
        SONGS.clear();
        SONGS.addAll(value);
      });
    });
    super.initState();
  }
  // data : path,
  // title : title,

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff212121),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: SONGS.length,
              itemBuilder: ((context, index) {
                return Visibility(
                  visible: SONGS[index].isMusic! ? true : false,
                  child: InkWell(
                    onTap: () async {
                      playing_song_id = SONGS[index].id;
                      playing_song_name = SONGS[index].displayNameWOExt;
                      playing_song_artist = SONGS[index].artist!;
                      playing_song_path = SONGS[index].data;
                      setState(() {});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => now_playing(
                            Path: SONGS[index].data,
                            Song_Id: SONGS[index].id,
                            Song_Name: SONGS[index].displayNameWOExt,
                            Artist_Name: SONGS[index].artist!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 4, left: 4),
                      padding: EdgeInsets.all(7),
                      width: width,
                      height: height / 10,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              QueryArtworkWidget(
                                id: SONGS[index].id,
                                size: 100,
                                artworkBorder: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Container(
                                  child: Lottie.asset('assets/music.json',
                                      width: 50, height: 50),
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Container(
                                child: Expanded(
                                  child: Text(SONGS[index].displayNameWOExt,
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false),
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            Miniplayer(
              elevation: 5,
              minHeight: 70,
              maxHeight: 70,
              builder: (height, percentage) {
                return InkWell(
                  onTap: (){
                    if(assetsAudioPlayer.isPlaying.value){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => now_playing(Song_Name: playing_song_name,
                          Song_Id: playing_song_id,
                          Artist_Name: playing_song_artist,
                          Path: playing_song_path,
                          ),
                        ),
                      );
                    }else{
                      print('No Song !');
                    }

                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    color: Color(0xff999999),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          QueryArtworkWidget(
                            id: playing_song_id,
                            size: 100,
                            artworkBorder: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Container(
                              child: Lottie.asset('assets/music.json',
                                  width: 50, height: 50),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(playing_song_name,
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false)),
                          assetsAudioPlayer.builderIsPlaying(
                              builder: (context, _isPlaying) {
                            return IconButton(
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
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
