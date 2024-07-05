import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPetModal extends StatefulWidget {
  final Map<String, dynamic> petData;
  final Function(int, String, String, String, double, String, double, String?, int) editPet;

  EditPetModal(this.petData, this.editPet);

  @override
  _EditPetModalState createState() => _EditPetModalState();
}

class _EditPetModalState extends State<EditPetModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  File? _pickedImage;
  String? _selectedSex;
  String? _selectedSize;

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
    _pickedImage = widget.petData['imagem'] != null ? File(widget.petData['imagem']) : null;
    _selectedSex = widget.petData['sexo'];
    _selectedSize = widget.petData['porte']; // Mantido diretamente como o valor do porte
  }

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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final id = widget.petData['id'] as int;
      final enteredName = _nameController.text;
      final enteredBirthDate = _birthDateController.text;
      final enteredWeight = double.parse(_weightController.text);
      final enteredHeight = double.parse(_heightController.text);

      widget.editPet(
        id,
        enteredName,
        enteredBirthDate,
        _selectedSex!,
        enteredWeight,
        _selectedSize!,
        enteredHeight,
        _pickedImage?.path,
        widget.petData['idusuario'] as int,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nome'),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nameController.text = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  controller: _birthDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Data de Nascimento é obrigatória';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _birthDateController.text = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Sexo'),
                  value: _selectedSex,
                  items: ['Macho', 'Fêmea'].map((sex) {
                    return DropdownMenuItem(
                      value: sex,
                      child: Text(sex),
                    );
                  }).toList(),
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
                  onSaved: (value) {
                    _selectedSex = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Peso'),
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Peso é obrigatório';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _weightController.text = value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Porte'),
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
                  onSaved: (value) {
                    _selectedSize = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Altura'),
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura é obrigatória';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _heightController.text = value!;
                  },
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
                  child: Text('Salvar'),
                  onPressed: _submitData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
