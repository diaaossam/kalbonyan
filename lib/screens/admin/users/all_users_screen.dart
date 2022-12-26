import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/main_layout/cubit/main_cubit.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

import 'widgets/user_item.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainAdminCubit, MainAdminState>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is GetAllUsersLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: "إبحث بالإسم",
                      suffixIcon: Icons.search,
                      onChange: (String? value) {
                        if (value!.isNotEmpty) {
                          MainCubit.get(context).serachQuery(query: value);
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => UserItemDesign(
                              MainAdminCubit.get(context).allUsersList[index]),
                          separatorBuilder: (context, index) => SizedBox(
                              height: SizeConfigManger.bodyHeight * .01),
                          itemCount:
                              MainAdminCubit.get(context).allUsersList.length),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
