import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/screens/add_pet_modal.dart';
import 'package:app_aula/screens/edit_pet_modal.dart';
import 'package:app_aula/repositories/pet_repository.dart';
import 'package:app_aula/models/pet.dart';

class PetsScreen extends StatefulWidget {
  @override
  _PetsScreenState createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<Map<String, dynamic>> _pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        List<Pet> pets = await PetRepository().readPetsByUser(userId);
        setState(() {
          _pets = pets.map((pet) => pet.toMap()).toList();
        });
      } else {
        print('User ID is null');
      }
    } catch (e) {
      print('Erro ao carregar pets: $e');
    }
  }

  void _openAddPetModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final userId =
            Provider.of<UserProvider>(context, listen: false).userId;
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: AddPetModal(userId!, _addPet),
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
      print('Erro ao adicionar pet: $e');
    }
  }

  void _openEditPetModal(BuildContext context, Map<String, dynamic> petData) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: EditPetModal(petData, _editPet),
        );
      },
    );
  }

  Future<void> _editPet(int id, String nome, String datanasc, String sexo, double peso,
      String porte, double altura, String? imagem, int idusuario) async {

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
      print('Erro ao atualizar pet: $e');
    }
  }

  void _confirmDeletePet(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja excluir este pet?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _deletePet(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePet(int id) async {
    try {
      await PetRepository().deletePet(id);
      setState(() {
        _pets.removeWhere((pet) => pet['id'] == id);
      });
    } catch (e) {
      print('Erro ao excluir pet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pets'),
      ),
      body: ListView.builder(
        itemCount: _pets.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            leading: _pets[index]['imagem'] != null
                ? Image.file(File(_pets[index]['imagem']))
                : null,
            title: Text(_pets[index]['nome']),
            subtitle: Text(_pets[index]['datanasc']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _confirmDeletePet(_pets[index]['id'] as int),
            ),
            onTap: () =>
                _openEditPetModal(context, _pets[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openAddPetModal(context),
      ),
    );
  }
}
