class BankCard {
  int? id;
  String? number;
  String? cvv;
  String? cardType; // <-- visa, mastercard
  String? country;
  DateTime? created;

  // default constructor
  BankCard({this.id, this.number, this.cvv, this.cardType, this.country})
      : created = DateTime.now();

  // from database
  BankCard.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        number = parsedJson['number'],
        cvv = parsedJson['cvv'],
        cardType = parsedJson['cardType'],
        country = parsedJson['country'],
        created = DateTime.tryParse(parsedJson['created']);

  // to database
  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "number": number,
      "cvv": cvv,
      "cardType": cardType,
      "country": country,
      "created": DateTime.now().toIso8601String()
    };
  }
}
