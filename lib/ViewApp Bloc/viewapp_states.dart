
class ViewAppState{
  final bool isInstalled;
  final bool isUpdateAvailable;

  ViewAppState({
    required this.isInstalled,
    required this.isUpdateAvailable
  });
}

class ViewAppInitial extends ViewAppState{
  ViewAppInitial({
    required super.isInstalled,
    required super.isUpdateAvailable,
  });
}