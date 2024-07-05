import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/models/pet.dart';
import 'package:app_aula/models/servico.dart';
import 'package:app_aula/repositories/pet_repository.dart';
import 'package:app_aula/repositories/servico_repository.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/repositories/servico_agenda_repository.dart';
import 'package:app_aula/repositories/agenda_repository.dart';
import 'package:app_aula/models/agenda.dart';
import 'package:app_aula/models/servicos_agenda.dart';

class AddAgendaModal extends StatefulWidget {
  final Function(String, String, int, int) onAddAgenda;

  AddAgendaModal(this.onAddAgenda);

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadPets();
    await _loadServicos();
  }

  Future<void> _loadPets() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        List<Pet> pets = await PetRepository().readPetsByUser(userId);
        setState(() {
          _pets = pets;
        });
      } else {
        print('User ID is null');
      }
    } catch (e) {
      print('Erro ao carregar pets: $e');
    }
  }

  Future<void> _loadServicos() async {
    try {
      List<Servico> servicos = await ServicoRepository().readServicos();
      setState(() {
        _servicos = servicos;
      });
    } catch (e) {
      print('Erro ao carregar serviços: $e');
    }
  }

  void _submitData() async {
    final enteredData = _dataController.text;
    final enteredHora = _horaController.text;

    if (enteredData.isEmpty || enteredHora.isEmpty || _selectedPet == null || _selectedServico == null) {
      return;
    }

    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        widget.onAddAgenda(
          enteredData,
          enteredHora,
          _selectedPet!.id!,
          _selectedServico!.id!,
        );


      } else {
        print('User ID is null');
      }
    } catch (e) {
      print('Erro ao adicionar agenda: $e');
    }
  }

  Future<int> _createAgenda(int userId, String data, String hora, int idPet, int idServico) async {
    try {
      Agenda newAgenda = Agenda(
        data: data,
        hora: hora,
        idusuario: userId,
        idpet: idPet,
      );

      final AgendaRepository agendaRepo = AgendaRepository();
      int agendaId = await agendaRepo.createAgenda(newAgenda);

      ServicoAgendaRepository servicoAgendaRepo = ServicoAgendaRepository();
      await servicoAgendaRepo.createServicoAgenda(ServicoAgenda(idagenda: agendaId, idservico: idServico));

      return agendaId;
    } catch (e) {
      throw Exception('Erro ao criar agenda: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _dataController,
            decoration: InputDecoration(labelText: 'Data'),
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _horaController,
            decoration: InputDecoration(labelText: 'Hora'),
            onSubmitted: (_) => _submitData(),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            child: DropdownButton<Pet>(
              hint: Text('Selecione um Pet'),
              value: _selectedPet,
              isExpanded: true,
              onChanged: (Pet? newValue) {
                setState(() {
                  _selectedPet = newValue;
                });
              },
              items: _pets.map<DropdownMenuItem<Pet>>((Pet pet) {
                return DropdownMenuItem<Pet>(
                  value: pet,
                  child: Text(pet.nome),
                );
              }).toList(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            child: DropdownButton<Servico>(
              hint: Text('Selecione um Serviço'),
              value: _selectedServico,
              isExpanded: true,
              onChanged: (Servico? newValue) {
                setState(() {
                  _selectedServico = newValue;
                });
              },
              items: _servicos.map<DropdownMenuItem<Servico>>((Servico servico) {
                return DropdownMenuItem<Servico>(
                  value: servico,
                  child: Text(servico.nome),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitData,
            child: Text('Adicionar Agendamento'),
          ),
        ],
      ),
    );
  }
}
