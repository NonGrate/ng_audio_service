import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_audio_service.dart';

abstract class AudioServicePlatform extends PlatformInterface {
  /// Constructs an AudioServicePlatform.
  AudioServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioServicePlatform _instance = MethodChannelAudioService();

  /// The default instance of [AudioServicePlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioService].
  static AudioServicePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [AudioServicePlatform] when they register themselves.
  // TODO(amirh): Extract common platform interface logic.
  // https://github.com/flutter/flutter/issues/43368
  static set instance(AudioServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<ConfigureResponse> configure(ConfigureRequest request) {
    throw UnimplementedError('configure() has not been implemented.');
  }

  Future<void> setState(SetStateRequest request) {
    throw UnimplementedError('setState() has not been implemented.');
  }

  Future<void> setQueue(SetQueueRequest request) {
    throw UnimplementedError('setQueue() has not been implemented.');
  }

  Future<void> setMediaItem(SetMediaItemRequest request) {
    throw UnimplementedError('setMediaItem() has not been implemented.');
  }

  Future<void> stopService(StopServiceRequest request) {
    throw UnimplementedError('stopService() has not been implemented.');
  }

  Future<void> setAndroidPlaybackInfo(
      SetAndroidPlaybackInfoRequest request) async {}

  Future<void> androidForceEnableMediaButtons(
      AndroidForceEnableMediaButtonsRequest request) async {}

  Future<void> notifyChildrenChanged(
      NotifyChildrenChangedRequest request) async {}

  void setClientCallbacks(AudioClientCallbacks callbacks);

  void setHandlerCallbacks(AudioHandlerCallbacks callbacks);
}

/// Callbacks from the platform to a client running in another isolate.
abstract class AudioClientCallbacks {
  const AudioClientCallbacks();

  Future<void> onPlaybackStateChanged(OnPlaybackStateChangedRequest request);

  Future<void> onQueueChanged(OnQueueChangedRequest request);

  Future<void> onMediaItemChanged(OnMediaItemChangedRequest request);

  // We currently implement children notification in Dart through inter-isolate
  // send/receive ports.
  // XXX: Could we actually implement the above 3 callbacks in the same way?
  // If so, then platform->client communication should be reserved for a future
  // feature where an app can observe another process's media session.
  //Future<void> onChildrenLoaded(OnChildrenLoadedRequest request);

  // TODO: Add more callbacks
}

/// Callbacks from the platform to the handler.
abstract class AudioHandlerCallbacks {
  /// Prepare media items for playback.
  Future<void> prepare(PrepareRequest request);

  /// Prepare a specific media item for playback.
  Future<void> prepareFromMediaId(PrepareFromMediaIdRequest request);

  /// Prepare playback from a search query.
  Future<void> prepareFromSearch(PrepareFromSearchRequest request);

  /// Prepare a media item represented by a Uri for playback.
  Future<void> prepareFromUri(PrepareFromUriRequest request);

  /// Start or resume playback.
  Future<void> play(PlayRequest request);

  /// Play a specific media item.
  Future<void> playFromMediaId(PlayFromMediaIdRequest request);

  /// Begin playback from a search query.
  Future<void> playFromSearch(PlayFromSearchRequest request);

  /// Play a media item represented by a Uri.
  Future<void> playFromUri(PlayFromUriRequest request);

  /// Play a specific media item.
  Future<void> playMediaItem(PlayMediaItemRequest request);

  /// Pause playback.
  Future<void> pause(PauseRequest request);

  /// Process a headset button click, where [ClickRequest.button] defaults to
  /// [MediaButtonMessage.media].
  Future<void> click(ClickRequest request);

  /// Stop playback and release resources.
  Future<void> stop(StopRequest request);

  /// Add [AddQueueItemRequest.mediaItem] to the queue.
  Future<void> addQueueItem(AddQueueItemRequest request);

  /// Add [AddQueueItemsRequest.queue] to the queue.
  Future<void> addQueueItems(AddQueueItemsRequest request);

  /// Insert [InsertQueueItemRequest.mediaItem] into the queue at position [InsertQueueItemRequest.index].
  Future<void> insertQueueItem(InsertQueueItemRequest request);

  /// Update to the queue to [UpdateQueueRequest.queue].
  Future<void> updateQueue(UpdateQueueRequest request);

  /// Update the properties of [UpdateMediaItemRequest.mediaItem].
  Future<void> updateMediaItem(UpdateMediaItemRequest request);

  /// Remove [RemoveQueueItemRequest.mediaItem] from the queue.
  Future<void> removeQueueItem(RemoveQueueItemRequest request);

  /// Remove media item from the queue at the specified [RemoveQueueItemAtRequest.index].
  Future<void> removeQueueItemAt(RemoveQueueItemAtRequest request);

  /// Skip to the next item in the queue.
  Future<void> skipToNext(SkipToNextRequest request);

  /// Skip to the previous item in the queue.
  Future<void> skipToPrevious(SkipToPreviousRequest request);

  /// Jump forward by [AudioServiceConfigMessage.fastForwardInterval].
  Future<void> fastForward(FastForwardRequest request);

  /// Jump backward by [AudioServiceConfigMessage.rewindInterval]. Note: this value
  /// must be positive.
  Future<void> rewind(RewindRequest request);

  /// Skip to a queue item.
  Future<void> skipToQueueItem(SkipToQueueItemRequest request);

