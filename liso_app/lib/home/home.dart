import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharish/books/books.dart';
import 'package:sharish/borrows/view/borrows_page.dart';
import 'package:sharish/loans/loans.dart';
import 'package:sharish/utils/colors_util.dart';
import 'package:sharish/utils/images_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? tabController;
  int? index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    tabController!.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      index = tabController!.index;
      print('_handleTabSelection => call Listner');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.purple,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight * 0.6),
              child: TabBar(
                controller: tabController,
                unselectedLabelColor: AppColor.white,
                labelColor: AppColor.green,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 10,
                    color: AppColor.green,
                  ),
                  // insets: EdgeInsets.symmetric(vertical:16.0)
                ),
                // padding: EdgeInsets.only(bottom: 10),
                labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                labelPadding: EdgeInsets.only(
                  bottom: tabController!.index == 0 ? 10 : 10,
                ),
                tabs: [
                  Tab(
                    icon: SvgPicture.asset(
                      Assets.triangleLeftGreen,
                      height: tabController!.index == 0 ? 27 : 11,
                      color: tabController!.index == 0
                          ? AppColor.green
                          : AppColor.white,
                    ),
                    text: "I've borrowed",
                  ),
                  Tab(
                    icon: SvgPicture.asset(
                      Assets.bookMarkGreen,
                      height: tabController!.index == 1 ? 27 : 11,
                      color: tabController!.index == 1
                          ? AppColor.green
                          : AppColor.white,
                    ),
                    text: 'My Books',
                  ),
                  Tab(
                    icon: SvgPicture.asset(
                      Assets.triangleRightGreen,
                      height: tabController!.index == 2 ? 27 : 11,
                      color: tabController!.index == 2
                          ? AppColor.green
                          : AppColor.white,
                    ),
                    text: 'Loans',
                  ),
                ],
              )),
        ),
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            BorrowsPage(),
            BooksPage(),
            LoansPage(),
          ],
        ),
      ),
    );
  }
}
