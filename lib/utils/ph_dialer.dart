import 'package:book/widgets/show_toast.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

// void launchPhoneDialer(String phoneNumber) async {
//   final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//   if (await canLaunch("tel:1234567")) {
//     await launch("tel:1234567");
//   } else {
//     // Handle the error (e.g., show an error message)
//     print('Could not launch $phoneUri');
//     showToast(message: "Try again later.", type: ToastificationType.error);
//   }
// }

void launchPhoneDialer(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    // Handle the error (e.g., show an error message)
    print('Could not launch $phoneUri');
    showToast(message: "Try again later.", type: ToastificationType.error);
  }
}
