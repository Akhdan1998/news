import 'package:equatable/equatable.dart';
import 'package:news/model.dart';

abstract class NewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News>? news;

  NewsLoaded({this.news});

  @override
  List<Object> get props => [news!];
}

class NewsLoadingFailed extends NewsState {
  final String? message;

  NewsLoadingFailed(this.message);

  @override
  List<Object> get props => [message!];
}
