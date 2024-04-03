import 'package:supabase_flutter/supabase_flutter.dart';

Future initializeApp() async {
  await Supabase.initialize(
    url: 'https://mfukrbocfpedgtkziens.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1mdWtyYm9jZnBlZGd0a3ppZW5zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg3MDUyOTgsImV4cCI6MjAyNDI4MTI5OH0.1OwKNPKss0sXQABdOOFAMy-bcc44tJbeEgDI9N-HS3o',
  );
}
