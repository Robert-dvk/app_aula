import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPetModal extends StatefulWidget {
  final int userId;
  final Function addPet;

  AddPetModal(this.userId, this.addPet);

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

  void _submitData() {
    if (_pickedImage == null) {
      return;
    }

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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Nome'),
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Data de Nascimento'),
                controller: _birthDateController,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sexo'),
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
                decoration: InputDecoration(labelText: 'Peso'),
                controller: _weightController,
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Porte'),
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
                decoration: InputDecoration(labelText: 'Altura'),
                controller: _heightController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _pickedImage != null
                        ? Image.file(_pickedImage!, fit: BoxFit.cover)
                        : Text('Nenhuma imagem selecionada'),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              ElevatedButton(
                child: Text('Adicionar Pet'),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
