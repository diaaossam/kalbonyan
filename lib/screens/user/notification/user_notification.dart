import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_layout/cubit/main_cubit.dart';
import 'package:kalbonyan/models/notification_model.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

import 'widgets/notification_item.dart';

class UserNotification extends StatelessWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return state is GetAllNotificationLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                child: cubit.allNotification.isEmpty
                    ? Center(
                        child: AppText(
                            text: "لا يوجد إشعارات",
                            color: Colors.grey,
                            textSize: 25),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) => NotificationItem(
                              notificationModel: cubit.allNotification[index],
                              cubit: cubit,
                            ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: SizeConfigManger.bodyHeight * .01),
                        itemCount: cubit.allNotification.length),
              );
      },
    );
  }
}
