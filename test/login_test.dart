import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Testing Login Functionality', () {
    
    // Test if login is saved
    test('Login is saved locally', () async {
      SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String name = 'Pero';
      prefs.setString('username', name);

      expect(prefs.getString('username'), 'Pero');
    });

    // Test if logout is correct
    test('Logout is updated locally', () async {
      SharedPreferences.setMockInitialValues({'username': 'Pero'});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('username');

      expect(prefs.getString('username'), null);
    });
  });
}