import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------
    // SIMPAN FOTO ANDA DI: assets/images/foto_profil.jpg
    // Lalu pastikan sudah didaftarkan di pubspec.yaml
    // -------------------------------------------------------------------
    const String imagePath = 'lib/assets/img/foto_profil.jpg';

    // NAMA MAHASISWA:
    const String namaMahasiswa = 'Wildan Maulana Abdusyahid';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 320,
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                // Layer 1: Gambar dari Asset Lokal
                Positioned.fill(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    // Menampilkan icon default jika gambar tidak ditemukan
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                // Layer 2: Overlay Hitam Transparan di Bagian Bawah
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.65),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Text(
                      'Nama Mahasiswa: $namaMahasiswa',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}