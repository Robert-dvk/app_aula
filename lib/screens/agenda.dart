import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/services/agenda_service.dart';
import 'package:app_aula/models/agenda.dart';
import 'package:app_aula/models/pet.dart';
import 'package:app_aula/screens/add_agenda_modal.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

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
      final token = Provider.of<UserProvider>(context, listen: false).token;
      List<Map<String, dynamic>> agendas = await AgendaService().getAgendamentos(userId, token);
      setState(() {
        _agendas = agendas.map((agenda) => Agenda.fromJson(agenda)).toList();
      });
    } catch (e) {
      debugPrint('Erro ao carregar agendas: $e');
    }
  }

  Future<void> _loadPet() async {
    try {
      // Implemente a lógica para carregar o pet do usuário, se necessário
    } catch (e) {
      debugPrint('Erro ao carregar pet: $e');
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
      final token = Provider.of<UserProvider>(context, listen: false).token;

      Agenda newAgenda = Agenda(
        data: data,
        hora: hora,
        idusuario: userId,
        idpet: idPet,
      );

      await AgendaService().createAgenda(newAgenda, idServico, token);
      await _loadAgendas();
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Erro ao adicionar agenda: $e');
    }
  }

  void _confirmDeleteAgenda(int id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja excluir esta agenda?'),
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
              onPressed: () {
                //_deleteAgenda(id);
                Navigator.of(context).pop();
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
      backgroundColor: Colors.blue, // Cor de fundo da tela
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: _agendas.isEmpty
          ? Center(
              child: Text(
                'Nenhuma agenda encontrada.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _agendas.length,
              itemBuilder: (ctx, index) {
                final agenda = _agendas[index];
                final petName = _pet?.nome ?? 'Pet desconhecido';
                return Card(
                  elevation: 4, // Elevação para um efeito de card
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      '${agenda.data} ${agenda.hora}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Pet: $petName'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteAgenda(agenda.id!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddAgendaModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
