import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/cubit/authentication/authentication_cubit.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/models/AuthenticateModel.dart';
import 'package:buffaloes_farm_management/models/DistrictModel.dart';
import 'package:buffaloes_farm_management/models/ProvinceModel.dart';
import 'package:buffaloes_farm_management/models/SubDistrictModel.dart';
import 'package:buffaloes_farm_management/pages/loading/authenticate_loading_page.dart';
import 'package:buffaloes_farm_management/service/AuthenticationService.dart';
import 'package:buffaloes_farm_management/tools/ThailandProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../home_page.dart';
import '../loading/main_initial_loading_page.dart';
import '../main_home_page.dart';

class InitialFarmPage extends StatefulWidget {
  const InitialFarmPage({Key? key}) : super(key: key);

  @override
  _InitialFarmPageState createState() => _InitialFarmPageState();
}

class _InitialFarmPageState extends State<InitialFarmPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FlutterSecureStorage storage = const FlutterSecureStorage();


  bool loaded = false;

  TextEditingController farmNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  ProvinceModel? province;
  DistrictModel? district;
  SubDistrictModel? subDistrict;

  bool initial = false;

  load() async {

    String? farm_name =
    await storage.read(key: "farm_name".toUpperCase());

    if(farm_name == null){
      AuthenticateModel? model =
      await AuthenticationService.login(token: auth.currentUser?.uid);

      if (model != null) {
        if (model.access_token != null && model.refresh_token != null) {
          toHomePage();
        }
      }
      setState(() {
        loaded = true;
        initial = true;
      });
    }else {
      toHomePage();
    }


  }

  onSubmit() async {

    setState(() {
      loaded = false;
    });

    FlutterSecureStorage storage = FlutterSecureStorage();
    String? phoneNumber = await storage.read(key: "phone_number".toUpperCase());

    AuthenticateModel? authentication = await AuthenticationService.register(
        farmName: farmNameController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phoneNumber: phoneNumber ?? "",
        token: auth.currentUser?.uid ?? "",
        province: province?.PROVINCE_NAME ?? "",
        district: district?.DISTRICT_NAME ?? "",
        subDistrict: subDistrict?.SUB_DISTRICT_NAME ?? "");

    print("authentication != null: ${authentication != null}");
    if (authentication != null) {
      toHomePage();
    }else {
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    if (loaded) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: kBGColor,
            systemNavigationBarDividerColor: kBGColor,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            statusBarColor: bgButtonColor
            //systemNavigationBarContrastEnforced: true,
            ),
        child: Material(child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
          backgroundColor: bgButtonColor,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              // here the desired height
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: bgButtonColor,
                  statusBarIconBrightness: Brightness.light,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(22),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "รายละเอียดฟาร์ม",
                  style: GoogleFonts.itim(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                titleSpacing: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    context.read<AuthenticationCubit>().signOut(context);
                  },
                ),
              )),
          // floatingActionButtonLocation:
          // FloatingActionButtonLocation.centerFloat,
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () {},
          //   heroTag: null,
          //   backgroundColor: bgButtonColor,
          //   extendedPadding: const EdgeInsets.only(left: 94, right: 94),
          //   extendedIconLabelSpacing: 12,
          //   elevation: 0,
          //   splashColor: bgButtonColor.withOpacity(0.4),
          //   shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(14))),
          //   label: Text("ยืนยัน",
          //       style: GoogleFonts.itim(
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 18)),
          //   icon: Icon(Ionicons.checkmark_outline, color: Colors.white),
          // ),
          body: Container(
              decoration: const BoxDecoration(
                  color: kBGColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(22),
                  )),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              height: MediaQuery.of(context).size.height,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 30),
                children: <Widget>[
                  const SizedBox(height: 20),
                  textField(hint: "ชื่อฟาร์ม",controller: farmNameController),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  textHeader(title: "รายละเอียด"),
                  textField(hint: "ชื่อ",controller: firstNameController),
                  const SizedBox(height: 8),
                  textField(hint: "นามสกุล",controller: lastNameController),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  textHeader(title: "ที่อยู่"),
                  textField(hint: "",controller: addressController),
                  const SizedBox(height: 8),
                  textField(
                      hint: "จังหวัด",
                      value: province?.PROVINCE_NAME,
                      readOnly: true,
                      enabled: true,
                      onTap: () {
                        provinceDialog();
                      }),
                  const SizedBox(height: 8),
                  textField(
                      hint: "อำเภอ",
                      value: district?.DISTRICT_NAME,
                      readOnly: true,
                      enabled: province != null,
                      onTap: () {
                        districtDialog();
                      }),
                  const SizedBox(height: 8),
                  textField(
                      hint: "ตำบล",
                      value: subDistrict?.SUB_DISTRICT_NAME,
                      readOnly: true,
                      enabled: district != null,
                      onTap: () {
                        subDistrictDialog();
                      }),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  button(
                      enabled: isEnabledConfirmButton(),
                      title: "ยืนยัน",
                      function: () {
                        onSubmit();
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
        )),)
      );
    } else if(initial == false) {
      return const MainInitialLoadingPage();
    } else {
      return const AuthenticateLoadingPage();
    }
  }

  isEnabledConfirmButton(){
    if(farmNameController.text.isNotEmpty && firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty && subDistrict != null){
      return true;
    }
    return false;
  }

  provinceDialog() async {
    List<ProvinceModel> provinces = await ThailandProvider.provinces(context);
    openDialog(provinces);
  }

  districtDialog() async {
    List<DistrictModel> districts = await ThailandProvider.districts(context,
        provinceId: province?.PROVINCE_ID);
    openDialog(districts);
  }

  subDistrictDialog() async {
    List<SubDistrictModel> subDistricts = await ThailandProvider.subDistricts(
        context,
        provinceId: district?.PROVINCE_ID,
        districtId: district?.DISTRICT_ID);
    openDialog(subDistricts);
  }

  openDialog(List data) async {
    showBarModalBottomSheet(
      context: context,
      enableDrag: true,
      backgroundColor: kBGColor,
      isDismissible: false,
      builder: (context) => Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        child: Scaffold(
            backgroundColor: kBGColor,
            // appBar: PreferredSize(
            //     preferredSize: const Size.fromHeight(50.0),
            //     child: Container(
            //       color: kBGColor,
            //       padding: const EdgeInsets.only(
            //           left: 10, right: 10, top: 0, bottom: 10),
            //       child: textField(hint: "จังหวัด"),
            //     )),
            body: ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              itemBuilder: (BuildContext context, int index) {
                var slot = data[index];
                if (slot is ProvinceModel) {
                  return provinceTile(slot);
                }
                if (slot is DistrictModel) {
                  return districtTile(slot);
                }
                if (slot is SubDistrictModel) {
                  return subDistrictTile(slot);
                }

                return Container();
              },
              itemCount: data.length,
            )),
      ),
    );
  }

  Widget provinceTile(ProvinceModel data) {
    return ListTile(
      onTap: () {
        setState(() {
          province = data;
          district = null;
          subDistrict = null;
        });
        Navigator.pop(context);
      },
      title: Text(
        data.PROVINCE_NAME ?? "",
        style: GoogleFonts.itim(color: Colors.black, fontSize: 20),
      ),
    );
  }

  Widget districtTile(DistrictModel data) {
    return ListTile(
      onTap: () {
        setState(() {
          district = data;
          subDistrict = null;
        });
        Navigator.pop(context);
      },
      title: Text(
        data.DISTRICT_NAME ?? "",
        style: GoogleFonts.itim(color: Colors.black, fontSize: 20),
      ),
    );
  }

  Widget subDistrictTile(SubDistrictModel data) {
    return ListTile(
      onTap: () {
        setState(() {
          subDistrict = data;
        });
        Navigator.pop(context);
      },
      title: Text(
        data.SUB_DISTRICT_NAME ?? "",
        style: GoogleFonts.itim(color: Colors.black, fontSize: 20),
      ),
    );
  }

  Widget textHeader({required String title}) {
    return Container(
        height: 20,
        margin: const EdgeInsets.only(
          top: 0,
          bottom: 6,
          left: 6,
        ),
        child: Text(title,
            style: GoogleFonts.itim(
                fontSize: 16, color: const Color(0xFF8F8F8F))));
  }

  Widget textField(
      {TextEditingController? controller,
      String? value,
      bool readOnly = false,
      Function? onTap,
      bool enabled = true,
      required String hint}) {
    return Container(
        height: 44,
        margin: const EdgeInsets.only(top: 0),
        child: TextFormField(
          readOnly: readOnly,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          controller: controller ?? TextEditingController(text: value),
          style: textFieldStyle,
          //maxLength: 10,
          // inputFormatters: [
          //   MaskedInputFormatter('###-###-####')
          // ],
          //initialValue: value,

          onTap: () {
            onTap?.call();
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: hintText,
            floatingLabelStyle: labelText,
            fillColor: enabled ? Colors.white : bgDisabledTextFieldColor,
            filled: true,
            hintStyle: hintText,
            contentPadding: fieldSearchPadding,
            enabledBorder: textFieldInputBorder,
            disabledBorder: textFieldInputBorder,
            focusedBorder: textFieldInputBorder,
          ),
        ));
  }

  Widget button(
      {Function? function, required String title, bool enabled = true}) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: 44,
      margin: const EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: enabled ? navyButtonStyle : navyButtonDisabledStyle,
        onPressed: enabled
            ? () {
                function?.call();
              }
            : null,
        child: Text(
          title,
          style: whiteTextButton,
        ),
      ),
    );
  }

  toHomePage(){
    context.read<HomeCubit>().farm(context);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainHomePage()),
            (Route<dynamic> route) => false);
  }
}
