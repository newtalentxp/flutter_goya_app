class Utils {
  static String getIconPath(String name,{String format:'png'}) {
    return 'assets/icon/$name.$format';
  }

  static String getImagePath(String name,{String format:'png'}) {
    return 'assets/image/$name.$format';
  }

  static String getStateImagePath(String name,{String format:'png'}) {
    return 'assets/state/$name.$format';
  }
}
