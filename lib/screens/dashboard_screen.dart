import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:special_one_student/providers/theme_provider.dart';
import 'package:special_one_student/services/dashboard_service.dart';
import 'package:special_one_student/config/localization.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  Map<String, dynamic>? _student;
  List<dynamic>? _schedules;
  List<dynamic>? _announcements;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final student = await _dashboardService.getStudentData();
      final schedules = await _dashboardService.getSchedules();
      final announcements = await _dashboardService.getAnnouncements();
      setState(() {
        _student = student;
        _schedules = schedules;
        _announcements = announcements;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.dashboard),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement settings navigation
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _student?['fullName'] ?? '',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4.0),
                              Text(' ${l.username}: ${_student?['username'] ?? ''} — ${l.learningCenter}: ${_student?['center'] ?? ''}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.qrCode),
                              const SizedBox(height: 8.0),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    if (_student != null && _student!['id'] != null) {
                                      Navigator.pushNamed(context, '/qr_code', arguments: _student!['id']);
                                    }
                                  },
                                  child: QrImageView(
                                    data: _student?['id'] ?? 'no-id',
                                    size: 180.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.schedule),
                              const SizedBox(height: 8.0),
                              if (_schedules == null || _schedules!.isEmpty)
                                Text(l.noData),
                              ...(_schedules ?? []).map(
                                (s) => ListTile(
                                  title: Text(
                                      '${s['subject'] ?? ''} — ${s['date']} ${s['time']}'),
                                  subtitle: Text(s['center'] ?? ''),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.announcements),
                              const SizedBox(height: 8.0),
                              if (_announcements == null || _announcements!.isEmpty)
                                Text(l.noData),
                              ...(_announcements ?? []).map(
                                (a) => ListTile(
                                  title: Text(a['text'] ?? ''),
                                  onTap: () => Navigator.pushNamed(context, '/announcements'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/news');
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.teacherNews),
                                const SizedBox(height: 8.0),
                                const Text('عرض كل الأخبار'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}