  /// Seek to [SeekRequest.position].
  Future<void> seek(SeekRequest request);

  /// Set the rating.
  Future<void> setRating(SetRatingRequest request);

  Future<void> setCaptioningEnabled(SetCaptioningEnabledRequest request);

  /// Set the repeat mode.
  Future<void> setRepeatMode(SetRepeatModeRequest request);

  /// Set the shuffle mode.
  Future<void> setShuffleMode(SetShuffleModeRequest request);

  /// Begin or end seeking backward continuously.
  Future<void> seekBackward(SeekBackwardRequest request);

  /// Begin or end seeking forward continuously.
  Future<void> seekForward(SeekForwardRequest request);

  /// Set the playback speed.
  Future<void> setSpeed(SetSpeedRequest request);

  /// A mechanism to support app-specific actions.
  Future<dynamic> customAction(CustomActionRequest request);

  /// Handle the task being swiped away in the task manager (Android).
  Future<void> onTaskRemoved(OnTaskRemovedRequest request);

  /// Handle the notification being swiped away (Android).
  Future<void> onNotificationDeleted(OnNotificationDeletedRequest request);

  Future<void> onNotificationClicked(OnNotificationClickedRequest request);

  /// Get the children of a parent media item.
  Future<GetChildrenResponse> getChildren(GetChildrenRequest request);

  /// Get a particular media item.
  Future<GetMediaItemResponse> getMediaItem(GetMediaItemRequest request);

  /// Search for media items.
  Future<SearchResponse> search(SearchRequest request);

  /// Set the remote volume on Android. This works only when using
  /// [RemoteAndroidPlaybackInfoMessage].
  Future<void> androidSetRemoteVolume(AndroidSetRemoteVolumeRequest request);

  /// Adjust the remote volume on Android. This works only when using
  /// [RemoteAndroidPlaybackInfoMessage].
  Future<void> androidAdjustRemoteVolume(
      AndroidAdjustRemoteVolumeRequest request);
}

/// The states of audio processing.
enum AudioProcessingStateMessage {
  /// There hasn't been any resource loaded yet.
  idle,

  /// Resource is being loaded.
  loading,

  /// Resource is being buffered.
  buffering,

  /// Resource is buffered enough and available for playback.
  ready,

  /// The end of resource was reached.
  completed,

  /// There was an error loading resource.
  ///
  /// [PlaybackStateMessage.errorCode] and [PlaybackStateMessage.errorMessage] will be not null
  /// in this state.
  error,
}

/// The actons associated with playing audio.
enum MediaActionMessage {
  stop,
  pause,
  play,
  rewind,
  skipToPrevious,
  skipToNext,
  fastForward,
  setRating,
  seek,
  playPause,
  playFromMediaId,
  playFromSearch,
  skipToQueueItem,
  playFromUri,
  prepare,
  prepareFromMediaId,
  prepareFromSearch,
  prepareFromUri,
  setRepeatMode,
  unused_1,
  unused_2,
  setShuffleMode,
  seekBackward,
  seekForward,
}

class MediaControlMessage {
  /// A reference to an Android icon resource for the control (e.g.
  /// `"drawable/ic_action_pause"`)
  final String androidIcon;

  /// A label for the control
  final String label;

  /// The action to be executed by this control
  final MediaActionMessage action;

  @literal
  const MediaControlMessage({
     this.androidIcon,
     this.label,
     this.action,
  });

  Map<String, dynamic> toMap() => {
        'androidIcon': androidIcon,
        'label': label,
        'action': action.index,
      };
}

/// The playback state which includes a [playing] boolean state, a processing
/// state such as [AudioProcessingStateMessage.buffering], the playback position and
/// the currently enabled actions to be shown in the Android notification or the
/// iOS control center.
class PlaybackStateMessage {
  /// The audio processing state e.g. [AudioProcessingStateMessage.buffering].
  final AudioProcessingStateMessage processingState;

  /// Whether audio is either playing, or will play as soon as [processingState]
  /// is [AudioProcessingStateMessage.ready]. A true value should be broadcast whenever
  /// it would be appropriate for UIs to display a pause or stop button.
  ///
  /// Since [playing] and [processingState] can vary independently, it is
  /// possible distinguish a particular audio processing state while audio is
  /// playing vs paused. For example, when buffering occurs during a seek, the
  /// [processingState] can be [AudioProcessingStateMessage.buffering], but alongside
  /// that [playing] can be true to indicate that the seek was performed while
  /// playing, or false to indicate that the seek was performed while paused.
  final bool playing;

  /// The list of currently enabled controls which should be shown in the media
  /// notification. Each control represents a clickable button with a
  /// [MediaActionMessage] that must be one of:
  ///
  /// * [MediaActionMessage.stop]
  /// * [MediaActionMessage.pause]
  /// * [MediaActionMessage.play]
  /// * [MediaActionMessage.rewind]
  /// * [MediaActionMessage.skipToPrevious]
  /// * [MediaActionMessage.skipToNext]
  /// * [MediaActionMessage.fastForward]
  /// * [MediaActionMessage.playPause]
  final List<MediaControlMessage> controls;

  /// Up to 3 indices of the [controls] that should appear in Android's compact
  /// media notification view. When the notification is expanded, all [controls]
  /// will be shown.
  final List<int> androidCompactActionIndices;

