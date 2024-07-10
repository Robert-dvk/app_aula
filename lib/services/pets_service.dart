import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'abstract_service.dart';

class PetsService extends AbstractService {
  Future<List<Map<String, dynamic>>> getMyPets(int userId, String token) async {
    final url = Uri.parse('$apiRest/pets/meus-pets');

    headers['Authorization'] = 'Bearer $token';

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('data') && data['data'] is List) {
        List<dynamic> petsList = data['data'];
        List<Map<String, dynamic>> pets =
            petsList.map((item) => item as Map<String, dynamic>).toList();
        return pets;
      } else {
        throw Exception('Formato de resposta inválido');
      }
    } else {
      throw Exception('Failed to load pets');
    }
  }

  Future<String?> getStringImage(File? file) async {
    if (file == null) return null;
    return base64Encode(file.readAsBytesSync());
  }

  Future<Map<String, dynamic>> savePet(
      Map<String, dynamic> petData, String token, String imageFile) async {
    final url = Uri.parse('$apiRest/pets/inserir');

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nome'] = petData['nome'];
    request.fields['datanasc'] = petData['datanasc'];
    request.fields['sexo'] = petData['sexo'];
    request.fields['peso'] = petData['peso'].toString();
    request.fields['porte'] = petData['porte'];
    request.fields['altura'] = petData['altura'].toString();
    request.fields['idusuario'] = petData['idusuario'].toString();
    request.fields['imagem'] = imageFile;

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedData = json.decode(responseData.body);
        return decodedData;
      } else {
        throw Exception('Failed to save pet: ${responseData.body}');
      }
    } catch (e) {
      throw Exception('Error during request: $e');
    }
  }

  Future<Map<String, dynamic>> editPet(
    Map<String, dynamic> petData, String token, String imageFile) async {
    final petId = petData['id'];

    final url = Uri.parse('$apiRest/pets/$petId');

    final request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nome'] = petData['nome'];
    request.fields['datanasc'] = petData['datanasc'];
    request.fields['sexo'] = petData['sexo'];
    request.fields['peso'] = petData['peso'].toString();
    request.fields['porte'] = petData['porte'];
    request.fields['altura'] = petData['altura'].toString();
    request.fields['idusuario'] = petData['idusuario'].toString();
    request.fields['imagem'] = imageFile;

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final decodedData = json.decode(responseData.body);
        return decodedData;
      } else {
        throw Exception('Failed to edit pet: ${responseData.body}');
      }
    } catch (e) {
      throw Exception('Error during request: $e');
    }
  }


  Future<void> deletePet(int petId, String token) async {
    final url = Uri.parse('$apiRest/pets/$petId');

    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        print('Pet deleted successfully');
      } else {
        throw Exception('Failed to delete pet: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during request: $e');
    }
  }
}
