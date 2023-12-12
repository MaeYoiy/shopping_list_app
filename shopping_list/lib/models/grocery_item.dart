import 'package:shopping_list/models/category.dart';

class GroceryItem {
  // ใน data ตัวแปรที่ชื่อว่า groceryItems เป็น type final สามารถเพิ่มหรือลดได้แต่แก้ไขไม่ได้ เพราะฉะนั้นต้องการ name parameter (required) ดังนั้นจึงใข้รูปแบบนี้
  const GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;
}
