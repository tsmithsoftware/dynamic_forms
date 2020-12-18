enum CheckType {
  STRING,
  YES_NO,
  NONE
}

class CheckTypeFactory {
  static CheckType getTypeFrom(String value) {
    switch(value.toLowerCase()) {
      case "string":
        return CheckType.STRING;
      case "yesno":
        return CheckType.YES_NO;
      default:
        return CheckType.NONE;
    }
  }

  static String getStringFrom(CheckType type) {
    switch(type) {
      case CheckType.STRING:
        return "string";
      case CheckType.YES_NO:
        return "yesNo";
      case CheckType.NONE:
        return null;
    }
    return "";
  }
}