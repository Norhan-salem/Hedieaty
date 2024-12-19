import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadToImgBB(File imageFile) async {
  const String apiKey = '42a6c365d13dce830da76fc7f3f60eac';
  const String uploadUrl = 'https://api.imgbb.com/1/upload';

  try {
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.fields['key'] = apiKey;
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['data']['url'];
    } else {
      print('Failed to upload image: ${response.reasonPhrase}');
      return null;
    }
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