  /// The set of system actions currently enabled. This is for specifying any
  /// other [MediaActionMessage]s that are not supported by [controls], because they do
  /// not represent clickable buttons. For example:
  ///
  /// * [MediaActionMessage.seek] (enable a seek bar)
  /// * [MediaActionMessage.seekForward] (enable press-and-hold fast-forward control)
  /// * [MediaActionMessage.seekBackward] (enable press-and-hold rewind control)
  ///
  /// Note that specifying [MediaActionMessage.seek] in [systemActions] will enable
  /// a seek bar in both the Android notification and the iOS control center.
  /// [MediaActionMessage.seekForward] and [MediaActionMessage.seekBackward] have a special
  /// behaviour on iOS in which if you have already enabled the
  /// [MediaActionMessage.skipToNext] and [MediaActionMessage.skipToPrevious] buttons, these
  /// additional actions will allow the user to press and hold the buttons to
  /// activate the continuous seeking behaviour.
  ///
  /// When enabling the seek bar, also note that some Android devices will not
  /// render the seek bar correctly unless your [AudioServiceConfigMessage.androidNotificationIcon]
  /// is a monochrome white icon on a transparent background, and your
  /// [AudioServiceConfigMessage.notificationColor] is a non-transparent color.
  final Set<MediaActionMessage> systemActions;

  /// The playback position at [updateTime].
  ///
  /// For efficiency, the [updatePosition] should NOT be updated continuously in
  /// real time. Instead, it should be updated only when the normal continuity
  /// of time is disrupted, such as during a seek, buffering and seeking. When
  /// broadcasting such a position change, the [updateTime] specifies the time
  /// of that change, allowing clients to project the realtime value of the
  /// position as `position + (DateTime.now() - updateTime)`.
  final Duration updatePosition;

  /// The buffered position.
  final Duration bufferedPosition;

  /// The current playback speed where 1.0 means normal speed.
  final double speed;

  /// The time at which the playback position was last updated.
  final DateTime updateTime;

  /// The error code when [processingState] is [AudioProcessingStateMessage.error].
  final int errorCode;

  /// The error message when [processingState] is [AudioProcessingStateMessage.error].
  final String errorMessage;

  /// The current repeat mode.
  final AudioServiceRepeatModeMessage repeatMode;

  /// The current shuffle mode.
  final AudioServiceShuffleModeMessage shuffleMode;

  /// Whether captioning is enabled.
  final bool captioningEnabled;

  /// The index of the current item in the queue, if any.
  final int queueIndex;

  /// Creates a [PlaybackStateMessage] with given field values, and with [updateTime]
  /// defaulting to [DateTime.now].
  PlaybackStateMessage({
    this.processingState = AudioProcessingStateMessage.idle,
    this.playing = false,
    this.controls = const [],
    this.androidCompactActionIndices,
    this.systemActions = const {},
    this.updatePosition = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.speed = 1.0,
    DateTime updateTime,
    this.errorCode,
    this.errorMessage,
    this.repeatMode = AudioServiceRepeatModeMessage.none,
    this.shuffleMode = AudioServiceShuffleModeMessage.none,
    this.captioningEnabled = false,
    this.queueIndex,
  })  : assert(androidCompactActionIndices == null ||
            androidCompactActionIndices.length <= 3),
        this.updateTime = updateTime ?? DateTime.now();

  factory PlaybackStateMessage.fromMap(Map map) => PlaybackStateMessage(
        processingState:
            AudioProcessingStateMessage.values[map['processingState']],
        playing: map['playing'],
        controls: const [],
        androidCompactActionIndices: null,
        systemActions: (map['systemActions'] as List)
            .map((dynamic action) => MediaActionMessage.values[action as int])
            .toSet(),
        updatePosition: Duration(microseconds: map['updatePosition']),
        bufferedPosition: Duration(microseconds: map['bufferedPosition']),
        speed: map['speed'],
        updateTime: DateTime.fromMillisecondsSinceEpoch(map['updateTime']),
        errorCode: map['errorCode'],
        errorMessage: map['errorMessage'],
        repeatMode: AudioServiceRepeatModeMessage.values[map['repeatMode']],
        shuffleMode: AudioServiceShuffleModeMessage.values[map['shuffleMode']],
        captioningEnabled: map['captioningEnabled'],
        queueIndex: map['queueIndex'],
      );

  Map<String, dynamic> toMap() => {
        'processingState': processingState.index,
        'playing': playing,
        'controls': controls.map((control) => control.toMap()).toList(),
        'androidCompactActionIndices': androidCompactActionIndices,
        'systemActions': systemActions.map((action) => action.index).toList(),
        'updatePosition': updatePosition.inMilliseconds,
        'bufferedPosition': bufferedPosition.inMilliseconds,
        'speed': speed,
        'updateTime': updateTime.millisecondsSinceEpoch,
        'errorCode': errorCode,
        'errorMessage': errorMessage,
        'repeatMode': repeatMode.index,
        'shuffleMode': shuffleMode.index,
        'captioningEnabled': captioningEnabled,
        'queueIndex': queueIndex,
      };
}

class AndroidVolumeDirectionMessage {
  static const lower = AndroidVolumeDirectionMessage(-1);
  static const same = AndroidVolumeDirectionMessage(0);
  static const raise = AndroidVolumeDirectionMessage(1);
  static const values = <int, AndroidVolumeDirectionMessage>{
    -1: lower,
    0: same,
    1: raise,
  };
  final int index;

  @literal
  const AndroidVolumeDirectionMessage(this.index);

