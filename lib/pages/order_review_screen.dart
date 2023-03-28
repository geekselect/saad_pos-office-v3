import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos/controller/auth_controller.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/app_lable_widget.dart';
import 'package:pos/utils/app_toolbar.dart';
import 'package:pos/utils/constants.dart';
import 'package:pos/utils/rounded_corner_app_button.dart';

class OrderReviewScreen extends StatefulWidget {
  final int? orderId;

  const OrderReviewScreen({Key? key, this.orderId}) : super(key: key);

  @override
  _OrderReviewScreenState createState() => _OrderReviewScreenState();
}

class Item {
  const Item(this.name, this.icon);

  final String name;
  final Icon icon;
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  /// 😠 😕 😐 ☺ 😍
  int radioindex = -1;

  String? strCountryCode = '+61';

  bool isFirst = true, isSecond = false, isThird = false, isAllAdded = false;

  final picker = ImagePicker();

  final _textContactNo = TextEditingController();
  final _textComment = TextEditingController();

  List<File> _imageList = [];
  final _formKey =  GlobalKey<FormState>();
  List<String> _listBase64String = [];

  double orderRate = 0;

  @override
  Widget build(BuildContext context) {
    _textContactNo.text = AuthController.sharedPreferences!.getString(Constants.loginPhone) ?? '';
    return SafeArea(
      child: Scaffold(
          appBar: ApplicationToolbar(
            appbarTitle: 'Order Review',
          ),
          backgroundColor: Color(0xFFFAFAFA),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/ic_background_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: ScreenUtil().setHeight(150),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('images/ic_review_start.png'),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                                    child: Text(
                                      'Give Star',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Center(
                                    child: RatingBar.builder(
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      glow: false,
                                      itemSize: ScreenUtil().setWidth(50),
                                      allowHalfRating: true,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (double rating) {
                                        setState(() => orderRate = rating);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(5),
                                        bottom: ScreenUtil().setHeight(5),
                                        top: ScreenUtil().setHeight(15)),
                                    child: Text(
                                      'Review This Food',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    height: ScreenUtil().setHeight(130),
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: _textComment,
                                          keyboardType: TextInputType.text,
                                          validator: kvalidateFeedbackComment,
                                          decoration: InputDecoration(
                                              hintText: 'Add Your Valuable Feedback',
                                              errorStyle: TextStyle(
                                                  fontFamily: Constants.appFontBold,
                                                  color: Colors.red),
                                              border: InputBorder.none),
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontFamily: Constants.appFont,
                                              fontSize: ScreenUtil().setSp(14),
                                              color: Color(
                                                Constants.colorGray,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      children: [
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: _imageList.length > 0
                                              ? Image.file(
                                                  _imageList[0],
                                            width: ScreenUtil().setWidth(60),
                                            height: ScreenUtil().setHeight(60),
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                            width: ScreenUtil().setWidth(60),
                                            height: ScreenUtil().setHeight(60),
                                                ),
                                        ),
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: _imageList.length > 1
                                              ? Image.file(
                                                  _imageList[1],
                                            width: ScreenUtil().setWidth(60),
                                            height: ScreenUtil().setHeight(60),
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                            width: ScreenUtil().setWidth(60),
                                            height: ScreenUtil().setHeight(60),
                                                ),
                                        ),
                                        Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: _imageList.length > 2
                                              ? Image.file(
                                                  _imageList[2],
                                                  width: ScreenUtil().setWidth(60),
                                                  height: ScreenUtil().setHeight(60),
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: ScreenUtil().setWidth(60),
                                                  height: ScreenUtil().setHeight(60),
                                                ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (!isAllAdded) {
                                              if (isFirst) {
                                                _showPicker(context, 0);
                                              } else if (isSecond) {
                                                _showPicker(context, 1);
                                              } else if (isThird) {
                                                _showPicker(context, 2);
                                              }
                                            } else {
                                              Constants.toastMessage(
                                                  'Max 3 Image');
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10,top: 5),
                                            child: DottedBorder(
                                              borderType: BorderType.RRect,
                                              radius: Radius.circular(16),
                                              strokeWidth: 2,
                                              dashPattern: [8, 4],
                                              color: Color(0xffdddddd),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.all(Radius.circular(12)),
                                                child: Container(
                                                  height: ScreenUtil().setHeight(60),
                                                  width: ScreenUtil().setWidth(60),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: SvgPicture.asset(
                                                      'images/ic_plus1.svg',
                                                      color: Color(0xffdddddd),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(20),
                                  ),
                                  AppLableWidget(
                                    title: 'Contact Number',
                                  ),
                                  Row(
                                    children: [
                                      // Expanded(
                                      //   child: Card(
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(15.0),
                                      //     ),
                                      //     elevation: 5.0,
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                                      //       child: CountryCodePicker(
                                      //         enabled: false,
                                      //         onChanged: (c) {
                                      //           setState(() {
                                      //             strCountryCode = c.dialCode;
                                      //           });
                                      //         },
                                      //         // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                      //         initialSelection: 'AU',
                                      //         favorite: ['+61', 'AU'],
                                      //         hideMainText: true,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      Expanded(
                                        flex: 3,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          elevation: 5.0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      enabled: false,
                                                      style: TextStyle(
                                                        fontFamily: Constants.appFont,
                                                      ),
                                                      decoration: InputDecoration(
                                                         // hintText: strCountryCode,
                                                          hintStyle: TextStyle(
                                                              color: Color(Constants.colorHint)),
                                                          border: InputBorder.none),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(
                                                        0, 10.0, 10.0, 10.0),
                                                    child: VerticalDivider(
                                                      color: Colors.black54,
                                                      width: 5.0,
                                                      thickness: 1.0,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: TextFormField(
                                                      enabled: false,
                                                      controller: _textContactNo,
                                                      validator: kvalidateCotactNum,
                                                      style: TextStyle(
                                                        fontFamily: Constants.appFont,
                                                      ),
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(
                                                          errorStyle: TextStyle(
                                                              fontFamily: Constants.appFontBold,
                                                              color: Colors.red),
                                                          hintText: '3360010099',
                                                          hintStyle: TextStyle(
                                                              color: Color(Constants.colorHint)),
                                                          border: InputBorder.none),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(50),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: RoundedCornerAppButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          print(_listBase64String.toString());
                                          print(radioindex);
                                          if (orderRate != 0) {
                                            //int rate = radioindex + 1;
                                            callShareAppFeedback(orderRate);
                                          } else {
                                            Constants.toastMessage(
                                                'Please Give Star');
                                          }
                                        } else {
                                          setState(() {
                                            // validation error
                                          });
                                        }
                                      },
                                      btnLabel: 'Submit It',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  String? kvalidateCotactNum(String? value) {
    if (value!.length == 0) {
      return 'Contact Number Required';
    } else if (value.length > 10) {
      return 'Contact Number Not Valid';
    } else
      return null;
  }

  String? kvalidateFeedbackComment(String? value) {
    if (value!.length == 0) {
      return 'Feedback Comment Required';
    } else
      return null;
  }

  bool isCurrentDateInRange(DateTime startDate, DateTime endDate) {
    final currentDate = DateTime.now();
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }

  _imgFromGallery(int pos) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageList.add(File(pickedFile.path));
        List<int> imageBytes = _imageList[pos].readAsBytesSync();
        _listBase64String.add(base64Encode(imageBytes));

        if (pos == 0) {
          isFirst = false;
          isSecond = true;
        } else if (pos == 1) {
          isSecond = false;
          isThird = true;
        } else if (pos == 2) {
          isThird = false;
          isAllAdded = true;
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImage(int pos) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageList.add(File(pickedFile.path));
        List<int> imageBytes = _imageList[pos].readAsBytesSync();
        _listBase64String.add(base64Encode(imageBytes));
        if (pos == 0) {
          isFirst = false;
          isSecond = true;
        } else if (pos == 1) {
          isSecond = false;
          isThird = true;
        } else if (pos == 2) {
          isThird = false;
          isAllAdded = true;
        }
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context, int pos) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child:  Wrap(
              children: <Widget>[
                 ListTile(
                    leading:  Icon(Icons.photo_library),
                    title:  Text(
                      'Photo Library',
                      style: TextStyle(fontFamily: Constants.appFont),
                    ),
                    onTap: () {
                      _imgFromGallery(pos);
                      Navigator.of(context).pop();
                    }),
                 ListTile(
                  leading:  Icon(Icons.photo_camera),
                  title:  Text(
                    'Camera',
                    style: TextStyle(fontFamily: Constants.appFont),
                  ),
                  onTap: () {
                    getImage(pos);
                    Navigator.of(context).pop();
                  },
                ),
                 ListTile(
                  leading:  Icon(Icons.close),
                  title:  Text(
                    'Cancel',
                    style: TextStyle(fontFamily: Constants.appFont),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<BaseModel<CommenRes>> callShareAppFeedback(double rate) async {
    CommenRes response;
    try{
      Map body = {
        'rate': rate.toString(),
        'comment': _textComment.text,
        'image': _listBase64String,
        'order_id': widget.orderId,
        'contact': _textContactNo.text,
      };
      response  = await RestClient(await RetroApi().dioData()).addReview(body);
      print(response.success);
      // Constants.hideDialog(context);
      if (response.success!) {
        Constants.toastMessage(response.data!);
        Navigator.pop(context);
      } else {
        Constants.toastMessage(response.data!);
      }

    }catch (error, stacktrace) {

      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
