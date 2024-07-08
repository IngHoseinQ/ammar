import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void showMessageAbout(BuildContext context) {
  const String name = "Hossein Ahmed Qasspa";
  const String email = "hq84068@gmail.com";
  const String phone = "+967776764455";
  const String facebookUrl = 'https://www.facebook.com/hossein.qasspa';
  const String telegramUrl = 'https://t.me/O_2_y';
  const String whatsappUrl = "https://wa.me/+967776764455";

  Future<void> copyToClipboard(String url, String message) async {
    await Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8.0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "BY $name",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text("Email: $email"),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              Text("Phone: $phone"),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.email, color: Colors.orange),
                    onPressed: () async => await copyToClipboard(
                      email,
                      'تم نسخ الايميل',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.facebook, color: Colors.blueAccent),
                    onPressed: () async => await copyToClipboard(
                      facebookUrl,
                      'تم نسخ رابط الفيسبوك',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.telegram, color: Colors.blue),
                    onPressed: () async => await copyToClipboard(
                      telegramUrl,
                      'تم نسخ رابط التيليجرام',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.perm_phone_msg, color: Colors.green),
                    onPressed: () async => await copyToClipboard(
                      whatsappUrl,
                      'تم نسخ رابط الوتس اب ',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
