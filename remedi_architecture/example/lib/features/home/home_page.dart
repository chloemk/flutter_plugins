import 'package:example/app_models/auth_app_model.dart';
import 'package:example/features/home/counter_widget.dart';
import 'package:example/features/home/home_view_model.dart';
import 'package:example/features/home/login_button_widget.dart';
import 'package:example/features/home/login_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:remedi_architecture/remedi_architecture.dart';

class HomePage extends IViewModelView<HomeViewModel> {
  static const routeName = '/home';
  final GlobalKey<StatefulDataViewState<int>> countState = GlobalKey();
  final GlobalKey<StatefulStateDataViewState<LoginState, bool>> loginState =
      GlobalKey();
  final GlobalKey<StatefulStateDataViewState<LoginState, bool>>
      loginButtonState = GlobalKey();

  HomePage({Key? key, required HomeViewModel viewModel})
      : super(key: key, viewModel: viewModel);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      backgroundColor: viewModel.colorAppModel.color,
      appBar: AppBar(
        title: const Text('MVVM Example'),
      ),
      body: Column(children: [
        Expanded(
          child: Center(
            child: LoginStateWidget(
                key: loginState, stateData: viewModel.loginState),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: LoginButtonWidget(
            key: loginButtonState,
            login: () {
              viewModel.authAppModel.login();
            },
            logout: () {
              viewModel.authAppModel.logout();
            },
            stateData: viewModel.loginState,
          ),
        ),
        Expanded(
          child: Center(
            child: CountWidget(
              key: countState,
              data: viewModel.count,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: MaterialButton(
            minWidth: double.infinity,
            color: Colors.blue,
            height: 48,
            onPressed: () {
              viewModel.increase();
            },
            child: const Text('Increase count'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: MaterialButton(
            minWidth: double.infinity,
            color: Colors.grey,
            height: 48,
            onPressed: () {
              viewModel.toggleThemeMode();
            },
            child: const Text('Toggle Theme'),
          ),
        ),
      ]),
    );
  }

  @override
  void onActionChanged(BuildContext context, HomeViewModel viewModel, action) {
    super.onActionChanged(context, viewModel, action);
    switch (action) {
      case 'increase':
        countState.currentState?.updateData(data: viewModel.count);
        break;

      case 'login':
        loginState.currentState
            ?.updateStateData(stateData: viewModel.loginState);
        loginButtonState.currentState
            ?.updateStateData(stateData: viewModel.loginState);
        break;
    }
  }
}
