import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/news_model.dart';
import '../../data/repositories/f1_repository.dart';

// Events
abstract class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNews extends NewsEvent {}

class RefreshNews extends NewsEvent {}

// States
abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  NewsLoaded(this.articles);
  @override
  List<Object?> get props => [articles];
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final F1Repository repository;

  NewsBloc({required this.repository}) : super(NewsInitial()) {
    on<LoadNews>(_onLoad);
    on<RefreshNews>(_onRefresh);
  }

  Future<void> _onLoad(LoadNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final articles = await repository.getNews();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError('Failed to load news: $e'));
    }
  }

  Future<void> _onRefresh(RefreshNews event, Emitter<NewsState> emit) async {
    try {
      final articles = await repository.getNews();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError('Failed to refresh news: $e'));
    }
  }
}
