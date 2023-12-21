
abstract class ViewAppEvents {}

class UpdateIsInstalledEvent extends ViewAppEvents {
  final bool isInstalled;

  UpdateIsInstalledEvent(this.isInstalled);
}

class UpdateIsUpdateAvailableEvent extends ViewAppEvents {
  final bool isUpdateAvailable;

  UpdateIsUpdateAvailableEvent(this.isUpdateAvailable);
}

class UpdateDownloadingEvent extends ViewAppEvents {
  final bool downloading;

  UpdateDownloadingEvent(this.downloading);
}

class UpdateFileExistsEvent extends ViewAppEvents {
  final bool fileExists;

  UpdateFileExistsEvent(this.fileExists);
}

class UpdateProgressEvent extends ViewAppEvents {
  final double progress;

  UpdateProgressEvent(this.progress);
}