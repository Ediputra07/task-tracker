class SupabaseConfig {
  // TODO: Ganti dengan Supabase URL dan Anon Key proyek Anda dari dashboard Supabase
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://bopnuonqhgwrwihoofwl.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJvcG51b25xaGd3cndpaG9vZndsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc1NzAxODMsImV4cCI6MjA5MzE0NjE4M30.8lfKhrZBBuC5viPAJE0jPalFHr7Vz8GdbwuGx_xnpMI',
  );
}
