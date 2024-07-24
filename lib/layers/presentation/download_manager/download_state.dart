class DownloadState {
  Map<String, int> downloadProgressMap;

  DownloadState({this.downloadProgressMap = const {}});

  DownloadState.clone(DownloadState existingState)
      : this(
          downloadProgressMap: existingState.downloadProgressMap,
        );
}
