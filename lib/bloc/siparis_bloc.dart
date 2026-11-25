import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/errors/app_failure.dart';
import '../models/siparis_durumu.dart';
import '../models/siparis_modeli.dart';
import '../services/i_siparis_servisi.dart';
import '../services/yerel_siparis_deposu.dart';
import 'siparis_event.dart';
import 'siparis_state.dart';

class SiparisBloc extends Bloc<SiparisEvent, SiparisState> {
  final ISiparisServisi servis;
  final YerelSiparisDeposu yerelDepo;

  SiparisBloc({required this.servis, required this.yerelDepo})
      : super(const SiparisInitialState()) {
    on<SiparisleriYukleEvent>(_onSiparisleriYukle);
    on<YeniSiparisVerEvent>(_onYeniSiparisVer);
    on<SiparisDurumuGuncelleEvent>(_onDurumGuncelle);
    on<SiparisleriFiltreleEvent>(_onFiltrele);
  }

  Future<void> _onSiparisleriYukle(
    SiparisleriYukleEvent event,
    Emitter<SiparisState> emit,
  ) async {
    final aktifFiltre = _mevcutFiltre;
    emit(const SiparisLoadingState());

    var yerelListe = const <SiparisModeli>[];
    try {
      yerelListe = await yerelDepo.siparisleriOku();
      if (yerelListe.isNotEmpty) emit(_durumOlustur(yerelListe, aktifFiltre));
    } on AppFailure {
      yerelListe = const [];
    }

    try {
      final uzakListe = await servis.siparisleriGetir();
      await _guvenliKaydet(uzakListe);
      emit(_durumOlustur(uzakListe, aktifFiltre));
    } on AppFailure catch (hata) {
      if (yerelListe.isNotEmpty) {
        emit(_durumOlustur(yerelListe, aktifFiltre, offlineMi: true));
      } else {
        emit(SiparisErrorState(hata.mesaj));
      }
    }
  }

  Future<void> _onYeniSiparisVer(
    YeniSiparisVerEvent event,
    Emitter<SiparisState> emit,
  ) async {
    final aktifFiltre = _mevcutFiltre;
    final mevcutListe = _mevcutListe;
    try {
      final olusturulan = await servis.siparisOlustur(event.yeniSiparis);
      final guncelListe = [olusturulan, ...mevcutListe];
      await _guvenliKaydet(guncelListe);
      emit(_durumOlustur(
        guncelListe,
        aktifFiltre,
        bildirimMesaji: 'Sipariş oluşturuldu: ${olusturulan.kahveAdi}',
      ));
    } on AppFailure catch (hata) {
      emit(SiparisErrorState(hata.mesaj));
    }
  }

  Future<void> _onDurumGuncelle(
    SiparisDurumuGuncelleEvent event,
    Emitter<SiparisState> emit,
  ) async {
    final aktifFiltre = _mevcutFiltre;
    final mevcutListe = _mevcutListe;
    try {
      final guncelSiparis =
          await servis.siparisDurumuGuncelle(event.id, event.yeniDurum);
      final guncelListe = mevcutListe
          .map((s) => s.id == event.id ? guncelSiparis : s)
          .toList();
      await _guvenliKaydet(guncelListe);
      emit(_durumOlustur(
        guncelListe,
        aktifFiltre,
        bildirimMesaji: 'Durum güncellendi: ${event.yeniDurum.etiket}',
      ));
    } on AppFailure catch (hata) {
      emit(SiparisErrorState(hata.mesaj));
    }
  }

  void _onFiltrele(
    SiparisleriFiltreleEvent event,
    Emitter<SiparisState> emit,
  ) {
    final mevcut = state;
    if (mevcut is SiparisLoadedState) {
      emit(_durumOlustur(
        mevcut.tumSiparisler,
        event.seciliDurum,
        offlineMi: mevcut.offlineMi,
      ));
    }
  }

  SiparisDurumu get _mevcutFiltre => state is SiparisLoadedState
      ? (state as SiparisLoadedState).seciliFiltre
      : SiparisDurumu.tumu;

  List<SiparisModeli> get _mevcutListe => state is SiparisLoadedState
      ? (state as SiparisLoadedState).tumSiparisler
      : const [];

  Future<void> _guvenliKaydet(List<SiparisModeli> liste) async {
    try {
      await yerelDepo.siparisleriKaydet(liste);
    } on AppFailure catch (_) {
      return;
    }
  }

  SiparisLoadedState _durumOlustur(
    List<SiparisModeli> tumListe,
    SiparisDurumu filtre, {
    bool offlineMi = false,
    String? bildirimMesaji,
  }) {
    final filtrelenmis = filtre == SiparisDurumu.tumu
        ? tumListe
        : tumListe.where((s) => s.durum == filtre).toList();
    final toplam = filtrelenmis
        .where((s) => s.durum != SiparisDurumu.iptal)
        .fold<double>(0, (a, s) => a + s.toplamTutar);
    return SiparisLoadedState(
      tumSiparisler: tumListe,
      filtrelenmisSiparisler: filtrelenmis,
      seciliFiltre: filtre,
      toplamTutar: toplam,
      offlineMi: offlineMi,
      bildirimMesaji: bildirimMesaji,
    );
  }
}
