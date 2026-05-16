import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String title;
  final String description;
  final String url;
  final String? imageUrl;
  final String publishedAt;
  final String source;

  const NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    required this.source,
  });

  factory NewsArticle.fromNewsData(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? 'No description available.',
      url: json['link'] ?? '',
      imageUrl: json['image_url'],
      publishedAt: json['pubDate'] ?? '',
      source: json['source_id'] ?? 'Unknown',
    );
  }

  factory NewsArticle.fromGNews(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? 'No description available.',
      url: json['url'] ?? '',
      imageUrl: json['image'],
      publishedAt: json['publishedAt'] ?? '',
      source: json['source']?['name'] ?? 'Unknown',
    );
  }

  // Mock fallback articles when no API key
  static List<NewsArticle> get mockArticles => [
        const NewsArticle(
          title: 'Max Verstappen wins the 2024 Formula 1 World Championship',
          description:
              'Red Bull Racing driver Max Verstappen claimed his fourth consecutive world championship title with a dominant performance this season.',
          url: 'https://www.formula1.com',
          imageUrl: null,
          publishedAt: '2024-11-24',
          source: 'Formula 1',
        ),
        const NewsArticle(
          title: 'Ferrari announce major upgrades for next season',
          description:
              'Scuderia Ferrari has revealed plans for a comprehensive upgrade package aimed at closing the gap to Red Bull Racing in the upcoming season.',
          url: 'https://www.formula1.com',
          imageUrl: null,
          publishedAt: '2024-11-20',
          source: 'Formula 1',
        ),
        const NewsArticle(
          title: 'Lewis Hamilton makes shock move to Ferrari',
          description:
              'Seven-time world champion Lewis Hamilton has confirmed he will join Scuderia Ferrari for the 2025 season in one of the biggest moves in F1 history.',
          url: 'https://www.formula1.com',
          imageUrl: null,
          publishedAt: '2024-02-01',
          source: 'Formula 1',
        ),
        const NewsArticle(
          title: '2025 F1 Calendar: 24 races confirmed',
          description:
              'The FIA has confirmed the 2025 Formula 1 World Championship calendar featuring 24 races across five continents.',
          url: 'https://www.formula1.com',
          imageUrl: null,
          publishedAt: '2024-11-15',
          source: 'FIA',
        ),
        const NewsArticle(
          title: 'McLaren claim constructors championship in stunning finale',
          description:
              'McLaren Racing secured the constructors championship at the final race of the season in Abu Dhabi after a nail-biting battle with Ferrari.',
          url: 'https://www.formula1.com',
          imageUrl: null,
          publishedAt: '2024-12-08',
          source: 'Formula 1',
        ),
      ];

  @override
  List<Object?> get props => [title, url, publishedAt];
}