  @override
  String toString() => '$index';
}

class AndroidPlaybackTypeMessage {
  static const local = AndroidPlaybackTypeMessage(1);
  static const remote = AndroidPlaybackTypeMessage(2);
  final int index;

  @literal
  const AndroidPlaybackTypeMessage(this.index);

  @override
  String toString() => '$index';
}

enum AndroidVolumeControlTypeMessage { fixed, relative, absolute }

abstract class AndroidPlaybackInfoMessage {
  @literal
  const AndroidPlaybackInfoMessage();

  Map<String, dynamic> toMap();
}

class RemoteAndroidPlaybackInfoMessage extends AndroidPlaybackInfoMessage {
  //final AndroidAudioAttributes audioAttributes;
  final AndroidVolumeControlTypeMessage volumeControlType;
  final int maxVolume;
  final int volume;

  @literal
  const RemoteAndroidPlaybackInfoMessage({
     this.volumeControlType,
     this.maxVolume,
     this.volume,
  });

  Map<String, dynamic> toMap() => {
        'playbackType': AndroidPlaybackTypeMessage.remote.index,
        'volumeControlType': volumeControlType.index,
        'maxVolume': maxVolume,
        'volume': volume,
      };

  @override
  String toString() => '${toMap()}';
}

class LocalAndroidPlaybackInfoMessage extends AndroidPlaybackInfoMessage {
  @literal
  const LocalAndroidPlaybackInfoMessage();

  Map<String, dynamic> toMap() => {
        'playbackType': AndroidPlaybackTypeMessage.local.index,
      };

  @override
  String toString() => '${toMap()}';
}

/// The buttons on a headset.
enum MediaButtonMessage {
  media,
  next,
  previous,
}

/// The available shuffle modes for the queue.
enum AudioServiceShuffleModeMessage { none, all, group }

/// The available repeat modes.
///
/// This defines how media items should repeat when the current one is finished.
enum AudioServiceRepeatModeMessage {
  /// The current media item or queue will not repeat.
  none,

  /// The current media item will repeat.
  one,

  /// Playback will continue looping through all media items in the current list.
  all,

  /// UNIMPLEMENTED - see https://github.com/ryanheise/audio_service/issues/560
  ///
  /// This could represent a playlist that is a smaller subset of all media items.
  group,
}

class MediaItemMessage {
  /// A unique id.
  final String id;

  /// The album this media item belongs to.
  final String album;

  /// The title of this media item.
  final String title;

  /// The artist of this media item.
  final String artist;

  /// The genre of this media item.
  final String genre;

  /// The duration of this media item.
  final Duration duration;

  /// The artwork for this media item as a uri.
  final Uri artUri;

  /// Whether this is playable (i.e. not a folder).
  final bool playable;

  /// Override the default title for display purposes.
  final String displayTitle;

  /// Override the default subtitle for display purposes.
  final String displaySubtitle;

  /// Override the default description for display purposes.
  final String displayDescription;

  /// The rating of the MediaItemMessage.
  final RatingMessage rating;

  /// A map of additional metadata for the media item.
  ///
  /// The values must be integers or strings.
  final Map<String, dynamic> extras;

  /// Creates a [MediaItemMessage].
  ///
  /// The [id] must be unique for each instance.
  @literal
  const MediaItemMessage({
     this.id,
     this.album,
     this.title,
    this.artist,
    this.genre,
    this.duration,
    this.artUri,
    this.playable = true,
    this.displayTitle,
    this.displaySubtitle,
    this.displayDescription,
    this.rating,
    this.extras,
  });

  /// Creates a [MediaItemMessage] from a map of key/value pairs corresponding to
  /// fields of this class.
  factory MediaItemMessage.fromMap(Map raw) => MediaItemMessage(
        id: raw['id'],
        album: raw['album'],
        title: raw['title'],
        artist: raw['artist'],
        genre: raw['genre'],
        duration: raw['duration'] != null
            ? Duration(milliseconds: raw['duration'])
            : null,
        artUri: raw['artUri'] != null ? Uri.parse(raw['artUri']) : null,
        playable: raw['playable'],
        displayTitle: raw['displayTitle'],
        displaySubtitle: raw['displaySubtitle'],
        displayDescription: raw['displayDescription'],
        rating:
            raw['rating'] != null ? RatingMessage.fromMap(raw['rating']) : null,
        extras: (raw['extras'] as Map)?.cast<String, dynamic>(),
      );

  /// Converts this [MediaItemMessage] to a map of key/value pairs corresponding to
  /// the fields of this class.
  Map<String, dynamic> toMap() => {
        'id': id,
        'album': album,
        'title': title,
        'artist': artist,
        'genre': genre,
        'duration': duration?.inMilliseconds,
        'artUri': artUri?.toString(),
        'playable': playable,
        'displayTitle': displayTitle,
        'displaySubtitle': displaySubtitle,
        'displayDescription': displayDescription,
        'rating': rating?.toMap(),
        'extras': extras,
      };
}

/// A rating to attach to a MediaItemMessage.
class RatingMessage {
  final RatingStyleMessage type;
  final Object value;

  @literal
  const RatingMessage({this.type, this.value});

  /// Returns a percentage rating value greater or equal to 0.0f, or a
  /// negative value if the rating style is not percentage-based, or
  /// if it is unrated.
  double get percentRating {
    if (type != RatingStyleMessage.percentage) return -1;
    final localValue = value as double;
    if (localValue == null || localValue < 0 || localValue > 100) return -1;
    return localValue;
  }

