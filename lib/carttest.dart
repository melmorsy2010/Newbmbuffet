import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> updateJsonFile() async {
  try {
    final String githubToken = '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';
    final String owner = 'melmorsy2010';
    final String repo = 'Retailtribebuffet';
    final String path = 'https://github.com/melmorsy2010/Retailtribebuffet/blob/main/drinkss.json';

    // Replace with the new JSON data you want to write to the file
    final Map<String, dynamic> newData = {'key': 'value'};

    // Encode the new JSON data as a string
    final String jsonString = json.encode(newData);

    // Make a GET request to fetch the current contents of the file
    final currentFileUrl = 'https://api.github.com/repos/$owner/$repo/contents/$path';
    final currentFileResponse = await http.get(Uri.parse(currentFileUrl),
        headers: {'Authorization': 'token $githubToken'});
    final currentFileJson = json.decode(currentFileResponse.body);
    final currentFileSha = currentFileJson['sha'];

    // Make a PUT request to update the JSON file on Github
    final updateFileUrl = 'https://api.github.com/repos/$owner/$repo/contents/$path';
    final updateFileResponse = await http.put(Uri.parse(updateFileUrl),
        headers: {'Authorization': 'token $githubToken'},
        body: json.encode({
          'message': 'Update JSON file',
          'content': base64.encode(utf8.encode(jsonString)),
          'sha': currentFileSha,
        }));
    if (updateFileResponse.statusCode == 200) {
      print('JSON file updated successfully');
    } else {
      print('Failed to update JSON file');
    }
  } catch (e) {
    print('Error: $e');
  }
}
