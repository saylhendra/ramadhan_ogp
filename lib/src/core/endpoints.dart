class Endpoints {
  static const String baseUrl = 'https://aueevfggytzboyeszwlw.supabase.co/rest/v1/';
  static const String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF1ZWV2ZmdneXR6Ym95ZXN6d2x3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTAwMjc1MDksImV4cCI6MjAyNTYwMzUwOX0.C4iVOFeeQYhXb8jVGPbYhAqUu6fvD7r1oc4ACvcnzC8";
  static String articles = '$baseUrl${'articles'}?apikey=$apiKey';
  static String articlesFootnotes = '$baseUrl${'articles_footnotes'}?apikey=$apiKey';
  static String characters = '$baseUrl${'characters'}?apikey=$apiKey';
  static String articlesCharacters = '$baseUrl${'articles_characters'}?apikey=$apiKey';
  static String places = '$baseUrl${'places'}?apikey=$apiKey';
  static String articlesPlaces = '$baseUrl${'articles_places'}?apikey=$apiKey';
}
