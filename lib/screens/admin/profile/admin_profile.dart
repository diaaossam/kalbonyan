import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/screens/admin/profile/widgets/level_drop_admin.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/methods.dart';
import 'package:kalbonyan/widget/custom_button.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

import '../../../shared/helper/mangers/size_config.dart';

class AdminProfile extends StatelessWidget {


  var name = TextEditingController();
  var id = TextEditingController();
  var phone = TextEditingController();
  var joinNumber = TextEditingController();
  var permitNumber = TextEditingController();
  var company = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainAdminCubit, MainAdminState>(
        listener: (context, state) {
      if (state is DeleteAccountSuccess) {
        showToast(msg: "تم حذف الحساب بنجاح", color: Colors.red);
      } else if (state is UpdateUserDataSuccess) {
        showToast(msg: "تم تعديل بيانات الحساب بنجاح", color: Colors.green);
      }
    }, builder: (context, state) {
      MainAdminCubit cubit = MainAdminCubit.get(context);
      return cubit.userModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfigManger.bodyHeight * 0.03),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                      CustomTextFormField(
                        controller: name..text = cubit.userModel!.name!,
                        hintText: "إسم الحاج كاملاً",
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "إسم الحاج مطلوب";
                          }
                        },
                      ),
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                      CustomTextFormField(
                        controller: id..text = cubit.userModel!.id!,
                        hintText: "رقم الهوية الوطنية",
                        type: TextInputType.number,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "رقم الهوية مطلوب";
                          }
                        },
                      ),
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                      CustomTextFormField(
                        controller: phone..text = cubit.userModel!.phone!,
                        type: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "رقم الجوال مطلوب";
                          }
                        },
                        hintText: "رقم الجوال",
                      ),
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                      CustomTextFormField(
                        controller: joinNumber
                          ..text = cubit.userModel!.joinNumber!,
                        type: TextInputType.number,
                        hintText: "رقم الإنضمام",
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "رقم الإنضمام مطلوب";
                          }
                        },
                      ),
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                      DropDownAdminLevel(
                          cubit: cubit,
                          hintText: cubit.userModel!.companyName!),
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                      CustomTextFormField(
                        controller: permitNumber
                          ..text = cubit.userModel!.permitNumber!,
                        type: TextInputType.number,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "رقم التصريح مطلوب";
                          }
                        },
                        hintText: "رقم التصريح",
                      ),
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.04),
                      CustomButton(
                          press: () async {
                            if (formKey.currentState!.validate()) {
                              String? token =
                                  await FirebaseMessaging.instance.getToken();
                              UserModel userModel = UserModel(
                                  userId: cubit.getCurrentUserUid(),
                                  name: name.text,
                                  id: id.text,
                                  phone: phone.text,
                                  joinNumber: joinNumber.text,
                                  companyName:
                                      cubit.companyName ?? company.text,
                                  permitNumber: permitNumber.text,
                                  token: token,
                                  isAdmin: false);

                              if (userModel == cubit.userModel!) {
                                showToast(
                                    msg: "لم يتم تحديث البيانات",
                                    color: Colors.red);
                              } else {
                                cubit.updateUserInfo(userModel: userModel);
                              }
                            }
                          },
                          text: "حفظ",
                          weight: FontWeight.w800),
                      SizedBox(height: SizeConfigManger.bodyHeight * 0.01),
                      CustomButton(
                          backgroundColor: ColorsManger.grey,
                          press: () async => await cubit.deleteUserAccount(),
                          text: "حذف الحساب",
                          weight: FontWeight.w800),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
