import 'dart:io';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class music_list extends StatefulWidget {
  const music_list({Key? key}) : super(key: key);

  @override
  State<music_list> createState() => _music_listState();
}

class _music_listState extends State<music_list> {
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
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
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
  //data : path
  //title : title

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
    scrollDirection: Axis.vertical,
    itemCount: SONGS.length,
    itemBuilder: ((context, index) {
        return Container(
          margin: EdgeInsets.only(top: 7,left: 8,right: 8),
          width: width,
          height: height/10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color(0xff2f2f2f))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Expanded(
                  child: Text(SONGS[index].title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              QueryArtworkWidget(
                id: SONGS[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Icon(Icons.music_note),
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.blueAccent,
              //     image: DecorationImage(
              //       image: FileImage(File(SONGS[index].uri!)),
              //       fit: BoxFit.fill,
              //     ),
              //   ),
              // ),
            ],
          ),
        );
    }
        ),
    ),
      ),
    );
  }
}