  /// Returns a rating value greater or equal to 0.0f, or a negative
  /// value if the rating style is not star-based, or if it is
  /// unrated.
  int get starRating {
    if (type != RatingStyleMessage.range3stars &&
        type != RatingStyleMessage.range4stars &&
        type != RatingStyleMessage.range5stars) {
      return -1;
    }
    return value as int ?? -1;
  }

  /// Returns true if the rating is "heart selected" or false if the
  /// rating is "heart unselected", if the rating style is not [RatingStyleMessage.heart]
  /// or if it is unrated.
  bool get hasHeart {
    if (type != RatingStyleMessage.heart) return false;
    return value as bool ?? false;
  }

  /// Returns true if the rating is "thumb up" or false if the rating
  /// is "thumb down", if the rating style is not [RatingStyleMessage.thumbUpDown] or if
  /// it is unrated.
  bool get isThumbUp {
    if (type != RatingStyleMessage.thumbUpDown) return false;
    return value as bool ?? false;
  }

  /// Return whether there is a rating value available.
  bool get isRated => value != null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.index,
      'value': value,
    };
  }

  // Even though this should take a Map<String, dynamic>, that makes an error.
  RatingMessage.fromMap(Map raw)
      : this(
          type: RatingStyleMessage.values[raw['type']],
          value: raw['value'],
        );

  @override
  String toString() => '${toMap()}';
}

enum RatingStyleMessage {
  /// Indicates a rating style is not supported.
  ///
  /// A Rating will never have this type, but can be used by other classes
  /// to indicate they do not support Rating.
  none,

  /// A rating style with a single degree of rating, "heart" vs "no heart".
  ///
  /// Can be used to indicate the content referred to is a favorite (or not).
  heart,

  /// A rating style for "thumb up" vs "thumb down".
  thumbUpDown,

  /// A rating style with 0 to 3 stars.
  range3stars,

  /// A rating style with 0 to 4 stars.
  range4stars,

  /// A rating style with 0 to 5 stars.
  range5stars,

  /// A rating style expressed as a percentage.
  percentage,
}

class OnPlaybackStateChangedRequest {
  final PlaybackStateMessage state;

  @literal
  const OnPlaybackStateChangedRequest({this.state});

  factory OnPlaybackStateChangedRequest.fromMap(Map map) =>
      OnPlaybackStateChangedRequest(
        state: PlaybackStateMessage.fromMap(map['state']),
      );

  Map<String, dynamic> toMap() => {
        'state': state.toMap(),
      };
}

class OnQueueChangedRequest {
  final List<MediaItemMessage> queue;

  @literal
  const OnQueueChangedRequest({this.queue});

  factory OnQueueChangedRequest.fromMap(Map map) => OnQueueChangedRequest(
      queue: map['queue'] == null
          ? []
          : (map['queue'] as List)
              .map((raw) => MediaItemMessage.fromMap(raw))
              .toList());

  Map<String, dynamic> toMap() => {
        'queue': queue.map((item) => item.toMap()).toList(),
      };
}

class OnMediaItemChangedRequest {
  final MediaItemMessage mediaItem;

  @literal
  const OnMediaItemChangedRequest({this.mediaItem});

  factory OnMediaItemChangedRequest.fromMap(Map map) =>
      OnMediaItemChangedRequest(
        mediaItem: map['mediaItem'] == null
            ? null
            : MediaItemMessage.fromMap(map['mediaItem']),
      );

  Map<String, dynamic> toMap() => {
        'mediaItem': mediaItem?.toMap(),
      };
}

class OnChildrenLoadedRequest {
  final String parentMediaId;
  final List<MediaItemMessage> children;

  @literal
  const OnChildrenLoadedRequest({
    this.parentMediaId,
    this.children,
  });

  factory OnChildrenLoadedRequest.fromMap(Map map) => OnChildrenLoadedRequest(
        parentMediaId: map['parentMediaId'],
        children: (map['queue'] as List)
            .map((raw) => MediaItemMessage.fromMap(raw))
            .toList(),
      );
}

class OnNotificationClickedRequest {
  final bool clicked;

  @literal
  const OnNotificationClickedRequest({this.clicked});

  factory OnNotificationClickedRequest.fromMap(Map map) =>
      OnNotificationClickedRequest(
        clicked: map['clicked'] == null,
      );

  Map<String, dynamic> toMap() => {
        'clicked': clicked,
      };
}

class SetStateRequest {
  final PlaybackStateMessage state;

  @literal
  const SetStateRequest({this.state});

  Map<String, dynamic> toMap() => {
        'state': state.toMap(),
      };
}

class SetQueueRequest {
  final List<MediaItemMessage> queue;

  @literal
  const SetQueueRequest({this.queue});

  Map<String, dynamic> toMap() => {
        'queue': queue.map((item) => item.toMap()).toList(),
      };
}

class SetMediaItemRequest {
  final MediaItemMessage mediaItem;

  const SetMediaItemRequest({this.mediaItem});

  Map<String, dynamic> toMap() => {
        'mediaItem': mediaItem.toMap(),
      };
}

class StopServiceRequest {
  @literal
  const StopServiceRequest();

  Map<String, dynamic> toMap() => {};
}

class SetAndroidPlaybackInfoRequest {
  final AndroidPlaybackInfoMessage playbackInfo;

