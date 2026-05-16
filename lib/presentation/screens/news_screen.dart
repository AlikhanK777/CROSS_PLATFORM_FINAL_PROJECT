import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/news/news_bloc.dart';
import '../../data/models/news_model.dart';
import '../../core/theme/app_theme.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NewsView();
  }
}

class _NewsView extends StatelessWidget {
  const _NewsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('F1 News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<NewsBloc>().add(RefreshNews()),
          ),
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.f1Red));
          }
          if (state is NewsLoaded) {
            return RefreshIndicator(
              color: AppTheme.f1Red,
              onRefresh: () async =>
                  context.read<NewsBloc>().add(RefreshNews()),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.articles.length,
                itemBuilder: (context, index) =>
                    _NewsCard(article: state.articles[index]),
              ),
            );
          }
          if (state is NewsError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.grey)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news/detail', extra: {
        'title': article.title,
        'url': article.url,
        'imageUrl': article.imageUrl,
        'publishedAt': article.publishedAt,
        'description': article.description,
      }),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  article.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: AppTheme.f1Grey,
                    child: const Center(
                        child: Icon(Icons.image,
                            color: Colors.grey, size: 40)),
                  ),
                ),
              )
            else
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.f1Red, Color(0xFF8B0000)],
                  ),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Center(
                    child: Icon(Icons.sports_motorsports,
                        color: Colors.white, size: 36)),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.f1Red.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(article.source,
                            style: const TextStyle(
                                color: AppTheme.f1Red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(article.publishedAt),
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(article.title,
                      style: const TextStyle(
                          color: AppTheme.f1White,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.3)),
                  const SizedBox(height: 6),
                  Text(article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text('Read more →',
                        style: TextStyle(
                            color: AppTheme.f1Red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return date;
    }
  }
}