import 'dart:io';
import 'package:phoenix/src/Begin/pages/albums/albums_inside.dart';
import 'package:phoenix/src/Begin/utilities/init.dart';
import 'package:phoenix/src/Begin/widgets/artist_collage.dart';
import '../../utilities/page_backend/artists_back.dart';
import 'package:phoenix/src/Begin/widgets/dialogues/awakening.dart';
import 'package:phoenix/src/Begin/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/Begin/begin.dart';
import 'artists_inside.dart';

class Artists extends StatefulWidget {
  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollBarController;
  @override
  void initState() {
    _scrollBarController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bool darkModeOn = true;
    if (ascend) {
      return Scrollbar(
        controller: _scrollBarController,
        child: RefreshIndicator(
          backgroundColor:
              musicBox.get("dynamicArtDB") ?? true ? nowColor : Colors.white,
          color: musicBox.get("dynamicArtDB") ?? true
              ? nowContrast
              : kMaterialBlack,
          onRefresh: () async {
            await fetchAll();
          },
          child: GridView.builder(
            controller: _scrollBarController,
            addAutomaticKeepAlives: true,
            physics: musicBox.get("fluidAnimation") ?? true
                ? BouncingScrollPhysics()
                : ClampingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 0, top: 0),
            itemCount: allArtists.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: orientedCar
                    ? (deviceHeight / 4) /
                        (deviceHeight / 4 + deviceHeight / 16)
                    : (deviceWidth / 3) / (deviceWidth / 3 + deviceWidth / 12),
                crossAxisCount: orientedCar ? 4 : 3),
            itemBuilder: (BuildContext context, int index) {
              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(kRounded),
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRounded),
                  onTap: () async {
                    artistPassed = index;
                    await artistsAllSongs(allArtists[index]);
                    if (musicBox.get("mapOfArtists") != null &&
                        musicBox.get("mapOfArtists")[allArtists[index]] !=
                            null) {
                      if (musicBox.get("colorsOfArtists") == null
                          ? true
                          : musicBox
                                  .get("colorsOfArtists")[allArtists[index]] ==
                              null) {
                        try {
                          await albumColor(FileImage(File(
                              "${applicationFileDirectory.path}/artists/${allArtists[index]}.jpg")));
                          Map colorMap = musicBox.get("colorsOfArtists") ?? {};
                          colorMap[allArtists[index]] = [
                            dominantAlbum.value,
                            contrastAlbum.value
                          ];
                          musicBox.put("colorsOfArtists", colorMap);
                        } catch (e) {
                          contrastAlbum = Colors.white;
                          dominantAlbum = kMaterialBlack;
                        }
                      } else {
                        dominantAlbum = Color(musicBox
                            .get("colorsOfArtists")[allArtists[index]][0]);
                        contrastAlbum = Color(musicBox
                            .get("colorsOfArtists")[allArtists[index]][1]);
                      }
                    } else {
                      contrastAlbum = Colors.white;
                      dominantAlbum = kMaterialBlack;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArtistsInside(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 5)),
                      PhysicalModel(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(kRounded),
                        elevation: deviceWidth / 140,
                        child: SizedBox(
                            width: orientedCar
                                ? deviceHeight / 4 - 17
                                : deviceWidth / 3 - 17,
                            height: orientedCar
                                ? deviceHeight / 4 - 17
                                : deviceWidth / 3 - 17,
                            child: artistCollage(
                              index,
                              allArtists,
                              kRounded,
                              orientedCar
                                  ? deviceHeight / 4 - 17
                                  : deviceWidth / 3 - 17,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceHeight / 100
                                : deviceWidth / 70),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 9, right: 9),
                        child: Text(
                          allArtists[index].contains(",")
                              ? allArtists[index]
                                      .replaceRange(
                                          allArtists[index].indexOf(","),
                                          allArtists[index].length,
                                          "")
                                      .contains(" FEAT")
                                  ? allArtists[index]
                                      .replaceRange(
                                          allArtists[index].indexOf(","),
                                          allArtists[index].length,
                                          "")
                                      .replaceRange(
                                          allArtists[index].indexOf("FEAT"),
                                          allArtists[index]
                                              .replaceRange(
                                                  allArtists[index]
                                                      .indexOf(","),
                                                  allArtists[index].length,
                                                  "")
                                              .length,
                                          "")
                                  : allArtists[index].replaceRange(
                                      allArtists[index].indexOf(","),
                                      allArtists[index].length,
                                      "")
                              : allArtists[index].contains(" FEAT")
                                  ? allArtists[index].replaceRange(
                                      allArtists[index].indexOf(" FEAT"),
                                      allArtists[index].length,
                                      "")
                                  : allArtists[index],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: orientedCar
                                ? deviceHeight / 58
                                : deviceWidth / 32,
                            fontFamily: "Urban",
                            fontWeight: FontWeight.w600,
                            color: musicBox.get("dynamicArtDB") ?? true
                                ? Colors.white
                                : darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                            shadows: [
                              Shadow(
                                offset: musicBox.get("dynamicArtDB") ?? true
                                    ? Offset(1.0, 1.0)
                                    : darkModeOn
                                        ? Offset(0, 1.0)
                                        : Offset(0, 0.5),
                                blurRadius: 2.0,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return orientedCar
          ? SingleChildScrollView(child: Awakening())
          : Awakening();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
