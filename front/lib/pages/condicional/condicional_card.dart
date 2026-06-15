import 'package:flutter/material.dart';
import 'package:front/models/item_condicional.dart';

import '../../app_theme.dart';
import '../../models/condicional.dart';

class CondicionalCard extends StatelessWidget {
  final Condicional condicional;
  final String Function(String?) fmtData;
  final VoidCallback onEdit, onDelete, onDevolver;

  const CondicionalCard({
    super.key,
    required this.condicional,
    required this.fmtData,
    required this.onEdit,
    required this.onDelete,
    required this.onDevolver,
  });

  @override
  Widget build(BuildContext context) {
    final Condicional c = condicional;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: c.devolvido
              ? Colors.green[50]
              : DefaultColors.primary.withOpacity(0.1),
          child: Icon(
            c.devolvido ? Icons.check_circle : Icons.loop,
            color: c.devolvido ? Colors.green : DefaultColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          c.clienteNome,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          c.nomeItem ?? 'Sem descrição',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        trailing: c.devolvido
            ? const Chip(
                label: Text(
                  'Devolvido',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 4),
              )
            : null,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _row(
                  Icons.calendar_today_outlined,
                  'Retirada',
                  fmtData(c.dataRetirada),
                ),
                _row(
                  Icons.event_available_outlined,
                  'Devolução',
                  fmtData(c.dataDevolucao),
                ),
                if (c.observacao?.isNotEmpty == true)
                  _row(Icons.notes, 'Obs', c.observacao!),
                const Divider(height: 16),
                const Text(
                  'Itens:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...c.itens.map(
                  (ItemCondicional it) => Text(
                    '  • ${it.quantidade}x ${it.nomeProduto ?? ''}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (!c.devolvido)
                      OutlinedButton.icon(
                        onPressed: onDevolver,
                        icon: const Icon(Icons.check_circle_outline, size: 16),
                        label: const Text('Devolvido'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 15, color: Colors.grey),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
