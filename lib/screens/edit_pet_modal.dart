import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_aula/services/pets_service.dart';

class EditPetModal extends StatefulWidget {
  final Map<String, dynamic> petData;
  final String token;
  final Function onPetUpdated;

  const EditPetModal({
    required this.petData,
    required this.token,
    required this.onPetUpdated,
    Key? key,
  }) : super(key: key);

  @override
  _EditPetModalState createState() => _EditPetModalState();
}

class _EditPetModalState extends State<EditPetModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _pickedImage;
  String? _selectedSex;
  String? _selectedSize;
  final PetsService _petsService = PetsService();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _nameController.text = widget.petData['nome'];
    _birthDateController.text = widget.petData['datanasc'];
    _weightController.text = widget.petData['peso'].toString();
    _heightController.text = widget.petData['altura'].toString();
    _pickedImage = widget.petData['imagem'] as String?;
    _selectedSex = widget.petData['sexo'];
    _selectedSize = widget.petData['porte'];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = pickedImageFile.path;
      });
    }
  }

  Future<String?> _getStringImage(File? file) async {
    if (file == null) return null;
    return _petsService.getStringImage(file);
  }

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final id = widget.petData['id'] as int;
      final enteredName = _nameController.text;
      final enteredBirthDate = _birthDateController.text;
      final enteredWeight = double.parse(_weightController.text);
      final enteredHeight = double.parse(_heightController.text);
      final imageFile = _pickedImage != null
          ? await _getStringImage(File(_pickedImage!))
          : '';

      final petData = {
        'id': id,
        'nome': enteredName,
        'datanasc': enteredBirthDate,
        'sexo': _selectedSex,
        'peso': enteredWeight,
        'porte': _selectedSize,
        'altura': enteredHeight,
        'idusuario': widget.petData['idusuario'],
        'imagem': imageFile,
      };

      try {
        await _petsService.editPet(petData, widget.token, imageFile ?? '');
        widget.onPetUpdated();
      } catch (e) {
        // Handle error
        print('Error updating pet: $e');
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('Falha ao atualizar o pet.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome'),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Data de Nascimento'),
                  controller: _birthDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Data de Nascimento é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Sexo'),
                  value: _selectedSex,
                  items: const [
                    DropdownMenuItem(value: 'm', child: Text('Macho')),
                    DropdownMenuItem(value: 'f', child: Text('Fêmea')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSex = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione o Sexo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Peso'),
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Peso é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Porte'),
                  value: _selectedSize,
                  items: ['Pequeno', 'Médio', 'Grande'].map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione o Porte';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Altura'),
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _pickedImage != null
                          ? _pickedImage!.startsWith('http')
                              ? Image.network(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                  height: 400,
                                )
                              : Image.file(
                                  File(_pickedImage!),
                                  fit: BoxFit.cover,
                                  height: 400,
                                )
                          : const SizedBox(
                              height: 30,
                              child: Center(
                                child: Text('Nenhuma imagem selecionada'),
                              ),
                            ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Salvar Alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
