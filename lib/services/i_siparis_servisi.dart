import '../models/siparis_durumu.dart';
import '../models/siparis_modeli.dart';

abstract interface class ISiparisServisi {
  Future<List<SiparisModeli>> siparisleriGetir();

  Future<SiparisModeli> siparisOlustur(SiparisModeli siparis);

  Future<SiparisModeli> siparisDurumuGuncelle(
    String id,
    SiparisDurumu yeniDurum,
  );
}

