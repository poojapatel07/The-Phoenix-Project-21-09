import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/Begin/utilities/constants.dart';
import 'package:phoenix/src/Begin/utilities/native/go_native.dart';
import 'package:phoenix/src/Begin/utilities/set_ringtone.dart';
import 'package:phoenix/src/Begin/widgets/seek_bar.dart';
import '../../begin.dart';

final ringtonePlayer = AudioPlayer();

class Ringtone extends StatefulWidget {
  final int artworkId;
  final String artist;
  final String title;
  final double songDuration;
  final String filePath;

  Ringtone(
      {@required this.artworkId,
      @required this.filePath,
      @required this.artist,
      @required this.title,
      @required this.songDuration});
  @override
  _RingtoneState createState() => _RingtoneState();
}

class _RingtoneState extends State<Ringtone> with TickerProviderStateMixin {
  var animatedIcon;
  List<double> ranges = [];
  bool isCompleted = false;
  bool isStartChanged = false;
  List<double> fadeIn = [0];
  bool isProcessing = false;

  @override
  void initState() {
    animatedIcon = AnimationController(
        vsync: this, duration: Duration(milliseconds: crossfadeDuration));
    animatedIcon.forward();
    ranges = [0, widget.songDuration];
    ringtonePlayer.setFilePath(widget.filePath);
    playerState();
    getSettingPermission();
    super.initState();
  }

  @override
  void dispose() {
    animatedIcon.dispose();
    super.dispose();
  }

