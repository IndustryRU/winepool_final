// import 'package:ebs_plugin/ebs_plugin.dart';
import 'package:flutter/material.dart';

class EbsVerificationScreen extends StatelessWidget {
  const EbsVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Верификация через ЕБС'),
      ),
      body: const Center(
        child: Text('Экран верификации через ЕБС'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final result = await EbsPlugin().requestVerification(
      //       infoSystem: 'winepool_final',
      //       adapterUri: 'https://...',
      //       sid: '...',
      //       dboKoUri: 'https://...',
      //       dbkKoPublicUri: 'https://...',
      //     );
      //     print('Verification result: $result');
      //   },
      //   child: const Icon(Icons.check),
      // ),
    );
  }
}