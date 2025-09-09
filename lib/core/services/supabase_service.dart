import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Read from --dart-define or fallback to empty
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (url.isEmpty || anonKey.isEmpty) {
      debugPrint('[Supabase] Skipped init: SUPABASE_URL or SUPABASE_ANON_KEY missing');
      return;
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      // Optional local storage can be configured if needed
    );

    _initialized = true;
    debugPrint('[Supabase] Initialized successfully');
  }

  static SupabaseClient get client => Supabase.instance.client;
}
