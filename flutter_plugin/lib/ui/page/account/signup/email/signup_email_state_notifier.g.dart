// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_email_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signUpEmailStateNotifierHash() =>
    r'8cea2d21b05bf01a7881303a38737d646ad5839a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SignUpEmailStateNotifier
    extends BuildlessAutoDisposeNotifier<SignUpEmailUiState> {
  late final String type;

  SignUpEmailUiState build({
    String type = 'mobile',
  });
}

/// See also [SignUpEmailStateNotifier].
@ProviderFor(SignUpEmailStateNotifier)
const signUpEmailStateNotifierProvider = SignUpEmailStateNotifierFamily();

/// See also [SignUpEmailStateNotifier].
class SignUpEmailStateNotifierFamily extends Family<SignUpEmailUiState> {
  /// See also [SignUpEmailStateNotifier].
  const SignUpEmailStateNotifierFamily();

  /// See also [SignUpEmailStateNotifier].
  SignUpEmailStateNotifierProvider call({
    String type = 'mobile',
  }) {
    return SignUpEmailStateNotifierProvider(
      type: type,
    );
  }

  @override
  SignUpEmailStateNotifierProvider getProviderOverride(
    covariant SignUpEmailStateNotifierProvider provider,
  ) {
    return call(
      type: provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'signUpEmailStateNotifierProvider';
}

/// See also [SignUpEmailStateNotifier].
class SignUpEmailStateNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SignUpEmailStateNotifier, SignUpEmailUiState> {
  /// See also [SignUpEmailStateNotifier].
  SignUpEmailStateNotifierProvider({
    String type = 'mobile',
  }) : this._internal(
          () => SignUpEmailStateNotifier()..type = type,
          from: signUpEmailStateNotifierProvider,
          name: r'signUpEmailStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$signUpEmailStateNotifierHash,
          dependencies: SignUpEmailStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              SignUpEmailStateNotifierFamily._allTransitiveDependencies,
          type: type,
        );

  SignUpEmailStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  SignUpEmailUiState runNotifierBuild(
    covariant SignUpEmailStateNotifier notifier,
  ) {
    return notifier.build(
      type: type,
    );
  }

  @override
  Override overrideWith(SignUpEmailStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SignUpEmailStateNotifierProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SignUpEmailStateNotifier,
      SignUpEmailUiState> createElement() {
    return _SignUpEmailStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignUpEmailStateNotifierProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SignUpEmailStateNotifierRef
    on AutoDisposeNotifierProviderRef<SignUpEmailUiState> {
  /// The parameter `type` of this provider.
  String get type;
}

class _SignUpEmailStateNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SignUpEmailStateNotifier,
        SignUpEmailUiState> with SignUpEmailStateNotifierRef {
  _SignUpEmailStateNotifierProviderElement(super.provider);

  @override
  String get type => (origin as SignUpEmailStateNotifierProvider).type;
}

String _$signUpEmailUiEventHash() =>
    r'774187777b9a7a5750f07e4aeb972bdc97dee0d7';

abstract class _$SignUpEmailUiEvent
    extends BuildlessAutoDisposeNotifier<CommonUIEvent> {
  late final String type;

  CommonUIEvent build({
    String type = 'mobile',
  });
}

/// See also [SignUpEmailUiEvent].
@ProviderFor(SignUpEmailUiEvent)
const signUpEmailUiEventProvider = SignUpEmailUiEventFamily();

/// See also [SignUpEmailUiEvent].
class SignUpEmailUiEventFamily extends Family<CommonUIEvent> {
  /// See also [SignUpEmailUiEvent].
  const SignUpEmailUiEventFamily();

  /// See also [SignUpEmailUiEvent].
  SignUpEmailUiEventProvider call({
    String type = 'mobile',
  }) {
    return SignUpEmailUiEventProvider(
      type: type,
    );
  }

  @override
  SignUpEmailUiEventProvider getProviderOverride(
    covariant SignUpEmailUiEventProvider provider,
  ) {
    return call(
      type: provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'signUpEmailUiEventProvider';
}

/// See also [SignUpEmailUiEvent].
class SignUpEmailUiEventProvider
    extends AutoDisposeNotifierProviderImpl<SignUpEmailUiEvent, CommonUIEvent> {
  /// See also [SignUpEmailUiEvent].
  SignUpEmailUiEventProvider({
    String type = 'mobile',
  }) : this._internal(
          () => SignUpEmailUiEvent()..type = type,
          from: signUpEmailUiEventProvider,
          name: r'signUpEmailUiEventProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$signUpEmailUiEventHash,
          dependencies: SignUpEmailUiEventFamily._dependencies,
          allTransitiveDependencies:
              SignUpEmailUiEventFamily._allTransitiveDependencies,
          type: type,
        );

  SignUpEmailUiEventProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  CommonUIEvent runNotifierBuild(
    covariant SignUpEmailUiEvent notifier,
  ) {
    return notifier.build(
      type: type,
    );
  }

  @override
  Override overrideWith(SignUpEmailUiEvent Function() create) {
    return ProviderOverride(
      origin: this,
      override: SignUpEmailUiEventProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SignUpEmailUiEvent, CommonUIEvent>
      createElement() {
    return _SignUpEmailUiEventProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignUpEmailUiEventProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SignUpEmailUiEventRef on AutoDisposeNotifierProviderRef<CommonUIEvent> {
  /// The parameter `type` of this provider.
  String get type;
}

class _SignUpEmailUiEventProviderElement
    extends AutoDisposeNotifierProviderElement<SignUpEmailUiEvent,
        CommonUIEvent> with SignUpEmailUiEventRef {
  _SignUpEmailUiEventProviderElement(super.provider);

  @override
  String get type => (origin as SignUpEmailUiEventProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
