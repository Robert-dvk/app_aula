import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_aula/providers/user_provider.dart';
import 'package:app_aula/services/agenda_service.dart';
import 'package:app_aula/models/agenda.dart';
import 'package:app_aula/screens/add_agenda_modal.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<Agenda> _agendas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadAgendas();
    await _loadPets();
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

  Future<void> _loadPets() async {
    try {
      setState(() {});
    } catch (e) {
      debugPrint('Erro ao carregar pets: $e');
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

  Future<void> _addAgenda(String data, String hora, int userId, int idPet, String token, int idServico) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      final token = Provider.of<UserProvider>(context, listen: false).token;

      Agenda newAgenda = Agenda(
        data: data,
        hora: hora,
        idusuario: userId,
        idpet: idPet,
      );

      await AgendaService()
          .createAgenda(newAgenda, userId, idPet, token, idServico);
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
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final token =
                      Provider.of<UserProvider>(context, listen: false).token;
                  await AgendaService().deleteAgenda(id, token);
                  setState(() {
                    _agendas.removeWhere((agenda) => agenda.id == id);
                  });
                } catch (e) {
                  debugPrint('Erro ao excluir agenda: $e');
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
        title: const Text('Agenda'),
      ),
      body: _agendas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma agenda encontrada.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _agendas.length,
              itemBuilder: (ctx, index) {
                final agenda = _agendas[index];
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      '${agenda.data} ${agenda.hora}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pet: ${agenda.nomepet}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Serviço: ${agenda.serviconome}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Valor: R\$ ${agenda.servicovalor}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: agenda.id != null
                          ? () => _confirmDeleteAgenda(agenda.id!)
                          : null,
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
