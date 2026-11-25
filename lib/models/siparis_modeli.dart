import 'package:equatable/equatable.dart';

import 'siparis_durumu.dart';

class SiparisModeli extends Equatable {
  final String id;
  final String kahveAdi;
  final String boyut;
  final double fiyat;
  final int adet;
  final SiparisDurumu durum;
  final DateTime tarih;

  const SiparisModeli({
    required this.id,
    required this.kahveAdi,
    required this.boyut,
    required this.fiyat,
    required this.adet,
    required this.durum,
    required this.tarih,
  });

  double get toplamTutar => fiyat * adet;

  SiparisModeli copyWith({
    String? id,
    String? kahveAdi,
    String? boyut,
    double? fiyat,
    int? adet,
    SiparisDurumu? durum,
    DateTime? tarih,
  }) {
    return SiparisModeli(
      id: id ?? this.id,
      kahveAdi: kahveAdi ?? this.kahveAdi,
      boyut: boyut ?? this.boyut,
      fiyat: fiyat ?? this.fiyat,
      adet: adet ?? this.adet,
      durum: durum ?? this.durum,
      tarih: tarih ?? this.tarih,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kahveAdi': kahveAdi,
      'boyut': boyut,
      'fiyat': fiyat,
      'adet': adet,
      'durum': durum.name,
      'tarih': tarih.toIso8601String(),
    };
  }

  factory SiparisModeli.fromMap(Map<String, dynamic> map) {
    return SiparisModeli(
      id: map['id'] as String,
      kahveAdi: map['kahveAdi'] as String,
      boyut: map['boyut'] as String,
      fiyat: (map['fiyat'] as num).toDouble(),
      adet: (map['adet'] as num).toInt(),
      durum: SiparisDurumu.fromName(map['durum'] as String?),
      tarih: DateTime.parse(map['tarih'] as String),
    );
  }

  @override
  List<Object?> get props => [id, kahveAdi, boyut, fiyat, adet, durum, tarih];
}

