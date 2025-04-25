// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_song_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UploadSongState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadSongState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadSongState()';
}


}

/// @nodoc
class $UploadSongStateCopyWith<$Res>  {
$UploadSongStateCopyWith(UploadSongState _, $Res Function(UploadSongState) __);
}


/// @nodoc


class UploadSongInitial implements UploadSongState {
  const UploadSongInitial({this.isSongPicked = false, this.isThumbnailPicked = false, this.songFileName = '', this.thumbnailFileName = ''});
  

@JsonKey() final  bool isSongPicked;
@JsonKey() final  bool isThumbnailPicked;
@JsonKey() final  String songFileName;
@JsonKey() final  String thumbnailFileName;

/// Create a copy of UploadSongState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadSongInitialCopyWith<UploadSongInitial> get copyWith => _$UploadSongInitialCopyWithImpl<UploadSongInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadSongInitial&&(identical(other.isSongPicked, isSongPicked) || other.isSongPicked == isSongPicked)&&(identical(other.isThumbnailPicked, isThumbnailPicked) || other.isThumbnailPicked == isThumbnailPicked)&&(identical(other.songFileName, songFileName) || other.songFileName == songFileName)&&(identical(other.thumbnailFileName, thumbnailFileName) || other.thumbnailFileName == thumbnailFileName));
}


@override
int get hashCode => Object.hash(runtimeType,isSongPicked,isThumbnailPicked,songFileName,thumbnailFileName);

@override
String toString() {
  return 'UploadSongState.initial(isSongPicked: $isSongPicked, isThumbnailPicked: $isThumbnailPicked, songFileName: $songFileName, thumbnailFileName: $thumbnailFileName)';
}


}

/// @nodoc
abstract mixin class $UploadSongInitialCopyWith<$Res> implements $UploadSongStateCopyWith<$Res> {
  factory $UploadSongInitialCopyWith(UploadSongInitial value, $Res Function(UploadSongInitial) _then) = _$UploadSongInitialCopyWithImpl;
@useResult
$Res call({
 bool isSongPicked, bool isThumbnailPicked, String songFileName, String thumbnailFileName
});




}
/// @nodoc
class _$UploadSongInitialCopyWithImpl<$Res>
    implements $UploadSongInitialCopyWith<$Res> {
  _$UploadSongInitialCopyWithImpl(this._self, this._then);

  final UploadSongInitial _self;
  final $Res Function(UploadSongInitial) _then;

/// Create a copy of UploadSongState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isSongPicked = null,Object? isThumbnailPicked = null,Object? songFileName = null,Object? thumbnailFileName = null,}) {
  return _then(UploadSongInitial(
isSongPicked: null == isSongPicked ? _self.isSongPicked : isSongPicked // ignore: cast_nullable_to_non_nullable
as bool,isThumbnailPicked: null == isThumbnailPicked ? _self.isThumbnailPicked : isThumbnailPicked // ignore: cast_nullable_to_non_nullable
as bool,songFileName: null == songFileName ? _self.songFileName : songFileName // ignore: cast_nullable_to_non_nullable
as String,thumbnailFileName: null == thumbnailFileName ? _self.thumbnailFileName : thumbnailFileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UploadSongLoading implements UploadSongState {
  const UploadSongLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadSongLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadSongState.loading()';
}


}




/// @nodoc


class UploadSongSuccess implements UploadSongState {
  const UploadSongSuccess(this.message);
  

 final  String message;

/// Create a copy of UploadSongState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadSongSuccessCopyWith<UploadSongSuccess> get copyWith => _$UploadSongSuccessCopyWithImpl<UploadSongSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadSongSuccess&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UploadSongState.success(message: $message)';
}


}

/// @nodoc
abstract mixin class $UploadSongSuccessCopyWith<$Res> implements $UploadSongStateCopyWith<$Res> {
  factory $UploadSongSuccessCopyWith(UploadSongSuccess value, $Res Function(UploadSongSuccess) _then) = _$UploadSongSuccessCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$UploadSongSuccessCopyWithImpl<$Res>
    implements $UploadSongSuccessCopyWith<$Res> {
  _$UploadSongSuccessCopyWithImpl(this._self, this._then);

  final UploadSongSuccess _self;
  final $Res Function(UploadSongSuccess) _then;

/// Create a copy of UploadSongState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(UploadSongSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UploadSongFailure implements UploadSongState {
  const UploadSongFailure(this.error);
  

 final  String error;

/// Create a copy of UploadSongState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadSongFailureCopyWith<UploadSongFailure> get copyWith => _$UploadSongFailureCopyWithImpl<UploadSongFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadSongFailure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'UploadSongState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $UploadSongFailureCopyWith<$Res> implements $UploadSongStateCopyWith<$Res> {
  factory $UploadSongFailureCopyWith(UploadSongFailure value, $Res Function(UploadSongFailure) _then) = _$UploadSongFailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$UploadSongFailureCopyWithImpl<$Res>
    implements $UploadSongFailureCopyWith<$Res> {
  _$UploadSongFailureCopyWithImpl(this._self, this._then);

  final UploadSongFailure _self;
  final $Res Function(UploadSongFailure) _then;

/// Create a copy of UploadSongState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(UploadSongFailure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
