import 'package:flutter/material.dart';

import '../models/siparis_durumu.dart';

class DurumRozeti extends StatelessWidget {
  final SiparisDurumu durum;

  const DurumRozeti({super.key, required this.durum});

  @override
  Widget build(BuildContext context) {
    final renk = durum.renk;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: renk.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(durum.ikon, size: 15, color: renk),
          const SizedBox(width: 5),
          Text(
            durum.etiket,
            style: TextStyle(
              color: renk,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

