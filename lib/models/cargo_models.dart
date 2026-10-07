class ArmadaModel {
  final String id;
  final String nama;
  final String tipe;
  final double kapasitasTon; // Max tonage
  final String status;
  final String badgeText;
  final int badgeColorHex;
  final String iconType; // e.g. truck type identifier or image representation
  final double tarifPerTon;

  ArmadaModel({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.kapasitasTon,
    required this.status,
    required this.badgeText,
    required this.badgeColorHex,
    required this.iconType,
    required this.tarifPerTon,
  });
}

class HazardousMaterialModel {
  final String id;
  final String kodeKelas;
  final String namaMaterial;
  final String tingkatBahaya;
  final String panduanPenanganan;
  final List<String> apdWajib;
  bool isExpanded;

  HazardousMaterialModel({
    required this.id,
    required this.kodeKelas,
    required this.namaMaterial,
    required this.tingkatBahaya,
    required this.panduanPenanganan,
    required this.apdWajib,
    this.isExpanded = false,
  });
}

class ResiModel {
  final String noResi;
  final String namaArmada;
  final String tipeArmada;
  final String kategoriMuatan;
  final List<String> layananEkstra;
  final double tonase;
  final String tanggalPenjemputan;
  final String jamKeberangkatan;
  final bool isReeferActive;
  final double totalBiaya;
  final String waktuPenerbitan;
  final String status;

  ResiModel({
    required this.noResi,
    required this.namaArmada,
    required this.tipeArmada,
    required this.kategoriMuatan,
    required this.layananEkstra,
    required this.tonase,
    required this.tanggalPenjemputan,
    required this.jamKeberangkatan,
    required this.isReeferActive,
    required this.totalBiaya,
    required this.waktuPenerbitan,
    this.status = "TERBIT (SIAP ANGKUT)",
  });
}
