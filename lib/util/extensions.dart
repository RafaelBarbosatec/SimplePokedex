extension StringExtensions on String {
  String fistLetterUpperCase() {
    if (this.length < 2) return this;
    return '${this.substring(0, 1).toUpperCase()}${this.substring(1)}';
  }
}
