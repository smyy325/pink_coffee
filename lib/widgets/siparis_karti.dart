import 'package:flutter/material.dart';

import '../core/constants/uygulama_renkleri.dart';
import '../models/siparis_durumu.dart';
import '../models/siparis_modeli.dart';
import 'durum_rozeti.dart';

class SiparisKarti extends StatelessWidget {
  final SiparisModeli siparis;
  final ValueChanged<SiparisDurumu> onDurumGuncelle;

  const SiparisKarti({
    super.key,
    required this.siparis,
    required this.onDurumGuncelle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UygulamaRenkleri.kartArkaPlan,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: UygulamaRenkleri.pembeKenar),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: UygulamaRenkleri.acikPembe,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_cafe_rounded,
                  color: UygulamaRenkleri.anaPembe,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siparis.kahveAdi,
                      style: const TextStyle(
                        color: UygulamaRenkleri.koyuKahve,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${siparis.boyut} • ${siparis.adet} Adet',
                      style: const TextStyle(
                        color: UygulamaRenkleri.ikincilMetin,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<SiparisDurumu>(
                tooltip: 'Durumu Güncelle',
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: UygulamaRenkleri.ikincilMetin,
                ),
                onSelected: onDurumGuncelle,
                itemBuilder: (_) => SiparisDurumu.siparisAsamalari
                    .map((d) => PopupMenuItem<SiparisDurumu>(
                          value: d,
                          child: Row(
                            children: [
                              Icon(d.ikon, size: 18, color: d.renk),
                              const SizedBox(width: 8),
                              Text(d.etiket),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DurumRozeti(durum: siparis.durum),
              Text(
                '₺${siparis.toplamTutar.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: UygulamaRenkleri.koyuKahve,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
