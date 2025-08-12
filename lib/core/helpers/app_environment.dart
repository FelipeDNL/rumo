import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {
  static String get placeAPIAgentName {
    return dotenv.env['PLACE_API_AGENT_NAME'] ?? 'RumoApp';
  }

  static String get supabseAnonKey {
    return dotenv.env['SUPABASE_ANON_KEY'] ?? '<SUPABASE_ANON_KEY>';
  }

  static String get supabaseProjectURL {
    return dotenv.env['SUPABASE_PROJECT_URL'] ?? '<SUPABASE_PROJECT_URL>';
  }
}