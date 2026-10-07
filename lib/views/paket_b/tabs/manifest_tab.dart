import 'package:flutter/material.dart';
import '../../../models/cargo_models.dart';
import '../cargo_booking_screen.dart';

class ManifestTab extends StatefulWidget {
  final Function(ResiModel) onResiCreated;

  const ManifestTab({
    super.key,
    required this.onResiCreated,
  });

  @override
  State<ManifestTab> createState() => _ManifestTabState();
}

class _ManifestTabState extends State<ManifestTab> {
  final List<ArmadaModel> _armadaList = [
    ArmadaModel(
      id: 'ARM-001',
      nama: 'Colt Diesel Light Freight',
      tipe: 'Truk Engkel 4 Roda',
      kapasitasTon: 4.5,
      status: 'Tersedia',
      badgeText: 'Kapasitas 4.5 Ton',
      badgeColorHex: 0xFF2196F3, // Blue
      iconType: 'colt_diesel',
      tarifPerTon: 150000,
    ),
    ArmadaModel(
      id: 'ARM-002',
      nama: 'Fuso Heavy Transporter',
      tipe: 'Truk CDD 6 Roda',
      kapasitasTon: 10.0,
      status: 'Tersedia',
      badgeText: 'Kapasitas 10.0 Ton',
      badgeColorHex: 0xFF2196F3, // Blue
      iconType: 'fuso',
      tarifPerTon: 220000,
    ),
    ArmadaModel(
      id: 'ARM-003',
      nama: 'Tronton Wingbox Express',
      tipe: 'Tronton 10 Roda Box',
      kapasitasTon: 20.0,
      status: 'Tersedia',
      badgeText: 'Kapasitas 20.0 Ton',
      badgeColorHex: 0xFF2196F3, // Blue
      iconType: 'tronton',
      tarifPerTon: 350000,
    ),
    ArmadaModel(
      id: 'ARM-004',
      nama: 'Trailer Container Reefer 40ft',
      tipe: 'Truk Kontainer Pendingin',
      kapasitasTon: 28.0,
      status: 'Tersedia',
      badgeText: 'Kapasitas 28.0 Ton',
      badgeColorHex: 0xFF2196F3, // Blue
      iconType: 'container',
      tarifPerTon: 480000,
    ),
  ];

  final List<HazardousMaterialModel> _hazmatGuideList = [
    HazardousMaterialModel(
      id: 'HAZ-001',
      kodeKelas: 'Kelas 1 (Explosives)',
      namaMaterial: 'Bahan Peledak & Amunisi Industri',
      tingkatBahaya: 'Tinggi',
      panduanPenanganan:
          '1. Gunakan truk khusus bertembok ganda.\n'
          '2. Kecepatan maksimal 50 km/jam dengan pengawalan.\n'
          '3. Hindari area padat penduduk.',
      apdWajib: ['Helm HAZMAT', 'Sarung Tangan Anti Statis', 'Masker Respirator'],
      isExpanded: false,
    ),
    HazardousMaterialModel(
      id: 'HAZ-002',
      kodeKelas: 'Kelas 3 (Flammable Liquids)',
      namaMaterial: 'Cairan Mudah Terbakar (BBM, Solven, Cat)',
      tingkatBahaya: 'Sedang-Tinggi',
      panduanPenanganan:
          '1. Pastikan tanki kontainer terkunci rapat.\n'
          '2. Dilarang merokok di radius 50 meter.\n'
          '3. Sediakan lembar MSDS di ruang kemudi.',
      apdWajib: ['Kacamata Safety', 'Sarung Tangan Nitril', 'Sepatu Safety'],
      isExpanded: false,
    ),
    HazardousMaterialModel(
      id: 'HAZ-003',
      kodeKelas: 'Kelas 6 (Toxic & Infectious)',
      namaMaterial: 'Bahan Beracun & Limbah Medis',
      tingkatBahaya: 'Tinggi',
      panduanPenanganan:
          '1. Kemasan wajib dilapisi segel kedap udara.\n'
          '2. Wajib menggunakan armada box tertutup.\n'
          '3. Jika bocor, isolasi area dan hubungi Tim SAR.',
      apdWajib: ['Baju Hazmat', 'Respirator Kimia', 'Sarung Tangan Karet'],
      isExpanded: false,
    ),
    HazardousMaterialModel(
      id: 'HAZ-004',
      kodeKelas: 'Kelas 8 (Corrosive Substances)',
      namaMaterial: 'Zat Korosif (Asam Sulfat, Aki Bekas)',
      tingkatBahaya: 'Sedang',
      panduanPenanganan:
          '1. Gunakan alas kontainer tahan korosi.\n'
          '2. Jangan ditumpuk bersama bahan makanan.\n'
          '3. Bilas air mengalir jika terkena kulit.',
      apdWajib: ['Celemek Anti-Asam', 'Face Shield', 'Sepatu Boot'],
      isExpanded: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Basic TabBar with blue theme
          const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(
                icon: Icon(Icons.directions_bus),
                text: "Armada Tersedia",
              ),
              Tab(
                icon: Icon(Icons.warning),
                text: "Syarat Muatan Berbahaya",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildArmadaTersediaTab(context),
                _buildSyaratMuatanBerbahayaTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArmadaTersediaTab(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _armadaList.length,
      itemBuilder: (context, index) {
        final armada = _armadaList[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Simple Icon instead of image
                    Container(
                      width: 70,
                      height: 70,
                      color: Colors.blue[50],
                      child: const Icon(
                        Icons.local_shipping,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            armada.nama,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            armada.tipe,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Tarif: Rp ${_formatRupiah(armada.tarifPerTon)} / Ton",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () async {
                                final result = await Navigator.push<ResiModel>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CargoBookingScreen(
                                      armada: armada,
                                    ),
                                  ),
                                );

                                if (result != null) {
                                  widget.onResiCreated(result);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("Pilih Armada"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Clean Stack & Positioned Capacity Badge
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      armada.badgeText,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSyaratMuatanBerbahayaTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Panduan Muatan Berbahaya (Hazardous Materials):",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ExpansionPanelList(
            elevation: 1,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _hazmatGuideList[index].isExpanded = isExpanded;
              });
            },
            children: _hazmatGuideList.map<ExpansionPanel>((item) {
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: const Icon(Icons.warning, color: Colors.orange),
                    title: Text(
                      item.kodeKelas,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.namaMaterial),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tingkat Risiko: ${item.tingkatBahaya}"),
                      const SizedBox(height: 6),
                      const Text(
                        "Panduan Penanganan:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item.panduanPenanganan),
                      const SizedBox(height: 8),
                      const Text(
                        "APD Wajib:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(item.apdWajib.join(", ")),
                    ],
                  ),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
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
