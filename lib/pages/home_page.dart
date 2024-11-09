// ignore_for_file: must_be_immutable

import 'package:do_an_app/pages/setting_page.dart';
import 'package:do_an_app/pages/warning_page.dart';
import 'package:flutter/material.dart';
import 'package:do_an_app/pages/list_of_cow_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade200, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Center(child: Text("Xin chào Nguyễn Trường Thản")),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    ContainerNavigation(),
                  ],
                ))
          ]),
    );
  }
}

class ContainerNavigation extends StatelessWidget {
  const ContainerNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền của Container
        borderRadius: BorderRadius.circular(15), // Bo tròn các góc
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Màu đổ bóng
            spreadRadius: 5, // Độ lan rộng của bóng
            blurRadius: 7, // Độ mờ của bóng
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio:
            ((MediaQuery.of(context).size.width * 0.85 / 3) / (180 / 2)),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          NavigationItem(
            title: 'Bản đồ',
            icon: Icons.map,
            navigationPage: null,
          ),
          NavigationItem(
              title: 'Danh sách',
              icon: Icons.list_outlined,
              navigationPage: ListOfCowPage()),
          NavigationItem(
            title: 'Cảnh báo',
            icon: Icons.warning_outlined,
            navigationPage: WarningPage(),
          ),
          NavigationItem(
            title: 'Cài đặt',
            icon: Icons.settings,
            navigationPage: SettingPage(),
          ),
        ],
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? navigationPage;

  const NavigationItem({
    required this.title,
    required this.icon,
    required this.navigationPage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (navigationPage != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return navigationPage!;
          }));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title được nhấn!')),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), Text(title)],
        ),
      ),
    );
  }
}
