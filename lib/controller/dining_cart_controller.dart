import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiningCartController extends GetxController{
  String diningUserName='';
  String diningUserMobileNumber='';
  String diningNotes='';

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController notesController = TextEditingController();
}