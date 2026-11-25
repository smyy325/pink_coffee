import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/siparis_bloc.dart';
import 'bloc/siparis_event.dart';
import 'core/constants/uygulama_renkleri.dart';
import 'screens/siparis_takip_ekrani.dart';
import 'services/mock_siparis_servisi.dart';
import 'services/yerel_siparis_deposu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(PinkCoffeeApp(
    servis: MockSiparisServisi(),
    yerelDepo: YerelSiparisDeposu(prefs),
  ));
}

class PinkCoffeeApp extends StatelessWidget {
  final MockSiparisServisi servis;
  final YerelSiparisDeposu yerelDepo;

  const PinkCoffeeApp({super.key, required this.servis, required this.yerelDepo});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SiparisBloc(servis: servis, yerelDepo: yerelDepo)
            ..add(const SiparisleriYukleEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'PinkCoffee',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: UygulamaRenkleri.anaPembe,
            surface: UygulamaRenkleri.arkaPlan,
          ),
          useMaterial3: true,
        ),
        home: const SiparisTakipEkrani(),
      ),
    );
  }
}
