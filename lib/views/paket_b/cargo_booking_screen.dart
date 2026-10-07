import 'package:flutter/material.dart';
import '../../models/cargo_models.dart';
import '../../widgets/custom_group_buttons.dart';

class CargoBookingScreen extends StatefulWidget {
  final ArmadaModel armada;

  const CargoBookingScreen({
    super.key,
    required this.armada,
  });

  @override
  State<CargoBookingScreen> createState() => _CargoBookingScreenState();
}

class _CargoBookingScreenState extends State<CargoBookingScreen> {
  String _selectedKategori = 'General Cargo';
  final List<String> _kategoriOptions = [
    'General Cargo',
    'Makanan Beku/Perishable',
    'Alat Berat',
  ];

  List<String> _selectedProteksi = ['Asuransi Barang Rusak'];
  final List<String> _proteksiOptions = [
    'Asuransi Barang Rusak',
    'Jasa Forklift Muat',
    'Pengawalan Prioritas',
  ];

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 09, minute: 30);

  late double _tonaseValue;
  bool _isReeferActive = false;

  @override
  void initState() {
    super.initState();
    _tonaseValue = widget.armada.kapasitasTon > 2.0 ? 2.0 : widget.armada.kapasitasTon;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  double _calculateTotalBiaya() {
    double baseRate = widget.armada.tarifPerTon * _tonaseValue;

    if (_selectedKategori == 'Makanan Beku/Perishable') {
      baseRate += 150000;
    } else if (_selectedKategori == 'Alat Berat') {
      baseRate += 300000;
    }

    if (_selectedProteksi.contains('Asuransi Barang Rusak')) baseRate += 50000;
    if (_selectedProteksi.contains('Jasa Forklift Muat')) baseRate += 100000;
    if (_selectedProteksi.contains('Pengawalan Prioritas')) baseRate += 200000;

    if (_isReeferActive) baseRate += 250000;

    return baseRate;
  }

  void _openCalculationBottomSheet() {
    final double totalBiaya = _calculateTotalBiaya();
    final String formattedDate =
        "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}";
    final String formattedTime =
        "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} WIB";

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bContext) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Rincian Biaya Logistik",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Divider(),
              _buildCostRow("Armada", widget.armada.nama),
              _buildCostRow("Kategori Muatan", _selectedKategori),
              _buildCostRow("Estimasi Tonase", "${_tonaseValue.toStringAsFixed(1)} Ton"),
              _buildCostRow("Jadwal", "$formattedDate ($formattedTime)"),
              _buildCostRow("Reefer Container", _isReeferActive ? "Aktif" : "Tidak"),
              _buildCostRow(
                "Layanan Ekstra",
                _selectedProteksi.isEmpty ? "-" : _selectedProteksi.join(", "),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Biaya:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "Rp ${_formatRupiah(totalBiaya)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showFinalConfirmationDialog(bContext, totalBiaya, formattedDate, formattedTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("PROSES TRANSAKSI", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFinalConfirmationDialog(
    BuildContext bottomSheetContext,
    double totalBiaya,
    String formattedDate,
    String formattedTime,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Transaksi'),
          content: Text(
            'Apakah Anda yakin ingin menerbitkan Surat Jalan armada ${widget.armada.nama} '
            'dengan total biaya Rp ${_formatRupiah(totalBiaya)}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(bottomSheetContext);

                final String newNoResi = "CG-RESI-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
                final ResiModel newResi = ResiModel(
                  noResi: newNoResi,
                  namaArmada: widget.armada.nama,
                  tipeArmada: widget.armada.tipe,
                  kategoriMuatan: _selectedKategori,
                  layananEkstra: _selectedProteksi,
                  tonase: _tonaseValue,
                  tanggalPenjemputan: formattedDate,
                  jamKeberangkatan: formattedTime,
                  isReeferActive: _isReeferActive,
                  totalBiaya: totalBiaya,
                  waktuPenerbitan: DateTime.now().toString(),
                );

                Navigator.pop(context, newResi);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Setujui & Terbitkan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDateStr =
        "${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}";
    final String formattedTimeStr =
        "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} WIB";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Booking Kargo"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Armada info card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping, color: Colors.blue, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.armada.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text("Kapasitas Max: ${widget.armada.kapasitasTon} Ton"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 1. RadioButtonGroup
            const Text("1. Kategori Muatan (RadioButtonGroup):", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            RadioButtonGroup(
              labels: _kategoriOptions,
              picked: _selectedKategori,
              activeColor: Colors.blue,
              onSelected: (String selected) {
                setState(() {
                  _selectedKategori = selected;
                  if (selected == 'Makanan Beku/Perishable') {
                    _isReeferActive = true;
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // 2. CheckboxGroup
            const Text("2. Proteksi Pengiriman (CheckboxGroup):", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            CheckboxGroup(
              labels: _proteksiOptions,
              checked: _selectedProteksi,
              activeColor: Colors.blue,
              onSelected: (List<String> updatedList) {
                setState(() {
                  _selectedProteksi = updatedList;
                });
              },
            ),
            const SizedBox(height: 16),

            // 3. Date & Time pickers
            const Text("3. Jadwal Pengambilan:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text("Tgl: $formattedDateStr"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.access_time),
                    label: Text("Jam: $formattedTimeStr"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. Slider & Switch
            const Text("4. Pengaturan Muatan:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Estimasi Tonase: ${_tonaseValue.toStringAsFixed(1)} Ton"),
                    Slider(
                      value: _tonaseValue,
                      min: 1.0,
                      max: widget.armada.kapasitasTon,
                      divisions: (widget.armada.kapasitasTon * 2 - 2).toInt(),
                      label: "${_tonaseValue.toStringAsFixed(1)} Ton",
                      activeColor: Colors.blue,
                      onChanged: (double val) {
                        setState(() {
                          _tonaseValue = val;
                        });
                      },
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Mesin Pendingin Container (Reefer):"),
                        Switch(
                          value: _isReeferActive,
                          activeTrackColor: Colors.blue,
                          onChanged: (bool val) {
                            setState(() {
                              _isReeferActive = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Hitung Biaya Logistik
            ElevatedButton(
              onPressed: _openCalculationBottomSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text("HITUNG BIAYA LOGISTIK", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
