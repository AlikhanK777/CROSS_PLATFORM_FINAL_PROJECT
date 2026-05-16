import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String url;
  final String? imageUrl;
  final String publishedAt;
  final String description;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              final uri = Uri.tryParse(url);
              if (uri != null && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: AppTheme.f1Grey,
                ),
              )
            else
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.f1Red, Color(0xFF8B0000)],
                  ),
                ),
                child: const Center(
                    child: Icon(Icons.sports_motorsports,
                        color: Colors.white, size: 48)),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(publishedAt,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 10),
                  Text(title,
                      style: const TextStyle(
                          color: AppTheme.f1White,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.3)),
                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.f1Grey),
                  const SizedBox(height: 16),
                  Text(description,
                      style: const TextStyle(
                          color: AppTheme.f1White,
                          fontSize: 16,
                          height: 1.6)),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.tryParse(url);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Read Full Article'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
