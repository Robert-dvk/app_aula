import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/services/pets_service.dart';
import 'package:app_aula/providers/user_provider.dart';

class AddPetModal extends StatefulWidget {
  final int userId;
  final Function(String, String, String, double, String, double, String?, int)
      addPet;
  final Function loadPets;

  const AddPetModal({
    required this.userId,
    required this.addPet,
    required this.loadPets,
    Key? key,
  }) : super(key: key);

  @override
  _AddPetModalState createState() => _AddPetModalState();
}

class _AddPetModalState extends State<AddPetModal> {
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  File? _pickedImage;
  String? _selectedSex;
  String? _selectedSize;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
    }
  }

  void _submitData() async {
    if (_pickedImage == null) {
      return;
    }
    String? image = await PetsService().getStringImage(_pickedImage);

    final enteredName = _nameController.text;
    final enteredBirthDate = _birthDateController.text;
    final enteredWeight = double.parse(_weightController.text);
    final enteredHeight = double.parse(_heightController.text);

    if (enteredName.isEmpty ||
        enteredBirthDate.isEmpty ||
        _selectedSex == null ||
        enteredWeight <= 0 ||
        _selectedSize == null ||
        enteredHeight <= 0) {
      return;
    }

    try {
      final petsService = PetsService();
      final token = Provider.of<UserProvider>(context, listen: false).token;

      final petData = {
        'nome': enteredName,
        'datanasc': enteredBirthDate,
        'sexo': _selectedSex!.substring(0, 1).toLowerCase(),
        'peso': enteredWeight.toString(),
        'porte': _selectedSize!,
        'altura': enteredHeight.toString(),
        'idusuario': widget.userId.toString(),
      };

      await petsService.savePet(petData, token, image!);
      widget.addPet(
        enteredName,
        enteredBirthDate,
        _selectedSex!,
        enteredWeight,
        _selectedSize!,
        enteredHeight,
        _pickedImage!.path,
        widget.userId,
      );
      widget.loadPets();
    } catch (e) {
      print('Error saving pet: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Nome'),
                controller: _nameController,
              ),
              TextField(
                decoration:
                    const InputDecoration(labelText: 'Data de Nascimento'),
                controller: _birthDateController,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Sexo'),
                value: _selectedSex,
                items: ['Macho', 'Fêmea'].map((sexo) {
                  return DropdownMenuItem(
                    value: sexo,
                    child: Text(sexo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSex = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Peso'),
                controller: _weightController,
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Porte'),
                value: _selectedSize,
                items: ['Pequeno', 'Médio', 'Grande'].map((porte) {
                  return DropdownMenuItem(
                    value: porte,
                    child: Text(porte),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSize = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Altura'),
                controller: _heightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _pickedImage != null
                        ? Image.file(_pickedImage!, fit: BoxFit.cover)
                        : const Text('Nenhuma imagem selecionada'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Adicionar Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
