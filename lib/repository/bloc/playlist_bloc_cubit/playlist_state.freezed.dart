// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaylistState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistState()';
}


}

/// @nodoc
class $PlaylistStateCopyWith<$Res>  {
$PlaylistStateCopyWith(PlaylistState _, $Res Function(PlaylistState) __);
}


/// @nodoc


class PlaylistInitial implements PlaylistState {
  const PlaylistInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistState.initial()';
}


}




/// @nodoc


class PlaylistLoading implements PlaylistState {
  const PlaylistLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PlaylistState.loading()';
}


}




/// @nodoc


class PlaylistSuccess implements PlaylistState {
  const PlaylistSuccess(final  List<dynamic> playlists): _playlists = playlists;
  

 final  List<dynamic> _playlists;
 List<dynamic> get playlists {
  if (_playlists is EqualUnmodifiableListView) return _playlists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playlists);
}


/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistSuccessCopyWith<PlaylistSuccess> get copyWith => _$PlaylistSuccessCopyWithImpl<PlaylistSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistSuccess&&const DeepCollectionEquality().equals(other._playlists, _playlists));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_playlists));

@override
String toString() {
  return 'PlaylistState.success(playlists: $playlists)';
}


}

/// @nodoc
abstract mixin class $PlaylistSuccessCopyWith<$Res> implements $PlaylistStateCopyWith<$Res> {
  factory $PlaylistSuccessCopyWith(PlaylistSuccess value, $Res Function(PlaylistSuccess) _then) = _$PlaylistSuccessCopyWithImpl;
@useResult
$Res call({
 List<dynamic> playlists
});




}
/// @nodoc
class _$PlaylistSuccessCopyWithImpl<$Res>
    implements $PlaylistSuccessCopyWith<$Res> {
  _$PlaylistSuccessCopyWithImpl(this._self, this._then);

  final PlaylistSuccess _self;
  final $Res Function(PlaylistSuccess) _then;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playlists = null,}) {
  return _then(PlaylistSuccess(
null == playlists ? _self._playlists : playlists // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}

/// @nodoc


class PlaylistSongsFetched implements PlaylistState {
  const PlaylistSongsFetched(final  List<SongData> songs): _songs = songs;
  

 final  List<SongData> _songs;
 List<SongData> get songs {
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_songs);
}


/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistSongsFetchedCopyWith<PlaylistSongsFetched> get copyWith => _$PlaylistSongsFetchedCopyWithImpl<PlaylistSongsFetched>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistSongsFetched&&const DeepCollectionEquality().equals(other._songs, _songs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_songs));

@override
String toString() {
  return 'PlaylistState.songsFetched(songs: $songs)';
}


}

/// @nodoc
abstract mixin class $PlaylistSongsFetchedCopyWith<$Res> implements $PlaylistStateCopyWith<$Res> {
  factory $PlaylistSongsFetchedCopyWith(PlaylistSongsFetched value, $Res Function(PlaylistSongsFetched) _then) = _$PlaylistSongsFetchedCopyWithImpl;
@useResult
$Res call({
 List<SongData> songs
});




}
/// @nodoc
class _$PlaylistSongsFetchedCopyWithImpl<$Res>
    implements $PlaylistSongsFetchedCopyWith<$Res> {
  _$PlaylistSongsFetchedCopyWithImpl(this._self, this._then);

  final PlaylistSongsFetched _self;
  final $Res Function(PlaylistSongsFetched) _then;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? songs = null,}) {
  return _then(PlaylistSongsFetched(
null == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<SongData>,
  ));
}


}

/// @nodoc


class PlaylistFailure implements PlaylistState {
  const PlaylistFailure(this.error);
  

 final  String error;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistFailureCopyWith<PlaylistFailure> get copyWith => _$PlaylistFailureCopyWithImpl<PlaylistFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'PlaylistState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $PlaylistFailureCopyWith<$Res> implements $PlaylistStateCopyWith<$Res> {
  factory $PlaylistFailureCopyWith(PlaylistFailure value, $Res Function(PlaylistFailure) _then) = _$PlaylistFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$PlaylistFailureCopyWithImpl<$Res>
    implements $PlaylistFailureCopyWith<$Res> {
  _$PlaylistFailureCopyWithImpl(this._self, this._then);

  final PlaylistFailure _self;
  final $Res Function(PlaylistFailure) _then;

/// Create a copy of PlaylistState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(PlaylistFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
