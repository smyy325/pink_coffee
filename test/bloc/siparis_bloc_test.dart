import 'package:bloc_test/bloc_test.dart';
import 'package:coffee/bloc/siparis_bloc.dart';
import 'package:coffee/bloc/siparis_event.dart';
import 'package:coffee/bloc/siparis_state.dart';
import 'package:coffee/core/errors/app_failure.dart';
import 'package:coffee/models/siparis_durumu.dart';
import 'package:coffee/models/siparis_modeli.dart';
import 'package:coffee/services/i_siparis_servisi.dart';
import 'package:coffee/services/yerel_siparis_deposu.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockServis extends Mock implements ISiparisServisi {}

class MockYerelDepo extends Mock implements YerelSiparisDeposu {}

void main() {
  late MockServis servis;
  late MockYerelDepo depo;
  final tarih = DateTime(2026, 11, 25, 10, 0);
  final s1 = SiparisModeli(
    id: 'PC-1', kahveAdi: 'V60 Ethiopia', boyut: 'Orta',
    fiyat: 150.0, adet: 2, durum: SiparisDurumu.hazirlaniyor, tarih: tarih,
  );
  final s2 = SiparisModeli(
    id: 'PC-2', kahveAdi: 'Flat White', boyut: 'Küçük',
    fiyat: 120.0, adet: 1, durum: SiparisDurumu.teslimEdildi, tarih: tarih,
  );

  setUpAll(() {
    registerFallbackValue(s1);
    registerFallbackValue(SiparisDurumu.hazirlaniyor);
  });

  setUp(() {
    servis = MockServis();
    depo = MockYerelDepo();
    when(() => depo.siparisleriKaydet(any())).thenAnswer((_) async {});
  });

  group('SiparisBloc', () {
    test('başlangıç durumu SiparisInitialState olmalıdır', () {
      final bloc = SiparisBloc(servis: servis, yerelDepo: depo);
      expect(bloc.state, const SiparisInitialState());
      bloc.close();
    });

    blocTest<SiparisBloc, SiparisState>(
      'çevrimiçi yüklemede uzak veriyi getirir ve önbelleğe yazar',
      build: () {
        when(() => depo.siparisleriOku()).thenAnswer((_) async => const []);
        when(() => servis.siparisleriGetir()).thenAnswer((_) async => [s1, s2]);
        return SiparisBloc(servis: servis, yerelDepo: depo);
      },
      act: (b) => b.add(const SiparisleriYukleEvent()),
      expect: () => [
        const SiparisLoadingState(),
        SiparisLoadedState(tumSiparisler: [s1, s2], filtrelenmisSiparisler: [s1, s2], toplamTutar: 420.0),
      ],
      verify: (_) => verify(() => depo.siparisleriKaydet([s1, s2])).called(1),
    );

    blocTest<SiparisBloc, SiparisState>(
      'internet yokken önbellekte veri varsa offlineMi: true ile yayar',
      build: () {
        when(() => depo.siparisleriOku()).thenAnswer((_) async => [s1]);
        when(() => servis.siparisleriGetir()).thenThrow(const NetworkFailure());
        return SiparisBloc(servis: servis, yerelDepo: depo);
      },
      act: (b) => b.add(const SiparisleriYukleEvent()),
      expect: () => [
        const SiparisLoadingState(),
        SiparisLoadedState(tumSiparisler: [s1], filtrelenmisSiparisler: [s1], toplamTutar: 300.0),
        SiparisLoadedState(tumSiparisler: [s1], filtrelenmisSiparisler: [s1], toplamTutar: 300.0, offlineMi: true),
      ],
    );

    blocTest<SiparisBloc, SiparisState>(
      'internet yokken önbellek de boşsa SiparisErrorState yayar',
      build: () {
        when(() => depo.siparisleriOku()).thenAnswer((_) async => const []);
        when(() => servis.siparisleriGetir()).thenThrow(const NetworkFailure('Ağ yok'));
        return SiparisBloc(servis: servis, yerelDepo: depo);
      },
      act: (b) => b.add(const SiparisleriYukleEvent()),
      expect: () => [const SiparisLoadingState(), const SiparisErrorState('Ağ yok')],
    );

    blocTest<SiparisBloc, SiparisState>(
      'yeni sipariş verildiğinde listeye ekler ve bildirim mesajı yayar',
      build: () {
        when(() => servis.siparisOlustur(any())).thenAnswer((_) async => s2);
        return SiparisBloc(servis: servis, yerelDepo: depo);
      },
      seed: () => SiparisLoadedState(tumSiparisler: [s1], filtrelenmisSiparisler: [s1], toplamTutar: 300.0),
      act: (b) => b.add(YeniSiparisVerEvent(s2)),
      expect: () => [
        SiparisLoadedState(
          tumSiparisler: [s2, s1], filtrelenmisSiparisler: [s2, s1],
          toplamTutar: 420.0, bildirimMesaji: 'Sipariş oluşturuldu: Flat White',
        ),
      ],
    );

    blocTest<SiparisBloc, SiparisState>(
      'sipariş durumu güncellendiğinde listeyi günceller ve bildirim mesajı yayar',
      build: () {
        when(() => servis.siparisDurumuGuncelle('PC-1', SiparisDurumu.yolda))
            .thenAnswer((_) async => s1.copyWith(durum: SiparisDurumu.yolda));
        return SiparisBloc(servis: servis, yerelDepo: depo);
      },
      seed: () => SiparisLoadedState(tumSiparisler: [s1, s2], filtrelenmisSiparisler: [s1, s2], toplamTutar: 420.0),
      act: (b) => b.add(const SiparisDurumuGuncelleEvent(id: 'PC-1', yeniDurum: SiparisDurumu.yolda)),
      expect: () => [SiparisLoadedState(
        tumSiparisler: [s1.copyWith(durum: SiparisDurumu.yolda), s2],
        filtrelenmisSiparisler: [s1.copyWith(durum: SiparisDurumu.yolda), s2],
        toplamTutar: 420.0, bildirimMesaji: 'Durum güncellendi: Yolda',
      )],
    );

    blocTest<SiparisBloc, SiparisState>(
      'filtreleme olayında seçili duruma göre listeyi ve toplam tutarı süzer',
      build: () => SiparisBloc(servis: servis, yerelDepo: depo),
      seed: () => SiparisLoadedState(tumSiparisler: [s1, s2], filtrelenmisSiparisler: [s1, s2], toplamTutar: 420.0),
      act: (b) => b.add(const SiparisleriFiltreleEvent(SiparisDurumu.teslimEdildi)),
      expect: () => [SiparisLoadedState(
        tumSiparisler: [s1, s2], filtrelenmisSiparisler: [s2],
        seciliFiltre: SiparisDurumu.teslimEdildi, toplamTutar: 120.0,
      )],
    );

    blocTest<SiparisBloc, SiparisState>(
      'iptal olan siparişleri toplam tutara dahil etmez',
      build: () {
        when(() => servis.siparisDurumuGuncelle('PC-1', SiparisDurumu.iptal))
            .thenAnswer((_) async => s1.copyWith(durum: SiparisDurumu.iptal));
        return SiparisBloc(servis: servis, yerelDepo: depo);
      },
      seed: () => SiparisLoadedState(tumSiparisler: [s1, s2], filtrelenmisSiparisler: [s1, s2], toplamTutar: 420.0),
      act: (b) => b.add(const SiparisDurumuGuncelleEvent(id: 'PC-1', yeniDurum: SiparisDurumu.iptal)),
      expect: () => [SiparisLoadedState(
        tumSiparisler: [s1.copyWith(durum: SiparisDurumu.iptal), s2],
        filtrelenmisSiparisler: [s1.copyWith(durum: SiparisDurumu.iptal), s2],
        toplamTutar: 120.0, bildirimMesaji: 'Durum güncellendi: İptal',
      )],
    );
  });
}
