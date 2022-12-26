import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/main_layout/cubit/main_cubit.dart';
import 'package:kalbonyan/screens/complete_profile/cubit/complete_cubit.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/widget/app_text.dart';

class DropDownAdminLevel extends StatelessWidget {
  MainAdminCubit cubit;
  String hintText;

  DropDownAdminLevel({required this.cubit,required this.hintText});


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            buttonPadding: EdgeInsetsDirectional.only(end: 20, start: 30),
            buttonDecoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            hint: AppText(text: "$hintText",color: ColorsManger.black),
            items: cubit.companiesList
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Center(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ))
                .toList(),
            value: cubit.companyName,
            onChanged: (value) {
              cubit.chooseCompanyName(value: value as String);
            },
            buttonHeight: 70,
            buttonWidth: double.infinity,
            itemHeight: 60,
          ),
        ));
  }
}
