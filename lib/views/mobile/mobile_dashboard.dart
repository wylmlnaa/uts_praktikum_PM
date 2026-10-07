import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class MobileDashboard extends StatefulWidget {
  const MobileDashboard({super.key});

  @override
  State<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {
  int _currentIndex = 0;
  final _reportTitleController = TextEditingController();
  final _reportDescController = TextEditingController();
  String _reportCategory = 'Banjir';

  @override
  void dispose() {
    _reportTitleController.dispose();
    _reportDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final List<Widget> tabs = [
      _buildHomeTab(context, user),
      _buildMapTab(context),
      _buildReportTab(context),
      _buildTasksTab(context, user),
      _buildProfileTab(context, authProvider),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFEF4444),
        unselectedItemColor: const Color(0xFF9CA3AF),
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: "Peta",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: "Lapor",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: "Tugas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }

  // --- HOME TAB ---
  Widget _buildHomeTab(BuildContext context, user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Halo,",
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                  ),
                  Text(
                    user?.fullName ?? "Pengguna Lifeline",
                    style: const TextStyle(color: Color(0xFF1F2937), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  // Duty Status Badge (If Volunteer)
                  if (user?.role == 'VOLUNTEER' || user?.role == 'RESPONDER')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: Color(0xFF10B981)),
                          SizedBox(width: 6),
                          Text("On Duty", style: TextStyle(color: Color(0xFF065F46), fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  // Notification icon
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Color(0xFF4B5563)),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // EMERGENCY PANIC BUTTON CARD (WHITE / RED BRAND)
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "BUTUH BANTUAN SEGERA?",
                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                    ),
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tekan tombol di bawah untuk melaporkan kondisi darurat langsung ke LGU terdekat.",
                  style: TextStyle(color: Color(0xFF4B5563), fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (user != null) {
                        await FirestoreService().sendEmergencyReport(
                          reporterId: user.id,
                          reporterName: user.fullName,
                          title: "PANGGILAN DARURAT (SOS)",
                          description: "Pengguna menekan tombol SOS dari HP. Memerlukan bantuan darurat segera.",
                          category: "SOS",
                          latitude: 16.035,
                          longitude: 120.33,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("SOS Berhasil dikirim! Petugas LGU telah diberitahu."),
                              backgroundColor: Color(0xFFEF4444),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6)),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "SOS",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Weather/Alert Info
          const Text(
            "Kondisi Saat Ini",
            style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.cloudy_snowing, size: 44, color: Color(0xFF3B82F6)),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hujan Lebat & Resiko Banjir",
                        style: TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Dagupan City, Pangasinan. Siaga 2 kenaikan permukaan air.",
                        style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Contacts (Hotlines)
          const Text(
            "Nomor Darurat Penting",
            style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildHotlineCard("CDRRMO Hotline", "0917-123-4567", Icons.call),
          _buildHotlineCard("Pemadam Kebakaran", "(075) 522-1234", Icons.fire_truck),
          _buildHotlineCard("Rumah Sakit Daerah", "(075) 522-9999", Icons.local_hospital),
        ],
      ),
    );
  }

  Widget _buildHotlineCard(String name, String phone, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFEF4444), size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(phone, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: Color(0xFF10B981)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // --- PETA / MAP TAB ---
  Widget _buildMapTab(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: const Row(
            children: [
              Icon(Icons.map, color: Color(0xFFEF4444)),
              SizedBox(width: 12),
              Text(
                "Peta Pemantauan Bencana",
                style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirestoreService().streamEmergencies(),
            builder: (context, snapshot) {
              final markers = <Marker>[];

              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data();
                  final lat = (data['latitude'] as num?)?.toDouble() ?? 16.035;
                  final lng = (data['longitude'] as num?)?.toDouble() ?? 120.33;
                  final status = data['status'] ?? 'PENDING';
                  final title = data['title'] ?? 'Laporan';

                  markers.add(
                    Marker(
                      point: LatLng(lat, lng),
                      width: 45,
                      height: 45,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(title),
                              content: Text("Detail: ${data['description']}\nKategori: ${data['category']}\nStatus: $status"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Tutup"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.location_on,
                          color: status == 'APPROVED' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          size: 40,
                        ),
                      ),
                    ),
                  );
                }
              }

              return FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(16.035, 120.33),
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.lifeline.latihan_flutter',
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // --- REPORT INCIDENT / LAPOR TAB ---
  Widget _buildReportTab(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Laporkan Kejadian Darurat",
            style: TextStyle(color: Color(0xFF1F2937), fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Lengkapi form berikut untuk mengirimkan laporan bencana.",
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Category Dropdown
          DropdownButtonFormField<String>(
            initialValue: _reportCategory,
            dropdownColor: Colors.white,
            style: const TextStyle(color: Color(0xFF1F2937)),
            decoration: _reportInputDecoration("Kategori Bencana", Icons.category),
            items: ['Banjir', 'Kebakaran', 'Gempa Bumi', 'Medis', 'Kriminalitas'].map((c) {
              return DropdownMenuItem(
                value: c,
                child: Text(c),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _reportCategory = val ?? 'Banjir';
              });
            },
          ),
          const SizedBox(height: 16),

          // Title
          TextField(
            controller: _reportTitleController,
            style: const TextStyle(color: Color(0xFF1F2937)),
            decoration: _reportInputDecoration("Judul Kejadian", Icons.title),
          ),
          const SizedBox(height: 16),

          // Description
          TextField(
            controller: _reportDescController,
            maxLines: 4,
            style: const TextStyle(color: Color(0xFF1F2937)),
            decoration: _reportInputDecoration("Detail Deskripsi Kejadian", Icons.description),
          ),
          const SizedBox(height: 20),

          // Image Attachment Picker Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFEF4444)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lampirkan Foto Kejadian", style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Opsional, simulasi kamera", style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    foregroundColor: const Color(0xFF1F2937),
                    elevation: 0,
                  ),
                  child: const Text("Pilih"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Submit button
          ElevatedButton(
            onPressed: () async {
              if (user == null) return;
              if (_reportTitleController.text.isEmpty || _reportDescController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Judul dan deskripsi tidak boleh kosong!"),
                    backgroundColor: Color(0xFFEF4444),
                  ),
                );
                return;
              }

              final double lat = 16.03 + (0.02 * (DateTime.now().second % 6 / 6.0));
              final double lng = 120.32 + (0.02 * (DateTime.now().minute % 6 / 6.0));

              await FirestoreService().sendEmergencyReport(
                reporterId: user.id,
                reporterName: user.fullName,
                title: _reportTitleController.text.trim(),
                description: _reportDescController.text.trim(),
                category: _reportCategory,
                latitude: lat,
                longitude: lng,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Laporan berhasil dikirim ke LGU!"),
                    backgroundColor: Colors.green,
                  ),
                );
                _reportTitleController.clear();
                _reportDescController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text(
              "KIRIM LAPORAN",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _reportInputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF)),
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }

  // --- VOLUNTEER TASKS / TUGAS TAB ---
  Widget _buildTasksTab(BuildContext context, user) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hasVolunteerAccess = user?.role == 'VOLUNTEER' || user?.role == 'RESPONDER';

    if (!hasVolunteerAccess) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.security, size: 72, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              "Menu Khusus Relawan",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Color(0xFF1F2937), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Anda terdaftar sebagai pengguna umum (Community). Silakan ajukan pendaftaran relawan LGU Lifeline untuk menerima tugas tanggap darurat.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').doc(user.id).update({
                  'role': 'VOLUNTEER',
                  'volunteerStatus': 'APPROVED',
                });
                await authProvider.checkAuthStatus();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pendaftaran Relawan Anda Berhasil Diterima secara Otomatis!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text("DAFTAR SEBAGAI RELAWAN", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tugas Aktif Relawan",
            style: TextStyle(color: Color(0xFF1F2937), fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirestoreService().streamVolunteerTasks(user.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada penugasan dari LGU Admin.\nTunggu instruksi lebih lanjut.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF6B7280)),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, idx) {
                    final doc = snapshot.data!.docs[idx];
                    final task = doc.data();
                    final status = task['status'] ?? 'ACTIVE';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.01),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: status == 'COMPLETED'
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  status == 'COMPLETED' ? "SELESAI" : "AKTIF",
                                  style: TextStyle(
                                    color: status == 'COMPLETED' ? const Color(0xFF065F46) : const Color(0xFFB91C1C),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text("Tugas #${task['id'].substring(0, 4)}", style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(task['title'] ?? 'Tugas Evakuasi', style: const TextStyle(color: Color(0xFF1F2937), fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(task['location'] ?? 'Dagupan City', style: const TextStyle(color: Color(0xFF4B5563), fontSize: 13)),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFFE5E7EB)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                                  foregroundColor: const Color(0xFF4B5563),
                                ),
                                child: const Text("Navigasi Peta"),
                              ),
                              if (status != 'COMPLETED')
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirestoreService().completeDispatchTask(task['id']);
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Tugas telah selesai diverifikasi!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: const Text("Selesaikan Tugas"),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- PROFIL / PROFILE TAB ---
  Widget _buildProfileTab(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.currentUser;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFE5E7EB),
                  backgroundImage: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user?.avatarUrl == null || user!.avatarUrl!.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Color(0xFF9CA3AF))
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.fullName ?? "Pengguna Lifeline",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF1F2937), fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const SizedBox(height: 32),

          // Profile details card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileItem("ID Lifeline", user?.lifelineId ?? "Belum Dibuat"),
                const Divider(color: Color(0xFFE5E7EB)),
                _buildProfileItem("Peran", user?.role ?? "COMMUNITY"),
                const Divider(color: Color(0xFFE5E7EB)),
                _buildProfileItem("Kabupaten/Barangay", "${user?.barangay ?? 'Tapuac'}, ${user?.municipality ?? 'Dagupan'}"),
                const Divider(color: Color(0xFFE5E7EB)),
                _buildProfileItem("Nomor Kontak", user?.contactNo ?? "-"),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text("KELUAR DARI AKUN"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: const Color(0xFFFEE2E2),
              foregroundColor: const Color(0xFFB91C1C),
              side: const BorderSide(color: Color(0xFFFCA5A5)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          Text(value, style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
