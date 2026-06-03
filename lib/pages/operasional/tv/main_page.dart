import 'package:flutter/material.dart';
import 'package:dfw_playstation/core/app_colors.dart';
import 'package:dfw_playstation/widgets/side_bar.dart';
import 'package:dfw_playstation/services/api_service.dart';

class DaftarTVPage extends StatefulWidget {
  const DaftarTVPage({super.key});

  @override
  State<DaftarTVPage> createState() => _DaftarTVPageState();
}

class _DaftarTVPageState extends State<DaftarTVPage> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _tvData;

  @override
  void initState() {
    super.initState();
    _tvData = _apiService.fetchTvData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _tvData = _apiService.fetchTvData();
    });
  }

  void _showEditDialog(Map<String, dynamic> tv) {
    final nameCtrl = TextEditingController(text: tv['nama_tv']);
    final modelCtrl = TextEditingController(text: tv['model']);
    String currentKondisi = tv['kondisi'] ?? 'Baik';
    String currentStatus = tv['status'] ?? 'Tersedia';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit TV ${tv['id']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Merk TV'),
              ),
              TextField(
                controller: modelCtrl,
                decoration: const InputDecoration(labelText: 'Model Seri'),
              ),
              DropdownButton<String>(
                value: currentKondisi,
                isExpanded: true,
                items: ['Baik', 'Rusak', 'Dalam Perbaikan']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setDialogState(() => currentKondisi = val!),
              ),
              DropdownButton<String>(
                value: currentStatus,
                isExpanded: true,
                items: ['Tersedia', 'Tidak Tersedia', 'Maintenance']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setDialogState(() => currentStatus = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool ok = await _apiService.editTv(
                  tv['id'],
                  nameCtrl.text,
                  modelCtrl.text,
                  currentKondisi,
                  currentStatus,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  if (ok) _refreshData();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text(
          'Menghapus TV ini otomatis akan menghapus Kombinasi Unit Play yang memakainya. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              bool ok = await _apiService.hapusTv(id);
              if (context.mounted) {
                Navigator.pop(context);
                if (ok) _refreshData();
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      drawer: const SideBar(),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/operasional');
            }
          },
        ),
        title: const Text(
          'Daftar TV',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.primaryGreen,
          child: FutureBuilder<List<dynamic>>(
            future: _tvData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = snapshot.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(
                              context,
                              '/operasional',
                            );
                          }
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        label: const Text(
                          'Kembali',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/tambah-tv',
                        ).then((_) => _refreshData()),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Tambah TV'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ...list.map(
                    (tv) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderGrey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tv['nama_tv'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                tv['status'] ?? '-',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Text('ID: ${tv['id']} | Model: ${tv['model']}'),
                          Text('Kondisi: ${tv['kondisi']}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () => _showEditDialog(tv),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDelete(tv['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
