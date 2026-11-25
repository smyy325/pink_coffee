# PinkCoffee — Proje Dosya Özeti ve Mimari Uyum Raporu

Bu doküman, `project.md` ve `skill.md` standartları temel alınarak `lib/` ve `test/` altındaki tüm `.dart` dosyalarının güncel durumunu özetler.

---

## 1. Katman Bazlı Dosya Tablosu

| Katman | Dosya Yolu | Sorumluluğu / Görevi (SOLID) | Satır Sayısı | Sınır Kontrolü |
| :--- | :--- | :--- | :---: | :---: |
| **Giriş (DI)** | `lib/main.dart` | Uygulamayı başlatır ve `MultiBlocProvider` ile bağımlılık enjeksiyonunu sağlar. | 50 | ✅ (40–50) |
| **Core** | `lib/core/constants/uygulama_renkleri.dart` | Uygulama genelindeki modern, hafif pembe dokunuşlu renk sabitlerini barındırır. | 22 | ✅ (≤150) |
| **Core** | `lib/core/errors/app_failure.dart` | `Equatable` tabanlı `AppFailure`, `NetworkFailure`, `ServerFailure` ve `CacheFailure` hata sınıflarını tanımlar. | 29 | ✅ (≤150) |
| **Models** | `lib/models/siparis_durumu.dart` | `SiparisDurumu` enum değerlerini (`tumu` dahil) ve her durumun `etiket`, `ikon`, `renk` getter'larını sunar (OCP). | 50 | ✅ (≤150) |
| **Models** | `lib/models/siparis_modeli.dart` | `Equatable`, `copyWith`, `toMap` ve `num.toDouble()` korumalı `fromMap` içeren değişmez sipariş modelidir. | 73 | ✅ (≤150) |
| **Services** | `lib/services/i_siparis_servisi.dart` | Uzak sipariş servisi için soyut sözleşmeyi tanımlar (DIP & ISP). | 14 | ✅ (≤150) |
| **Services** | `lib/services/mock_siparis_servisi.dart` | `ISiparisServisi` sözleşmesini uygulayarak gecikme ve çevrimdışı mod simülasyonlu sahte API sağlar (LSP). | 85 | ✅ (≤150) |
| **Services** | `lib/services/yerel_siparis_deposu.dart` | `SharedPreferences` üzerinden JSON formatında çevrimdışı sipariş önbellekleme yapar (SRP). | 52 | ✅ (≤150) |
| **BLoC** | `lib/bloc/siparis_event.dart` | Yükleme, yeni sipariş, durum güncelleme ve filtreleme `Equatable` olaylarını tanımlar. | 47 | ✅ (≤150) |
| **BLoC** | `lib/bloc/siparis_state.dart` | Başlangıç, yüklenme, yüklendi (filtreli liste, toplam tutar, offline bayrağı) ve hata durumlarını tanımlar. | 57 | ✅ (≤150) |
| **BLoC** | `lib/bloc/siparis_bloc.dart` | Offline-First veri akışını, filtrelemeyi ve iptal hariç toplam tutar hesaplamasını yönetir. | 145 | ✅ (≤150) |
| **Widgets** | `lib/widgets/durum_rozeti.dart` | Sipariş durumunu ikon ve renkli etiket olarak çizen saf UI bileşenidir. | 38 | ✅ (≤150) |
| **Widgets** | `lib/widgets/offline_uyari_cubugu.dart` | İnternet kesintisinde gösterilen çevrimdışı uyarı bandıdır. | 33 | ✅ (≤150) |
| **Widgets** | `lib/widgets/durum_filtre_cubugu.dart` | `SiparisDurumu` değerlerine göre yatay filtre seçimi sunan saf UI bileşenidir. | 53 | ✅ (≤150) |
| **Widgets** | `lib/widgets/siparis_karti.dart` | Tek bir siparişi ve durum değiştirme menüsünü gösteren saf kart bileşenidir. | 110 | ✅ (≤150) |
| **Screens** | `lib/screens/siparis_takip_ekrani.dart` | `BlocConsumer` ile durum dinleyen (`SnackBar` yan etkileri `listener` içinde) ana takip ekranıdır. | 148 | ✅ (≤150) |
| **Test** | `test/bloc/siparis_bloc_test.dart` | `bloc_test` ve `mocktail` ile `SiparisBloc` senaryolarını (çevrimiçi, çevrimdışı, hata, ekleme, güncelleme, filtre, iptal hariç toplam) test eder. | 148 | ✅ (≤150) |
| **Test** | `test/widget_test.dart` | `PinkCoffeeApp` açılışında sipariş listesinin yüklendiğini doğrulayan widget testidir. | 23 | ✅ (≤150) |

---

## 2. Mimari Uyum Kontrolü

- **`SiparisDurumu` Enum Kuralı:** `lib/models/siparis_durumu.dart` içinde `tumu`, `hazirlaniyor`, `yolda`, `teslimEdildi` ve `iptal` değerlerinin tamamı tanımlıdır; aktif sipariş aşamaları `siparisAsamalari` getter'ı ile ayrılmıştır.
- **UI Katmanı Saflığı (Hesaplama & Yan Etki Yasağı):**
  - `lib/screens/` ve `lib/widgets/` altındaki hiçbir dosyada matematiksel hesaplama yer almaz; `toplamTutar` ve `filtrelenmisSiparisler` doğrudan `SiparisBloc` tarafından üretilen `SiparisLoadedState` üzerinden, satır tutarı ise `SiparisModeli.toplamTutar` üzerinden okunur.
  - `SnackBar` gösterimleri yalnızca `SiparisTakipEkrani` içindeki `BlocConsumer.listener` bloğunda (`_bildirimGoster`) tetiklenir; `builder` içinde yan etki yoktur.
- **`test/bloc/siparis_bloc_test.dart` Durumu:** 8 adet `SiparisBloc` birim testi (+ 1 adet `widget_test.dart`, toplam 9 test) eksiksiz çalışmakta ve `flutter test` ile `flutter analyze` kontrollerinden hatasız geçmektedir.