  playerState() {
    ringtonePlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        animatedIcon.forward();
        isCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        splashColor: Colors.transparent,
        icon: isProcessing
            ? null
            : Icon(Icons.check_rounded, color: Colors.black),
        label: isProcessing
            ? Center(
                child: Container(
                  height: deviceWidth / 25,
                  width: deviceWidth / 25,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.black,
                  ),
                ),
              )
            : Text("Set Ringtone",
                style: TextStyle(
                    inherit: false,
                    color: Colors.black,
                    fontSize: deviceWidth / 25,
                    fontFamily: 'Urban',
                    fontWeight: FontWeight.w600)),
        backgroundColor: Color(0xFF1DB954),
        elevation: 8.0,
        onPressed: () async {
          setState(() {
            isProcessing = true;
          });
          try {
            await ringtoneTrim(
                pathOfFile: widget.filePath,
                ranges: ranges,
                fade: fadeIn[0].toInt(),
                title: widget.title);
            ringtoneSuccess(context);
          } catch (e) {
            print(e);
            ringtoneFailed(context);
          }
          setState(() {
            isProcessing = false;
          });
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "RINGTONE",
          style: TextStyle(
            color: Colors.white,
            inherit: false,
            fontSize: deviceWidth / 18,
            fontWeight: FontWeight.w600,
            fontFamily: "Urban",
          ),
        ),
      ),
      body: Theme(
        data: themeOfApp,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: QueryArtworkWidget(
                id: widget.artworkId,
                type: ArtworkType.AUDIO,
                format: ArtworkFormat.JPEG,
                size: 400,
                artworkQuality: FilterQuality.high,
                keepOldArtwork: true,
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRounded),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(defaultNone),
                    ),
                  ),
                ),
                artworkBorder: BorderRadius.circular(kRounded),
                artworkFit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: artworkBlurConst, sigmaY: artworkBlurConst),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: SizedBox(
                      height: orientedCar ? deviceWidth : deviceHeight,
                      width: orientedCar ? deviceHeight : deviceWidth,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: kToolbarHeight +
                                MediaQuery.of(context).padding.top),
                        child: CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: orientedCar
                                              ? deviceWidth / 12
                                              : deviceHeight / 12,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 50, right: 50, bottom: 15),
                                        child: Text(
                                          widget.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Urban",
                                            fontWeight: FontWeight.w600,
                                            fontSize: deviceWidth / 18,
                                          ),
                                        ),
                                      ),
                                      RingtoneSeekBar(
                                          duration: Duration(
                                              milliseconds:
                                                  widget.songDuration ~/ 1)),
                                      IconButton(
                                        icon: AnimatedIcon(
                                          progress: animatedIcon,
                                          icon: AnimatedIcons.pause_play,
                                          color: Colors.white,
                                        ),
                                        iconSize: deviceWidth / 9,
                                        alignment: Alignment.center,
                                        onPressed: () async {
                                          if (isCompleted) {
                                            ringtonePlayer
                                                .setFilePath(widget.filePath);
                                            ringtonePlayer.play();
                                            isCompleted = false;
                                            animatedIcon.reverse();
                                          } else if (ringtonePlayer.playing) {
                                            ringtonePlayer.pause();
                                            animatedIcon.forward();
                                          } else {
                                            ringtonePlayer.play();
                                            animatedIcon.reverse();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: orientedCar
                                          ? deviceWidth / 9
                                          : deviceHeight / 9,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Select Range",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Urban",
                                          fontSize: deviceWidth / 18,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 30)),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                    Duration(
                                                            milliseconds:
                                                                ranges[0] ~/ 1)
                                                        .toString()
                                                        .replaceRange(0, 2, "")
                                                        .replaceRange(
                                                          7,
                                                          Duration(
                                                                  milliseconds:
                                                                      nowMediaItem
                                                                          .duration
                                                                          .inMilliseconds)
                                                              .toString()
                                                              .replaceRange(
                                                                  0, 2, "")
                                                              .length,
                                                          "",
                                                        ),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text(
                                                    Duration(
                                                            milliseconds:
                                                                ranges[1] ~/ 1)
                                                        .toString()
                                                        .replaceRange(0, 2, "")
                                                        .replaceRange(
                                                          7,
                                                          Duration(
                                                                  milliseconds:
                                                                      nowMediaItem
                                                                          .duration
                                                                          .inMilliseconds)
                                                              .toString()
                                                              .replaceRange(
                                                                  0, 2, "")
                                                              .length,
                                                          "",
                                                        ),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20)),
                                          SizedBox(
                                            width: orientedCar
                                                ? deviceHeight / 1.1
                                                : deviceWidth / 1.1,
                                            height: 50,
                                            child: FlutterSlider(
                                              trackBar: FlutterSliderTrackBar(
                                                inactiveTrackBar: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black12,
                                                  border: Border.all(
                                                      width: 3,
                                                      color: Colors.white24),
                                                ),
                                                activeTrackBar: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.white),
                                              ),
                                              axis: Axis.horizontal,
                                              values: ranges,
                                              step:
                                                  FlutterSliderStep(step: 100),
                                              tooltip: FlutterSliderTooltip(
                                                  disabled: true),
                                              rangeSlider: true,
                                              min: 0.0,
                                              max: widget.songDuration,
                                              onDragging:
                                                  (int index, start, end) {
                                                if (start != ranges[0]) {
                                                  isStartChanged = true;
                                                }
                                                setState(() {
                                                  ranges = [start, end];
                                                });
                                              },
                                              onDragCompleted:
                                                  (index, start, end) {
                                                if (start == ranges[0]) {
                                                  if (isStartChanged) {
                                                    setState(() {
                                                      ringtonePlayer.seek(
                                                          Duration(
                                                              milliseconds:
                                                                  start ~/ 1));
                                                    });
                                                    isStartChanged = false;
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: orientedCar
                                                  ? deviceWidth / 9
                                                  : deviceHeight / 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Fade In",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Urban",
                                              fontSize: deviceWidth / 18,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 50,
                                            ),
                                            child: SizedBox(
                                              width: orientedCar
                                                  ? deviceHeight / 1.1
                                                  : deviceWidth / 1.1,
                                              height: 50,
                                              child: FlutterSlider(
                                                tooltip: FlutterSliderTooltip(
                                                    format: (String value) {
                                                      return value + "s";
                                                    },
                                                    textStyle: TextStyle(
                                                        color: Colors.white),
                                                    boxStyle:
                                                        FlutterSliderTooltipBox(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .black26))),
                                                step: FlutterSliderStep(
                                                  step: 0.5,
                                                ),
                                                trackBar: FlutterSliderTrackBar(
                                                  inactiveTrackBar:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.black12,
                                                    border: Border.all(
                                                        width: 3,
                                                        color: Colors.white24),
                                                  ),
                                                  activeTrackBar: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Colors.white),
                                                ),
                                                values: fadeIn,
                                                max: 10,
                                                min: 0,
                                                onDragging: (handlerIndex,
                                                    lowerValue, upperValue) {
                                                  print(lowerValue);
                                                  setState(() {
                                                    fadeIn = [lowerValue];
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: orientedCar
                                              ? deviceWidth / 9
                                              : deviceHeight / 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ringtoneSuccess(BuildContext context) async {
    Flushbar(
      messageText: Text("Ringtone updated!",
          style: TextStyle(fontFamily: "Futura", color: Colors.white)),
      icon: Icon(
        Icons.music_note,
        size: 28.0,
        color: kCorrect,
      ),
      shouldIconPulse: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      borderColor: Colors.white.withOpacity(0.04),
      borderWidth: 1,
      backgroundColor: glassOpacity,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      barBlur:
          musicBox.get("glassBlur") == null ? 18 : musicBox.get("glassBlur"),
      margin: EdgeInsets.only(bottom: 20, left: 8, right: 8),
      borderRadius: BorderRadius.circular(15),
    )..show(context);
  }

  ringtoneFailed(BuildContext context) async {
    Flushbar(
      messageText: Text("Failed to set ringtone",
          style: TextStyle(fontFamily: "Futura", color: Colors.white)),
      icon: Icon(
        Icons.error_outline,
        size: 28.0,
        color: Color(0xFFCB0447),
      ),
      shouldIconPulse: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 3),
      borderColor: Colors.white.withOpacity(0.04),
      borderWidth: 1,
      backgroundColor: glassOpacity,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      barBlur:
          musicBox.get("glassBlur") == null ? 18 : musicBox.get("glassBlur"),
      margin: EdgeInsets.only(bottom: 20, left: 8, right: 8),
      borderRadius: BorderRadius.circular(15),
    )..show(context);
  }
}
