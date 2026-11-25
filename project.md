æç# PinkCoffee — 3. Dalga Nitelikli Kahve Sipariş & Canlı Takip

**PinkCoffee**, Flutter ile kurumsal **BLoC (Business Logic Component)** mimarisi, **Offline-First** veri kalıcılığı, **SOLID** yazılım prensipleri ve **otomatik test güvencesi** standartlarında geliştirilen nitelikli kahve sipariş ve takip uygulamasıdır.

---

## Temel Mühendislik Standartları

Bu projede kod kalitesini ve sürdürülebilirliği korumak için aşağıdaki kurallar zorunludur:

1. **Satır Sınırı Disiplini (Clean & Modular Code):**
   - `main.dart` dosyası yalnızca uygulama giriş noktası ve bağımlılık enjeksiyonu (DI) görevini üstlenir; **40–50 satırı geçemez**.
   - Projedeki **hiçbir `.dart` dosyası 150 satırı geçemez**. Sınıra yaklaşan ekran veya bileşenler alt widget'lara bölünür.
   - Gereksiz yorum satırlarından, ölü koddan ve tekrar eden yapılardan kaçınılır.
2. **SOLID Prensipleri:**
   - **Tek Sorumluluk (SRP):** Her dosya ve sınıf yalnızca tek bir iş yapar.
   - **Açık/Kapalı (OCP):** Yeni bir sipariş durumu eklendiğinde UI widget'ları değiştirilmez; davranış `SiparisDurumu` üzerinden genişletilir.
   - **Liskov Yerine Geçme (LSP):** Sahte servis (`MockSiparisServisi`) ile gerçek API servisi birbirinin yerine sorunsuz geçebilir.
   - **Arayüz Ayrımı (ISP):** Servis arayüzleri yalnızca ilgili katmanın ihtiyaç duyduğu metotları barındırır.ææ
   - **Bağımlılığın Tersine Çevrilmesi (DIP):** `SiparisBloc` somut sınıflara değil, soyut sözleşmelere (`ISiparisServisi`) bağımlıdır.
3. **BLoC & UI Ayrımı:**
   - İş mantığı ve hesaplamalar yalnızca `SiparisBloc` içinde yapılır; UI katmanı saf (dumb) bileşenlerden oluşur.
   - Bildirim (`SnackBar`) ve yönlendirmeler yalnızca `BlocListener` içinde çalışır.

---

## Kurulum ve Paketler

Projeyi ayağa kaldırmak için `pubspec.yaml` dosyasına aşağıdaki paketler eklenir:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  shared_preferences: ^2.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
```

### Testleri Çalıştırma
```bash
flutter test
```