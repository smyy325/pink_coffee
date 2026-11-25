import '../core/errors/app_failure.dart';
import '../models/siparis_durumu.dart';
import '../models/siparis_modeli.dart';
import 'i_siparis_servisi.dart';

class MockSiparisServisi implements ISiparisServisi {
  final Duration gecikme;
  bool cevrimdisiMod;
  final List<SiparisModeli> _siparisler;

  MockSiparisServisi({
    this.gecikme = const Duration(milliseconds: 400),
    this.cevrimdisiMod = false,
    List<SiparisModeli>? baslangicSiparisleri,
  }) : _siparisler = List<SiparisModeli>.from(
          baslangicSiparisleri ?? _varsayilanSiparisler(),
        );

  @override
  Future<List<SiparisModeli>> siparisleriGetir() async {
    await Future<void>.delayed(gecikme);
    if (cevrimdisiMod) throw const NetworkFailure();
    return List<SiparisModeli>.unmodifiable(_siparisler);
  }

  @override
  Future<SiparisModeli> siparisOlustur(SiparisModeli siparis) async {
    await Future<void>.delayed(gecikme);
    if (cevrimdisiMod) throw const NetworkFailure();
    _siparisler.insert(0, siparis);
    return siparis;
  }

  @override
  Future<SiparisModeli> siparisDurumuGuncelle(
    String id,
    SiparisDurumu yeniDurum,
  ) async {
    await Future<void>.delayed(gecikme);
    if (cevrimdisiMod) throw const NetworkFailure();

    final indeks = _siparisler.indexWhere((s) => s.id == id);
    if (indeks == -1) {
      throw const ServerFailure('Güncellenecek sipariş sunucuda bulunamadı.');
    }

    final guncel = _siparisler[indeks].copyWith(durum: yeniDurum);
    _siparisler[indeks] = guncel;
    return guncel;
  }

  static List<SiparisModeli> _varsayilanSiparisler() {
    final simdi = DateTime.now();
    return [
      SiparisModeli(
        id: 'PC-101',
        kahveAdi: 'V60 Ethiopia Yirgacheffe',
        boyut: 'Orta',
        fiyat: 165.0,
        adet: 1,
        durum: SiparisDurumu.hazirlaniyor,
        tarih: simdi.subtract(const Duration(minutes: 12)),
      ),
      SiparisModeli(
        id: 'PC-102',
        kahveAdi: 'Flat White',
        boyut: 'Küçük',
        fiyat: 135.0,
        adet: 2,
        durum: SiparisDurumu.yolda,
        tarih: simdi.subtract(const Duration(minutes: 28)),
      ),
      SiparisModeli(
        id: 'PC-103',
        kahveAdi: 'Cold Brew Tonic',
        boyut: 'Büyük',
        fiyat: 155.0,
        adet: 1,
        durum: SiparisDurumu.teslimEdildi,
        tarih: simdi.subtract(const Duration(hours: 2)),
      ),
    ];
  }
}

