import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/errors/app_failure.dart';
import '../models/siparis_modeli.dart';

class YerelSiparisDeposu {
  static const String _siparislerKey = 'pink_coffee_siparisler';

  final SharedPreferences _prefs;

  YerelSiparisDeposu(this._prefs);

  Future<List<SiparisModeli>> siparisleriOku() async {
    try {
      final hamVeri = _prefs.getString(_siparislerKey);
      if (hamVeri == null || hamVeri.isEmpty) return const [];

      final cozulmus = jsonDecode(hamVeri) as List<dynamic>;
      return cozulmus
          .map((e) => SiparisModeli.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheFailure('Yerel sipariş verileri okunamadı.');
    }
  }

  Future<void> siparisleriKaydet(List<SiparisModeli> siparisler) async {
    try {
      final kodlanmis = jsonEncode(
        siparisler.map((siparis) => siparis.toMap()).toList(),
      );
      final basarili = await _prefs.setString(_siparislerKey, kodlanmis);
      if (!basarili) {
        throw const CacheFailure('Yerel sipariş verileri kaydedilemedi.');
      }
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw const CacheFailure('Yerel sipariş verileri kaydedilemedi.');
    }
  }

  Future<void> temizle() async {
    try {
      await _prefs.remove(_siparislerKey);
    } catch (_) {
      throw const CacheFailure('Yerel önbellek temizlenemedi.');
    }
  }
}

