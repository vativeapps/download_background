import 'package:download_background/files_model.dart';

class DownloadProgress {
  final int progress;
  final int id;

  DownloadProgress(this.progress, this.id);
}

class AddedToQueue {
  final FileModel fileModel;
  AddedToQueue(this.fileModel);
}

class Downloading {
  final FileModel fileModel;
  Downloading(this.fileModel);
}

class DownloadComplete {}

///if both files are clicked to be downloaded in such a way that as one completes then click for second to download, then it is saving