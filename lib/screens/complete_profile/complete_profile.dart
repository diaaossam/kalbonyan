import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_admin_layout/main_admin_layout.dart';
import 'package:kalbonyan/main_layout/main_layout.dart';
import 'package:kalbonyan/screens/complete_profile/cubit/complete_cubit.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/helper/methods.dart';
import 'package:kalbonyan/widget/custom_button.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

import '../../shared/helper/mangers/colors.dart';
import '../../widget/app_text.dart';
import '../admin/pick_location_screen/pick_location_screen.dart';

class CompleteProfile extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var name = TextEditingController();
  var id = TextEditingController();
  var phone = TextEditingController();
  var joinNumber = TextEditingController();
  var permitNumber = TextEditingController();
  var company = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteCubit()..getUserInfo(),
      child: BlocConsumer<CompleteCubit, CompleteState>(
        listener: (context, state) {
          if(state is SuccessRequestPermmsion){
            navigateToAndFinish(context,PickLocationsScreen());
          }
        },
        builder: (context, state) {
          CompleteCubit cubit = CompleteCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: AppText(
                  text: "تسجيل الدخول",
                  color: Colors.white,
                  textSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            body: state is GetUserInfoLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfigManger.bodyHeight * 0.03),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.1),
                        Align(
                            alignment: AlignmentDirectional.topStart,
                            child: AppText(
                              text: 'اهلا بك !',
                              color: ColorsManger.black,
                              fontWeight: FontWeight.w700,
                            )),
                        Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Row(
                              children: [
                                AppText(
                                  text:
                                      'أهلا بك قم بملء البيانات التالية لإتمام ',
                                  color: ColorsManger.black,
                                  fontWeight: FontWeight.w500,
                                  textSize: 16,
                                ),
                                AppText(
                                  text: 'تسجيل الدخول',
                                  fontWeight: FontWeight.w500,
                                  textSize: 16,
                                  color: ColorsManger.darkPrimary,
                                ),
                              ],
                            )),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                        CustomTextFormField(
                          controller: name..text = cubit.userModel!.name!,
                          isEnable: false,
                          hintText: "إسم الحاج كاملاً",
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                        CustomTextFormField(
                          controller: id..text = cubit.userModel!.id!,
                          isEnable: false,
                          hintText: "رقم الهوية الوطنية",
                          type: TextInputType.number,
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                        CustomTextFormField(
                          controller: phone..text = cubit.userModel!.phone!,
                          type: TextInputType.phone,
                          isEnable: false,
                          hintText: "رقم الجوال",
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                        CustomTextFormField(
                          controller: joinNumber..text = cubit.userModel!.joinNumber!,
                          isEnable: false,
                          type: TextInputType.number,
                          hintText: "رقم الإنضمام",
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                        // DropDownLevel(cubit: cubit),
                        CustomTextFormField(
                          controller: company..text = cubit.userModel!.companyName!,
                          isEnable: false,
                          type: TextInputType.number,
                          hintText: "رقم الإنضمام",
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                        CustomTextFormField(
                          controller: permitNumber..text = cubit.userModel!.permitNumber!,
                          isEnable: false,
                          type: TextInputType.number,
                          hintText: "رقم التصريح",
                        ),
                        SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                        CustomButton(
                            press: ()async {
                              if(cubit.userModel!.isAdmin == true){
                               await  cubit.setUpPermissions();
                              }else{
                                navigateToAndFinish(context, const MainLayout());
                              }

                            },
                            text: "تأكيد البيانات",
                            weight: FontWeight.w800)
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
