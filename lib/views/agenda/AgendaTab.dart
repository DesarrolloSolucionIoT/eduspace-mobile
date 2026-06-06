import 'package:flutter/material.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/meeting.dart';
import '../../services/meetings_service.dart';
import 'MeetingDetailPage.dart';
import 'SpaceBookingPage.dart';

class AgendaTab extends StatefulWidget {
  const AgendaTab({super.key});

  @override
  State<AgendaTab> createState() => _AgendaTabState();
}

class _AgendaTabState extends State<AgendaTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<Meeting>>? _meetingsFuture;

  final List<_Reservation> _reservations = [
    _Reservation(space: 'Auditorio Principal', date: 'Vie 31 May', time: '10:00 - 11:00', reason: 'Clase de recuperación', status: 'pending'),
    _Reservation(space: 'Sala de Grados', date: 'Lun 03 Jun', time: '15:00 - 16:00', reason: 'Reunión de área', status: 'confirmed'),
    _Reservation(space: 'Lab de Cómputo', date: 'Mar 04 Jun', time: '09:00 - 10:00', reason: 'Práctica', status: 'rejected'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _meetingsFuture = MeetingsService().getAllMeetings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      title: 'Mi Agenda',
      body: Column(
        children: [
          _buildHubTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildReuniones(), _buildReservas()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHubTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.white,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.all(4),
        tabs: const [Tab(text: 'Reuniones'), Tab(text: 'Reservas')],
      ),
    );
  }

  // ── Tab: Reuniones ──────────────────────────────────────────────────────────

  Widget _buildReuniones() {
    return FutureBuilder<List<Meeting>>(
      future: _meetingsFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
          return _emptyState(Icons.event_busy_outlined, 'Sin reuniones', 'No tienes reuniones asignadas.');
        }
        final meetings = snap.data!;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          itemCount: meetings.length,
          itemBuilder: (context, i) => _meetingCard(context, meetings[i]),
        );
      },
    );
  }

  Widget _meetingCard(BuildContext context, Meeting meeting) {
    return AppCard(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MeetingDetailPage(meeting: meeting))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(children: [
                  const Icon(Icons.calendar_month_outlined, size: 18, color: Color(0xFF6366f1)),
                  const SizedBox(width: 6),
                  Expanded(child: Text(meeting.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary))),
                ]),
              ),
              _badge('Programada', const Color(0xFF3730A3), const Color(0xFFE0E7FF)),
            ],
          ),
          const SizedBox(height: 10),
          _meetingInfoRow(Icons.access_time_outlined, '${meeting.date} • ${_hm(meeting.start)} - ${_hm(meeting.end)}'),
          const SizedBox(height: 4),
          _meetingInfoRow(Icons.business_outlined, 'Sala ${meeting.classroomId}'),
        ],
      ),
    );
  }

  String _hm(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  Widget _meetingInfoRow(IconData icon, String text) {
    return Row(children: [
      Icon(icon, size: 14, color: AppColors.textMuted),
      const SizedBox(width: 6),
      Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
    ]);
  }

  // ── Tab: Reservas ──────────────────────────────────────────────────────────

  Widget _buildReservas() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const SpaceBookingPage()));
              setState(() {});
            },
            icon: const Icon(Icons.add),
            label: const Text('Reservar Espacio'),
          ),
        ),
        const SizedBox(height: 16),
        ..._reservations.map((r) => _reservationCard(r)),
      ],
    );
  }

  Widget _reservationCard(_Reservation r) {
    final (label, fg, bg, leftBorder) = _reservationBadge(r.status);
    return AppCard(
      leftBorderColor: leftBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(r.space, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textMain)),
              _badge(label, fg, bg),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.access_time_outlined, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Text('${r.date} • ${r.time}', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.comment_outlined, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 6),
            Text(r.reason, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          ]),
          if (r.status == 'pending') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => _reservations.remove(r)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFED7D7)),
                  foregroundColor: const Color(0xFFC53030),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Cancelar', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  (String, Color, Color, Color?) _reservationBadge(String status) {
    return switch (status) {
      'confirmed' => ('Confirmada', AppColors.stateOk, const Color(0xFFDCFCE7), AppColors.stateOk),
      'rejected' => ('Rechazada', AppColors.stateDanger, const Color(0xFFFEE2E2), null),
      _ => ('Pendiente', AppColors.stateWarn, const Color(0xFFFEF3C7), null),
    };
  }

  Widget _badge(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.white70),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _Reservation {
  final String space;
  final String date;
  final String time;
  final String reason;
  final String status;

  _Reservation({required this.space, required this.date, required this.time, required this.reason, required this.status});
}
