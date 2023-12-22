class Task {
  final String id;
  final String type;
  final String size;
  final String paperorient;
  final String paper;
  final String des;
  final int quantity;
  final String email;
  final String name;
  final String contact;
  final String designeremail;
  final String designerName;
  final String designerStatus;
  final String printeremail;
  final String printerName;
  final String printStatus;

  Task({
    required this.id,
    required this.type,
    required this.size,
    required this.paperorient,
    required this.paper,
    required this.des,
    required this.quantity,
    required this.email,
    required this.name,
    required this.contact,
    required this.designeremail,
    required this.designerName,
    required this.designerStatus,
    required this.printeremail,
    required this.printerName,
    required this.printStatus,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id:json['_id']?? '',
      type: json['type']?? '',
      size: json['size']?? '',
      paperorient: json['paperorient']?? '',
      paper: json['paper']?? '',
      des: json['des']?? '',
      quantity: json['quantity'] ?? 0,
      email: json['email']?? '',
      name: json['name']?? '',
      contact: json['contact']?? '',
      designeremail: json['designeremail']?? '',
      designerName: json['designerName']?? '',
      designerStatus: json['designerStatus']?? '',
      printeremail: json['printeremail']?? '',
      printerName: json['printerName']?? '',
      printStatus: json['printStatus']?? '',



    );
  }
}
