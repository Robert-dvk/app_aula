import 'package:app_aula/services/servicos_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/models/pet.dart';
import 'package:app_aula/models/servico.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/services/pets_service.dart';

class AddAgendaModal extends StatefulWidget {
  final Function(String, String, int, int, String, int) onAddAgenda;

  const AddAgendaModal(this.onAddAgenda, {Key? key}) : super(key: key);

  @override
  _AddAgendaModalState createState() => _AddAgendaModalState();
}

class _AddAgendaModalState extends State<AddAgendaModal> {
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  Pet? _selectedPet;
  Servico? _selectedServico;
  List<Pet> _pets = [];
  List<Servico> _servicos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _loadPets();
      await _loadServicos();
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPets() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    final token = userProvider.token;

    try {
      List<Map<String, dynamic>> pets =
          await PetsService().getMyPets(userId, token);
      List<Pet> mappedPets =
          pets.map((petData) => Pet.fromJson(petData)).toList();
      setState(() {
        _pets = mappedPets;
      });
    } catch (e) {
      debugPrint('Erro ao carregar pets: $e');
    }
  }

  Future<void> _loadServicos() async {
    try {
      List<Servico> servicos = await ServicosService().getServicos();
      setState(() {
        _servicos = servicos;
      });
    } catch (e) {
      debugPrint('Erro ao carregar serviços: $e');
    }
  }

  void _submitData() async {
    final enteredData = _dataController.text;
    final enteredHora = _horaController.text;

    if (enteredData.isEmpty ||
        enteredHora.isEmpty ||
        _selectedPet == null ||
        _selectedServico == null) {
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId;
    final token = userProvider.token;
    final idServico = _selectedServico!.id!;

    try {
      final idagenda = await widget.onAddAgenda(
        enteredData,
        enteredHora,
        userId,
        _selectedPet!.id!,
        token,
        idServico, // Passa o ID do serviço para onAddAgenda
      );

      if (idagenda != null) {
        Navigator.of(context).pop();
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Erro ao adicionar agenda: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Data',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                onSubmitted: (_) => _submitData(),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _horaController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                onSubmitted: (_) => _submitData(),
              ),
              const SizedBox(height: 12.0),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                DropdownButtonFormField<Pet>(
                  hint: const Text('Selecione um Pet'),
                  value: _selectedPet,
                  onChanged: (Pet? newValue) {
                    setState(() {
                      _selectedPet = newValue;
                    });
                  },
                  items: _pets.map((Pet pet) {
                    return DropdownMenuItem<Pet>(
                      value: pet,
                      child: Text(pet.nome),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<Servico>(
                  hint: const Text('Selecione um Serviço'),
                  value: _selectedServico,
                  onChanged: (Servico? newValue) {
                    setState(() {
                      _selectedServico = newValue;
                    });
                  },
                  items: _servicos.map((Servico servico) {
                    return DropdownMenuItem<Servico>(
                      value: servico,
                      child: Text(
                          '${servico.nome} - \$${servico.valor.toStringAsFixed(2)}'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Adicionar Agenda'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
