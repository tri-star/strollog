import '../app_location.dart';
import 'package:test/test.dart';

void main() {
  group('UriPathParser', () {
    group('セグメント数', () {
      var tests = {
        'セグメント数一致__値も一致__OK': {
          'pathDefinition': '/a/b/c',
          'uri': Uri.parse('/a/b/c'),
          'expected': true,
        },
        'セグメント数一致__値が不一致__NG': {
          'pathDefinition': '/a/b/c',
          'uri': Uri.parse('/a/b/d'),
          'expected': false,
        },
        'セグメント数不一致__少ない__NG': {
          'pathDefinition': '/a/b/c',
          'uri': Uri.parse('/a/b'),
          'expected': false,
        },
        'セグメント数不一致__多い__NG': {
          'pathDefinition': '/a/b/c',
          'uri': Uri.parse('/a/b/c/d'),
          'expected': false,
        },
      };

      tests.forEach((title, t) {
        test(title, () {
          var pathDefinition = t['pathDefinition'] as String;
          var uri = t['uri'] as Uri;
          var expected = t['expected'] as bool;
          var result = UriPathParser.parse(pathDefinition, uri);

          expect(result.success, expected);
        });
      });
    });

    group('パラメータ', () {
      var tests = {
        'パラメータをキャプチャできること': {
          'pathDefinition': '/a/:name',
          'uri': Uri.parse('/a/bcdef'),
          'expected': {
            'name': 'bcdef',
          },
        },
      };

      tests.forEach((title, t) {
        test(title, () {
          var pathDefinition = t['pathDefinition'] as String;
          var uri = t['uri'] as Uri;
          var expected = t['expected'] as Map<String, String>;
          var result = UriPathParser.parse(pathDefinition, uri);

          var capturedParameters = result.parameters.map(
              (key, parameter) => MapEntry<String, String>(key, parameter));

          expect(capturedParameters, expected);
        });
      });
    });

    group('クエリ文字列', () {
      var tests = {
        'クエリ文字列がない場合は空であること': {
          'pathDefinition': '/a/b',
          'uri': Uri.parse('/a/b'),
          'expected': <String, String>{},
        },
        'クエリ文字列を取得できること': {
          'pathDefinition': '/a/b',
          'uri': Uri.parse('/a/b?c=1&d=2'),
          'expected': {
            'c': '1',
            'd': '2',
          },
        },
      };

      tests.forEach((title, t) {
        test(title, () {
          var pathDefinition = t['pathDefinition'] as String;
          var uri = t['uri'] as Uri;
          var expected = t['expected'] as Map<String, String>;
          var result = UriPathParser.parse(pathDefinition, uri);

          var capturedQueries = result.queries
              .map((key, value) => MapEntry<String, String>(key, value));

          expect(capturedQueries, expected);
        });
      });
    });
  });
}