  @literal
  const SetAndroidPlaybackInfoRequest({this.playbackInfo});

  Map<String, dynamic> toMap() => {
        'playbackInfo': playbackInfo.toMap(),
      };
}

class AndroidForceEnableMediaButtonsRequest {
  @literal
  const AndroidForceEnableMediaButtonsRequest();

  Map<String, dynamic> toMap() => {};
}

class NotifyChildrenChangedRequest {
  final String parentMediaId;
  final Map<String, dynamic> options;

  @literal
  const NotifyChildrenChangedRequest({
    this.parentMediaId,
    this.options,
  });

  Map<String, dynamic> toMap() => {
        'parentMediaId': parentMediaId,
        'options': options,
      };
}

class PrepareRequest {
  @literal
  const PrepareRequest();

  Map<String, dynamic> toMap() => {};
}

class PrepareFromMediaIdRequest {
  final String mediaId;
  final Map<String, dynamic> extras;

  @literal
  const PrepareFromMediaIdRequest({this.mediaId, this.extras});

  Map<String, dynamic> toMap() => {
        'mediaId': mediaId,
      };
}

class PrepareFromSearchRequest {
  final String query;
  final Map<String, dynamic> extras;

  @literal
  const PrepareFromSearchRequest({this.query, this.extras});

  Map<String, dynamic> toMap() => {
        'query': query,
        'extras': extras,
      };
}

class PrepareFromUriRequest {
  final Uri uri;
  final Map<String, dynamic> extras;

  @literal
  const PrepareFromUriRequest({ this.uri, this.extras});

  Map<String, dynamic> toMap() => {
        'uri': uri.toString(),
        'extras': extras,
      };
}

class PlayRequest {
  @literal
  const PlayRequest();

  Map<String, dynamic> toMap() => {};
}

class PlayFromMediaIdRequest {
  final String mediaId;
  final Map<String, dynamic> extras;

  @literal
  const PlayFromMediaIdRequest({ this.mediaId, this.extras});

  Map<String, dynamic> toMap() => {
        'mediaId': mediaId,
      };
}

class PlayFromSearchRequest {
  final String query;
  final Map<String, dynamic> extras;

  @literal
  const PlayFromSearchRequest({ this.query, this.extras});

  Map<String, dynamic> toMap() => {
        'query': query,
        'extras': extras,
      };
}

class PlayFromUriRequest {
  final Uri uri;
  final Map<String, dynamic> extras;

  @literal
  const PlayFromUriRequest({ this.uri, this.extras});

  Map<String, dynamic> toMap() => {
        'uri': uri.toString(),
        'extras': extras,
      };
}

class PlayMediaItemRequest {
  final MediaItemMessage mediaItem;

  @literal
  const PlayMediaItemRequest({ this.mediaItem});

  Map<String, dynamic> toMap() => {
        'mediaItem': mediaItem.toString(),
      };
}

class PauseRequest {
  @literal
  const PauseRequest();

  Map<String, dynamic> toMap() => {};
}

class ClickRequest {
  final MediaButtonMessage button;

  @literal
  const ClickRequest({ this.button});

  Map<String, dynamic> toMap() => {
        'button': button.index,
      };
}

class StopRequest {
  @literal
  const StopRequest();

  Map<String, dynamic> toMap() => {};
}

class AddQueueItemRequest {
  final MediaItemMessage mediaItem;

  @literal
  const AddQueueItemRequest({ this.mediaItem});

  Map<String, dynamic> toMap() => {
        'mediaItem': mediaItem.toMap(),
      };
}

class AddQueueItemsRequest {
  // TODO: rename https://github.com/ryanheise/audio_service/pull/640#issuecomment-816842550
  final List<MediaItemMessage> queue;

  @literal
  const AddQueueItemsRequest({ this.queue});

  Map<String, dynamic> toMap() => {
        'queue': queue.map((item) => item.toMap()).toList(),
      };
}

class InsertQueueItemRequest {
  final int index;
  final MediaItemMessage mediaItem;

  @literal
  const InsertQueueItemRequest({ this.index,  this.mediaItem});

  Map<String, dynamic> toMap() => {
        'index': index,
        'mediaItem': mediaItem.toMap(),
      };
}

class UpdateQueueRequest {
  final List<MediaItemMessage> queue;

  @literal
  const UpdateQueueRequest({ this.queue});

  Map<String, dynamic> toMap() => {
        'queue': queue.map((item) => item.toMap()).toList(),
      };
}

class UpdateMediaItemRequest {
  final MediaItemMessage mediaItem;

  @literal
  const UpdateMediaItemRequest({ this.mediaItem});

  Map<String, dynamic> toMap() => {
        'mediaItem': mediaItem.toMap(),
      };
}

class RemoveQueueItemRequest {
  final MediaItemMessage mediaItem;

  @literal
  const RemoveQueueItemRequest({ this.mediaItem});

  Map<String, dynamic> toMap() => {
        'mediaItem': mediaItem.toMap(),
      };
}

class RemoveQueueItemAtRequest {
  final int index;

  @literal
  const RemoveQueueItemAtRequest({ this.index});

  Map<String, dynamic> toMap() => {
        'index': index,
      };
}

class SkipToNextRequest {
  @literal
  const SkipToNextRequest();

  Map<String, dynamic> toMap() => {};
}

class SkipToPreviousRequest {
  @literal
  const SkipToPreviousRequest();

  Map<String, dynamic> toMap() => {};
}

