import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnection() async {
  final ConnectivityResult result = await Connectivity().checkConnectivity();
  return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
}
