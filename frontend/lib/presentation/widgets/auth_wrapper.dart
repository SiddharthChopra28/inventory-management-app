part of '../../main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Authentication Error")),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          context.read<AuthBloc>().add(CheckAuthStatus());
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is AuthAuthenticated) {
          // Navigate to your main inventory app
          return MyHomePage(title: 'Inventory Management System');

        } else {
          // Show login page for unauthenticated users
          return LoginPage();
        }
      },
    );
  }
}
