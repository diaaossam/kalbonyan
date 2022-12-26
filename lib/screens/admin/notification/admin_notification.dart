import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/models/notification_model.dart';
import 'package:kalbonyan/screens/admin/notification/widgets/notification_item.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

class AdminNotification extends StatelessWidget {
  const AdminNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainAdminCubit, MainAdminState>(
      listener: (context, state) {
        if(state is SendNotificationSuccess){
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return state is GetAllNotificationLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                child: MainAdminCubit.get(context).allNotification.isEmpty
                    ? Center(
                        child: AppText(
                            text: "لا يوجد إشعارات",
                            color: Colors.grey,
                            textSize: 25),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) => NotificationItem(
                            notificationModel: MainAdminCubit.get(context)
                                .allNotification[index]),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: SizeConfigManger.bodyHeight * .01),
                        itemCount:
                            MainAdminCubit.get(context).allNotification.length),
              );
      },
    );
  }
}
