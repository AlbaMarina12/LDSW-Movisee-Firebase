import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/pokemon.dart';

/// Pokémon guardado en la colección "equipo" de Cloud Firestore.
class MiembroEquipo {
  final int id;
  final String nombre;
  final String imagenUrl;
  final List<String> tipos;

  const MiembroEquipo({
    required this.id,
    required this.nombre,
    required this.imagenUrl,
    required this.tipos,
  });

  factory MiembroEquipo.fromFirestore(Map<String, dynamic> data) {
    return MiembroEquipo(
      id: (data['id'] as num).toInt(),
      nombre: data['nombre'] as String,
      imagenUrl: data['imagenUrl'] as String? ?? '',
      tipos: List<String>.from(data['tipos'] as List? ?? const []),
    );
  }
}

/// Servicio para agregar, leer y quitar Pokémon de "Mi equipo"
/// en la base de datos Cloud Firestore.
class EquipoService {
  static const int maximo = 6; // Un equipo Pokémon tiene máximo 6 integrantes

  final CollectionReference<Map<String, dynamic>> _coleccion =
      FirebaseFirestore.instance.collection('equipo');

  /// Escucha el equipo en tiempo real (ordenado por número de Pokédex).
  Stream<List<MiembroEquipo>> escucharEquipo() {
    return _coleccion.orderBy('id').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => MiembroEquipo.fromFirestore(doc.data()))
              .toList(),
        );
  }

  /// Revisa si un Pokémon ya está en el equipo.
  Stream<bool> estaEnEquipo(int id) {
    return _coleccion.doc('$id').snapshots().map((doc) => doc.exists);
  }

  /// AGREGA un Pokémon a la base de datos.
  /// Usa el número de Pokédex como id del documento para no repetirlo.
  Future<void> agregar(PokemonDetalle p) async {
    final total = await _coleccion.count().get();
    if ((total.count ?? 0) >= maximo) {
      throw Exception('Tu equipo ya tiene $maximo Pokémon. Quita uno primero.');
    }
    await _coleccion.doc('${p.id}').set({
      'id': p.id,
      'nombre': p.nombre,
      'imagenUrl': p.imagenUrl,
      'tipos': p.tipos,
      'agregadoEn': FieldValue.serverTimestamp(),
    });
  }

  /// Quita un Pokémon del equipo.
  Future<void> quitar(int id) => _coleccion.doc('$id').delete();
}
