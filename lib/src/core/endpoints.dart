class Endpoints {
  static const String baseUrl = 'https://aueevfggytzboyeszwlw.supabase.co/rest/v1/';
  static const String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF1ZWV2ZmdneXR6Ym95ZXN6d2x3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAwMjc1MDksImV4cCI6MjAyNTYwMzUwOX0.C4iVOFeeQYhXb8jVGPbYhAqUu6fvD7r1oc4ACvcnzC8";

  static String masterBlocks = '$baseUrl${'master_blocks'}?apikey=$apiKey';
  static String sanlats = '$baseUrl${'sanlats'}?apikey=$apiKey';
}
