import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/repositories/pet_repository.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/screens/add_pet_modal.dart';
import 'package:app_aula/screens/edit_pet_modal.dart';
import 'package:app_aula/services/pets_service.dart';
import 'package:app_aula/models/pet.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  _PetsScreenState createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<Pet> _pets = [];
  final PetsService _petsService = PetsService();

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      final token = Provider.of<UserProvider>(context, listen: false).token;
      List<Map<String, dynamic>> petsData =
          await _petsService.getMyPets(userId, token);

      List<Pet> pets = petsData.map((data) => Pet.fromMap(data)).toList();
      setState(() {
        _pets = pets;
      });
    } catch (e) {
      debugPrint('Erro ao carregar pets: $e');
    }
  }

  void _openAddPetModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final userId = Provider.of<UserProvider>(context, listen: false).userId;
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: AddPetModal(
            userId: userId,
            addPet: _addPet,
          ),
        );
      },
    );
  }

  Future<void> _addPet(String nome, String datanasc, String sexo, double peso,
      String porte, double altura, String? imagem, int idusuario) async {
    try {
      Pet pet = Pet(
        nome: nome,
        datanasc: datanasc,
        sexo: sexo,
        peso: peso,
        porte: porte,
        altura: altura,
        imagem: imagem,
        idusuario: idusuario,
      );

      await PetRepository().createPet(pet);
      await _loadPets();

      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Erro ao adicionar pet: $e');
    }
  }

  void _openEditPetModal(BuildContext context, Pet pet) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: EditPetModal(pet.toMap(), _editPet),
        );
      },
    );
  }

  Future<void> _editPet(
      int id,
      String nome,
      String datanasc,
      String sexo,
      double peso,
      String porte,
      double altura,
      String? imagem,
      int idusuario) async {
    try {
      Pet pet = Pet(
        id: id,
        nome: nome,
        datanasc: datanasc,
        sexo: sexo,
        peso: peso,
        porte: porte,
        altura: altura,
        imagem: imagem,
        idusuario: idusuario,
      );

      await PetRepository().updatePet(pet);
      await _loadPets();

      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Erro ao atualizar pet: $e');
    }
  }

  void _confirmDeletePet(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja excluir este pet?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final token = Provider.of<UserProvider>(context, listen: false).token;
                  await _petsService.deletePet(id, token);
                  setState(() {
                    _pets.removeWhere((pet) => pet.id == id);
                  });
                } catch (e) {
                  debugPrint('Erro ao excluir pet: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Meus pets'),
      ),
      body: _pets.isEmpty
          ? const Center(
              child: Text(
                'Nenhum pet encontrado.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _pets.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: _buildPetImage(_pets[index].imagem),
                    title: Text(
                      _pets[index].nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Data de Nascimento: ${_pets[index].datanasc}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeletePet(_pets[index].id!),
                    ),
                    onTap: () => _openEditPetModal(context, _pets[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openAddPetModal(context),
      ),
    );
  }

  Widget _buildPetImage(String? image) {
    if (image == null || image.isEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(
          Icons.pets,
          color: Colors.grey[700],
        ),
      );
    } else if (image.startsWith('http')) {
      // Altere 'http://10.0.2.2:8000' para 'http://localhost:8000'
      String localImageURL = image.replaceFirst('http://localhost', 'http://10.0.2.2');
      return Image.network(
        localImageURL,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Erro ao carregar imagem: $error');
          return _buildPlaceholder(); // Substituir por um widget de erro personalizado, se necessário
        },
      );
    } else {
      try {
        return Image.memory(
          base64Decode(image),
          fit: BoxFit.cover,
        );
      } catch (e) {
        debugPrint('Erro ao decodificar imagem: $e');
        return _buildPlaceholder();
      }
    }
  }

  Widget _buildPlaceholder() {
    return CircleAvatar(
      backgroundColor: Colors.grey[200],
      child: Icon(
        Icons.pets,
        color: Colors.grey[700],
      ),
    );
  }
}
