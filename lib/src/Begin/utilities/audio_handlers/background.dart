import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:phoenix/src/Begin/begin.dart';

class AudioPlayerTask extends BaseAudioHandler {
  AudioPlayerTask() {
    _init();
  }
  List<MediaItem> leQueue = [];
  final AudioPlayer _audioPlayer = AudioPlayer(
    handleInterruptions: true,
    androidApplyAudioAttributes: true,
    handleAudioSessionActivation: true,
  );
  int indexOfQueue = 0;
  int addToQueueIndex = -1;
  AudioProcessingState _skipState;
  StreamSubscription<PlaybackEvent> _eventSubscription;
  ConcatenatingAudioSource source;

  _init() {
    // Broadcast that we're connecting, and what controls are available.
    _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      _broadcastState();
    });
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        mediaItem.add(leQueue[index]);
        indexOfQueue = index;
        if (addToQueueIndex == index) {
          addToQueueIndex = -1;
        }
      }
    });

    _audioPlayer.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          break;
        case ProcessingState.ready:
          _skipState = null;
          break;
        default:
          break;
      }
    });
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    if (addToQueueIndex == -1) {
      addToQueueIndex = indexOfQueue + 1;
    } else {
      addToQueueIndex += 1;
    }
    leQueue.insert(addToQueueIndex, mediaItem);
    source.insert(addToQueueIndex, AudioSource.uri(Uri.parse(mediaItem.id)));
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    leQueue.insert(index, mediaItem);
  }

  @override
  Future<void> updateQueue(List mediaItems) async {
    leQueue = mediaItems;
    source = ConcatenatingAudioSource(
      children:
          leQueue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
    );
    await _audioPlayer.setAudioSource(source, preload: false, initialIndex: 0);
    mediaItem.add(leQueue[0]);
    _audioPlayer.setLoopMode(LoopMode.all);
    addToQueueIndex = -1;
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.all)
      _audioPlayer.setShuffleModeEnabled(true);
    else
      _audioPlayer.setShuffleModeEnabled(false);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode loopMode) async {
    if (loopMode == AudioServiceRepeatMode.one)
      _audioPlayer.setLoopMode(LoopMode.one);
    else
      _audioPlayer.setLoopMode(LoopMode.all);
  }

  @override
  Future<void> play() async {
    _audioPlayer.play();
  }

  @override
  Future<void> click([MediaButton button = MediaButton.media]) async {
    switch (button) {
      case MediaButton.next:
        skipToNext();
        break;
      case MediaButton.previous:
        skipToPrevious();
        break;
      case MediaButton.media:
        if (_audioPlayer.playing) {
          await _audioPlayer.pause();
        } else {
          audioHandler.play();
        }
        break;
    }
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    // Stop playing audio.
    _audioPlayer.stop();
    _eventSubscription.cancel();
    await _broadcastState();
    // Broadcast that we've stopped.
    playbackState.add(PlaybackState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.completed));
    // Shut down this background task
    await super.stop();
  }

  @override
  Future<void> skipToPrevious() async {
    _audioPlayer.seekToPrevious();
    if (!_audioPlayer.playing) _audioPlayer.play();
  }

  @override
  Future<void> skipToNext() async {
    _audioPlayer.seekToNext();
    if (!_audioPlayer.playing) _audioPlayer.play();
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  Future<void> onTaskRemoved() async {
    await stop();
  }

  Future<void> _broadcastState() async {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: _getProcessingState(),
        playing: _audioPlayer.playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
      ),
    );
  }

  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState;
    switch (_audioPlayer.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_audioPlayer.processingState}");
    }
  }
}
