import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepoInfoTab extends StatelessWidget {
  const DepoInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    const String apiTrackingCode = "https://api.cargoflow.id/v1/tracking/SUBANG-HUB-9988X";
    const String depoLicenseKey = "LIC-CARGOFLOW-SUBANG-2026-GENAP";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil Depo Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Profil Depo Utama Subang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 6),
                  const Text("Alamat: Subang Green City Blok C No.27, Subang"),
                  const SizedBox(height: 4),
                  const Text("Kepala Depo: Wildan Maulana Abdusyahid"),
                  const SizedBox(height: 4),
                  const Text("Telepon: 08569941797"),
                  const SizedBox(height: 4),
                  const Text("Jam Operasional: 08.00 - 17.00 WIB"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // SelectableText API & Lisensi Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kode Tracking API & Lisensi Resmi",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Teks di bawah ini menggunakan SelectableText sehingga dapat disalin:",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  const Text("Endpoint API Tracking:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        const Expanded(
                          child: SelectableText(
                            apiTrackingCode,
                            style: TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: apiTrackingCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Endpoint API berhasil disalin!")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text("Kode Lisensi Depo:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        const Expanded(
                          child: SelectableText(
                            depoLicenseKey,
                            style: TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: depoLicenseKey));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Kode Lisensi berhasil disalin!")),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
