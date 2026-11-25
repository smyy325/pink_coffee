import 'package:flutter/material.dart';

import '../core/constants/uygulama_renkleri.dart';

class OfflineUyariCubugu extends StatelessWidget {
  const OfflineUyariCubugu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: UygulamaRenkleri.offlineArkaPlan,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: UygulamaRenkleri.offlineYazi, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Çevrimdışı mod: Önbellekteki kayıtlı siparişler gösteriliyor.',
              style: TextStyle(
                color: UygulamaRenkleri.offlineYazi,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

