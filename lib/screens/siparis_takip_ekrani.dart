import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/siparis_bloc.dart';
import '../bloc/siparis_event.dart';
import '../bloc/siparis_state.dart';
import '../core/constants/uygulama_renkleri.dart';
import '../models/siparis_durumu.dart';
import '../models/siparis_modeli.dart';
import '../widgets/durum_filtre_cubugu.dart';
import '../widgets/offline_uyari_cubugu.dart';
import '../widgets/siparis_karti.dart';

class SiparisTakipEkrani extends StatelessWidget {
  const SiparisTakipEkrani({super.key});

  void _yeniSiparisEkle(BuildContext context) {
    final yeni = SiparisModeli(
      id: 'PC-${DateTime.now().millisecondsSinceEpoch % 10000}',
      kahveAdi: 'Iced Pink Latte',
      boyut: 'Orta',
      fiyat: 145.0,
      adet: 1,
      durum: SiparisDurumu.hazirlaniyor,
      tarih: DateTime.now(),
    );
    context.read<SiparisBloc>().add(YeniSiparisVerEvent(yeni));
  }

  void _bildirimGoster(BuildContext context, String mesaj, Color renk) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj), backgroundColor: renk),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UygulamaRenkleri.arkaPlan,
      appBar: AppBar(
        backgroundColor: UygulamaRenkleri.arkaPlan,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'PinkCoffee • Sipariş Takip',
          style: TextStyle(
            color: UygulamaRenkleri.koyuKahve,
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            color: UygulamaRenkleri.koyuKahve,
            onPressed: () => context.read<SiparisBloc>().add(const SiparisleriYukleEvent()),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: UygulamaRenkleri.anaPembe,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _yeniSiparisEkle(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Sipariş'),
      ),
      body: BlocConsumer<SiparisBloc, SiparisState>(
        listener: (context, state) {
          if (state is SiparisLoadedState && state.bildirimMesaji != null) {
            _bildirimGoster(context, state.bildirimMesaji!, UygulamaRenkleri.basariRenk);
          } else if (state is SiparisErrorState) {
            _bildirimGoster(context, state.mesaj, UygulamaRenkleri.hataRenk);
          }
        },
        builder: (context, state) {
          if (state is SiparisLoadingState || state is SiparisInitialState) {
            return const Center(
              child: CircularProgressIndicator(color: UygulamaRenkleri.anaPembe),
            );
          }
          if (state is SiparisErrorState) {
            return Center(
              child: Text(state.mesaj, style: const TextStyle(color: UygulamaRenkleri.hataRenk)),
            );
          }
          final yuklendi = state as SiparisLoadedState;
          return Column(
            children: [
              if (yuklendi.offlineMi) const OfflineUyariCubugu(),
              DurumFiltreCubugu(
                seciliDurum: yuklendi.seciliFiltre,
                onSecim: (d) => context.read<SiparisBloc>().add(SiparisleriFiltreleEvent(d)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: UygulamaRenkleri.acikPembe,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: UygulamaRenkleri.pembeKenar),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${yuklendi.filtrelenmisSiparisler.length} sipariş',
                      style: const TextStyle(color: UygulamaRenkleri.ikincilMetin),
                    ),
                    Text(
                      'Toplam: ₺${yuklendi.toplamTutar.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: UygulamaRenkleri.koyuKahve,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: yuklendi.filtrelenmisSiparisler.isEmpty
                    ? const Center(child: Text('Bu filtrede sipariş bulunamadı.'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 84),
                        itemCount: yuklendi.filtrelenmisSiparisler.length,
                        itemBuilder: (context, index) {
                          final siparis = yuklendi.filtrelenmisSiparisler[index];
                          return SiparisKarti(
                            siparis: siparis,
                            onDurumGuncelle: (yeniDurum) => context
                                .read<SiparisBloc>()
                                .add(SiparisDurumuGuncelleEvent(
                                  id: siparis.id,
                                  yeniDurum: yeniDurum,
                                )),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
