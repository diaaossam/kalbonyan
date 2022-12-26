import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/widget/app_text.dart';

import '../screens/admin/notification/widgets/custom_aleart.dart';

class MainAdminLayout extends StatelessWidget {
  const MainAdminLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      MainAdminCubit()
        ..setUpPermissions(),
      child: BlocConsumer<MainAdminCubit, MainAdminState>(
        listener: (context, state) {},
        builder: (context, state) {
          MainAdminCubit cubit = MainAdminCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: AppText(
                  text: cubit.titles[cubit.currentIndex],
                  color: Colors.white,
                  textSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: cubit.currentIndex == 1
                ? FloatingActionButton(onPressed: () => showAddDialog(context,cubit),
                child: Icon(Icons.add)):null,
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavItems,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: ColorsManger.darkPrimary,
              selectedLabelStyle: const TextStyle(
                fontFamily: ConstantsManger.appFont,
              ),
              onTap: (index) => cubit.changeBottomNavBar(index: index),
              currentIndex: cubit.currentIndex,
            ),
          );
        },
      ),
    );
  }

  Future<void> showAddDialog(context,MainAdminCubit cubit) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CustomNotificationDialog(cubit);
      },
    );
  }

}
