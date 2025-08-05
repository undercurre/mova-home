enum AdType {
  splash,
  homePage;

  String get typeName {
    return switch (this) {
      splash => 'splashAd',
      homePage => 'homePage',
    };
  }

  String get typeFileName {
    return switch (this) {
      splash => 'ad_splash',
      homePage => 'ad_show',
    };
  }

  String get typeKey {
    return switch (this) {
      splash => 'adSplash',
      homePage => 'adShow',
    };
  }
}