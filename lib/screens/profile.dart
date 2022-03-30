import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/model/UpdateProfile.dart';
import 'package:doctro/model/doctor_profile.dart';
import 'package:doctro/model/update_profileimage.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/EducationCertifiacate.dart';
import 'package:doctro/model/EducationModel.dart';
import 'package:doctro/model/categories.dart';
import 'package:doctro/model/Treatment.dart';
import 'package:doctro/model/experties.dart';
import 'package:doctro/model/hospital.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

//profile image
String? name;
String? msg = "";

//Choose Images
String? image;

class _ProfileScreen extends State<ProfileScreen> {
  Future? doctorLoader;

  //Add List Data
  List<EducationModel> educationList = [];
  List<EducationCertificate> certificateList = [];

  bool oldPassword = false;

  //alertdialog
  TextEditingController _degree = TextEditingController();
  TextEditingController _college = TextEditingController();
  TextEditingController _completeyear = TextEditingController();
  TextEditingController _certificate = TextEditingController();
  TextEditingController _year = TextEditingController();

  String calldegree = '';
  String callcollege = '';
  String callyear = '';
  String callcertificate = '';
  String callcertificateyear = '';
  String valuedegree = '';
  String valuecollege = '';
  String valueyear = '';
  String certificate = '';
  String certificateyear = '';

  //Select Dob
  DateTime? _selectedDate;
  String newDateApiPass = "";
  String? showFormate = '';
  var temp;

  //Set Stepper
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  //Doctor Profile Controller
  TextEditingController _pDegree = TextEditingController();
  TextEditingController _pExperience = TextEditingController();
  TextEditingController _pStartTime = TextEditingController();
  TextEditingController _pEndTime = TextEditingController();
  TextEditingController _pTimeSlot = TextEditingController();
  TextEditingController _pAppointmentFees = TextEditingController();
  TextEditingController _pName = TextEditingController();
  TextEditingController _pDob = TextEditingController();
  TextEditingController _pDesc = TextEditingController();
  TextEditingController _pCollege = TextEditingController();
  TextEditingController _pCollegeYear = TextEditingController();
  TextEditingController _pCertificate = TextEditingController();
  TextEditingController _pCertificateYear = TextEditingController();
  TextEditingController _pBasedOn = TextEditingController();

  //Set Open Drawer
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //Set List Data Hospital
  List<Hospitalname> hospitalreq = [];
  Hospitalname? _valueHospital;

  //Set List Data Treatment
  List<TreatmentData> treatmentreq = [];
  TreatmentData? _valueTreatment;

  //Set List Data Category
  List<CategoriesData> categoryreq = [];
  CategoriesData? _valueCategories;

  //Set List Data Expertise
  List<Expert> expertreq = [];
  Expert? _valueExperties;

  //update user image
  File? proImage;
  final picker = ImagePicker();

  //Set DropDown Popular Field
  List<String> popular = [];
  String? _selectedpopular;

  //Set DropDown For Male/Female
  List<String> gender = [];
  String? _genderSelect;

  int? isfilled;

  //Set MediaQuery Height / Width
  double? width;
  late double height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gender = [
      getTranslated(context, gender_male).toString(),
      getTranslated(context, gender_female).toString(),
    ];

