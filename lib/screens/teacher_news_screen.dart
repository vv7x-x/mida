import 'package:flutter/material.dart';
import 'package:mobile_app/services/teacher_news_service.dart';
import 'package:mobile_app/localization/localization.dart';
import 'package:mobile_app/utils/app_strings.dart';

class TeacherNewsScreen extends StatefulWidget {
  const TeacherNewsScreen({super.key});

  @override
  State<TeacherNewsScreen> createState() => _TeacherNewsScreenState();
}

class _TeacherNewsScreenState extends State<TeacherNewsScreen> {
  final TeacherNewsService _newsService = TeacherNewsService();
  List<dynamic>? _news;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final news = await _newsService.getNews();
      setState(() {
        _news = news;
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
        title: Text(appLocalizations.get(AppStrings.teacherNews)),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNews,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : _news == null || _news!.isEmpty
                    ? Center(child: Text(appLocalizations.get(AppStrings.noNewsAvailable)))
                    : ListView.builder(
                        itemCount: _news!.length,
                        itemBuilder: (context, index) {
                          final article = _news![index];
                          return Card(
                            child: ListTile(
                              title: Text(article['title'] ?? ''),
                              subtitle: Text(article['summary'] ?? ''),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailsScreen(
                                      news: article,
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

class NewsDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news['title'] ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(news['content'] ?? ''),
      ),
    );
  }
}