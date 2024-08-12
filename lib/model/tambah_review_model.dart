import 'detail_restaurant_model.dart';

class TambahReviewModel {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  TambahReviewModel({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory TambahReviewModel.fromJson(Map<String, dynamic> json) =>
      TambahReviewModel(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}

// class CustomerReview {
//   String name;
//   String review;
//   String date;

//   CustomerReview({
//     required this.name,
//     required this.review,
//     required this.date,
//   });

//   factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
//         name: json["name"],
//         review: json["review"],
//         date: json["date"],
//       );
// }