class FastForwardRequest {
  @literal
  const FastForwardRequest();

  Map<String, dynamic> toMap() => {};
}

class RewindRequest {
  @literal
  const RewindRequest();

  Map<String, dynamic> toMap() => {};
}

class SkipToQueueItemRequest {
  final int index;

  @literal
  const SkipToQueueItemRequest({ this.index});

  Map<String, dynamic> toMap() => {
        'index': index,
      };
}

class SeekRequest {
  final Duration position;

  @literal
  const SeekRequest({ this.position});

  Map<String, dynamic> toMap() => {
        'position': position.inMicroseconds,
      };
}

class SetRatingRequest {
  final RatingMessage rating;
  final Map<String, dynamic> extras;

  @literal
  const SetRatingRequest({ this.rating, this.extras});

  Map<String, dynamic> toMap() => {
        'rating': rating.toMap(),
        'extras': extras,
      };
}

class SetCaptioningEnabledRequest {
  final bool enabled;

  @literal
  const SetCaptioningEnabledRequest({ this.enabled});

  Map<String, dynamic> toMap() => {
        'enabled': enabled,
      };
}

class SetRepeatModeRequest {
  final AudioServiceRepeatModeMessage repeatMode;

  @literal
  const SetRepeatModeRequest({ this.repeatMode});

  Map<String, dynamic> toMap() => {
        'repeatMode': repeatMode.index,
      };
}

class SetShuffleModeRequest {
  final AudioServiceShuffleModeMessage shuffleMode;

  @literal
  const SetShuffleModeRequest({ this.shuffleMode});

  Map<String, dynamic> toMap() => {
        'shuffleMode': shuffleMode.index,
      };
}

class SeekBackwardRequest {
  final bool begin;

  @literal
  const SeekBackwardRequest({ this.begin});

  Map<String, dynamic> toMap() => {
        'begin': begin,
      };
}

class SeekForwardRequest {
  final bool begin;

  @literal
  const SeekForwardRequest({ this.begin});

  Map<String, dynamic> toMap() => {
        'begin': begin,
      };
}

class SetSpeedRequest {
  final double speed;

  @literal
  const SetSpeedRequest({ this.speed});

  Map<String, dynamic> toMap() => {
        'speed': speed,
      };
}

class CustomActionRequest {
  final String name;
  final Map<String, dynamic> extras;

  @literal
  const CustomActionRequest({ this.name, this.extras});

  Map<String, dynamic> toMap() => {
        'name': name,
        'extras': extras,
      };
}

class OnTaskRemovedRequest {
  @literal
  const OnTaskRemovedRequest();

  Map<String, dynamic> toMap() => {};
}

class OnNotificationDeletedRequest {
  @literal
  const OnNotificationDeletedRequest();

  Map<String, dynamic> toMap() => {};
}

class GetChildrenRequest {
  final String parentMediaId;
  final Map<String, dynamic> options;

  @literal
  const GetChildrenRequest({ this.parentMediaId, this.options});

  Map<String, dynamic> toMap() => {
        'parentMediaId': parentMediaId,
        'options': options,
      };
}

class GetChildrenResponse {
  final List<MediaItemMessage> children;

  @literal
  const GetChildrenResponse({ this.children});

  Map<String, dynamic> toMap() => {
        'children': children.map((item) => item.toMap()).toList(),
      };
}

class GetMediaItemRequest {
  final String mediaId;

  @literal
  const GetMediaItemRequest({ this.mediaId});

  Map<String, dynamic> toMap() => {
        'mediaId': mediaId,
      };
}

class GetMediaItemResponse {
  final MediaItemMessage mediaItem;

  @literal
  const GetMediaItemResponse({ this.mediaItem});

  Map<String, dynamic> toMap() => {
        'mediaItem': mediaItem.toMap(),
      };
}

class SearchRequest {
  final String query;
  final Map<String, dynamic> extras;

  @literal
  const SearchRequest({ this.query, this.extras});

  Map<String, dynamic> toMap() => {
        'query': query,
        'extras': extras,
      };
}

class SearchResponse {
  final List<MediaItemMessage> mediaItems;

  @literal
  const SearchResponse({ this.mediaItems});

  Map<String, dynamic> toMap() => {
        'mediaItems': mediaItems.map((item) => item.toMap()).toList(),
      };
}

class AndroidSetRemoteVolumeRequest {
  final int volumeIndex;

  @literal
  const AndroidSetRemoteVolumeRequest({ this.volumeIndex});

  Map<String, dynamic> toMap() => {
        'volumeIndex': volumeIndex,
      };
}

class AndroidAdjustRemoteVolumeRequest {
  final AndroidVolumeDirectionMessage direction;

  @literal
  const AndroidAdjustRemoteVolumeRequest({ this.direction});

  Map<String, dynamic> toMap() => {
        'direction': direction.index,
      };
}

class ConfigureRequest {
  final AudioServiceConfigMessage config;

  @literal
  const ConfigureRequest({ this.config});

  Map<String, dynamic> toMap() => {
        'config': config.toMap(),
      };
}

/// The result of [AudioServicePlatform.configure].
///
/// Doesn't have `const` constructor, because it's only supposed to be instantiated
/// from the result of a native call, and thus will be always runtime (and because `fromMap`
/// should not return constants as well).
class ConfigureResponse {
  static ConfigureResponse fromMap(Map map) => ConfigureResponse();
}

