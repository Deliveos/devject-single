abstract class IProvider<T> {
  Future<int> add(T t) async => throw UnimplementedError();
  Future<List<T>> get() async => throw UnimplementedError();
  Future<T> getOne(int id) async => throw UnimplementedError();
  Future<int> update(T t) async => throw UnimplementedError();
  Future<int> remove(int id) async => throw UnimplementedError();
}