import 'package:phoenix/src/Begin/begin.dart';
import 'package:phoenix/src/Begin/utilities/audio_handlers/previous_play_skip.dart';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

/// Credits to Sjoerd Bolten - https://github.com/Netlob/dart-lyrics
class Lyrics {
  final String _url =
      // "https://www.google.com/search?client=safari&rls=en&ie=UTF-8&oe=UTF-8&q=";
      "https://www.google.com/search?q=";
  String _delimiter1 =
      '</div></div></div></div><div class="hwc"><div class="BNeawe tAd8D AP7Wnd"><div><div class="BNeawe tAd8D AP7Wnd">';
  String _delimiter2 =
      '</div></div></div></div></div><div><span class="hwc"><div class="BNeawe uEec3 AP7Wnd">';

  Lyrics({delimiter1, delimiter2}) {
    this.setDelimiters(delimiter1: delimiter1, delimiter2: delimiter2);
  }

  void setDelimiters({String delimiter1, String delimiter2}) {
    _delimiter1 = delimiter1 ?? _delimiter1;
    _delimiter2 = delimiter2 ?? _delimiter2;
  }

  Future<List> getLyrics({String track, String artist, String path}) async {
    onGoingProcess = true;
    // if (track == null || artist == null)
    if (track == null) throw Exception("track must not be null");

    var lyrics;

    // try multiple queries

    if (artist == " ") {
      try {
        lyrics =
            (await http.get(Uri.parse(Uri.encodeFull('$_url$track lyrics'))))
                .body;
        lyrics = lyrics.split(_delimiter1).last;
        lyrics = lyrics.split(_delimiter2).first;
        if (lyrics.indexOf('<meta charset="UTF-8">') > -1) throw Error();
      } catch (_) {
        return (["Couldn't find any matching lyrics.", path]);
      }
    } else {
      try {
        lyrics = (await http.get(
                Uri.parse(Uri.encodeFull('$_url$track by $artist lyrics'))))
            .body;

        lyrics = lyrics.split(_delimiter1).last;
        lyrics = lyrics.split(_delimiter2).first;
        if (lyrics.indexOf('<meta charset="UTF-8">') > -1) throw Error();
      } catch (_) {
        try {
          lyrics = (await http.get(Uri.parse(
                  Uri.encodeFull('$_url$track by $artist song lyrics'))))
              .body;
          lyrics = lyrics.split(_delimiter1).last;
          lyrics = lyrics.split(_delimiter2).first;
          if (lyrics.indexOf('<meta charset="UTF-8">') > -1) throw Error();
        } catch (_) {
          try {
            lyrics = (await http.get(Uri.parse(Uri.encodeFull(
                    '$_url${track.split("-").first} by $artist lyrics'))))
                .body;
            lyrics = lyrics.split(_delimiter1).last;
            lyrics = lyrics.split(_delimiter2).first;
            if (lyrics.indexOf('<meta charset="UTF-8">') > -1) throw Error();
          } catch (_) {
            return (["Couldn't find any matching lyrics.", path]);
          }
        }
      }
    }

    final List<String> split = lyrics.split('\n');
    String result = '';
    for (var i = 0; i < split.length; i++) {
      result = '$result${split[i]}\n';
    }
    return [result.trim(), path];
  }
}

lyricsFetch(songArtist, songName, songData) async {
  lyricsDat = "";
  List lyrics = await Lyrics()
      .getLyrics(artist: songArtist, track: songName, path: songData);
  if (onGoingProcess) {
    if (lyrics[1] == nowMediaItem.id) {
      lyricsDat = "";
      String anotherLyrics = lyrics[0];
      onGoingProcess = false;
      if (anotherLyrics
          .contains("Sometimes you may be asked to solve the CAPTCHA")) {
        print("CAPTCH-MATE");
        anotherLyrics = "Couldn't find any matching lyrics.";
      }
      if (anotherLyrics.contains("</div>")) {
        anotherLyrics = anotherLyrics.replaceRange(
            anotherLyrics.indexOf("</div>"), anotherLyrics.length, "");
      }
      lyricsDat = HtmlUnescape().convert(anotherLyrics);
      saveLyrics(lyrics[1], lyricsDat);
    }
  }
}
