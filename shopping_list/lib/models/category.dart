import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  // ใน data ตัวแปรที่ชื่อว่า categories เป็น type const ดังนั้นจึงใข้รูปแบบนี้
  const Category(this.title, this.color);

  final String title;
  final Color color;
}
