enum Flavor {
  aciPlus,
  aciPlusPlus,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.aciPlus:
        return 'ACI+';
      case Flavor.aciPlusPlus:
        return 'ACI++';
      default:
        return 'title';
    }
  }
}
