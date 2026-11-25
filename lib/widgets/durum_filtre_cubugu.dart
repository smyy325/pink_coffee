import 'package:flutter/material.dart';

import '../core/constants/uygulama_renkleri.dart';
import '../models/siparis_durumu.dart';

class DurumFiltreCubugu extends StatelessWidget {
  final SiparisDurumu seciliDurum;
  final ValueChanged<SiparisDurumu> onSecim;

  const DurumFiltreCubugu({
    super.key,
    required this.seciliDurum,
    required this.onSecim,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: SiparisDurumu.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final durum = SiparisDurumu.values[index];
          final secili = durum == seciliDurum;
          return ChoiceChip(
            label: Text(durum.etiket),
            selected: secili,
            showCheckmark: false,
            selectedColor: UygulamaRenkleri.anaPembe,
            backgroundColor: UygulamaRenkleri.kartArkaPlan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: secili
                    ? UygulamaRenkleri.anaPembe
                    : UygulamaRenkleri.pembeKenar,
              ),
            ),
            labelStyle: TextStyle(
              color: secili ? Colors.white : UygulamaRenkleri.koyuKahve,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            onSelected: (_) => onSecim(durum),
          );
        },
      ),
    );
  }
}
