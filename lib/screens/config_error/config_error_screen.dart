import 'package:flutter/material.dart';

/// Layar yang ditampilkan ketika Firebase belum dikonfigurasi.
class ConfigErrorScreen extends StatelessWidget {
  const ConfigErrorScreen({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('MyAttend')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Firebase belum dikonfigurasi',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ikuti langkah berikut untuk menghubungkan aplikasi ke proyek Firebase Anda:',
              ),
              const SizedBox(height: 16),
              const _StepItem(
                number: '1',
                text: 'Pasang Firebase CLI di komputer Anda.',
              ),
              const _StepItem(number: '2', text: 'Jalankan: firebase login'),
              const _StepItem(
                number: '3',
                text: 'Jalankan: dart pub global activate flutterfire_cli',
              ),
              const _StepItem(
                number: '4',
                text:
                    'Jalankan: flutterfire configure --project=ID_PROJECT_ANDA',
              ),
              const _StepItem(number: '5', text: 'Jalankan ulang aplikasi.'),
              const SizedBox(height: 24),
              Text(
                'Detail galat: $error',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: SelectableText(text)),
        ],
      ),
    );
  }
}
