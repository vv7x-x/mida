import 'package:flutter/material.dart';
import 'package:mobile_app/services/dashboard_service.dart';
import 'package:mobile_app/localization/localization.dart';
import 'package:mobile_app/utils/app_strings.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final DashboardService _dashboardService = DashboardService();
  List<dynamic>? _announcements;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<void> _fetchAnnouncements() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final announcements = await _dashboardService.getAnnouncements();
      setState(() {
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
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.get(AppStrings.announcements)),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAnnouncements,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : _announcements == null || _announcements!.isEmpty
                    ? Center(child: Text(appLocalizations.get(AppStrings.noAnnouncementsAvailable)))
                    : ListView.builder(
                        itemCount: _announcements!.length,
                        itemBuilder: (context, index) {
                          final announcement = _announcements![index];
                          return Card(
                            child: ListTile(
                              title: Text(announcement['text'] ?? ''),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnnouncementDetailsScreen(
                                      announcement: announcement,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}

class AnnouncementDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> announcement;

  const AnnouncementDetailsScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(announcement['title'] ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(announcement['content'] ?? ''),
      ),
    );
  }
}