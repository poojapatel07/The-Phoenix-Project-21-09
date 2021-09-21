import 'package:phoenix/src/Begin/pages/settings/settings_pages/changelogs.dart';
import 'package:phoenix/src/Begin/pages/settings/settings_pages/interface.dart';
import 'package:phoenix/src/Begin/pages/settings/settings_pages/phoenix.dart';
import 'package:phoenix/src/Begin/widgets/artwork_background.dart';
import 'package:phoenix/src/Begin/utilities/constants.dart';
import 'package:phoenix/src/Begin/utilities/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../../begin.dart';
import 'settings_pages/miscellaneous.dart';

bool breakRotate = false;
bool onSettings = false;
List settingsList = [
  "INTERFACE",
  "MISCELLANEOUS",
  "CHANGELOGS",
  "PHOENIX",
];
var globalRotational;

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    breakRotate = false;
    statusBarColor = Colors.white;
    crossfadeStateChange = true;
    yeahRotate();
    super.initState();
  }

  @override
  void dispose() {
    statusBarColor = Colors.transparent;
    breakRotate = true;
    onSettings = false;
    crossfadeStateChange = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // rootCrossfadeState = Provider.of<Leprovider>(context);
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    onSettings = true;
    bool darkModeOn = true;
    return Consumer<Leprovider>(
      builder: (context, taste, _) {
        globaltaste = taste;
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Theme(
            data: themeOfApp,
            child: Stack(
              children: [
                BackArt(),
                Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: orientedCar ? deviceWidth : deviceHeight,
                          width: orientedCar ? deviceHeight : deviceWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: orientedCar
                                        ? deviceWidth / 4.2
                                        : deviceHeight / 5.5),
                              ),
                              SizedBox(
                                height: orientedCar
                                    ? deviceWidth - deviceWidth / 4.2
                                    : deviceHeight - deviceHeight / 5.5,
                                width: orientedCar ? deviceHeight : deviceWidth,
                                child: Center(
                                  child: ListView(
                                    padding: EdgeInsets.only(
                                        top: orientedCar ? deviceWidth / 7 : 0),
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      for (int i = 0;
                                          i < settingsList.length;
                                          i++)
                                        Container(
                                          alignment: Alignment.center,
                                          width: orientedCar
                                              ? deviceHeight
                                              : deviceWidth,
                                          height: deviceWidth / 5,
                                          child: Row(
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (i == 0) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          maintainState: false,
                                                          builder: (context) =>
                                                              ChangeNotifierProvider<
                                                                  Leprovider>(
                                                            create: (_) =>
                                                                Leprovider(),
                                                            builder: (context,
                                                                    child) =>
                                                                Interface(),
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        setState(() {});
                                                      });
                                                    } else if (i == 1) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          maintainState: false,
                                                          builder: (context) =>
                                                              ChangeNotifierProvider<
                                                                  Leprovider>(
                                                            create: (_) =>
                                                                Leprovider(),
                                                            builder: (context,
                                                                    child) =>
                                                                Miscellaneous(),
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        setState(() {});
                                                      });
                                                    } else if (i == 2) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          maintainState: false,
                                                          builder: (context) =>
                                                              ChangeNotifierProvider<
                                                                  Leprovider>(
                                                            create: (_) =>
                                                                Leprovider(),
                                                            builder: (context,
                                                                    child) =>
                                                                Changelogs(),
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        setState(() {});
                                                      });
                                                    } else if (i == 3) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          maintainState: false,
                                                          builder: (context) =>
                                                              ChangeNotifierProvider<
                                                                  Leprovider>(
                                                            create: (_) =>
                                                                Leprovider(),
                                                            builder: (context,
                                                                    child) =>
                                                                Phoenix(),
                                                          ),
                                                        ),
                                                      ).then((value) {
                                                        setState(() {});
                                                      });
                                                    }
                                                  },
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: orientedCar
                                                          ? deviceHeight
                                                          : deviceWidth,
                                                      height: orientedCar
                                                          ? deviceWidth / 5.1
                                                          : deviceHeight / 12,
                                                      child: Center(
                                                        child: Text(
                                                          settingsList[i],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Urban",
                                                              fontSize: orientedCar
                                                                  ? deviceWidth /
                                                                      22
                                                                  : deviceHeight /
                                                                      40,
                                                              color: darkModeOn
                                                                  ? Colors.white
                                                                  : kMaterialBlack),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppBar(
                          iconTheme: IconThemeData(
                            color: darkModeOn ? kMaterialBlack : Colors.white,
                          ),
                          elevation: deviceWidth / 60,
                          toolbarHeight: orientedCar
                              ? deviceWidth / 4.2
                              : deviceHeight / 5.5,
                          backgroundColor:
                              darkModeOn ? Colors.white : kMaterialBlack,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(deviceWidth / 14),
                            ),
                          ),
                          centerTitle: true,
                          title: Text(
                            "SETTINGS",
                            style: TextStyle(
                                letterSpacing: 1,
                                fontFamily: "Futura",
                                fontSize: deviceWidth / 10,
                                color:
                                    darkModeOn ? kMaterialBlack : Colors.white),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              top: orientedCar
                                  ? deviceWidth / 4.2 -
                                      deviceWidth / 14 +
                                      MediaQuery.of(context).padding.top
                                  : deviceHeight / 5.5 -
                                      deviceWidth / 14 +
                                      MediaQuery.of(context).padding.top),
                          child: Container(
                            height: deviceWidth / 7,
                            width: deviceWidth / 7,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                  blurRadius: 1.0,
                                  spreadRadius: deviceWidth / 230,
                                ),
                              ],
                              color: kMaterialBlack,
                              shape: BoxShape.circle,
                            ),
                            child: Consumer<MrMan>(
                              builder: (context, rotational, child) {
                                globalRotational = rotational;
                                return RotatedBox(
                                  quarterTurns: rotational.rotate,
                                  child: Hero(
                                    tag: "fortress1",
                                    child: Icon(
                                      Ionicons.settings_sharp,
                                      color: Color(0xFF02c9d3),
                                      size: deviceWidth / 9,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

yeahRotate() async {
  await Future.delayed(Duration(milliseconds: 280));
  int drotate = 0;
  int i = 0;

  high:
  while (i < 2) {
    if (breakRotate) {
      breakRotate = false;
      break high;
    }
    await Future.delayed(Duration(milliseconds: 60));
    drotate -= 1;
    globalRotational.rotator(drotate);
  }
}
