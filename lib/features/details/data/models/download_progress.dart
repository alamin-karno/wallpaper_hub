class DownloadProgress {
  final int received;
  final int total;

  const DownloadProgress(this.received, this.total);

  double get percent => total == 0 ? 0 : received / total;
}
