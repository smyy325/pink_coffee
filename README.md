# PinkCoffee — 3. Dalga Nitelikli Kahve Sipariş & Canlı Takip

**PinkCoffee**, Flutter ile **Clean Architecture**, **BLoC (Business Logic Component)** mimarisi, **Offline-First** veri kalıcılığı ve **SOLID** prensipleri doğrultusunda geliştirilen modern kahve sipariş ve takip uygulamasıdır.

---

## Özellikler

- **Offline-First Veri Akışı:** Açılışta önce `SharedPreferences` yerel önbelleğinden kayıtlı siparişleri okur, ardından uzak servisten güncel veriyi çekip önbelleği yeniler. İnternet kesintisinde önbellekteki verileri çevrimdışı uyarı bandı ile gösterir.
- **Durum Bazlı Filtreleme:** `SiparisDurumu` (`Tümü`, `Hazırlanıyor`, `Yolda`, `Teslim Edildi`, `İptal`) seçenekleri ile anlık liste filtreleme.
- **Canlı Durum Güncelleme & Sipariş Ekleme:** Sipariş kartı üzerinden durum değiştirme ve yeni sipariş oluşturma; `BlocListener` üzerinden başarı/hata `SnackBar` bildirimleri.
- **İptal Hariç Toplam Tutar:** İptal edilen siparişler aktif filtre toplam tutarına dahil edilmez.
- **Modern Arayüz:** Hafif pembe dokunuşlu, sade ve okunabilir Material 3 tasarım.

---

## Mimari ve Klasör Yapısı

Uygulama tek yönlü veri akışı (Unidirectional Data Flow) ile çalışır; UI katmanı doğrudan servis veya yerel depo ile konuşmaz:

```text
lib/
├── main.dart                              # Uygulama giriş noktası ve MultiBlocProvider DI
├── core/
│   ├── constants/uygulama_renkleri.dart   # Renk paleti sabitleri
│   └── errors/app_failure.dart            # NetworkFailure, ServerFailure, CacheFailure
├── models/
│   ├── siparis_durumu.dart                # SiparisDurumu enum ve durum getter'ları
│   └── siparis_modeli.dart                # Equatable, copyWith, toMap, fromMap
├── services/
│   ├── i_siparis_servisi.dart             # Soyut servis arayüzü (DIP & ISP)
│   ├── mock_siparis_servisi.dart          # Uzak API simülatörü
│   └── yerel_siparis_deposu.dart          # SharedPreferences önbellek katmanı
├── bloc/
│   ├── siparis_event.dart                 # BLoC olayları
│   ├── siparis_state.dart                 # BLoC durumları
│   └── siparis_bloc.dart                  # İş mantığı ve Offline-First yönetimi
├── widgets/
│   ├── durum_filtre_cubugu.dart           # Yatay durum filtre seçici
│   ├── durum_rozeti.dart                  # Durum etiketi ve ikonu
│   ├── offline_uyari_cubugu.dart          # Çevrimdışı mod uyarı bandı
│   └── siparis_karti.dart                 # Sipariş kartı bileşeni
└── screens/
    └── siparis_takip_ekrani.dart          # BlocConsumer ile ana takip ekranı

test/
├── bloc/siparis_bloc_test.dart            # bloc_test ve mocktail birim testleri
└── widget_test.dart                       # Açılış widget testi
```

---

## Kullanılan Paketler

- `flutter_bloc` (`^8.1.6`)
- `equatable` (`^2.0.5`)
- `shared_preferences` (`^2.3.2`)
- `bloc_test` (`^9.1.7`) *(dev)*
- `mocktail` (`^1.0.4`) *(dev)*

---

## Kurulum ve Çalıştırma

```bash
# Bağımlılıkları yükle
flutter pub get

# Statik kod analizi
flutter analyze

# Birim ve widget testlerini çalıştır
flutter test

# Uygulamayı çalıştır
flutter run
```
