import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/screens/login_screen/cubit/login_cubit.dart';
import 'package:kalbonyan/widget/app_text.dart';

class RadioButtonDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {},
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        return Column(
          children: <Widget>[
            _myRadioButton(
              cubit: cubit,
              title: "حاج",
              value: 0,
              onChanged: (newValue) =>
                  cubit.changeRadioButtonState(value: newValue),
            ),
            _myRadioButton(
              title: "مشرف",
              cubit: cubit,
              value: 1,
              onChanged: (newValue) =>
                  cubit.changeRadioButtonState(value: newValue),
            ),
          ],
        );
      },
    );
  }

  Widget _myRadioButton(
      {required String title,
      required int value,
      required onChanged,
      required LoginCubit cubit}) {
    return RadioListTile(
      value: value,
      groupValue: cubit.groupValue,
      onChanged: onChanged,
      title: AppText(text: title,textSize: 18,fontWeight: FontWeight.w600),
    );
  }
}
