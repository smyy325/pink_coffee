import 'package:equatable/equatable.dart';

abstract class AppFailure extends Equatable implements Exception {
  final String mesaj;

  const AppFailure(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([
    super.mesaj = 'İnternet bağlantısı kurulamadı. Çevrimdışı veriler gösteriliyor.',
  ]);
}

class ServerFailure extends AppFailure {
  const ServerFailure([
    super.mesaj = 'Sunucu işlemi sırasında beklenmeyen bir hata oluştu.',
  ]);
}

class CacheFailure extends AppFailure {
  const CacheFailure([
    super.mesaj = 'Yerel sipariş önbelleğine erişilemedi.',
  ]);
}

