import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================
  // EMERGENCY REPORTS (LAPORAN BENCANA)
  // ============================================

  // Mengirim Laporan Darurat Baru dari HP
  Future<void> sendEmergencyReport({
    required String reporterId,
    required String reporterName,
    required String title,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) async {
    try {
      final docRef = _firestore.collection('emergencies').doc();
      await docRef.set({
        'id': docRef.id,
        'reporterId': reporterId,
        'reporterName': reporterName,
        'title': title,
        'description': description,
        'category': category,
        'latitude': latitude,
        'longitude': longitude,
        'imageUrl': imageUrl ?? '',
        'status': 'PENDING', // PENDING, APPROVED, RESOLVED
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error sending emergency report: $e');
      rethrow;
    }
  }

  // Stream Laporan Darurat secara Real-time untuk Peta dan Dashboard
  Stream<QuerySnapshot<Map<String, dynamic>>> streamEmergencies() {
    return _firestore
        .collection('emergencies')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // LGU/Admin menyetujui laporan darurat (Verifikasi & Simpan Status)
  Future<void> approveEmergencyReport(String reportId) async {
    try {
      await _firestore.collection('emergencies').doc(reportId).update({
        'status': 'APPROVED',
      });

      // Tambahkan Log audit blockchain tiruan (agar fungsinya sama dengan Capstone Project)
      final auditRef = _firestore.collection('blockchain_audit').doc();
      await auditRef.set({
        'id': auditRef.id,
        'action': 'VERIFY_EMERGENCY',
        'reportId': reportId,
        'txHash': '0x${reportId}e683656c890068ba13d5c4aadaf56391ced1bacce9d6b${DateTime.now().millisecond}',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error approving report: $e');
      rethrow;
    }
  }

  // ============================================
  // VOLUNTEER DISPATCH & TASKS (TUGAS RELAWAN)
  // ============================================

  // Stream tugas aktif untuk Relawan tertentu
  Stream<QuerySnapshot<Map<String, dynamic>>> streamVolunteerTasks(String volunteerId) {
    return _firestore
        .collection('dispatches')
        .where('volunteerId', isEqualTo: volunteerId)
        .snapshots();
  }

  // Membuat Tim Penugasan (Dispatch) Baru dari Web Admin
  Future<void> createDispatchTask({
    required String reportId,
    required String taskTitle,
    required String location,
    required String volunteerId,
    required String volunteerName,
  }) async {
    try {
      final docRef = _firestore.collection('dispatches').doc();
      await docRef.set({
        'id': docRef.id,
        'reportId': reportId,
        'title': taskTitle,
        'location': location,
        'volunteerId': volunteerId,
        'volunteerName': volunteerName,
        'status': 'ACTIVE', // ACTIVE, COMPLETED
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error creating dispatch task: $e');
      rethrow;
    }
  }

  // Menyelesaikan tugas relawan
  Future<void> completeDispatchTask(String taskId) async {
    try {
      await _firestore.collection('dispatches').doc(taskId).update({
        'status': 'COMPLETED',
      });
    } catch (e) {
      debugPrint('Error completing task: $e');
      rethrow;
    }
  }

  // Ubah status aktif relawan (On Duty / Off Duty)
  Future<void> updateVolunteerDuty(String uid, bool onDuty) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'onDuty': onDuty,
      });
    } catch (e) {
      debugPrint('Error updating volunteer duty status: $e');
      rethrow;
    }
  }

  // ============================================
  // REAL-TIME CHAT (DISKUSI RELAWAN)
  // ============================================

  // Kirim pesan chat pada tugas tertentu
  Future<void> sendChatMessage({
    required String dispatchId,
    required String senderName,
    required String message,
  }) async {
    try {
      await _firestore
          .collection('dispatches')
          .doc(dispatchId)
          .collection('chats')
          .add({
        'senderName': senderName,
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error sending chat message: $e');
      rethrow;
    }
  }

  // Stream Diskusi Chat secara Real-time
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String dispatchId) {
    return _firestore
        .collection('dispatches')
        .doc(dispatchId)
        .collection('chats')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // Stream audit log blockchain untuk ditampilkan di Web Dashboard
  Stream<QuerySnapshot<Map<String, dynamic>>> streamBlockchainAudit() {
    return _firestore
        .collection('blockchain_audit')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
