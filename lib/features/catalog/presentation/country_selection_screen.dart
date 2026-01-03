import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/catalog/application/countries_provider.dart';
import 'package:winepool_final/features/wines/domain/country.dart';

part 'country_selection_screen.g.dart';

@riverpod
class SelectedCountries extends _$SelectedCountries {
  @override
  List<String> build() {
    return [];
  }
}

class CountrySelectionScreen extends ConsumerStatefulWidget {
  const CountrySelectionScreen({
    super.key,
    this.initialSelectedCountries = const [],
  });

  final List<String> initialSelectedCountries;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends ConsumerState<CountrySelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Инициализируем состояние выбранных стран при первом построении
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedCountriesProvider.notifier).state = widget.initialSelectedCountries;
    });
  }

  @override
  Widget build(BuildContext context) {
    final countriesAsync = ref.watch(countriesListProvider);
    final selectedCountries = ref.watch(selectedCountriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите страны'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(selectedCountriesProvider.notifier).state = [];
            },
            child: const Text('Сбросить'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedCountries);
            },
            child: const Text('Применить'),
          ),
        ],
      ),
      body: countriesAsync.when(
        data: (allCountries) {
          return CountrySelectionBody(
            allCountries: allCountries,
            selectedCountries: selectedCountries,
            ref: ref,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки стран: $error'),
        ),
      ),
    );
  }
}

class CountrySelectionBody extends ConsumerStatefulWidget {
  const CountrySelectionBody({
    super.key,
    required this.allCountries,
    required this.selectedCountries,
    required this.ref,
  });

  final List<Country> allCountries;
  final List<String> selectedCountries;
  final WidgetRef ref;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountrySelectionBodyState();
}

class _CountrySelectionBodyState extends ConsumerState<CountrySelectionBody> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.allCountries;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredCountries = widget.allCountries;
      });
    } else {
      setState(() {
        _filteredCountries = widget.allCountries
            .where((country) => country.name.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Поиск по стране',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredCountries.length,
            itemBuilder: (context, index) {
              final country = _filteredCountries[index];
              final isSelected = widget.selectedCountries.contains(country.code);

              return CheckboxListTile(
                title: Text(country.name),
                value: isSelected,
                onChanged: (bool? value) {
                  final selectedCountries = List<String>.from(widget.selectedCountries);
                  if (value == true) {
                    selectedCountries.add(country.code);
                  } else {
                    selectedCountries.remove(country.code);
                  }
                  widget.ref.read(selectedCountriesProvider.notifier).state = selectedCountries;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}