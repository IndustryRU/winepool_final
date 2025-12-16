import 'package:ebs_plugin/ebs_plugin.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class EbsVerificationScreen extends StatefulWidget {
  const EbsVerificationScreen({super.key});

  @override
  State<EbsVerificationScreen> createState() => _EbsVerificationScreenState();
}

class _EbsVerificationScreenState extends State<EbsVerificationScreen> {
  bool? _isEbsAppInstalled;
  String _appName = '';
  String _installAppText = '';

  @override
  void initState() {
    super.initState();
    _checkEbsApp();
  }

  Future<void> _checkEbsApp() async {
    final isInstalled = await EbsPlugin().isInstalledApp();
    final appName = await EbsPlugin().getAppName();
    final installText = await EbsPlugin().getRequestInstallAppText();
    setState(() {
      _isEbsAppInstalled = isInstalled;
      _appName = appName ?? 'ЕБС';
      _installAppText = installText ?? 'Установите приложение ЕБС';
    });
  }

  Future<void> _startVerification() async {
    final result = await EbsPlugin().requestVerification(
      infoSystem: 'winepool_final',
      adapterUri: 'https://int.ebs.ru/api/v1',
      sid: '74733471-8261-44d7-9602-02797ff22f27',
      dboKoUri: 'https://winepool.app/ebs-callback',
      dbkKoPublicUri: 'https://winepool.app/ebs-redirect',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isError == true
                ? 'Ошибка: ${result.errorString}'
                : 'Успех! Secret: ${result.secret}',
          ),
        ),
      );
    }
  }

  void _installEbsApp() {
    EbsPlugin().requestInstallApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Верификация через ЕБС'),
      ),
      body: Center(
        child: _isEbsAppInstalled == null
            ? const ShimmerLoadingIndicator()
            : _isEbsAppInstalled!
                ? ElevatedButton(
                    onPressed: _startVerification,
                    child: const Text('Начать верификацию'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_appName, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      Text(_installAppText, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _installEbsApp,
                        child: const Text('Установить'),
                      ),
                    ],
                  ),
      ),
    );
  }
}