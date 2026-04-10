import 'package:flutter/material.dart';
import '../../utils/token_utils.dart';
import '../../services/admin_service.dart';
import '../../models/administratorprofile.dart';
import '../../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<AdministratorProfile?>? _adminProfileFuture;

  @override
  void initState() {
    super.initState();
    _adminProfileFuture = _loadAdminProfile();
  }

  Future<AdministratorProfile?> _loadAdminProfile() async {
    final adminId = await getAdministratorIdFromToken();
    if (adminId == null) return null;
    return await AdminService().getAdminById(adminId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Inicio', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF43E97B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<AdministratorProfile?>(
            future: _adminProfileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No se pudo cargar el perfil', style: TextStyle(color: Colors.white)));
              }
              final admin = snapshot.data!;
              return Center(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_circle, size: 64, color: Color(0xFF1976D2)),
                        const SizedBox(height: 18),
                        Text(
                          'Bienvenido',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${admin.firstName} ${admin.lastName}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
