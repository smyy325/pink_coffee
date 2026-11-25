import 'package:equatable/equatable.dart';

import '../models/siparis_durumu.dart';
import '../models/siparis_modeli.dart';

sealed class SiparisState extends Equatable {
  const SiparisState();

  @override
  List<Object?> get props => [];
}

final class SiparisInitialState extends SiparisState {
  const SiparisInitialState();
}

final class SiparisLoadingState extends SiparisState {
  const SiparisLoadingState();
}

final class SiparisLoadedState extends SiparisState {
  final List<SiparisModeli> tumSiparisler;
  final List<SiparisModeli> filtrelenmisSiparisler;
  final SiparisDurumu seciliFiltre;
  final double toplamTutar;
  final bool offlineMi;
  final String? bildirimMesaji;

  const SiparisLoadedState({
    required this.tumSiparisler,
    required this.filtrelenmisSiparisler,
    this.seciliFiltre = SiparisDurumu.tumu,
    this.toplamTutar = 0,
    this.offlineMi = false,
    this.bildirimMesaji,
  });

  @override
  List<Object?> get props => [
        tumSiparisler,
        filtrelenmisSiparisler,
        seciliFiltre,
        toplamTutar,
        offlineMi,
        bildirimMesaji,
      ];
}

final class SiparisErrorState extends SiparisState {
  final String mesaj;

  const SiparisErrorState(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}

