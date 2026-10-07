import 'package:flutter/material.dart';
import '../../models/cargo_models.dart';
import 'tabs/manifest_tab.dart';
import 'tabs/rekap_resi_tab.dart';
import 'tabs/depo_info_tab.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String stafName;
  final String stafId;

  const MainNavigationScreen({
    super.key,
    this.stafName = 'Petugas Lapangan',
    this.stafId = 'STAF-8892',
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<ResiModel> _resiList = [
    ResiModel(
      noResi: 'CG-RESI-9812401',
      namaArmada: 'Fuso Heavy Transporter',
      tipeArmada: 'Truk CDD 6 Roda',
      kategoriMuatan: 'General Cargo',
      layananEkstra: ['Asuransi Barang Rusak'],
      tonase: 8.5,
      tanggalPenjemputan: '08/10/2026',
      jamKeberangkatan: '09:00 WIB',
      isReeferActive: false,
      totalBiaya: 1920000,
      waktuPenerbitan: '07/10/2026 08:00',
    ),
  ];

  void _addNewResi(ResiModel resi) {
    setState(() {
      _resiList.insert(0, resi);
      _currentIndex = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Surat Jalan ${resi.noResi} Berhasil Diterbitkan!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      ManifestTab(onResiCreated: _addNewResi),
      RekapResiTab(resiList: _resiList),
      const DepoInfoTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTabTitle()),
      ),

      // Basic Drawer without any external images
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue, size: 36),
              ),
              accountName: Text(widget.stafName),
              accountEmail: Text("ID Staf: ${widget.stafId}"),
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping, color: Colors.blue),
              title: const Text("Manifes Muatan"),
              selected: _currentIndex == 0,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt, color: Colors.blue),
              title: const Text("Rekap Resi"),
              selected: _currentIndex == 1,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text("Informasi Depo"),
              selected: _currentIndex == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: tabs[_currentIndex],

      // Basic BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: "Manifes Muatan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Rekap Resi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Informasi Depo",
          ),
        ],
      ),
    );
  }

  String _getTabTitle() {
    switch (_currentIndex) {
      case 0:
        return "Manifes Muatan";
      case 1:
        return "Rekap Resi";
      case 2:
        return "Informasi Depo";
      default:
        return "CargoFlow";
    }
  }
}
