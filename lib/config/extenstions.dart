extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String removeDash() {
   return replaceAll('-', ' ');
  }

  String replaceBackWardSlash() {
    return replaceAll('\\', '/');
  }
}