
class Article {
  final int article;
  final int id;
  final String image;
  final String name;
  final double price;



  Article(
      {
        this.article,
        this.id,
        this.image,
        this.name,
        this.price
      }
      );


  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        article: json['article'],
        id: json['id'],
        image: json['image'],
        name: json['name'],
        price: double.tryParse(json['price'].toString()),
    );
  }


}