import 'package:flutter/cupertino.dart';
import 'package:login/core/service/i_auth_service.dart';
import 'package:provider/provider.dart';

import '../model/my_app_user.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key? key, required this.onPageBuilder})
      : super(key: key);
  final Widget Function(
      BuildContext context, AsyncSnapshot<MyAppUser?> snapshot) onPageBuilder;
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<IAuthService>(context, listen: false);
    return StreamBuilder<MyAppUser?>(
      stream: _authService.onAuthStateChange,
      builder: (context, AsyncSnapshot<MyAppUser?> snapshot) {
        final _userData = snapshot.data;
        if (_userData != null) {
          return MultiProvider(
              providers: [Provider.value(value: _userData)],
              child: onPageBuilder(context, snapshot));
        } else {
          return onPageBuilder(context, snapshot);
        }
      },
    );
  }
}
