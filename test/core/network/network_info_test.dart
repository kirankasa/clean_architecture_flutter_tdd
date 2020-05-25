import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo =
        NetworkInfoImpl(dataConnectionChecker: mockDataConnectionChecker);
  });

  group("is connected", () {
    test("should forward the call to DataConnectionChecker.hasConnection", () {
      final tHasConnectionFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) => tHasConnectionFuture);
      final result = networkInfo.isConnected;
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
