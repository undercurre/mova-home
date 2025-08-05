// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_sign_bind_email_code_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SocialSignBindEmailCodeUiState {
  bool get enableSend =>
      throw _privateConstructorUsedError; // RegionItem? phoneCodeRegion,
  String? get sourceText => throw _privateConstructorUsedError;
  String? get sourceWayText => throw _privateConstructorUsedError;
  bool get enableNext => throw _privateConstructorUsedError;
  String get sendButtonText => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SocialSignBindEmailCodeUiStateCopyWith<SocialSignBindEmailCodeUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialSignBindEmailCodeUiStateCopyWith<$Res> {
  factory $SocialSignBindEmailCodeUiStateCopyWith(
          SocialSignBindEmailCodeUiState value,
          $Res Function(SocialSignBindEmailCodeUiState) then) =
      _$SocialSignBindEmailCodeUiStateCopyWithImpl<$Res,
          SocialSignBindEmailCodeUiState>;
  @useResult
  $Res call(
      {bool enableSend,
      String? sourceText,
      String? sourceWayText,
      bool enableNext,
      String sendButtonText,
      CommonUIEvent event});
}

/// @nodoc
class _$SocialSignBindEmailCodeUiStateCopyWithImpl<$Res,
        $Val extends SocialSignBindEmailCodeUiState>
    implements $SocialSignBindEmailCodeUiStateCopyWith<$Res> {
  _$SocialSignBindEmailCodeUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? sourceText = freezed,
    Object? sourceWayText = freezed,
    Object? enableNext = null,
    Object? sendButtonText = null,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      sourceText: freezed == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceWayText: freezed == sourceWayText
          ? _value.sourceWayText
          : sourceWayText // ignore: cast_nullable_to_non_nullable
              as String?,
      enableNext: null == enableNext
          ? _value.enableNext
          : enableNext // ignore: cast_nullable_to_non_nullable
              as bool,
      sendButtonText: null == sendButtonText
          ? _value.sendButtonText
          : sendButtonText // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialSignBindEmailCodeUiStateImplCopyWith<$Res>
    implements $SocialSignBindEmailCodeUiStateCopyWith<$Res> {
  factory _$$SocialSignBindEmailCodeUiStateImplCopyWith(
          _$SocialSignBindEmailCodeUiStateImpl value,
          $Res Function(_$SocialSignBindEmailCodeUiStateImpl) then) =
      __$$SocialSignBindEmailCodeUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableSend,
      String? sourceText,
      String? sourceWayText,
      bool enableNext,
      String sendButtonText,
      CommonUIEvent event});
}

/// @nodoc
class __$$SocialSignBindEmailCodeUiStateImplCopyWithImpl<$Res>
    extends _$SocialSignBindEmailCodeUiStateCopyWithImpl<$Res,
        _$SocialSignBindEmailCodeUiStateImpl>
    implements _$$SocialSignBindEmailCodeUiStateImplCopyWith<$Res> {
  __$$SocialSignBindEmailCodeUiStateImplCopyWithImpl(
      _$SocialSignBindEmailCodeUiStateImpl _value,
      $Res Function(_$SocialSignBindEmailCodeUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? sourceText = freezed,
    Object? sourceWayText = freezed,
    Object? enableNext = null,
    Object? sendButtonText = null,
    Object? event = null,
  }) {
    return _then(_$SocialSignBindEmailCodeUiStateImpl(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      sourceText: freezed == sourceText
          ? _value.sourceText
          : sourceText // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceWayText: freezed == sourceWayText
          ? _value.sourceWayText
          : sourceWayText // ignore: cast_nullable_to_non_nullable
              as String?,
      enableNext: null == enableNext
          ? _value.enableNext
          : enableNext // ignore: cast_nullable_to_non_nullable
              as bool,
      sendButtonText: null == sendButtonText
          ? _value.sendButtonText
          : sendButtonText // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$SocialSignBindEmailCodeUiStateImpl
    implements _SocialSignBindEmailCodeUiState {
  _$SocialSignBindEmailCodeUiStateImpl(
      {this.enableSend = false,
      this.sourceText,
      this.sourceWayText,
      this.enableNext = false,
      this.sendButtonText = '',
      this.event = const EmptyEvent()});

  @override
  @JsonKey()
  final bool enableSend;
// RegionItem? phoneCodeRegion,
  @override
  final String? sourceText;
  @override
  final String? sourceWayText;
  @override
  @JsonKey()
  final bool enableNext;
  @override
  @JsonKey()
  final String sendButtonText;
  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'SocialSignBindEmailCodeUiState(enableSend: $enableSend, sourceText: $sourceText, sourceWayText: $sourceWayText, enableNext: $enableNext, sendButtonText: $sendButtonText, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialSignBindEmailCodeUiStateImpl &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.sourceText, sourceText) ||
                other.sourceText == sourceText) &&
            (identical(other.sourceWayText, sourceWayText) ||
                other.sourceWayText == sourceWayText) &&
            (identical(other.enableNext, enableNext) ||
                other.enableNext == enableNext) &&
            (identical(other.sendButtonText, sendButtonText) ||
                other.sendButtonText == sendButtonText) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enableSend, sourceText,
      sourceWayText, enableNext, sendButtonText, event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialSignBindEmailCodeUiStateImplCopyWith<
          _$SocialSignBindEmailCodeUiStateImpl>
      get copyWith => __$$SocialSignBindEmailCodeUiStateImplCopyWithImpl<
          _$SocialSignBindEmailCodeUiStateImpl>(this, _$identity);
}

abstract class _SocialSignBindEmailCodeUiState
    implements SocialSignBindEmailCodeUiState {
  factory _SocialSignBindEmailCodeUiState(
      {final bool enableSend,
      final String? sourceText,
      final String? sourceWayText,
      final bool enableNext,
      final String sendButtonText,
      final CommonUIEvent event}) = _$SocialSignBindEmailCodeUiStateImpl;

  @override
  bool get enableSend;
  @override // RegionItem? phoneCodeRegion,
  String? get sourceText;
  @override
  String? get sourceWayText;
  @override
  bool get enableNext;
  @override
  String get sendButtonText;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$SocialSignBindEmailCodeUiStateImplCopyWith<
          _$SocialSignBindEmailCodeUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
