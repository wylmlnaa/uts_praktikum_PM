import 'package:flutter/material.dart';
import '../../../models/cargo_models.dart';

class RekapResiTab extends StatelessWidget {
  final List<ResiModel> resiList;

  const RekapResiTab({
    super.key,
    required this.resiList,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rekapitulasi Data Surat Jalan (Resi)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: resiList.isEmpty
                ? const Center(
                    child: Text("Belum ada data resi."),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: screenWidth - 24, // Full width to match screen padding
                        ),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(Colors.blue[100]),
                          columns: const [
                            DataColumn(label: Text("No. Resi", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Armada", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Tonase", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Jadwal", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Total Biaya", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: resiList.map((resi) {
                            return DataRow(
                              cells: [
                                DataCell(Text(resi.noResi, style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(Text(resi.namaArmada)),
                                DataCell(Text(resi.kategoriMuatan)),
                                DataCell(Text("${resi.tonase.toStringAsFixed(1)} Ton")),
                                DataCell(Text("${resi.tanggalPenjemputan} ${resi.jamKeberangkatan}")),
                                DataCell(Text("Rp ${_formatRupiah(resi.totalBiaya)}")),
                                DataCell(
                                  Text(
                                    resi.status,
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(double val) {
    return val.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
