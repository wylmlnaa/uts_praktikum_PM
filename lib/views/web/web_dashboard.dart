import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class WebDashboard extends StatefulWidget {
  const WebDashboard({super.key});

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  int _selectedMenuIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Row(
        children: [
          // 1. SIDEBAR (White Theme)
          _buildSidebar(context, authProvider, user),

          // 2. MAIN AREA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header (White Theme)
                _buildHeader(context, user),

                // Content Page
                Expanded(
                  child: Container(
                    color: const Color(0xFFF6F7F9),
                    child: _buildMainContent(context, user),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HEADER DESIGN (WHITE THEME) ---
  Widget _buildHeader(BuildContext context, user) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF4B5563)),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getMenuTitle(),
                    style: const TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Welcome Back, ${user?.fullName ?? 'LGU Staff'}",
                    style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          // Search & Right Controls
          Row(
            children: [
              Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Dark mode / Light mode toggle placeholder
              IconButton(
                icon: const Icon(Icons.dark_mode_outlined, color: Color(0xFF4B5563)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF4B5563)),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              // User avatar
              CircleAvatar(
                backgroundColor: const Color(0xFFE5E7EB),
                child: Text(
                  user?.firstName.substring(0, 1) ?? "L",
                  style: const TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                user?.fullName ?? "Juan Dela Cruz",
                style: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4B5563)),
            ],
          ),
        ],
      ),
    );
  }

  String _getMenuTitle() {
    switch (_selectedMenuIndex) {
      case 0:
        return "Dasbor";
      case 1:
        return "Notifikasi";
      case 2:
        return "Darurat";
      case 3:
        return "Persetujuan / Verifikasi";
      case 4:
        return "Log Audit";
      case 5:
        return "Peta Langsung";
      default:
        return "Dasbor";
    }
  }

  // --- SIDEBAR DESIGN (WHITE THEME) ---
  Widget _buildSidebar(BuildContext context, AuthProvider authProvider, user) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo & SIBARNAS title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              children: [
                // Circular crest simulation
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                    ),
                  ),
                  child: const Icon(Icons.shield, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  "SIBARNAS",
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFE5E7EB), height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                // Group 1: UMUM
                _buildSidebarGroupHeader("UMUM"),
                _buildSidebarMenuItem(0, "Dasbor", Icons.dashboard_outlined),
                _buildSidebarMenuItem(1, "Notifikasi", Icons.notifications_none_outlined),

                // Group 2: OPERASI
                _buildSidebarGroupHeader("OPERASI"),
                _buildSidebarMenuItem(2, "Darurat", Icons.warning_amber_outlined),
                _buildSidebarMenuItem(3, "Persetujuan / Verifikasi", Icons.fact_check_outlined),
                _buildSidebarMenuItem(4, "Log Audit", Icons.history_outlined),
                _buildSidebarMenuItem(5, "Peta Langsung", Icons.map_outlined),
                _buildSidebarMenuItem(6, "Peralatan", Icons.construction_outlined),

                // Group 3: PEMBARUAN
                _buildSidebarGroupHeader("PEMBARUAN"),
                _buildSidebarMenuItem(7, "Pengumuman", Icons.campaign_outlined),
                _buildSidebarMenuItem(8, "Laporan", Icons.analytics_outlined),
                _buildSidebarMenuItem(9, "Lainnya", Icons.more_horiz_outlined),
              ],
            ),
          ),

          // Logout Section
          const Divider(color: Color(0xFFE5E7EB)),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Keluar", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () async {
              await authProvider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSidebarGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSidebarMenuItem(int index, String title, IconData icon) {
    final isSelected = _selectedMenuIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: -2),
        selected: isSelected,
        selectedColor: const Color(0xFF2563EB),
        leading: Icon(icon, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF6B7280)),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF374151),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedMenuIndex = index;
          });
        },
      ),
    );
  }

  // --- CONTENT ROUTING ---
  Widget _buildMainContent(BuildContext context, user) {
    switch (_selectedMenuIndex) {
      case 0:
        return _buildOverviewContent(context);
      case 2: // Darurat
        return _buildDispatchContent(context);
      case 3: // Persetujuan / Verifikasi
        return _buildApprovalsContent(context);
      case 4: // Log Audit
        return _buildAuditLogContent(context);
      case 5: // Peta Langsung
        return _buildLiveMapMonitor(context);
      default:
        return _buildOverviewContent(context);
    }
  }

  // --- 1. DASBOR (OVERVIEW) CONTENT (WHITE CARDS) ---
  Widget _buildOverviewContent(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestoreService.streamEmergencies(),
      builder: (context, snapshot) {
        int totalActive = 0;
        int totalPending = 0;

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          totalActive = docs.where((d) => d.data()['status'] != 'RESOLVED').length;
          totalPending = docs.where((d) => d.data()['status'] == 'PENDING').length;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stat Cards Row (AUTO-SCALING ROW, NO OVERFLOW)
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      "Darurat Aktif",
                      totalActive.toString(),
                      Icons.warning_amber_rounded,
                      const Color(0xFFEF4444),
                      const Color(0xFFFEE2E2),
                      "+4",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Relawan Tersedia",
                      "3",
                      Icons.people_outline,
                      const Color(0xFF10B981),
                      const Color(0xFFD1FAE5),
                      "0",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Tugas Berjalan",
                      totalPending.toString(),
                      Icons.assignment_outlined,
                      const Color(0xFFF59E0B),
                      const Color(0xFFFEF3C7),
                      "0",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      "Tingkat Respons",
                      "90%",
                      Icons.show_chart,
                      const Color(0xFF3B82F6),
                      const Color(0xFFDBEAFE),
                      "-10 pts",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Alerts & Logs Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildRecentAlertsSection(snapshot.data?.docs),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildBlockchainAuditSection(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color bgColor,
    String badgeText,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(color: Color(0xFF111827), fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAlertsSection(List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs) {
    final alerts = <Widget>[];

    if (docs != null && docs.isNotEmpty) {
      final limit = docs.length > 4 ? 4 : docs.length;
      for (int i = 0; i < limit; i++) {
        final data = docs[i].data();
        final title = data['title'] ?? 'Laporan Darurat';
        final category = data['category'] ?? 'Umum';
        final status = data['status'] ?? 'PENDING';

        alerts.add(
          _buildAlertListItem(
            title,
            "Kategori: $category | Status: $status",
            "Baru",
            status == 'APPROVED' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          ),
        );
      }
    } else {
      alerts.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text("Tidak ada laporan darurat aktif saat ini.", style: TextStyle(color: Color(0xFF6B7280))),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Laporan Darurat Terbaru", style: TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...alerts,
        ],
      ),
    );
  }

  Widget _buildAlertListItem(String title, String location, String time, Color indicatorColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(location, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBlockchainAuditSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Audit Blockchain (LGU)", style: TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestoreService.streamBlockchainAudit(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("Belum ada log audit di Blockchain.", style: TextStyle(color: Color(0xFF6B7280), fontSize: 13));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length > 4 ? 4 : snapshot.data!.docs.length,
                itemBuilder: (context, idx) {
                  final data = snapshot.data!.docs[idx].data();
                  final txHash = data['txHash'] ?? '0xHash';
                  final action = data['action'] ?? 'AUDIT';

                  return _buildBlockchainAuditItem(
                    txHash.substring(0, 8) + '...' + txHash.substring(txHash.length - 3),
                    action,
                    "Sukses",
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBlockchainAuditItem(String hash, String action, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hash, style: const TextStyle(color: Color(0xFF2563EB), fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(action, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(6)),
            child: const Text("Sukses", style: TextStyle(color: Color(0xFF065F46), fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- 2. LOG AUDIT CONTENT ---
  Widget _buildAuditLogContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Log Audit Transaksi Keamanan", style: TextStyle(color: Color(0xFF111827), fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestoreService.streamBlockchainAudit(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Belum ada logs transaksi.", style: TextStyle(color: Color(0xFF6B7280))));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, idx) {
                      final data = snapshot.data!.docs[idx].data();
                      final txHash = data['txHash'] ?? '0xHash';
                      final action = data['action'] ?? 'AUDIT';

                      return Card(
                        color: const Color(0xFFF9FAFB),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.enhanced_encryption, color: Colors.green),
                          title: Text(action, style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold)),
                          subtitle: Text("TxHash: $txHash", style: const TextStyle(color: Color(0xFF4B5563), fontFamily: 'monospace')),
                          trailing: const Chip(
                            backgroundColor: Color(0xFFD1FAE5),
                            label: Text("VERIFIED", style: TextStyle(color: Color(0xFF065F46), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. PERSETUJUAN / VERIFIKASI (APPROVALS) CONTENT ---
  Widget _buildApprovalsContent(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Emergency Approvals", style: TextStyle(color: Color(0xFF111827), fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text("Verifikasi laporan masyarakat sebelum memobilisasi relawan.", style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          const SizedBox(height: 24),

          // Table Card
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _firestoreService.streamEmergencies(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final pendingDocs = snapshot.data!.docs.where((d) => d.data()['status'] == 'PENDING').toList();

                  if (pendingDocs.isEmpty) {
                    return const Center(
                      child: Text("Semua laporan darurat telah disetujui / diproses.", style: TextStyle(color: Color(0xFF6B7280))),
                    );
                  }

                  return SingleChildScrollView(
                    child: DataTable(
                      headingTextStyle: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.bold),
                      dataTextStyle: const TextStyle(color: Color(0xFF4B5563)),
                      columns: const [
                        DataColumn(label: Text("Pelapor")),
                        DataColumn(label: Text("Bencana")),
                        DataColumn(label: Text("Deskripsi")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Tindakan")),
                      ],
                      rows: pendingDocs.map((doc) {
                        final data = doc.data();
                        final desc = data['description'] ?? 'Deskripsi';
                        final title = data['title'] ?? 'Laporan';
                        final reporter = data['reporterName'] ?? 'Anonim';
                        final reportId = doc.id;
                        final category = data['category'] ?? 'Banjir';

                        return DataRow(
                          cells: [
                            DataCell(Text(reporter)),
                            DataCell(Text(category)),
                            DataCell(Text(desc)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "PENDING",
                                  style: TextStyle(color: Color(0xFF92400E), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DataCell(
                              ElevatedButton(
                                onPressed: () async {
                                  // 1. Setujui Laporan
                                  await _firestoreService.approveEmergencyReport(reportId);

                                  // 2. Buat tugas relawan
                                  await _firestoreService.createDispatchTask(
                                    reportId: reportId,
                                    taskTitle: "Evakuasi: $category ($title)",
                                    location: "Dagupan City Area (Koordinat Terlampir)",
                                    volunteerId: user?.id ?? '',
                                    volunteerName: user?.fullName ?? 'Relawan Lifeline',
                                  );

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Laporan Darurat Disetujui & Tugas Relawan Terkirim!"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                child: const Text("Setujui & Dispatch"),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. PETA LANGSUNG CONTENT ---
  Widget _buildLiveMapMonitor(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: const Row(
            children: [
              Icon(Icons.monitor, color: Color(0xFF2563EB)),
              SizedBox(width: 12),
              Text(
                "Peta Pemantauan Wilayah SIBARNAS (Dagupan City)",
                style: TextStyle(color: Color(0xFF111827), fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestoreService.streamEmergencies(),
            builder: (context, snapshot) {
              final markers = <Marker>[];

              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data();
                  final lat = (data['latitude'] as num?)?.toDouble() ?? 16.035;
                  final lng = (data['longitude'] as num?)?.toDouble() ?? 120.33;
                  final status = data['status'] ?? 'PENDING';

                  markers.add(
                    Marker(
                      point: LatLng(lat, lng),
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.location_on,
                        color: status == 'APPROVED' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        size: 45,
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

  // --- 5. DARURAT (DISPATCH LIST) CONTENT ---
  Widget _buildDispatchContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Volunteer & Dispatch Management", style: TextStyle(color: Color(0xFF111827), fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text("Kelola koordinasi dan penugasan tim respon cepat.", style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          const SizedBox(height: 24),

          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('dispatches').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Belum ada relawan yang terdeploy saat ini.", style: TextStyle(color: Color(0xFF6B7280))),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, idx) {
                    final data = snapshot.data!.docs[idx].data();
                    final title = data['title'] ?? 'Penugasan';
                    final location = data['location'] ?? 'Dagupan City';
                    final volunteerName = data['volunteerName'] ?? 'Relawan';
                    final status = data['status'] ?? 'ACTIVE';

                    return Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title, 
                                  style: const TextStyle(color: Color(0xFF111827), fontSize: 15, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                                child: const Text("1 Relawan", style: TextStyle(color: Color(0xFF2563EB), fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.circle, size: 10, color: status == 'COMPLETED' ? Colors.grey : const Color(0xFF10B981)),
                              const SizedBox(width: 8),
                              Text(
                                status == 'COMPLETED' ? "Selesai Tugas" : "Aktif Lapangan", 
                                style: TextStyle(color: status == 'COMPLETED' ? const Color(0xFF4B5563) : const Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF6B7280)),
                              const SizedBox(width: 8),
                              Text(location, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16, color: Color(0xFF6B7280)),
                              const SizedBox(width: 8),
                              Text("Relawan: $volunteerName", style: const TextStyle(color: Color(0xFF4B5563), fontSize: 13)),
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
}
