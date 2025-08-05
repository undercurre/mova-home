// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_config_page_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userConfigPageStateNotifierHash() =>
    r'77aea61db5bd80865a14f0d167a948e2a0419935';

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

abstract class _$UserConfigPageStateNotifier
    extends BuildlessAutoDisposeNotifier<UserConfigPageUiState> {
  late final UserConfigType? type;

  UserConfigPageUiState build(
    UserConfigType? type,
  );
}

/// See also [UserConfigPageStateNotifier].
@ProviderFor(UserConfigPageStateNotifier)
const userConfigPageStateNotifierProvider = UserConfigPageStateNotifierFamily();

/// See also [UserConfigPageStateNotifier].
class UserConfigPageStateNotifierFamily extends Family<UserConfigPageUiState> {
  /// See also [UserConfigPageStateNotifier].
  const UserConfigPageStateNotifierFamily();

  /// See also [UserConfigPageStateNotifier].
  UserConfigPageStateNotifierProvider call(
    UserConfigType? type,
  ) {
    return UserConfigPageStateNotifierProvider(
      type,
    );
  }

  @override
  UserConfigPageStateNotifierProvider getProviderOverride(
    covariant UserConfigPageStateNotifierProvider provider,
  ) {
    return call(
      provider.type,
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
  String? get name => r'userConfigPageStateNotifierProvider';
}

/// See also [UserConfigPageStateNotifier].
class UserConfigPageStateNotifierProvider
    extends AutoDisposeNotifierProviderImpl<UserConfigPageStateNotifier,
        UserConfigPageUiState> {
  /// See also [UserConfigPageStateNotifier].
  UserConfigPageStateNotifierProvider(
    UserConfigType? type,
  ) : this._internal(
          () => UserConfigPageStateNotifier()..type = type,
          from: userConfigPageStateNotifierProvider,
          name: r'userConfigPageStateNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userConfigPageStateNotifierHash,
          dependencies: UserConfigPageStateNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserConfigPageStateNotifierFamily._allTransitiveDependencies,
          type: type,
        );

  UserConfigPageStateNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final UserConfigType? type;

  @override
  UserConfigPageUiState runNotifierBuild(
    covariant UserConfigPageStateNotifier notifier,
  ) {
    return notifier.build(
      type,
    );
  }

  @override
  Override overrideWith(UserConfigPageStateNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserConfigPageStateNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<UserConfigPageStateNotifier,
      UserConfigPageUiState> createElement() {
    return _UserConfigPageStateNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserConfigPageStateNotifierProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserConfigPageStateNotifierRef
    on AutoDisposeNotifierProviderRef<UserConfigPageUiState> {
  /// The parameter `type` of this provider.
  UserConfigType? get type;
}

class _UserConfigPageStateNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<UserConfigPageStateNotifier,
        UserConfigPageUiState> with UserConfigPageStateNotifierRef {
  _UserConfigPageStateNotifierProviderElement(super.provider);

  @override
  UserConfigType? get type =>
      (origin as UserConfigPageStateNotifierProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
