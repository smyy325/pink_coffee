import 'package:equatable/equatable.dart';

import '../models/siparis_durumu.dart';
import '../models/siparis_modeli.dart';

sealed class SiparisEvent extends Equatable {
  const SiparisEvent();

  @override
  List<Object?> get props => [];
}

final class SiparisleriYukleEvent extends SiparisEvent {
  const SiparisleriYukleEvent();
}

final class YeniSiparisVerEvent extends SiparisEvent {
  final SiparisModeli yeniSiparis;

  const YeniSiparisVerEvent(this.yeniSiparis);

  @override
  List<Object?> get props => [yeniSiparis];
}

final class SiparisDurumuGuncelleEvent extends SiparisEvent {
  final String id;
  final SiparisDurumu yeniDurum;

  const SiparisDurumuGuncelleEvent({
    required this.id,
    required this.yeniDurum,
  });

  @override
  List<Object?> get props => [id, yeniDurum];
}

final class SiparisleriFiltreleEvent extends SiparisEvent {
  final SiparisDurumu seciliDurum;

  const SiparisleriFiltreleEvent(this.seciliDurum);

  @override
  List<Object?> get props => [seciliDurum];
}

