// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fetch_song_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FetchSongState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchSongState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FetchSongState()';
}


}

/// @nodoc
class $FetchSongStateCopyWith<$Res>  {
$FetchSongStateCopyWith(FetchSongState _, $Res Function(FetchSongState) __);
}


/// @nodoc


class FetchSongInitial implements FetchSongState {
  const FetchSongInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchSongInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FetchSongState.initial()';
}


}




/// @nodoc


class FetchSongLoading implements FetchSongState {
  const FetchSongLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchSongLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FetchSongState.loading()';
}


}




/// @nodoc


class FetchSongSuccess implements FetchSongState {
  const FetchSongSuccess(final  List<SongData> songs): _songs = songs;
  

 final  List<SongData> _songs;
 List<SongData> get songs {
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_songs);
}


/// Create a copy of FetchSongState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchSongSuccessCopyWith<FetchSongSuccess> get copyWith => _$FetchSongSuccessCopyWithImpl<FetchSongSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchSongSuccess&&const DeepCollectionEquality().equals(other._songs, _songs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_songs));

@override
String toString() {
  return 'FetchSongState.success(songs: $songs)';
}


}

/// @nodoc
abstract mixin class $FetchSongSuccessCopyWith<$Res> implements $FetchSongStateCopyWith<$Res> {
  factory $FetchSongSuccessCopyWith(FetchSongSuccess value, $Res Function(FetchSongSuccess) _then) = _$FetchSongSuccessCopyWithImpl;
@useResult
$Res call({
 List<SongData> songs
});




}
/// @nodoc
class _$FetchSongSuccessCopyWithImpl<$Res>
    implements $FetchSongSuccessCopyWith<$Res> {
  _$FetchSongSuccessCopyWithImpl(this._self, this._then);

  final FetchSongSuccess _self;
  final $Res Function(FetchSongSuccess) _then;

/// Create a copy of FetchSongState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? songs = null,}) {
  return _then(FetchSongSuccess(
null == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<SongData>,
  ));
}


}

/// @nodoc


class FetchSongFailure implements FetchSongState {
  const FetchSongFailure(this.error);
  

 final  String error;

/// Create a copy of FetchSongState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchSongFailureCopyWith<FetchSongFailure> get copyWith => _$FetchSongFailureCopyWithImpl<FetchSongFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchSongFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'FetchSongState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $FetchSongFailureCopyWith<$Res> implements $FetchSongStateCopyWith<$Res> {
  factory $FetchSongFailureCopyWith(FetchSongFailure value, $Res Function(FetchSongFailure) _then) = _$FetchSongFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$FetchSongFailureCopyWithImpl<$Res>
    implements $FetchSongFailureCopyWith<$Res> {
  _$FetchSongFailureCopyWithImpl(this._self, this._then);

  final FetchSongFailure _self;
  final $Res Function(FetchSongFailure) _then;

/// Create a copy of FetchSongState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(FetchSongFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
