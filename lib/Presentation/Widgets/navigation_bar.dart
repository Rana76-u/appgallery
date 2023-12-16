import 'package:appgallery/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:appgallery/Bottom%20Navigation%20Bloc/bottom_navigation_events.dart';
import 'package:appgallery/Bottom%20Navigation%20Bloc/bottom_navigation_states.dart';
import 'package:appgallery/Presentation/Screens/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Screens/Notification Page/notification_page.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomBarBloc, BottomBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: state.currentIndex == 0
                ? const HomePage()
                : const NotificationPage(),
          ),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.notifications_rounded),
                  label: 'Notifications'),
            ],
            selectedIndex: state.currentIndex,
            onDestinationSelected: (int index) {
              BlocProvider.of<BottomBarBloc>(context)
                  .add(IndexChange(currentIndex: index));
            },
          ),
        );
      },
    );
  }
}
