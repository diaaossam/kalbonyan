import 'package:flutter/material.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/models/journey_model.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

class CustomBottomDesign extends StatelessWidget {
  List<JourneyModel> journeyModelList;
  MainAdminCubit cubit;
  String title;

  CustomBottomDesign(this.journeyModelList, this.cubit,this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: SizeConfigManger.bodyHeight * .4,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfigManger.bodyHeight * .01,
              vertical: SizeConfigManger.bodyHeight * .01),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfigManger.bodyHeight * .005,
                  vertical: SizeConfigManger.bodyHeight * .005,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: ColorsManger.background,
                    borderRadius: BorderRadius.circular(
                        SizeConfigManger.bodyHeight * .02)),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenHeight(15)),
                    child: AppText(
                      text: title,
                      fontWeight: FontWeight.w700,
                      textSize: 16,
                      color: ColorsManger.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfigManger.bodyHeight * .01),
              Center(
                child: AppText(
                  text: "معلومات الحملة",
                  fontWeight: FontWeight.w800,
                  textSize: 18,
                  color: ColorsManger.appTextColor,
                ),
              ),
              Row(
                children: [
                  AppText(
                    text: "حالات الرحلة",
                    fontWeight: FontWeight.w800,
                    textSize: 18,
                    color: ColorsManger.appTextColor,
                  ),
                  Spacer(),
                  AppText(
                    text: "مواقع الحملات",
                    fontWeight: FontWeight.w800,
                    textSize: 18,
                    color: ColorsManger.darkPrimary,
                  ),
                ],
              ),
              SizedBox(height: SizeConfigManger.bodyHeight * .01),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: SizeConfigManger.bodyHeight * .005,
                          vertical: SizeConfigManger.bodyHeight * .005,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: journeyModelList[index].isDone == true
                                ? ColorsManger.lightGreen
                                : ColorsManger.lightPrimary2,
                            borderRadius: BorderRadius.circular(
                                SizeConfigManger.bodyHeight * .02)),
                        child: Padding(
                          padding:
                              EdgeInsets.all(getProportionateScreenHeight(15)),
                          child: Row(
                            children: [
                              AppText(
                                text: "${journeyModelList[index].title}",
                                fontWeight: FontWeight.w700,
                                textSize: 16,
                                color: ColorsManger.black,
                              ),
                              Spacer(),
                              journeyModelList[index].isDone == true
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () => cubit.sendNotifiation(
                                          title: 'إنتقال جديد',
                                          body:
                                              '${journeyModelList[index].title}',
                                          fromHome: true,
                                          journeyId:
                                              journeyModelList[index].id),
                                      child: Image.asset(
                                        AssetsManger.notification,
                                        height:
                                            getProportionateScreenHeight(20),
                                        width: getProportionateScreenHeight(20),
                                        color: ColorsManger.appTextColor,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: journeyModelList.length),
            ],
          ),
        ),
      ),
    );
  }
}
