import 'package:flutter/material.dart';

import '../core/constants/uygulama_renkleri.dart';

enum SiparisDurumu {
  tumu,
  hazirlaniyor,
  yolda,
  teslimEdildi,
  iptal;

  String get etiket => switch (this) {
        SiparisDurumu.tumu => 'Tümü',
        SiparisDurumu.hazirlaniyor => 'Hazırlanıyor',
        SiparisDurumu.yolda => 'Yolda',
        SiparisDurumu.teslimEdildi => 'Teslim Edildi',
        SiparisDurumu.iptal => 'İptal',
      };

  IconData get ikon => switch (this) {
        SiparisDurumu.tumu => Icons.list_alt_rounded,
        SiparisDurumu.hazirlaniyor => Icons.coffee_maker_rounded,
        SiparisDurumu.yolda => Icons.delivery_dining_rounded,
        SiparisDurumu.teslimEdildi => Icons.check_circle_rounded,
        SiparisDurumu.iptal => Icons.cancel_rounded,
      };

  Color get renk => switch (this) {
        SiparisDurumu.tumu => UygulamaRenkleri.tumuRenk,
        SiparisDurumu.hazirlaniyor => UygulamaRenkleri.hazirlaniyorRenk,
        SiparisDurumu.yolda => UygulamaRenkleri.yoldaRenk,
        SiparisDurumu.teslimEdildi => UygulamaRenkleri.teslimEdildiRenk,
        SiparisDurumu.iptal => UygulamaRenkleri.iptalRenk,
      };

  static List<SiparisDurumu> get siparisAsamalari => const [
        SiparisDurumu.hazirlaniyor,
        SiparisDurumu.yolda,
        SiparisDurumu.teslimEdildi,
        SiparisDurumu.iptal,
      ];

  static SiparisDurumu fromName(String? value) {
    return SiparisDurumu.values.firstWhere(
      (durum) => durum.name == value,
      orElse: () => SiparisDurumu.hazirlaniyor,
    );
  }
}