    popular = [
      getTranslated(context, popular_yes).toString(),
      getTranslated(context, popular_no).toString(),
    ];
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      doctorLoader = treatment();
      hospital();
      name = SharedPreferenceHelper.getString(Preferences.name);
      isfilled = SharedPreferenceHelper.getInt(Preferences.is_filled);
      image = SharedPreferenceHelper.getString(Preferences.image);
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width! * 0.3, 170),
        child: SafeArea(
          top: true,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.02),
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(left: width! * 0.92),
                  child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 28,
                    ),
                    onTap: () {
                      if (_currentStep == 0) Navigator.pop(context);
                      if (_currentStep == 1) cancel();
                      if (_currentStep == 2) cancel();
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width! * 0.04, right: width! * 0.04),
                child: Row(
                  children: [
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: Stack(
                        children: [
                          proImage != null
                              ? Container(
                                  width: 80,
                                  height: 80,
                                  decoration: new BoxDecoration(shape: BoxShape.circle, boxShadow: [
                                    new BoxShadow(
                                      color: imageBorder,
                                      blurRadius: 1.0,
                                    ),
                                  ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.file(
                                      proImage!,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 82,
                                  height: 82,
                                  decoration: new BoxDecoration(shape: BoxShape.circle, boxShadow: [
                                    new BoxShadow(
                                      color: imageBorder,
                                      blurRadius: 1.5,
                                    ),
                                  ]),
                                  child: CachedNetworkImage(
                                    imageUrl: SharedPreferenceHelper.getString(Preferences.image),
                                    imageBuilder: (context, imageProvider) => CircleAvatar(
                                      backgroundColor: colorWhite,
                                      child: CircleAvatar(
                                        radius: 36,
                                        backgroundImage: imageProvider,
                                      ),
                                    ),
                                    placeholder: (context, url) => CircularProgressIndicator(color: loginButton),
                                    errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                  ),
                                ),
                          Positioned(
                            top: 52,
                            left: 58,
                            child: GestureDetector(
                              onTap: () {
                                chooseProfileImage();
                              },
                              child: CircleAvatar(
                                  backgroundColor: colorWhite,
                                  radius: 13,
                                  child: Icon(
                                    Icons.add,
                                    color: loginButton,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width! * 0.05, right: width! * 0.05),
                      child: Text(
                        "$name",
                        style: TextStyle(fontSize: width! * 0.047, color: hintColor),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: doctorLoader,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                width: width,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stepper(
                          type: stepperType,
                          physics: ScrollPhysics(),
                          onStepCancel: null,
                          currentStep: _currentStep,
                          onStepTapped: (step) => tapped(step),
                          onStepContinue: continued,
                          steps: <Step>[
                            // Step 1 //
                            Step(
                              title: new Text(
                                getTranslated(context, profile_personal_information).toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              content: GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                },
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(top: width! * 0.01),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(context, profile_doctor_name).toString(),
                                                style: TextStyle(fontSize: width! * 0.04, color: hintColor),
                                              ),
                                              TextFormField(
                                                controller: _pName,
                                                enableInteractiveSelection: false,
                                                keyboardType: TextInputType.name,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                                ],
                                                style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                decoration: InputDecoration(
                                                  hintText: getTranslated(context, profile_enter_name_hint).toString(),
                                                  hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                                ),
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return getTranslated(context, please_enter_profile_valid_name).toString();
                                                  } else if (value.trim().length < 1) {
                                                    return getTranslated(context, please_enter_valid_name).toString();
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String? name) {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(top: width! * 0.01),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(context, profile_date_of_birth).toString(),
                                                style: TextStyle(fontSize: width! * 0.04, color: hintColor),
                                              ),
                                              TextFormField(
                                                textCapitalization: TextCapitalization.words,
                                                enableInteractiveSelection: false,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: hintColor,
                                                ),
                                                controller: _pDob,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: getTranslated(context, profile_date_of_birth_hint).toString(),
                                                  hintStyle: TextStyle(
                                                    fontSize: width! * 0.04,
                                                    color: hintColor,
                                                  ),
                                                ),
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return getTranslated(context, please_enter_birth_date).toString();
                                                  }
                                                  return null;
                                                },
                                                onTap: () {
                                                  _selectDate(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(top: width! * 0.02),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(context, profile_gender).toString(),
                                                style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                              ),
                                              StatefulBuilder(
                                                builder: (context, myState) {
                                                  return DropdownButtonFormField<String>(
                                                    hint: Text(getTranslated(context, profile_gender_hint).toString()),
                                                    value: _genderSelect,
                                                    isExpanded: true,
                                                    iconSize: 35,
                                                    items: gender.map((genders) {
                                                      return DropdownMenuItem<String>(
                                                        child: new Text(genders),
                                                        value: genders,
                                                      );
                                                    }).toList(),
                                                    onSaved: (value) {
                                                      myState(() {
                                                        _genderSelect = value;
                                                      });
                                                    },
                                                    onChanged: (newValue) {
                                                      myState(() {
                                                        _genderSelect = newValue;
                                                      });
                                                    },
                                                    validator: (value) {
                                                      if (_genderSelect == null) {
                                                        return getTranslated(context, please_enter_profile_valid_name).toString();
                                                      }
                                                      return null;
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Main Hospital Data List
                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(top: width! * 0.01),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(context, profile_hospital).toString(),
                                                style: TextStyle(fontSize: width! * 0.04, color: hintColor),
                                              ),
                                              DropdownButtonFormField<Hospitalname>(
                                                isExpanded: true,
                                                iconSize: 35,
                                                value: _valueHospital,
                                                items: hospitalreq
                                                    .map(
                                                      (label) => DropdownMenuItem<Hospitalname>(
                                                        child: Text(label.name!),
                                                        value: label,
                                                      ),
                                                    )
                                                    .toList(),
                                                onChanged: (Hospitalname? value) {
                                                  setState(() {
                                                    _valueHospital = value;
                                                  });
                                                },
                                                hint: Text(getTranslated(context, profile_hospital_hint).toString()),
                                                validator: (value) {
                                                  if (_valueHospital == null) {
                                                    return getTranslated(context, please_select_hospital).toString();
                                                  }
                                                  return null;
                                                },
                                              )
                                            ],
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.topLeft,
                                          margin: EdgeInsets.only(top: width! * 0.02),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(context, profile_description).toString(),
                                                style: TextStyle(fontSize: width! * 0.04, color: hintColor),
                                              ),
                                              TextFormField(
                                                controller: _pDesc,
                                                enableInteractiveSelection: false,
                                                keyboardType: TextInputType.name,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z &.,]")),
                                                ],
                                                style: TextStyle(fontSize: 14, color: passwordVisibility),
                                                decoration: InputDecoration(
                                                  hintText: getTranslated(context, profile_description_hint).toString(),
                                                  hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                                ),
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return getTranslated(context, please_enter_description).toString();
                                                  } else if (value.trim().length < 1) {
                                                    return getTranslated(context, please_enter_valid_description).toString();
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String? name) {},
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
                            ),
                            // Step 2 //
                            Step(
                              title: new Text(
                                getTranslated(context, profile_education_information).toString(),
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                              content: SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.01),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_degree).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              controller: _pDegree,
                                              enableInteractiveSelection: false,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_degree_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_degree).toString();
                                                } else if (value.trim().length < 1) {
                                                  return getTranslated(context, please_enter_valid_degree).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.01),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_college).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pCollege,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_college_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_college).toString();
                                                } else if (value.trim().length < 1) {
                                                  return getTranslated(context, please_enter_valid_college).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.01),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_year_of_completion).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pCollegeYear,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_year_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_year_of_completion).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  insetPadding: EdgeInsets.all(10),
                                                  title: Text(getTranslated(context, profile_education_certificate).toString()),
                                                  content: Container(
                                                    height: height * 0.3,
                                                    width: width! * 1.0,
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          onChanged: (value) {
                                                            setState(() {
                                                              valuedegree = value;
                                                            });
                                                          },
                                                          controller: _degree,
                                                          decoration: InputDecoration(
                                                              hintText: getTranslated(context, profile_dialog_degree_hint).toString()),
                                                        ),
                                                        TextField(
                                                          onChanged: (value) {
                                                            setState(() {
                                                              valuecollege = value;
                                                            });
                                                          },
                                                          controller: _college,
                                                          decoration: InputDecoration(
                                                              hintText: getTranslated(context, profile_dialog_education).toString()),
                                                        ),
                                                        TextField(
                                                          onChanged: (value) {
                                                            setState(() {
                                                              valueyear = value;
                                                            });
                                                          },
                                                          controller: _completeyear,
                                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                          inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  getTranslated(context, profile_dialog_year_of_completion).toString()),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    OutlinedButton(
                                                      child: Text(getTranslated(context, profile_dialog_ok_button).toString()),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (_degree.text.isNotEmpty &&
                                                              _college.text.isNotEmpty &&
                                                              _completeyear.text.isNotEmpty) {
                                                            String addDegree = "";
                                                            String addCollege = "";
                                                            String addYear = "";
                                                            calldegree = valuedegree;
                                                            callcollege = valuecollege;
                                                            callyear = valueyear;
                                                            addDegree = _pDegree.text + "," + _degree.text;
                                                            addCollege = _pCollege.text + "," + _college.text;
                                                            addYear = _pCollegeYear.text + "," + _completeyear.text;

                                                            _pDegree.text = addDegree;
                                                            _pCollege.text = addCollege;
                                                            _pCollegeYear.text = addYear;
                                                            _degree.clear();
                                                            _college.clear();
                                                            _completeyear.clear();
                                                            Navigator.pop(context);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                              msg: getTranslated(context, please_fill_data).toString(),
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.BOTTOM,
                                                            );
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: height * 0.01),
                                          height: width! * 0.10,
                                          width: width! * 0.35,
                                          child: Row(
                                            children: [
                                              Card(
                                                color: divider,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                                                child: Icon(Icons.add, size: width! * 0.06, color: loginButton),
                                              ),
                                              Text(getTranslated(context, profile_add_more_button).toString())
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.03),
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, profile_dialog_certificate).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            )
                                          ],
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _pCertificate,
                                        enableInteractiveSelection: false,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(fontSize: 14, color: passwordVisibility),
                                        decoration: InputDecoration(
                                          hintText: getTranslated(context, profile_dialog_certificate_hint).toString(),
                                          hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                        ),
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return getTranslated(context, dialog_please_enter_certificate).toString();
                                          } else if (value.trim().length < 1) {
                                            return getTranslated(context, dialog_please_enter_valid_certificate).toString();
                                          }
                                          return null;
                                        },
                                        onSaved: (String? name) {},
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, profile_dialog_certificate_year).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            )
                                          ],
                                        ),
                                      ),
                                      TextFormField(
                                        enableInteractiveSelection: false,
                                        controller: _pCertificateYear,
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                        style: TextStyle(fontSize: 14, color: passwordVisibility),
                                        decoration: InputDecoration(
                                          hintText: getTranslated(context, profile_dialog_certificate_year_hint).toString(),
                                          hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                        ),
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return getTranslated(context, dialog_please_enter_certificate_year).toString();
                                          }
                                          return null;
                                        },
                                        onSaved: (String? name) {},
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: height * 0.02),
                                        height: width! * 0.10,
                                        width: width! * 0.35,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    insetPadding: EdgeInsets.all(10),
                                                    title: Text(getTranslated(context, profile_dialog_certificate).toString()),
                                                    content: Container(
                                                      height: height * 0.2,
                                                      width: width! * 1.0,
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                certificate = value;
                                                              });
                                                            },
                                                            controller: _certificate,
                                                            decoration: InputDecoration(
                                                                hintText: getTranslated(context, profile_dialog_certificate).toString()),
                                                          ),
                                                          TextField(
                                                            onChanged: (value) {
                                                              setState(() {
                                                                certificateyear = value;
                                                              });
                                                            },
                                                            controller: _year,
                                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                            inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                                                            decoration: InputDecoration(
                                                                hintText: getTranslated(context, profile_dialog_year).toString()),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      OutlinedButton(
                                                        child: Text(getTranslated(context, profile_dialog_ok_button).toString()),
                                                        onPressed: () {
                                                          setState(() {
                                                            if (_certificate.text.isNotEmpty && _year.text.isNotEmpty) {
                                                              String addCertificate = "";
                                                              String addCertificateyear = "";
                                                              callcertificate = certificate;
                                                              callcertificateyear = certificateyear;

                                                              addCertificate = _pCertificate.text + "," + _certificate.text;
                                                              addCertificateyear = _pCertificateYear.text + "," + _year.text;
                                                              _pCertificate.text = addCertificate;
                                                              _pCertificateYear.text = addCertificateyear;

                                                              _certificate.clear();
                                                              _year.clear();
                                                              Navigator.pop(context);
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                msg: getTranslated(context, please_fill_data).toString(),
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                gravity: ToastGravity.BOTTOM,
                                                              );
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Row(
                                            children: [
                                              Card(
                                                color: divider,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                                                child: Icon(Icons.add, size: width! * 0.06, color: loginButton),
                                              ),
                                              Text(getTranslated(context, profile_add_more_button).toString())
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
                            ),
                            // Step 3 //
                            Step(
                              title: new Text(
                                getTranslated(context, profile_other_information).toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              content: SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_experience).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pExperience,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [
                                                new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                              ],
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_experience_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_experience).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_appointment_fees).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pAppointmentFees,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [
                                                new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                              ],
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_appointment_fees_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_appointment_fees).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_treatment).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            DropdownButtonFormField<TreatmentData>(
                                              value: _valueTreatment,
                                              isExpanded: true,
                                              focusColor: red,
                                              iconSize: 35,
                                              items: treatmentreq.length > 1
                                                  ? treatmentreq.map((TreatmentData item) {
                                                      return DropdownMenuItem(
                                                        child: Text(item.name!, style: TextStyle(color: hintColor)),
                                                        value: item,
                                                      );
                                                    }).toList()
                                                  : treatmentreq.map((TreatmentData item) {
                                                      return DropdownMenuItem(
                                                        child: Text(item.name!, style: TextStyle(color: hintColor)),
                                                        value: item,
                                                      );
                                                    }).toList(),
                                              onChanged: (value) {
                                                _valueTreatment = value;
                                                categoryreq.clear();
                                                expertreq.clear();
                                                _valueCategories = null;
                                                _valueExperties = null;
                                                setState(() {});
                                                FutureBuilder<BaseModel<Categories>>(
                                                  future: category(value!.id, 0, 0),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState != ConnectionState.done) {
                                                      return Container(
                                                        child: CircularProgressIndicator(),
                                                      );
                                                    } else {
                                                      categoryreq.addAll(snapshot.data!.data!.categoriesData!);
                                                      var data = snapshot.data;

                                                      if (data != null) {
                                                        return Container();
                                                      } else {
                                                        return Container();
                                                      }
                                                    }
                                                  },
                                                );
                                              },
                                              hint: Text(getTranslated(context, profile_treatment_hint).toString()),
                                              validator: (value) {
                                                if (_valueTreatment == null) {
                                                  return getTranslated(context, please_select_treatment).toString();
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_categories).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            DropdownButtonFormField<CategoriesData>(
                                              value: _valueCategories,
                                              isExpanded: true,
                                              focusColor: red,
                                              iconSize: 35,
                                              items: categoryreq.length > 1
                                                  ? categoryreq.map((CategoriesData item) {
                                                      return DropdownMenuItem<CategoriesData>(
                                                        child: Text(item.name!, style: TextStyle(color: hintColor)),
                                                        value: item,
                                                      );
                                                    }).toList()
                                                  : categoryreq.map((CategoriesData item) {
                                                      return DropdownMenuItem<CategoriesData>(
                                                        child: Text(item.name!, style: TextStyle(color: hintColor)),
                                                        value: item,
                                                      );
                                                    }).toList(),
                                              onChanged: (CategoriesData? value) {
                                                setState(() {
                                                  _valueCategories = value;
                                                  FutureBuilder<BaseModel<Experties>>(
                                                    future: expertise(value!.id, 0),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState != ConnectionState.done) {
                                                        return Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      } else {
                                                        categoryreq.clear();
                                                        expertreq.addAll(snapshot.data!.data!.expertiseData!);
                                                        var data = snapshot.data;
                                                        if (data != null) {
                                                          return Container();
                                                        } else {
                                                          return Container();
                                                        }
                                                      }
                                                    },
                                                  );
                                                });
                                              },
                                              hint: Text(getTranslated(context, profile_categories_hint).toString()),
                                              validator: (value) {
                                                if (_valueCategories == null) {
                                                  return getTranslated(context, please_select_categories).toString();
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_expertise).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            DropdownButtonFormField<Expert>(
                                              value: _valueExperties,
                                              isExpanded: true,
                                              focusColor: red,
                                              iconSize: 35,
                                              items: expertreq.length > 1
                                                  ? expertreq.map((Expert item) {
                                                      return DropdownMenuItem<Expert>(
                                                        child: Text(item.name!, style: TextStyle(color: hintColor)),
                                                        value: item,
                                                      );
                                                    }).toList()
                                                  : expertreq.map((Expert item) {
                                                      return DropdownMenuItem<Expert>(
                                                        child: Text(
                                                          item.name!,
                                                          style: TextStyle(color: hintColor),
                                                        ),
                                                        value: item,
                                                      );
                                                    }).toList(),
                                              onChanged: (Expert? value) {
                                                setState(() {
                                                  _valueExperties = value;
                                                  FutureBuilder<BaseModel<Experties>>(
                                                    future: expertise(value!.id, 0),
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState != ConnectionState.done) {
                                                        return Container();
                                                      } else {
                                                        expertreq.clear();
                                                        expertreq.addAll(snapshot.data!.data!.expertiseData!);
                                                        var data = snapshot.data;
                                                        if (data != null) {
                                                          return Container();
                                                        } else {
                                                          return Container();
                                                        }
                                                      }
                                                    },
                                                  );
                                                });
                                              },
                                              hint: Text(getTranslated(context, profile_expertise_hint).toString()),
                                              validator: (value) {
                                                if (_valueExperties == null) {
                                                  return getTranslated(context, please_select_expertise).toString();
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_time_slot).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pTimeSlot,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [
                                                new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                              ],
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_time_slot_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_time_slot).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_based_on).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pBasedOn,
                                              readOnly: true,
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_based_on_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_based_on).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_start_time).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pStartTime,
                                              readOnly: true,
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_start_time_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              onTap: () async {
                                                final TimeOfDay? result = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                    builder: (context, child) {
                                                      return MediaQuery(
                                                          data: MediaQuery.of(context).copyWith(
                                                            // Using 12-Hour format
                                                            alwaysUse24HourFormat: false,
                                                          ),
                                                          // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                          child: child!);
                                                    });
                                                if (result != null) {
                                                  setState(() {
                                                    String data = result.format(context).toLowerCase();
                                                    String str;
                                                    var parts;
                                                    String? startPart;

                                                    int checkData;
                                                    str = data;
                                                    parts = str.split(":");
                                                    startPart = parts[0].trim();
                                                    checkData = int.parse(startPart!);
                                                    if (checkData > 9) {
                                                      _pStartTime.text = result.format(context).toLowerCase();
                                                    } else {
                                                      _pStartTime.text = "0" + result.format(context).toLowerCase();
                                                    }
                                                  });
                                                }
                                              },
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_start_time).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_end_time).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            TextFormField(
                                              enableInteractiveSelection: false,
                                              controller: _pEndTime,
                                              readOnly: true,
                                              style: TextStyle(fontSize: 14, color: passwordVisibility),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(context, profile_end_time_hint).toString(),
                                                hintStyle: TextStyle(fontSize: width! * 0.035, color: passwordVisibility),
                                              ),
                                              onTap: () async {
                                                final TimeOfDay? result = await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay.now(),
                                                    builder: (context, child) {
                                                      return MediaQuery(
                                                          data: MediaQuery.of(context).copyWith(
                                                              // Using 12-Hour format
                                                              alwaysUse24HourFormat: false),
                                                          // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                                                          child: child!);
                                                    });
                                                if (result != null) {
                                                  setState(() {
                                                    String data = result.format(context).toLowerCase();
                                                    String str;
                                                    var parts;
                                                    String? startPart;

                                                    int checkData;
                                                    str = data;
                                                    parts = str.split(":");
                                                    startPart = parts[0].trim();
                                                    checkData = int.parse(startPart!);
                                                    if (checkData > 9) {
                                                      _pEndTime.text = result.format(context).toLowerCase();
                                                    } else {
                                                      _pEndTime.text = "0" + result.format(context).toLowerCase();
                                                    }
                                                  });
                                                }
                                              },
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return getTranslated(context, please_enter_end_time).toString();
                                                }
                                                return null;
                                              },
                                              onSaved: (String? name) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(top: width! * 0.02),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTranslated(context, profile_popular).toString(),
                                              style: TextStyle(fontSize: width! * 0.038, color: hintColor),
                                            ),
                                            DropdownButton(
                                              hint: Text(getTranslated(context, profile_popular).toString()),
                                              value: _selectedpopular == '0'
                                                  ? getTranslated(context, popular_no).toString()
                                                  : getTranslated(context, popular_yes).toString(),
                                              isExpanded: true,
                                              iconSize: 35,
                                              onChanged: (dynamic newValue) {
                                                setState(() {
                                                  _selectedpopular = newValue;
                                                });
                                              },
                                              items: popular.map((popular) {
                                                return DropdownMenuItem(
                                                  child: new Text(popular),
                                                  value: popular,
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
                            ),
                          ],
                          controlsBuilder: (BuildContext context, {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                            return Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(),
                                SizedBox(),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      bottomNavigationBar: Container(
        height: width! * 0.12,
        child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentStep == 0)
                Text(
                  getTranslated(context, profile_continue_button).toString(),
                  style: TextStyle(fontSize: width! * 0.04, color: colorWhite),
                ),
              if (_currentStep == 1)
                Text(
                  getTranslated(context, profile_continue_button).toString(),
                  style: TextStyle(fontSize: width! * 0.04, color: colorWhite),
                ),
              if (_currentStep == 2)
                Text(
                  getTranslated(context, profile_submit_button).toString(),
                  style: TextStyle(fontSize: width! * 0.04, color: colorWhite),
                ),
            ],
          ),
          onPressed: () {
            if (_currentStep == 2) {
              updateprofile();
            }

            List<String> degree = [];
            List<String> college = [];
            List<String> year = [];
            List<String> certificate = [];
            List<String> certificateYear = [];

            if (_formkey.currentState!.validate()) {
              degree = _pDegree.text.toString().split(",");
              college = _pCollege.text.toString().split(',');
              year = _pCollegeYear.text.toString().split(',');

              certificate = _pCertificate.text.toString().split(',');
              certificateYear = _pCertificateYear.text.toString().split(',');

              educationList.clear();
              certificateList.clear();

              for (int i = 0; i < degree.length; i++) {
                EducationModel education = new EducationModel();
                education.degree = degree[i];
                education.college = college[i];
                education.year = year[i];
                educationList.add(education);
              }

              for (int i = 0; i < certificate.length; i++) {
                EducationCertificate certificateData = new EducationCertificate();
                certificateData.certificate = certificate[i];
                certificateData.certificateYear = certificateYear[i];
                certificateList.add(certificateData);
              }
              continued();
            }
          },
        ),
      ),
    );
  }

  Future<BaseModel<UpdateProfile>> updateprofile() async {
    var eeducationList = JsonEncoder().convert(educationList);
    var ccertificateList = JsonEncoder().convert(certificateList);

    //pass date formate
    if (_selectedDate != null) {
      temp = '$_selectedDate';
    } else {
      temp = '$showFormate';
    }

    newDateApiPass = DateUtilforpass().formattedDate(DateTime.parse('$temp'));
    Map<String, dynamic> body = {
      "name": _pName.text,
      "treatment_id": _valueTreatment!.id,
      "category_id": _valueCategories!.id,
      "expertise_id": _valueExperties!.id,
      "hospital_id": _valueHospital!.id,
      "dob": newDateApiPass,
      "gender": _genderSelect,
      "education": eeducationList,
      "certificate": ccertificateList,
      "experience": _pExperience.text,
      "appointment_fees": _pAppointmentFees.text,
      "start_time": _pStartTime.text.toLowerCase(),
      "end_time": _pEndTime.text.toLowerCase(),
      "timeslot": _pTimeSlot.text,
      "desc": _pDesc.text,
      "besdon": _pBasedOn.text,
      "is_popular": _selectedpopular == getTranslated(context, popular_yes).toString() ? 1 : 0
    };
    UpdateProfile response;
    try {
      response = await RestClient(RetroApi().dioData()).updateprofile(body);
      Navigator.pushNamed(context, "loginhome");
      SharedPreferenceHelper.setInt(Preferences.is_filled, 1);
      Fluttertoast.showToast(
        msg: response.msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Doctorprofile>> doctorprofile() async {
    Doctorprofile response;
    try {
      response = await RestClient(RetroApi().dioData()).doctorprofile();
      setState(() {
        var convertDegree;
        var eduCertificate;
        if (response.data!.education != null) {
          convertDegree = json.decode(response.data!.education!);
        }

        if (response.data!.certificate != null) {
          eduCertificate = json.decode(response.data!.certificate!);
        }

        _pName.text = response.data!.name!;
        showFormate = response.data!.dob;
        newDateApiPass = DateUtil().formattedDate(DateTime.parse('$showFormate'));
        _pDob.text = newDateApiPass;

        _genderSelect = response.data!.gender!;

        if (convertDegree != null) {
          for (int i = 0; i < convertDegree.length; i++) {
            //Split Data Condition
            if (_pDegree.text.length == 0) {
              _pDegree.text = _pDegree.text + convertDegree[i]['degree'];
            } else {
              _pDegree.text = _pDegree.text + ',' + convertDegree[i]['degree'];
            }
            if (_pCollege.text.length == 0) {
              _pCollege.text = _pCollege.text + convertDegree[i]['college'];
            } else {
              _pCollege.text = _pCollege.text + ',' + convertDegree[i]['college'];
            }
            if (_pCollegeYear.text.length == 0) {
              _pCollegeYear.text = _pCollegeYear.text + convertDegree[i]['year'];
            } else {
              _pCollegeYear.text = _pCollegeYear.text + ',' + convertDegree[i]['year'];
            }
          }
        }

        if (eduCertificate != null) {
          for (int i = 0; i < eduCertificate.length; i++) {
            if (_pCertificate.text.length == 0) {
              _pCertificate.text = _pCertificate.text + eduCertificate[i]['certificate'];
            } else {
              _pCertificate.text = _pCertificate.text + ',' + eduCertificate[i]['certificate'];
            }

            if (_pCertificateYear.text.length == 0) {
              _pCertificateYear.text = _pCertificateYear.text + eduCertificate[i]['certificate_year'];
            } else {
              _pCertificateYear.text = _pCertificateYear.text + ',' + eduCertificate[i]['certificate_year'];
            }
          }
        }

        _pExperience.text = response.data!.experience!;
        _pAppointmentFees.text = response.data!.appointmentFees!;
        _pTimeSlot.text = response.data!.timeslot!;
        _pStartTime.text = response.data!.startTime!;
        _pEndTime.text = response.data!.endTime!;
        _pBasedOn.text = response.data!.basedOn!;
        _pDesc.text = response.data!.desc!;
        _selectedpopular = response.data!.isPopular.toString();

        for (int i = 0; i < hospitalreq.length; i++) {
          if (response.data!.hospital!.id == hospitalreq[i].id) {
            _valueHospital = hospitalreq[i];
          }
        }

        for (int i = 0; i < treatmentreq.length; i++) {
          if (response.data!.treatmentId == treatmentreq[i].id) {
            _valueTreatment = treatmentreq[i];
            category(_valueTreatment!.id, response.data!.categoryId, response.data!.expertiseId);
          }
        }
        setState(() {});
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Hospitals>> hospital() async {
    Hospitals response;
    try {
      hospitalreq.clear();
      response = await RestClient(RetroApi().dioData()).hospitalrequest();
      setState(() {
        for (int i = 0; i < response.data!.length; i++) {
          hospitalreq.add(response.data![i]);
        }
        doctorprofile();
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Imageupload>> uploadimage() async {
    Map<String, dynamic> body = {
      "image": image,
    };
    Imageupload response;
    try {
      response = await RestClient(RetroApi().dioData()).uploadimage(body);
      setState(() {
        msg = response.data;
        SharedPreferenceHelper.setString(Preferences.image, response.data!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  void proimageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.image, pickedFile.path);
        proImage = File(SharedPreferenceHelper.getString(Preferences.image));
        List<int> imageBytes = proImage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        uploadimage();
      } else {
        print('No image selected.');
      }
    });
  }

  void proimageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.image, pickedFile.path);
        proImage = File(SharedPreferenceHelper.getString(Preferences.image));
        List<int> imageBytes = proImage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        uploadimage();
      } else {
        print('No image selected.');
      }
    });
  }

  void chooseProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      getTranslated(context, choose_image_gallery).toString(),
                    ),
                    onTap: () {
                      proimageFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    getTranslated(context, choose_image_camera).toString(),
                  ),
                  onTap: () {
                    proimageFromCamera();
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

  Future<BaseModel> treatment() async {
    Treatment response;
    try {
      response = await RestClient(RetroApi().dioData()).treatmentrequest();
      setState(() {
        for (int i = 0; i < response.data!.length; i++) {
          treatmentreq.add(response.data![i]);
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Categories>> category(id, categoryId, int? expertiseId) async {
    Categories response;
    try {
      response = await RestClient(RetroApi().dioData()).categoryrequest(id);
      setState(() {
        for (int i = 0; i < response.categoriesData!.length; i++) {
          categoryreq.add(response.categoriesData![i]);
        }

        if (categoryreq.length != 0) {
          for (int i = 0; i < categoryreq.length; i++) {
            if (categoryId == categoryreq[i].id) {
              _valueCategories = categoryreq[i];
              expertise(_valueCategories!.id, expertiseId);
            }
          }
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Experties>> expertise(id, expertiseId) async {
    Experties response;
    try {
      response = await RestClient(RetroApi().dioData()).expertiserequest(id);
      setState(() {
        for (int i = 0; i < response.expertiseData!.length; i++) {
          expertreq.add(response.expertiseData![i]);
        }
        if (expertreq.length != 0) {
          for (int i = 0; i < expertreq.length; i++) {
            if (expertiseId == expertreq[i].id) {
              _valueExperties = expertreq[i];
            }
          }
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[500]!,
              onPrimary: Colors.white,
              surface: Colors.blue[500]!,
              onSurface: Colors.black12,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _pDob
        ..text = DateFormat('dd-MM-yyyy').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: _pDob.text.length, affinity: TextAffinity.upstream),
        );
    }
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

//Pass Date Like this formate  in api
class DateUtilforpass {
  static const DATE_FORMAT = 'yyyy-MM-dd';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}

//Show Date like this formate in User
class DateUtil {
  static const DATE_FORMAT = 'dd-MM-yyyy';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
