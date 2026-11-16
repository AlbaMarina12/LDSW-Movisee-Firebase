import 'package:flutter/material.dart';

import '../services/equipo_service.dart';
import '../theme.dart';
import 'pokemon_detail_screen.dart';

/// "Mi equipo": muestra en tiempo real los Pokémon guardados en Firestore.
class EquipoScreen extends StatelessWidget {
  const EquipoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final servicio = EquipoService();

    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      appBar: AppBar(
        title: const Text('Mi equipo',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.rojo,
        foregroundColor: Colors.white,
      ),
      // StreamBuilder: se actualiza solo cuando cambia la base de datos
      body: StreamBuilder<List<MiembroEquipo>>(
        stream: servicio.escucharEquipo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('No se pudo leer la base de datos:\n${snapshot.error}',
                    textAlign: TextAlign.center),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.rojo));
          }

          final equipo = snapshot.data!;
          if (equipo.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.catching_pokemon,
                        size: 72, color: AppColors.rojo),
                    SizedBox(height: 16),
                    Text('Tu equipo está vacío',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      'Abre un Pokémon y toca "Agregar a mi equipo" '
                      'para guardarlo en la base de datos.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${equipo.length} de ${EquipoService.maximo} Pokémon',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.azul),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: equipo.length,
                  itemBuilder: (context, i) {
                    final m = equipo[i];
                    final color = m.tipos.isNotEmpty
                        ? colorDeTipo(m.tipos.first)
                        : AppColors.rojo;
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: color, width: 2),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: color.withOpacity(0.2),
                          child: Image.network(m.imagenUrl,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.catching_pokemon)),
                        ),
                        title: Text(
                          '#${m.id} ${m.nombre[0].toUpperCase()}${m.nombre.substring(1)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(m.tipos
                            .map((t) => nombresTipo[t] ?? t)
                            .join(' · ')),
                        trailing: IconButton(
                          tooltip: 'Quitar del equipo',
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.rojo),
                          onPressed: () async {
                            await servicio.quitar(m.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${m.nombre} salió de tu equipo')),
                              );
                            }
                          },
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PokemonDetailScreen(nombreONumero: m.nombre),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
