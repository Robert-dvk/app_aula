import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/repositories/agenda_repository.dart';
import 'package:app_aula/repositories/servico_agenda_repository.dart';
import 'package:app_aula/repositories/pet_repository.dart';
import 'package:app_aula/models/agenda.dart';
import 'package:app_aula/models/servicos_agenda.dart';
import 'package:app_aula/models/pet.dart';
import 'package:app_aula/screens/add_agenda_modal.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<Agenda> _agendas = [];
  Pet? _pet;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadAgendas();
    await _loadPet();
  }

  Future<void> _loadAgendas() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        List<Agenda> agendas = await AgendaRepository().readAgendasByUser(userId);
        setState(() {
          _agendas = agendas;
        });
      } else {
        print('User ID is null');
      }
    } catch (e) {
      print('Erro ao carregar agendas: $e');
    }
  }

  Future<void> _loadPet() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        List<Pet> pets = await PetRepository().readPetsByUser(userId);
        if (pets.isNotEmpty) {
          setState(() {
            _pet = pets.first;
          });
        }
      } else {
        print('User ID is null');
      }
    } catch (e) {
      print('Erro ao carregar pet: $e');
    }
  }

  void _openAddAgendaModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: AddAgendaModal(_addAgenda),
        );
      },
    );
  }

  Future<void> _addAgenda(String data, String hora, int idPet, int idServico) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
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

        await _loadAgendas();
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Erro ao adicionar agenda: $e');
    }
  }

  void _confirmDeleteAgenda(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja excluir esta agenda?'),
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
                _deleteAgenda(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAgenda(int id) async {
    try {
      await AgendaRepository().deleteAgenda(id);
      setState(() {
        _agendas.removeWhere((agenda) => agenda.id == id);
      });
    } catch (e) {
      print('Erro ao excluir agenda: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
      ),
      body: ListView.builder(
        itemCount: _agendas.length,
        itemBuilder: (ctx, index) {
          final agenda = _agendas[index];
          final petName = _pet?.nome ?? 'Pet desconhecido';
          return ListTile(
            title: Text('${agenda.data} ${agenda.hora}'),
            subtitle: Text('Pet: $petName'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _confirmDeleteAgenda(agenda.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddAgendaModal(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
