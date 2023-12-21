
import 'package:equatable/equatable.dart';

class ViewAppState extends Equatable{
  final bool isInstalled;
  final bool isUpdateAvailable;
  final bool downloading;
  final bool fileExists;
  final double progress;

  const ViewAppState({
    required this.isInstalled,
    required this.isUpdateAvailable,
    required this.downloading,
    required this.fileExists,
    required this.progress,
  });

  @override
  List<Object?> get props => [
    isInstalled,
    isUpdateAvailable,
    downloading,
    fileExists,
    progress
  ];

  ViewAppState copyWith({
    bool? isInstalled,
    bool? isUpdateAvailable,
    bool? downloading,
    bool? fileExists,
    double? progress,
  }){
    return ViewAppState(
        isInstalled: isInstalled ?? this.isInstalled,
        isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
        downloading: downloading ?? this.downloading,
        fileExists: fileExists ?? this.fileExists,
        progress: progress ?? this.progress,
    );
  }

}

class ViewAppInitState extends ViewAppState {
  const ViewAppInitState()
      : super(
            isInstalled: false,
            isUpdateAvailable: false,
            downloading: false,
            fileExists: false,
            progress: 0,
  );
}
