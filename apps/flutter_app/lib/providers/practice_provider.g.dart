// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PracticeSession)
const practiceSessionProvider = PracticeSessionProvider._();

final class PracticeSessionProvider
    extends $NotifierProvider<PracticeSession, PracticeSessionState> {
  const PracticeSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'practiceSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$practiceSessionHash();

  @$internal
  @override
  PracticeSession create() => PracticeSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PracticeSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PracticeSessionState>(value),
    );
  }
}

String _$practiceSessionHash() => r'59a0becaf2f9da2b5efa045c8417e6431d1e6133';

abstract class _$PracticeSession extends $Notifier<PracticeSessionState> {
  PracticeSessionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PracticeSessionState, PracticeSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PracticeSessionState, PracticeSessionState>,
              PracticeSessionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
