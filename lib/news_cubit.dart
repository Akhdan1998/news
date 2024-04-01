import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/service.dart';

import 'apireturn.dart';
import 'model.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  Future<void> getNews() async {
    ApiReturnNews<List<News>>? result =
    await NewsServices.getNews();
    if (result?.value != null) {
      emit(NewsLoaded(news: result?.value));
    } else {
      emit(NewsLoadingFailed(result?.message));
    }
  }
}
