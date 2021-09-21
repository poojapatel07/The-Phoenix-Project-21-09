import 'package:phoenix/src/Begin/utilities/init.dart';
import 'package:phoenix/src/Begin/widgets/dialogues/awakening.dart';
import 'package:phoenix/src/Begin/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/Begin/begin.dart';
import '../../utilities/page_backend/albums_back.dart';
import 'albums_inside.dart';

int passedIndexAlbum;
String selectedAlbumName;

class Albums extends StatefulWidget {
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> with AutomaticKeepAliveClientMixin {
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
            itemCount: allAlbums.length,
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
                    passedIndexAlbum = index;
                    if (musicBox.get("colorsOfAlbums") == null
                        ? true
                        : musicBox.get(
                                "colorsOfAlbums")[allAlbums[index].album] ==
                            null) {
                      await albumColor(MemoryImage(
                          albumsArts[allAlbums[index].album] ?? defaultNone));

                      Map albumColors = musicBox.get("colorsOfAlbums") ?? {};
                      albumColors[allAlbums[index].album] = [
                        dominantAlbum.value,
                        contrastAlbum.value
                      ];
                      musicBox.put("colorsOfAlbums", albumColors);
                    } else {
                      dominantAlbum = Color(musicBox
                          .get("colorsOfAlbums")[allAlbums[index].album][0]);
                      contrastAlbum = Color(musicBox
                          .get("colorsOfAlbums")[allAlbums[index].album][1]);
                    }
                    inAlbumSongs = [];
                    albumMediaItems = [];
                    inAlbumSongsArtIndex = [];
                    await albumSongs();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AlbumsInside()),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 5)),
                      Hero(
                        tag: "sterio-$index",
                        child: PhysicalModel(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(kRounded),
                          elevation: deviceWidth / 140,
                          child: Container(
                            width: orientedCar
                                ? deviceHeight / 4 - 17
                                : deviceWidth / 3 - 17,
                            height: orientedCar
                                ? deviceHeight / 4 - 17
                                : deviceWidth / 3 - 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kRounded),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  albumsArts[allAlbums[index].album] ??
                                      defaultNone,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceHeight / 100
                                : deviceWidth / 70),
                      ),
                      SizedBox(
                        width: orientedCar
                            ? deviceHeight / 4 - 17
                            : deviceWidth / 3 - 17,
                        child: Text(
                          allAlbums[index].album.toString().toUpperCase(),
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
