import 'package:equatable/equatable.dart';

class SrcData with EquatableMixin {
  SrcData({
    required this.original,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
  });

  final String original;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;

  @override
  List<Object?> get props => [
        original,
        large,
        medium,
        small,
        portrait,
        landscape,
      ];

  Map<String, String> toResolutionMap() {
    Map<String, String> resolutions = {
      'original': original,
      'large': large,
      'medium': medium,
      'small': small,
      'portrait': portrait,
      'landscape': landscape,
    };

    return resolutions.map((label, url) {
      final uri = Uri.tryParse(url);
      final params = uri?.queryParameters ?? {};
      final size = '${params['w'] ?? ''}x${params['h'] ?? ''}';
      final withSize = size != 'x' ? ' ($size)' : '';
      return MapEntry('$label$withSize', url);
    });
  }
}
