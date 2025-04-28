// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_song_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadSongState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadSongState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadSongState()';
}


}

/// @nodoc
class $DownloadSongStateCopyWith<$Res>  {
$DownloadSongStateCopyWith(DownloadSongState _, $Res Function(DownloadSongState) __);
}


/// @nodoc


class DownloadSongInitial implements DownloadSongState {
  const DownloadSongInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadSongInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadSongState.initial()';
}


}




/// @nodoc


class DownloadSongDownloading implements DownloadSongState {
  const DownloadSongDownloading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadSongDownloading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadSongState.downloading()';
}


}




/// @nodoc


class DownloadSongSuccess implements DownloadSongState {
  const DownloadSongSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadSongSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadSongState.success()';
}


}




/// @nodoc


class DownloadSongFailure implements DownloadSongState {
  const DownloadSongFailure(this.error);
  

 final  String error;

/// Create a copy of DownloadSongState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadSongFailureCopyWith<DownloadSongFailure> get copyWith => _$DownloadSongFailureCopyWithImpl<DownloadSongFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadSongFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'DownloadSongState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $DownloadSongFailureCopyWith<$Res> implements $DownloadSongStateCopyWith<$Res> {
  factory $DownloadSongFailureCopyWith(DownloadSongFailure value, $Res Function(DownloadSongFailure) _then) = _$DownloadSongFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$DownloadSongFailureCopyWithImpl<$Res>
    implements $DownloadSongFailureCopyWith<$Res> {
  _$DownloadSongFailureCopyWithImpl(this._self, this._then);

  final DownloadSongFailure _self;
  final $Res Function(DownloadSongFailure) _then;

/// Create a copy of DownloadSongState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(DownloadSongFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
