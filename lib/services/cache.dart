abstract class Cache<T> {
  Future<T> get(int index);
  void put(int index, T object);
}

// ignore: one_member_abstracts
abstract class Repository<TInstance, TIndex> {
  Future<TInstance> get(TIndex index);
}
