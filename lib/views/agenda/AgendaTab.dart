import 'package:eduspace_mobile/models/sharedspace.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/AppTheme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../models/meeting.dart';
import '../../services/meetings_service.dart';
import '../../services/sharedspaces_service.dart';
import '../../utils/token_utils.dart';
import 'MeetingDetailPage.dart';
import 'SpaceBookingPage.dart';

class AgendaTab extends StatefulWidget {
  const AgendaTab({super.key});

  @override
  AgendaTabState createState() => AgendaTabState();
}

class AgendaTabState extends State<AgendaTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<Meeting>>? _meetingsFuture;
  Future<List<SharedSpaceReservation>>? _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _meetingsFuture = MeetingsService().getAllMeetings();
    _loadReservations();
  }

  /// Recarga la información
  void reload() {
    setState(() {
      _meetingsFuture = MeetingsService().getAllMeetings();
    });
    _loadReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReservations() async {
    final teacherId = await getTeacherIdFromToken();
    if (teacherId != null) {
      setState(() {
        _reservationsFuture = SharedSpacesService().getTeacherReservations(
          teacherId,
        );
      });
    }
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
        tabs: const [
          Tab(text: 'Reuniones'),
          Tab(text: 'Reservas'),
        ],
      ),
    );
  }

  // ── Tab: Reuniones ──────────────────────────────────────────────────────────

  Widget _buildReuniones() {
    return FutureBuilder<List<Meeting>>(
      future: _meetingsFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
          return _emptyState(
            Icons.event_busy_outlined,
            'Sin reuniones',
            'No tienes reuniones asignadas.',
          );
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MeetingDetailPage(meeting: meeting)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: Color(0xFF6366f1),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        meeting.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _meetingInfoRow(
            Icons.access_time_outlined,
            '${meeting.date} • ${_hm(meeting.start)} - ${_hm(meeting.end)}',
          ),
          const SizedBox(height: 4),
          _meetingInfoRow(
            Icons.business_outlined,
            'Sala ${meeting.classroomId}',
          ),
        ],
      ),
    );
  }

  String _hm(String t) => t.length >= 5 ? t.substring(0, 5) : t;

  Widget _meetingInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    );
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
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SpaceBookingPage()),
              );
              if (result == true) {
                _loadReservations();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Reservar Espacio'),
          ),
        ),
        const SizedBox(height: 16),

        FutureBuilder<List<SharedSpaceReservation>>(
          future: _reservationsFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
              return _emptyState(
                Icons.meeting_room_outlined,
                'Sin reservas',
                'Aún no has reservado ningún espacio.',
              );
            }
            return Column(
              children: snap.data!.map((r) => _reservationCard(r)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _reservationCard(SharedSpaceReservation r) {
    return AppCard(
      leftBorderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            r.sharedSpaceName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textMain,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                '${DateFormat('EEE d MMM', 'es').format(r.reservationDate)} • ${r.startTime.substring(0, 5)} - ${r.endTime.substring(0, 5)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(
              Icons.note_outlined,
              size: 14,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
                r.reason,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
          ],)
        ],
      ),
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
