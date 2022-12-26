import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_layout/cubit/main_cubit.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()..initApp(),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          MainCubit cubit = MainCubit.get(context);
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
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.bottomNavItems,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: ColorsManger.darkPrimary,
              selectedLabelStyle: TextStyle(fontFamily: ConstantsManger.appFont,),
              onTap: (index)=>cubit.changeBottomNavBar(index: index),
              currentIndex: cubit.currentIndex,
            ),
          );
        },
      ),
    );
  }
}
