import 'package:flutter/material.dart';

class ShowUserDiariesComments extends StatelessWidget {
  const ShowUserDiariesComments({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar para indicar que é um modal
        Container(
          width: 80,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Comentários',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                // Remove o constraints com maxHeight
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize
                        .min, // Importante para não ocupar espaço desnecessário
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 20),
                          SizedBox(width: 8),
                          Expanded(
                            // Adiciona Expanded para o texto do usuário
                            child: Text(
                              'Usuário 1',
                              style: TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow
                                  .ellipsis, // Caso o nome seja muito longo
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In laoreet, purus non dictum ornare, nisl justo consectetur dolor, et congue ante lectus a eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. In laoreet, purus non dictum ornare, nisl justo consectetur dolor, et congue ante lectus a eros.',
                        style: TextStyle(color: Color(0xFF757575)),
                        // Opções para controlar o texto longo:
                        // overflow: TextOverflow.ellipsis, // Corta com "..."
                        // maxLines: 3, // Limita a 3 linhas
                        // softWrap: true, // Permite quebra de linha (padrão)
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Deixe seu comentário',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: 1, // Permite múltiplas linhas para o comentário
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
