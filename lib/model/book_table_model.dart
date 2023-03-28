
import 'dart:convert';

BookTableModel bookTableModelFromJson(String str) => BookTableModel.fromJson(json.decode(str));

String bookTableModelToJson(BookTableModel data) => json.encode(data.toJson());

class BookTableModel {
  BookTableModel({
    required this.success,
    required this.data,
  });

  final bool success;
  final Data data;

  factory BookTableModel.fromJson(Map<String, dynamic> json) => BookTableModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.bookedTable,
  });

  final List<BookedTable> bookedTable;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bookedTable: List<BookedTable>.from(json["bookedTable"].map((x) => BookedTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bookedTable": List<dynamic>.from(bookedTable.map((x) => x.toJson())),
  };
}

class BookedTable {
  BookedTable({
    required this.id,
    required this.vendorId,
    required this.bookedTableNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int vendorId;
  final int bookedTableNumber;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory BookedTable.fromJson(Map<String, dynamic> json) {
    return BookedTable(
      id: json["id"],

      vendorId: json["vendor_id"],
      bookedTableNumber: json["booked_table_number"],
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_id": vendorId,
    "booked_table_number": bookedTableNumber,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
