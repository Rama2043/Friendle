import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final picker = ImagePicker();
DatabaseReference realTimeDatabaseRef = FirebaseDatabase.instance.ref();
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
