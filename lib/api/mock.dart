import 'dart:math';

///A mock class for an ApiService. We do not want multiple instances of the ApiService as we should
///be using the same instance throughout the app.
final class MockApiService {

  ///Returns an instance of the [MockApiService]. If an instance has already been created, 
  ///an exception will be thrown.
  factory MockApiService() {
    if (_instance != null) {
      throw Exception('MockApiService has already been initialized');
    }

    return _instance ??= MockApiService._();
  }

  MockApiService._();

  final Random _random = Random();
  late final int _instanceId = _random.nextInt(1000);
  Map<int, MockResult> _results = {};

  ///Returns a list of 1000 [MockResult].
  Future<List<MockResult>> fetchResults() async {
    print('Fetching results $_instanceId');
    await Future.delayed(Duration(milliseconds: _random.nextInt(1000)));
    final results = List.generate(1000, (index) => _getMockResult(index)).toList();
    _results = results.fold(<int, MockResult>{}, (map, result) => map..[result.id] = result);
    return results;
  }

  ///Mocks a patch request to update a result. Will randomly fail.
  Future<MockResult> patchResult(int id, {String? name, String? description}) async {
    print('Patching result $id');
    final failed = Random().nextDouble() < 0.25;
    await Future.delayed(Duration(milliseconds: _random.nextInt(1000)));
    if (failed) {
      print('Failed to patch result $id');
      throw Exception('Failed to patch result $id');
    }

    final workingResult = _results[id];
    if (workingResult == null) {
      throw Exception('Result $id not found');
    }

    print('Successfully patched result $id');
    final patchedResult = MockResult._((
      id: id,
      name: name ?? workingResult.name,
      description: description ?? workingResult.description,
    ));
    
    _results[id] = patchedResult;
    return patchedResult;
  }

  MockResult _getMockResult(int id) {
    return MockResult._((
      id: id,
      name: 'i$_instanceId - $id',
      description: '',
    ));
  }

  static MockApiService? _instance;
}

extension type MockResult._(({int id, String name, String description}) _) {
  int get id => _.id;
  String get name => _.name;
  String get description => _.description;
}