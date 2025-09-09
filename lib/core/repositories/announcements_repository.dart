import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class Announcement {
  final String id;
  final String title;
  final String text;
  final String type;
  final bool important;
  final DateTime date;
  final String author;

  Announcement({
    required this.id,
    required this.title,
    required this.text,
    required this.type,
    required this.important,
    required this.date,
    required this.author,
  });

  factory Announcement.fromJson(Map<String, dynamic> j) => Announcement(
        id: j['id'] as String,
        title: (j['title'] ?? 'إعلان') as String,
        text: (j['text'] ?? '') as String,
        type: (j['type'] ?? 'general') as String,
        important: (j['important'] ?? false) as bool,
        date: DateTime.tryParse(j['date'] as String? ?? '') ?? DateTime.now(),
        author: (j['author'] ?? '') as String,
      );
}

class AnnouncementsRepository {
  final SupabaseClient _client;
  AnnouncementsRepository([SupabaseClient? client])
      : _client = client ?? SupabaseService.client;

  Future<List<Announcement>> fetch({String? type, int limit = 50, int page = 1}) async {
    final from = _client.from('announcements');
    var query = from.select().order('date', ascending: false).limit(limit).range((page - 1) * limit, (page * limit) - 1);
    if (type != null && type.isNotEmpty) {
      query = _client.from('announcements').select().eq('type', type).order('date', ascending: false).limit(limit).range((page - 1) * limit, (page * limit) - 1);
    }
    final data = await query;
    return (data as List<dynamic>).map((e) => Announcement.fromJson(e as Map<String, dynamic>)).toList();
  }
}
