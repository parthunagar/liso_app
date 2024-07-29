part of 'borrow_bloc.dart';

enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Borrow>[],
    this.page = 1,
    this.hasReachedMax = false,
  });

  final PostStatus status;
  final List<Borrow> posts;
  final int page;
  final bool hasReachedMax;

  PostState copyWith({
    PostStatus? status,
    List<Borrow>? posts,
    int? page,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, page: $page, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, page, hasReachedMax];
}
