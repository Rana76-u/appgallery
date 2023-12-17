abstract class ViewAppEvents {}

class BoolChange extends ViewAppEvents {
  final bool isInstalled;
  final bool isUpdateAvailable;

  BoolChange({
    required this.isUpdateAvailable,
    required this.isInstalled
  });
}