String apiUrl = "Your ApiUrl";
String paymentUrl = "Your PaymentUrl";
String playstoreUrl = "Your playStoreUrl";

Map<String, String>? headersToken(token) => {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token"
    };

Map<String, String>? get headers =>
    {'Accept': 'application/json', 'Content-Type': 'application/json'};
