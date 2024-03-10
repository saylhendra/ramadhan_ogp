import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // objectbox = await ObjectBox.create();
  await Supabase.initialize(
    url: 'https://aueevfggytzboyeszwlw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF1ZWV2ZmdneXR6Ym95ZXN6d2x3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAwMjc1MDksImV4cCI6MjAyNTYwMzUwOX0.C4iVOFeeQYhXb8jVGPbYhAqUu6fvD7r1oc4ACvcnzC8',
  );
  initializeDateFormatting();
  runApp(const ProviderScope(child: MyApp()));
}
