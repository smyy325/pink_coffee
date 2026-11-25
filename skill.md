# Mimari Tasarım Dokümanı (Architecture Blueprint)

## 1. Tek Yönlü Veri Akışı (Unidirectional Data Flow)

Uygulamada veri her zaman tek bir yönde akar. UI doğrudan servis veya yerel depo ile konuşmaz:

```text
[ UI (Ekran) ]  ---- (1) Event Fırlat: bloc.add(...) ---->  [ SiparisBloc ]
      ^                                                          |    ^
      |                                        (2) Önce Yerel    |    | (3) Sonra Uzak
(4) State Yay                                      Depodan Oku   v    |     API'den Çek
(BlocBuilder /                                             [ Yerel Depo & API ]
 BlocListener)  <------------- Yeni State Üret -----------------------+
```

---

## 2. Ana Veri Modeli (Domain Model)

### `SiparisDurumu` Enum Yapısı

```dart
enum SiparisDurumu {
  tumu,         // Filtreleme sekmesi için varsayılan seçenek
  hazirlaniyor, // Barista siparişi aldı
  yolda,        // Kurye / servis aşamasında
  teslimEdildi, // Müşteriye ulaştı
  iptal,        // Sipariş iptal edildi
}
```
* **Not:** Sipariş nesneleri oluşturulurken yalnızca aktif süreç durumları (`hazirlaniyor`, `yolda`, `teslimEdildi`, `iptal`) atanır; `tumu` seçeneği yalnızca liste filtreleme mekanizmasında kullanılır. Her durum kendi `etiket`, `ikon` ve `renk` bilgisini getter üzerinden sunar (Open/Closed Principle).

### `SiparisModeli` Özellikleri
* `id` (`String`): Benzersiz sipariş kimliği
* `kahveAdi` (`String`): Kahve adı (ör. V60 Ethiopia, Flat White)
* `boyut` (`String`): Bardak boyutu (Küçük, Orta, Büyük)
* `fiyat` (`double`): Birim fiyat (`(map['fiyat'] as num).toDouble()` korumalı)
* `adet` (`int`): Sipariş adedi
* `durum` (`SiparisDurumu`): Siparişin güncel durumu
* `tarih` (`DateTime`): Oluşturulma zamanı
* **Değişmezlik:** `Equatable` ve `copyWith` ile korunur; alanlar doğrudan değiştirilemez.

---

## 3. Kullanıcı Senaryoları ve State Geçiş Matrisi

### Kullanıcı Aksiyonları ($\rightarrow$ Event)
| Kullanıcı Etkileşimi | Tetiklenen Event | BLoC Sorumluluğu |
| :--- | :--- | :--- |
| Ekran açılır / yenilenir | `SiparisleriYukleEvent` | Önce yerel depodan veri okur, ardından uzak servisten güncel veriyi çekip önbelleği günceller. |
| Yeni sipariş oluşturulur | `YeniSiparisVerEvent(yeniSiparis)` | Siparişi uzak servise ve yerel depoya kaydeder; güncel listeyi yayar. |
| Sipariş aşaması güncellenir | `SiparisDurumuGuncelleEvent(id, yeniDurum)` | İlgili siparişin kopyasını (`copyWith`) yeni durumla günceller ve kalıcı hale getirir. |
| Filtre sekmesi seçilir | `SiparisleriFiltreleEvent(seciliDurum)` | `seciliDurum == SiparisDurumu.tumu` ise tüm listeyi, değilse eşleşen siparişleri süzer. |

### Ekran Durumları ($\rightarrow$ State)
| Sistem / Ağ Durumu | Yayılan State | UI & Yan Etki Davranışı |
| :--- | :--- | :--- |
| Başlangıç anı | `SiparisInitialState` | Henüz işlem başlamadı. |
| Veri çekiliyor | `SiparisLoadingState` | Yükleme göstergesi (`CircularProgressIndicator`). |
| İnternet yok, önbellekte veri var | `SiparisLoadedState(liste, seciliFiltre, offlineMi: true)` | Kayıtlı siparişler çizilir + üstte sarı `OfflineUyariCubugu` görünür. |
| Sunucu verisi güncel | `SiparisLoadedState(liste, seciliFiltre, offlineMi: false)` | Güncel siparişler çizilir; offline uyarısı gizlenir. |
| İşlem başarılı (yan etki) | `SiparisLoadedState(..., bildirimMesaji: '...')` | `BlocListener` yeşil `SnackBar` gösterir. |
| Hata oluştu | `SiparisErrorState(mesaj)` | `BlocListener` kırmızı hata `SnackBar`'ı gösterir. |

---

## 4. Klasör Ağacı ve Satır Bütçesi

Her dosyanın sorumluluğu ve maksimum satır hedefi aşağıda tanımlanmıştır:

```text
lib/
├── main.dart                          -> æçMultiBlocProvider ve uygulama başlatıcı
├── core/
│   ├── constants/
│   │   └── uygulama_renkleri.dart     -> Renk paleti ve tema sabitleri
│   └── errors/
│       └── app_failure.dart           -> Ağ, sunucu ve önbellek hata sınıfları
├── models/
│   ├── siparis_durumu.dart            -> Enum (tumu dahil) + etiket/ikon/renk getter'ları
│   └── siparis_modeli.dart            -> Equatable, fromMap, toMap ve copyWith
├── services/
│   ├── i_siparis_servisi.dart         ->  Soyut servis sözleşmesi (DIP & ISP)
│   ├── mock_siparis_servisi.dart      ->  Uzak API simülatörü
│   └── yerel_siparis_deposu.dart      ->  SharedPreferences offline önbellek katmanı
├── bloc/
│   ├── siparis_event.dart             ->  Equatable Event sınıfları
│   ├── siparis_state.dart             ->  Equatable State sınıfları ve filtre desteği
│   └── siparis_bloc.dart              ->  İş mantığı ve Offline-First motoru
├── widgets/
│   ├── siparis_karti.dart             -> Saf UI sipariş kartı bileşeni
│   ├── durum_rozeti.dart              -> Durum etiketi bileşeni
│   ├── durum_filtre_cubugu.dart       -> Enum tabanlı yatay filtre seçici
│   └── offline_uyari_cubugu.dart      -> İnternet kesintisi uyarı bandı
└── screens/
    └── siparis_takip_ekrani.dart      -> BlocConsumer ile yönetilen ana ekran
test/
└── bloc/
    └── siparis_bloc_test.dart         -> bloc_test ve mocktail test senaryoları
```