import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:winepool_final/utils/download_service_mobile.dart' as mobile_download_service;

import '../../../services/data_import_service.dart';

class ImportDataScreen extends ConsumerStatefulWidget {
  const ImportDataScreen({super.key});

  @override
  ConsumerState<ImportDataScreen> createState() => _ImportDataScreenState();
}

class _ImportDataScreenState extends ConsumerState<ImportDataScreen> {
  late final DataImportService _dataImportService;
  
  // Состояния для отслеживания процесса импорта
  bool _isImportingWineries = false;
 bool _isImportingWines = false;
 bool _isImportingGrapeVarieties = false;
 bool _isImportingGrapeVarietiesFromAsset = false; // Новое состояние для импорта из встроенного файла
  
  // Сообщения о статусе
  String? _wineryImportStatus;
  String? _wineImportStatus;
  String? _grapeVarietyImportStatus;
  String? _grapeVarietyAssetImportStatus; // Новый статус для импорта из встроенного файла
  
  // Имена выбранных файлов
  String? _selectedWineriesFile;
  String? _selectedWinesFile;
 String? _selectedGrapeVarietiesFile;
  
  // Прогресс импорта
  double _wineryProgress = 0.0;
  double _wineProgress = 0.0;
  double _grapeVarietyProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _dataImportService = ref.read(dataImportServiceProvider);
  }

  // Метод для скачивания шаблона CSV
 Future<void> _downloadTemplate(String assetPath, String fileName) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      final filePath = await mobile_download_service.downloadFile(bytes, fileName);
      
      if (filePath != null) {
        // Отображаем уведомление с информацией о пути к файлу
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Файл '$fileName' сохранен в $filePath"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Ошибка при скачивании файла
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при сохранении файла: не удалось получить путь'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on UnsupportedError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Загрузка файлов не поддерживается на этой платформе.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при скачивании шаблона: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
 }
 
  // Метод для выбора файла виноделен
  Future<void> _selectWineriesFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      dialogTitle: 'Выберите CSV-файл с винодельнями',
    );

    if (result != null) {
      setState(() {
        _selectedWineriesFile = result.files.single.name;
      });
    }
  }

 // Метод для выбора файла вин
  Future<void> _selectWinesFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      dialogTitle: 'Выберите CSV-файл с винами',
    );

    if (result != null) {
      setState(() {
        _selectedWinesFile = result.files.single.name;
      });
    }
  }

 // Метод для выбора файла сортов винограда
  Future<void> _selectGrapeVarietiesFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      dialogTitle: 'Выберите CSV-файл с сортами винограда',
    );

    if (result != null) {
      setState(() {
        _selectedGrapeVarietiesFile = result.files.single.name;
      });
    }
 }
 
 // Метод для импорта виноделен
  Future<void> _importWineries() async {
    if (_selectedWineriesFile == null) return;

    setState(() {
      _isImportingWineries = true;
      _wineryImportStatus = null;
      _wineryProgress = 0.0;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withReadStream: true,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileStream = file.openRead();
        final progressNotifier = ValueNotifier<double>(0.0);
        
        // Слушаем изменения прогресса
        progressNotifier.addListener(() {
          setState(() {
            _wineryProgress = progressNotifier.value;
          });
        });

        final importResult = await _dataImportService.importWineries(
          fileStream,
          progressNotifier,
          ref,
        );
        
        setState(() {
          _wineryImportStatus = _formatImportResult(importResult);
        });
      } else {
        setState(() {
          _wineryImportStatus = 'Файл не выбран или недоступен';
        });
      }
    } catch (e) {
      setState(() {
        _wineryImportStatus = 'Ошибка: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isImportingWineries = false;
        _wineryProgress = 0.0;
      });
    }
  }

 // Метод для импорта вин
  Future<void> _importWines() async {
    if (_selectedWinesFile == null) return;

    setState(() {
      _isImportingWines = true;
      _wineImportStatus = null;
      _wineProgress = 0.0;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withReadStream: true,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileStream = file.openRead();
        final progressNotifier = ValueNotifier<double>(0.0);
        
        // Слушаем изменения прогресса
        progressNotifier.addListener(() {
          setState(() {
            _wineProgress = progressNotifier.value;
          });
        });

        final importResult = await _dataImportService.importWines(
          fileStream,
          progressNotifier,
          ref,
        );
        
        setState(() {
          _wineImportStatus = _formatImportResult(importResult);
        });
      } else {
        setState(() {
          _wineImportStatus = 'Файл не выбран или недоступен';
        });
      }
    } catch (e) {
      setState(() {
        _wineImportStatus = 'Ошибка: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isImportingWines = false;
        _wineProgress = 0.0;
      });
    }
  }

 // Метод для импорта сортов винограда
  Future<void> _importGrapeVarieties() async {
    if (_selectedGrapeVarietiesFile == null) return;

    setState(() {
      _isImportingGrapeVarieties = true;
      _grapeVarietyImportStatus = null;
      _grapeVarietyProgress = 0.0;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withReadStream: true,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileStream = file.openRead();
        final progressNotifier = ValueNotifier<double>(0.0);
        
        // Слушаем изменения прогресса
        progressNotifier.addListener(() {
          setState(() {
            _grapeVarietyProgress = progressNotifier.value;
          });
        });

        final importResult = await _dataImportService.importGrapeVarieties(
          fileStream,
          progressNotifier,
          ref,
        );
        
        setState(() {
          _grapeVarietyImportStatus = _formatImportResult(importResult);
        });
      } else {
        setState(() {
          _grapeVarietyImportStatus = 'Файл не выбран или недоступен';
        });
      }
    } catch (e) {
      setState(() {
        _grapeVarietyImportStatus = 'Ошибка: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isImportingGrapeVarieties = false;
        _grapeVarietyProgress = 0.0;
      });
    }
  }

 // Новый метод для импорта сортов винограда из встроенного CSV-файла
 Future<void> _importGrapeVarietiesFromAsset() async {
    setState(() {
      _isImportingGrapeVarietiesFromAsset = true;
      _grapeVarietyAssetImportStatus = null;
    });

    try {
      final importResult = await _dataImportService.importGrapeVarietiesFromAsset();
      
      setState(() {
        _grapeVarietyAssetImportStatus = _formatImportResult(importResult);
      });
    } catch (e) {
      // Обработка ошибок, включая PostgrestException
      setState(() {
        _grapeVarietyAssetImportStatus = 'Ошибка импорта: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isImportingGrapeVarietiesFromAsset = false;
      });
    }
 }
 
 // Форматирование результата импорта для отображения
  String _formatImportResult(ImportResult result) {
    final buffer = StringBuffer();
    buffer.writeln('Всего строк в файле: ${result.totalRows}');
    buffer.writeln('Успешно обработано: ${result.successCount}');
    buffer.writeln('Строк с ошибками: ${result.errorCount}');
    
    if (result.hasErrors) {
      buffer.writeln('\nСписок ошибок:');
      for (final error in result.errorDetails) {
        buffer.writeln('• $error');
      }
    }
    
    return buffer.toString();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Импорт данных'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Импорт данных',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Карточка импорта виноделен
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Импорт Виноделен',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.blue),
                            tooltip: 'Скачать шаблон CSV',
                            onPressed: () => _downloadTemplate(
                              'assets/csv_templates/wineries_template.csv',
                              'wineries_template.csv',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectWineriesFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Выбрать CSV-файл'),
                      ),
                      if (_selectedWineriesFile != null) ...[
                        const SizedBox(height: 8),
                        Text('Выбран файл: $_selectedWineriesFile'),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectedWineriesFile != null && !_isImportingWineries 
                            ? _importWineries 
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: _isImportingWineries
                            ? const CircularProgressIndicator()
                            : const Text('Загрузить'),
                      ),
                      if (_isImportingWineries) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: _wineryProgress),
                        const SizedBox(height: 4),
                        Text('Прогресс: ${( _wineryProgress * 1 ).round()}%'),
                      ],
                      if (_wineryImportStatus != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _wineryImportStatus!.contains('Строк с ошибками: 0')
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _wineryImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          child: SelectableText(
                            _wineryImportStatus!,
                            style: TextStyle(
                              color: _wineryImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green[800]
                                  : Colors.red[800],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Карточка импорта вин
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Импорт Вин',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.green),
                            tooltip: 'Скачать шаблон CSV',
                            onPressed: () => _downloadTemplate(
                              'assets/csv_templates/wines_template.csv',
                              'wines_template.csv',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectWinesFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Выбрать CSV-файл'),
                      ),
                      if (_selectedWinesFile != null) ...[
                        const SizedBox(height: 8),
                        Text('Выбран файл: $_selectedWinesFile'),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectedWinesFile != null && !_isImportingWines 
                            ? _importWines 
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: _isImportingWines
                            ? const CircularProgressIndicator()
                            : const Text('Загрузить'),
                      ),
                      if (_isImportingWines) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: _wineProgress),
                        const SizedBox(height: 4),
                        Text('Прогресс: ${( _wineProgress * 100 ).round()}%'),
                      ],
                      if (_wineImportStatus != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _wineImportStatus!.contains('Строк с ошибками: 0')
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _wineImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          child: SelectableText(
                            _wineImportStatus!,
                            style: TextStyle(
                              color: _wineImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green[800]
                                  : Colors.red[800],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Карточка импорта сортов винограда
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Импорт Сортов Винограда',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.download, color: Colors.orange),
                            tooltip: 'Скачать шаблон CSV',
                            onPressed: () => _downloadTemplate(
                              'assets/csv_templates/grape_varieties_template.csv',
                              'grape_varieties_template.csv',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectGrapeVarietiesFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Выбрать CSV-файл'),
                      ),
                      if (_selectedGrapeVarietiesFile != null) ...[
                        const SizedBox(height: 8),
                        Text('Выбран файл: $_selectedGrapeVarietiesFile'),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectedGrapeVarietiesFile != null && !_isImportingGrapeVarieties 
                            ? _importGrapeVarieties 
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: _isImportingGrapeVarieties
                            ? const CircularProgressIndicator()
                            : const Text('Загрузить'),
                      ),
                      if (_isImportingGrapeVarieties) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: _grapeVarietyProgress),
                        const SizedBox(height: 4),
                        Text('Прогресс: ${( _grapeVarietyProgress * 100 ).round()}%'),
                      ],
                      if (_grapeVarietyImportStatus != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _grapeVarietyImportStatus!.contains('Строк с ошибками: 0')
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _grapeVarietyImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          child: SelectableText(
                            _grapeVarietyImportStatus!,
                            style: TextStyle(
                              color: _grapeVarietyImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green[800]
                                  : Colors.red[800],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Карточка импорта сортов винограда из встроенного файла
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Импорт Сортов Винограда из шаблона',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Импорт всех доступных сортов винограда из встроенного шаблона',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: !_isImportingGrapeVarietiesFromAsset ? _importGrapeVarietiesFromAsset : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        child: _isImportingGrapeVarietiesFromAsset
                            ? const CircularProgressIndicator()
                            : const Text('Импортировать все сорта'),
                      ),
                      if (_grapeVarietyAssetImportStatus != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _grapeVarietyAssetImportStatus!.contains('Строк с ошибками: 0')
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _grapeVarietyAssetImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          child: SelectableText(
                            _grapeVarietyAssetImportStatus!,
                            style: TextStyle(
                              color: _grapeVarietyAssetImportStatus!.contains('Строк с ошибками: 0')
                                  ? Colors.green[800]
                                  : Colors.red[800],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}