/// The options to use when configuring the [AudioServicePlatform].

class AudioServiceConfigMessage {
  // TODO: either fix, or remove this https://github.com/ryanheise/audio_service/issues/638
  final bool androidResumeOnClick;

  // A name of the media notification channel, that is
  // visible to user in settings of your app.
  final String androidNotificationChannelName;

  // A description of the media notification channel, that is
  // visible to user in settings of your app.
  final String androidNotificationChannelDescription;

  /// The color to use on the background of the notification on Android. This
  /// should be a non-transparent color.
  final Color notificationColor;

  /// The icon resource to be used in the Android media notification, specified
  /// like an XML resource reference. This should be a monochrome white icon on
  /// a transparent background. The default value is `"mipmap/ic_launcher"`.
  final String androidNotificationIcon;

  /// Whether notification badges (also known as notification dots) should
  /// appear on a launcher icon when the app has an active notification.
  final bool androidShowNotificationBadge;

  /// Whether the application activity will be opened on click on notification.
  final bool androidNotificationClickStartsActivity;

  /// Whether the notification can be swiped away.
  ///
  /// If you set this to true, [androidStopForegroundOnPause] must be true as well,
  /// otherwise this will not do anything, because when foreground service is active,
  /// it forces notification to be ongoing.
  final bool androidNotificationOngoing;

  /// Whether the Android service should switch to a lower priority state when
  /// playback is paused allowing the user to swipe away the notification. Note
  /// that while in this lower priority state, the operating system will also be
  /// able to kill your service at any time to reclaim resources.
  final bool androidStopForegroundOnPause;

  /// If not null, causes the artwork specified by [MediaItemMessage.artUri] to be
  /// downscaled to this maximum pixel width. If the resolution of your artwork
  /// is particularly high, this can help to conserve memory. If specified,
  /// [artDownscaleHeight] must also be specified.
  final int artDownscaleWidth;

  /// If not null, causes the artwork specified by [MediaItemMessage.artUri] to be
  /// downscaled to this maximum pixel height. If the resolution of your artwork
  /// is particularly high, this can help to conserve memory. If specified,
  /// [artDownscaleWidth] must also be specified.
  final int artDownscaleHeight;

  /// The interval to be used in [AudioHandlerCallbacks.fastForward]. This value will
  /// also be used on iOS to render the skip-forward button. This value must be
  /// positive.
  final Duration fastForwardInterval;

  /// The interval to be used in [AudioHandlerCallbacks.rewind]. This value will also be
  /// used on iOS to render the skip-backward button. This value must be
  /// positive.
  final Duration rewindInterval;

  /// Whether queue support should be enabled on the media session on Android.
  /// If your app will run on Android and has a queue, you should set this to
  /// true.
  final bool androidEnableQueue;

  /// By default artworks are loaded only when the item is fed into [AudioHandler.mediaItem].
  ///
  /// If set to `true`, artworks for items start loading as soon as they are added to
  /// [AudioHandler.queue].
  ///
  /// TODO: remove https://github.com/ryanheise/audio_service/pull/640#issuecomment-816850268
  final bool preloadArtwork;

  /// Extras to report on Android in response to an `onGetRoot` request.
  final Map<String, dynamic> androidBrowsableRootExtras;

  @literal
  const AudioServiceConfigMessage({
    this.androidResumeOnClick = true,
    this.androidNotificationChannelName = 'Notifications',
    this.androidNotificationChannelDescription,
    this.notificationColor,
    this.androidNotificationIcon = 'mipmap/ic_launcher',
    this.androidShowNotificationBadge = false,
    this.androidNotificationClickStartsActivity = true,
    this.androidNotificationOngoing = false,
    this.androidStopForegroundOnPause = true,
    this.artDownscaleWidth,
    this.artDownscaleHeight,
    this.fastForwardInterval = const Duration(seconds: 10),
    this.rewindInterval = const Duration(seconds: 10),
    this.androidEnableQueue = false,
    this.preloadArtwork = false,
    this.androidBrowsableRootExtras,
  })  : assert((artDownscaleWidth != null) == (artDownscaleHeight != null)),
        assert(fastForwardInterval > Duration.zero),
        assert(rewindInterval > Duration.zero),
        assert(
          !androidNotificationOngoing || androidStopForegroundOnPause,
          'The androidNotificationOngoing will make no effect with androidStopForegroundOnPause set to false',
        );

  Map<String, dynamic> toMap() => {
        'androidResumeOnClick': androidResumeOnClick,
        'androidNotificationChannelName': androidNotificationChannelName,
        'androidNotificationChannelDescription':
            androidNotificationChannelDescription,
        'notificationColor': notificationColor?.value,
        'androidNotificationIcon': androidNotificationIcon,
        'androidShowNotificationBadge': androidShowNotificationBadge,
        'androidNotificationClickStartsActivity':
            androidNotificationClickStartsActivity,
        'androidNotificationOngoing': androidNotificationOngoing,
        'androidStopForegroundOnPause': androidStopForegroundOnPause,
        'artDownscaleWidth': artDownscaleWidth,
        'artDownscaleHeight': artDownscaleHeight,
        'fastForwardInterval': fastForwardInterval.inMilliseconds,
        'rewindInterval': rewindInterval.inMilliseconds,
        'androidEnableQueue': androidEnableQueue,
        'preloadArtwork': preloadArtwork,
        'androidBrowsableRootExtras': androidBrowsableRootExtras,
      };
}
