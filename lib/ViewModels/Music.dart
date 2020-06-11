import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() {

    return _MusicPageState();
  }
}

class _MusicPageState extends State<MusicPage>
{
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  Duration currentTime = Duration();
  Duration totalTime = Duration();
  int position = 0;
  bool playing = false;
  List<SongInfo> _songs = [];
  String title = "";

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer.stop();
    getSongs();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  void getSongs() async{
    var songs = await audioQuery.getSongs();
    songs = new List.from(songs);

      setState(() {
        _songs = songs;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: 300,
            child: _songs != [] ? new ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, int index){
                return new ListTile(
                  leading: CircleAvatar(
                    child: new Text(_songs[index].title[0]),
                  ),
                  title: new Text(_songs[index].title),
                  onTap: () async{
                    assetsAudioPlayer.stop();
                    position = index;
                    String filePath = _songs[index].filePath;
                    title = _songs[index].title;
                    await assetsAudioPlayer.open(Audio.file(filePath));
                     assetsAudioPlayer.play();
                    assetsAudioPlayer.currentPosition.listen((Duration duration) {
                      setState(() {
                        currentTime = duration;
                      });
                    });
                    assetsAudioPlayer.current.listen((playingAudio) {
                      setState(() {
                        totalTime = playingAudio.audio.duration;
                      });
                    });
                     setState(() {
                       playing = true;
                     });
                  },
                );
              }
          ):Text("No songs found"),
          ),

          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: 60,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, top: MediaQuery.of(context).size.height*0.5),
            decoration: BoxDecoration(color: Colors.white),
            child: Text("Currently playing: " + title),
          ),

          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: 60,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, top: MediaQuery.of(context).size.height*0.6),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,

              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: FlatButton(
                    onPressed: () async {
                      if (position > 0) {
                        position--;
                        String filePath = _songs[position].filePath;
                        title = _songs[position].title;
                        await assetsAudioPlayer.open(Audio.file(filePath));
                        assetsAudioPlayer.play();
                        playing = true;

                        print(position);
                      }
                      else{
                        position = _songs.length - 1;
                        String filePath = _songs[position].filePath;
                        title = _songs[position].title;
                        await assetsAudioPlayer.open(Audio.file(filePath));
                        assetsAudioPlayer.play();
                        playing = true;

                        print(position);

                      }
                    },
                    child: Image.asset('assets/previous.png'),
                  ),
                ),



                Container(
                  height: 70,
                  width: 70,
                  child: FlatButton(
                      child: Image.asset(playing ? 'assets/pause.png' : 'assets/play.png'),
                      onPressed: () async{
                        assetsAudioPlayer.playOrPause();
                        if(playing){
                          setState(() {
                            title = _songs[position].title;
                            playing = false;

                          });
                        }
                        else{
                          setState(() {
                            title = _songs[position].title;
                            playing = true;
                          });
                        }
                      }
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  child: FlatButton(
                      child: Image.asset('assets/stop.png'),
                      onPressed: (){
                        assetsAudioPlayer.stop();
                        setState(() {
                          playing = false;
                          title = "";
                        });
                      }
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: FlatButton(
                    child: Image.asset('assets/next.png'),
                    onPressed: () async {
                      if(position < _songs.length-1){
                        position++;
                        String filePath = _songs[position].filePath;
                        title = _songs[position].title;
                        await assetsAudioPlayer.open(Audio.file(filePath));
                        assetsAudioPlayer.play();
                        playing = true;
                        print(position);
                      }
                      else{
                        position = 0;
                        String filePath = _songs[position].filePath;
                        title = _songs[position].title;
                        await assetsAudioPlayer.open(Audio.file(filePath));
                        assetsAudioPlayer.play();
                        playing = true;
                        print(position);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: 40,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, top: MediaQuery.of(context).size.height*0.7),
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(currentTime.toString().split(".")[0]),
                Slider(
                  value: currentTime.inSeconds.toDouble(),
                  min: 0.0,
                  max: totalTime.inSeconds.toDouble(),
                  onChanged: (double value){
                    setState(() {
                      seekToSec(value.toInt());
                      value = value;
                    });
                  },
                ),

                Text((totalTime-currentTime).toString().split(".")[0]),
              ],

            ),

          ),

        ],

      ),

    );
  }
  void seekToSec(int second){
    Duration newDuration = Duration(seconds: second);
    assetsAudioPlayer.seek(newDuration);
  }
}
