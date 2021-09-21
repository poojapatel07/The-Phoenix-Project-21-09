import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phoenix/src/Begin/begin.dart';
import 'package:phoenix/src/Begin/utilities/constants.dart';
import 'package:phoenix/src/Begin/utilities/provider/provider.dart';
import 'package:phoenix/src/Begin/widgets/artwork_background.dart';
import 'package:provider/provider.dart';

class GlassEffect extends StatefulWidget {
  const GlassEffect({Key key}) : super(key: key);

  @override
  _GlassEffectState createState() => _GlassEffectState();
}

class _GlassEffectState extends State<GlassEffect> {
  double whiteOpacity = musicBox.get("glassOverlayColor") == null
      ? 3
      : musicBox.get("glassOverlayColor");
  double blur =
      musicBox.get("glassBlur") == null ? 18 : musicBox.get("glassBlur");
  double shadow =
      musicBox.get("glassShadow") == null ? 10 : musicBox.get("glassShadow");
  @override
  void initState() {
    crossfadeStateChange = true;
    super.initState();
  }

  @override
  void dispose() {
    musicBox.put("glassBlur", blur);
    musicBox.put("glassOverlayColor", whiteOpacity);
    musicBox.put("glassShadow", shadow);
    glassBlur = ImageFilter.blur(sigmaX: blur, sigmaY: blur);
    glassOpacity = Colors.white.withOpacity(whiteOpacity / 100);
    glassShadowOpacity = shadow;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    rootCrossfadeState = Provider.of<Leprovider>(context);

    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    return Consumer<Leprovider>(
      builder: (context, taste, _) {
        globaltaste = taste;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            shadowColor: Colors.transparent,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              "Glass Effect",
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
                BackArt(),
                Container(
                  padding: EdgeInsets.only(
                      top: kToolbarHeight + MediaQuery.of(context).padding.top),
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: SizedBox(
                                width: orientedCar
                                    ? deviceHeight / 3
                                    : deviceWidth / 1.15,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(kRounded),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(shadow / 100),
                                          blurRadius: 13,
                                          offset: kShadowOffset,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(kRounded),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: blur, sigmaY: blur),
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(kRounded),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kRounded),
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.04)),
                                              color: Colors.white.withOpacity(
                                                  whiteOpacity / 100),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "Blur",
                                  style: TextStyle(
                                    fontFamily: "Urban",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: deviceWidth / 18 / 1.3,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${blur.toInt()}",
                                      style: TextStyle(
                                          fontSize: deviceWidth / 35,
                                          fontFamily: "Urban",
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 2.0,
                                              color: Colors.black38,
                                            ),
                                          ],
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: orientedCar
                                          ? deviceHeight / 1.5
                                          : deviceWidth / 1.5,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 3,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 5),
                                          inactiveTrackColor:
                                              musicBox.get("dynamicArtDB") ??
                                                      true
                                                  ? nowContrast.withOpacity(0.1)
                                                  : Colors.white10,
                                        ),
                                        child: Slider(
                                          value: blur,
                                          min: 0,
                                          max: 40,
                                          activeColor:
                                              musicBox.get("dynamicArtDB") ??
                                                      true
                                                  ? nowContrast
                                                  : Colors.white,
                                          onChanged: (value) {
                                            setState(() {
                                              blur = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "40",
                                      style: TextStyle(
                                          fontSize: deviceWidth / 35,
                                          fontFamily: "Urban",
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 2.0,
                                              color: Colors.black38,
                                            ),
                                          ],
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Text("Opacity",
                                    style: TextStyle(
                                      fontFamily: "Urban",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: deviceWidth / 18 / 1.3,
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${whiteOpacity.toInt()}",
                                      style: TextStyle(
                                          fontSize: deviceWidth / 35,
                                          fontFamily: "Urban",
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 2.0,
                                              color: Colors.black38,
                                            ),
                                          ],
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: orientedCar
                                          ? deviceHeight / 1.5
                                          : deviceWidth / 1.5,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 5),
                                          trackHeight: 3,
                                          inactiveTrackColor:
                                              musicBox.get("dynamicArtDB") ??
                                                      true
                                                  ? nowContrast.withOpacity(0.1)
                                                  : Colors.white10,
                                        ),
                                        child: Slider(
                                          value: whiteOpacity,
                                          min: 0,
                                          max: 20,
                                          activeColor:
                                              musicBox.get("dynamicArtDB") ??
                                                      true
                                                  ? nowContrast
                                                  : Colors.white,
                                          onChanged: (value) {
                                            setState(() {
                                              whiteOpacity = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "20",
                                      style: TextStyle(
                                          fontSize: deviceWidth / 35,
                                          fontFamily: "Urban",
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 2.0,
                                              color: Colors.black38,
                                            ),
                                          ],
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Shadow",
                                  style: TextStyle(
                                    fontFamily: "Urban",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: deviceWidth / 18 / 1.3,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${shadow.toInt()}",
                                      style: TextStyle(
                                          fontSize: deviceWidth / 35,
                                          fontFamily: "Urban",
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 2.0,
                                              color: Colors.black38,
                                            ),
                                          ],
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: orientedCar
                                          ? deviceHeight / 1.5
                                          : deviceWidth / 1.5,
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 3,
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 5),
                                          inactiveTrackColor:
                                              musicBox.get("dynamicArtDB") ??
                                                      true
                                                  ? nowContrast.withOpacity(0.1)
                                                  : Colors.white10,
                                        ),
                                        child: Slider(
                                          value: shadow,
                                          min: 0,
                                          max: 20,
                                          activeColor:
                                              musicBox.get("dynamicArtDB") ??
                                                      true
                                                  ? nowContrast
                                                  : Colors.white,
                                          onChanged: (value) {
                                            setState(() {
                                              shadow = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "20",
                                      style: TextStyle(
                                          fontSize: deviceWidth / 35,
                                          fontFamily: "Urban",
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 2.0,
                                              color: Colors.black38,
                                            ),
                                          ],
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      whiteOpacity = 3;
                                      blur = 18;
                                      shadow = 10;
                                      // shadowBlur = 13;
                                    });
                                  },
                                  style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.white30)),
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                      fontFamily: "Urban",
                                      color: Colors.white,
                                      fontSize: orientedCar
                                          ? deviceWidth / 34
                                          : deviceWidth / 34,
                                    ),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
