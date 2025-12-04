/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/view/auth_view/login_view.dart';
import '../../viewModel/home_view_model.dart';
import '../../widgets/shimmer.dart';
import '../Attendance/attendance_view.dart';
import '../Homework/home_work_view.dart';
import '../View3data/view3data.dart';
import '../chart_view/student_chart_view.dart';
import '../marks_view/marks_view.dart';
import '../news_view/news_view.dart';
import '../schedule_table/time_table_view.dart';
import '../seminar_view/activity_view.dart';
import '../studentperformance/performance_predictor_view.dart';
import 'menu_choice.dart';
import 'selectcard.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // fetching name and image/profile images
    // Future.microtask(() => Provider.of<HomeViewModel>(context, listen: false).fetchHomeData());
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("whole Screen rebuilding");
    }
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: viewModel.isLoading
            ? ShimmerContainer(width: 200, height: 20, borderRadius: 20)
            : Text(
          viewModel.username ?? "College System",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: viewModel.isLoading
                ? const ShimmerCircle(diameter: 36)
                : CircleAvatar(
              backgroundImage: NetworkImage(
                viewModel.profileImage ?? 'https://via.placeholder.com/150',
              ),
            ),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? _buildShimmerGrid()
          : _buildMenuGrid(context),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      padding: const EdgeInsets.all(16),
      children: List.generate(9,
            (index) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ShimmerCircle(diameter: 60),
            const SizedBox(height: 10),
            ShimmerContainer(width: 80, height: 18, borderRadius: 6),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        children: List.generate(choices.length, (index) {
          return InkWell(
            onTap: () {

              Navigator.push(context,MaterialPageRoute(builder: (context) => choices[index].destinationPage),
              );
            },
            child: SelectCard(choice: choices[index]),
          );
        }),
      ),
    );
  }
}

///  Menu items list
List<MenuChoice> choices = <MenuChoice>[
  MenuChoice(
    name: 'Attendances',
    svgAssetPath: 'svgimage/calendar.svg',
    color: Colors.green,
    height: 35,
    width: 35,
    destinationPage: AttendanceView(),
  ),
  MenuChoice(
    name: 'Homework',
    svgAssetPath: 'svgimage/homework.svg',
    color: Colors.orange,
    height: 30,
    width: 30,
    destinationPage: HomeWorkView(),
  ),
  MenuChoice(
    name: 'Predictions',
    svgAssetPath: 'svgimage/behaviour.svg',
    color: Colors.purple,
    height: 30,
    width: 30,
    destinationPage: PerformancePredictorView(),
  ),
  MenuChoice(
    name: 'Subject Marks',
    svgAssetPath: 'svgimage/exam.svg',
    color: Colors.orange,
    height: 30,
    width: 30,
    destinationPage: MarksView(),
  ),
  MenuChoice(
    name: 'Activity',
    svgAssetPath: 'svgimage/doubleuser.svg',
    color: Colors.purple,
    height: 30,
    width: 30,
    destinationPage: ActivityView(),
  ),
  MenuChoice(
    name: 'Circulars',
    svgAssetPath: 'svgimage/time.svg',
    color: Colors.greenAccent,
    height: 30,
    width: 30,
    destinationPage: StudentMarksChartView(),
  ),
  MenuChoice(
    name: 'Time Table',
    svgAssetPath: 'svgimage/timetable.svg',
    color: Colors.green,
    height: 30,
    width: 30,
    destinationPage: TimeTableView(),
  ),
  MenuChoice(
    name: 'Notices',
    svgAssetPath: 'svgimage/messages.svg',
    color: Colors.purple,
    height: 30,
    width: 30,
    destinationPage: NewsView(),
  ),
  MenuChoice(
    name: 'View Data',
    svgAssetPath: 'svgimage/more.svg',
    color: Colors.blue,
    height: 30,
    width: 30,
    destinationPage: View3Data(),
  ),
];
*/



/// New User Interface
import 'package:cached_network_image/cached_network_image.dart';  // New: For cached images
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/view/auth_view/login_view.dart';  // Assuming this is for logout or something, but not used here
import '../../resources/components/round_button.dart';
import '../../utils/routes/routes_name.dart';
import '../../viewModel/home_view_model.dart';
import '../../widgets/shimmer.dart';  // Assuming this is custom shimmer
import '../Attendance/attendance_view.dart';
import '../Homework/home_work_view.dart';
import '../View3data/view3data.dart';
import '../chart_view/student_chart_view.dart';
import '../marks_view/marks_view.dart';
import '../news_view/news_view.dart';
import '../schedule_table/time_table_view.dart';
import '../seminar_view/activity_view.dart';
import '../studentperformance/performance_predictor_view.dart';
import 'menu_choice.dart';
import 'selectcard.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Fetch data asynchronously on init
    Future.microtask(() {
      final viewModel = Provider.of<HomeViewModel>(context, listen: false);
      // throwing the error if comes up during the rendering
      viewModel.fetchHomeData().catchError((error) {
        // Handle errors to prevent app crash
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading Username/profile Image: $error')),
        );
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    // Removed debug print to avoid console spam; use DevTools for profiling instead
    // Use Consumer to limit rebuilds to specific parts
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],  // Darker Blue for modern gradient
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(  // Modern: Add gradient to AppBar
              colors: [Colors.blue[800]!, Colors.blue[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Consumer<HomeViewModel>(  // Rebuild only title on change
          builder: (context, viewModel, child) {
            return viewModel.isLoading
                ? ShimmerContainer(width: 200, height: 20, borderRadius: 20)
                : Text(
              viewModel.username ?? "College System",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),  // Modern: Bold text
            );
          },
        ),
        centerTitle: true,
        // Profile Image
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<HomeViewModel>(  // Rebuild only avatar on change
                  builder: (context, viewModel, child) {
                    return viewModel.isLoading ? const ShimmerCircle(diameter: 36):
                    CircleAvatar(
                      radius: 18,  // Slightly smaller for modern feel
                      backgroundColor: Colors.grey[300],  // Fallback background
                      child: ClipOval(
                        child: CachedNetworkImage(  // New: Cached for performance
                          imageUrl: viewModel.profileImage.toString(),
                          placeholder: (context, url) => const CircularProgressIndicator(),  // Modern loader
                          errorWidget: (context, url, error) =>  Image.asset("assets/logo.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              RoundButton(
                title: "Logout",
                onPress: (){
                  Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (route) => false,);
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(  // Rebuild only body on loading change
        builder: (context, viewModel, child) {
          return viewModel.isLoading ? _buildShimmerGrid() : _buildMenuGrid(context);
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    // Improved: Use GridView.builder for lazy building (even though small)
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),  // New: Responsive grid (3 on phone, more on tablet)
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,  // Adjusted for better spacing
      ),
      padding: const EdgeInsets.all(16),
      itemCount: choices.length,
      itemBuilder: (context, index) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ShimmerCircle(diameter: 60),
          const SizedBox(height: 10),
          ShimmerContainer(width: 80, height: 18, borderRadius: 6),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(  // Changed to builder for efficiency
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),  // Responsive
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 0.8,  // Better ratio for cards
        ),
        itemCount: choices.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Modern: Add fade transition for navigation
              Navigator.push(
                context, PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => choices[index].destinationPageBuilder(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),  // Modern: Rounded ripple
            child: SelectCard(choice: choices[index]),  // Assume updated for modern look (e.g., add elevation in SelectCard)
          );
        },
      ),
    );
  }

  // New: Responsive cross-axis count
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 4;  // Tablet/large screen
    return 3;  // Phone
  }
}

// Menu items list (updated with builders for lazy loading)
const List<MenuChoice> choices = <MenuChoice>[
  MenuChoice(
    name: 'Attendances',
    svgAssetPath: 'svgimage/calendar.svg',
    color: Colors.green,
    height: 35,
    width: 35,
    destinationPageBuilder: AttendanceView.new,  // Use .new for const constructors if available
  ),
  MenuChoice(
    name: 'Homework',
    svgAssetPath: 'svgimage/homework.svg',
    color: Colors.orange,
    height: 30,
    width: 30,
    destinationPageBuilder: HomeWorkView.new,
  ),
  MenuChoice(
    name: 'Predictions',
    svgAssetPath: 'svgimage/behaviour.svg',
    color: Colors.purple,
    height: 30,
    width: 30,
    destinationPageBuilder: PerformancePredictorView.new,
  ),
  MenuChoice(
    name: 'Subject Marks',
    svgAssetPath: 'svgimage/exam.svg',
    color: Colors.orange,
    height: 30,
    width: 30,
    destinationPageBuilder: MarksView.new,
  ),
  MenuChoice(
    name: 'Activity',
    svgAssetPath: 'svgimage/doubleuser.svg',
    color: Colors.purple,
    height: 30,
    width: 30,
    destinationPageBuilder: ActivityView.new,
  ),
  MenuChoice(
    name: 'Circulars',
    svgAssetPath: 'svgimage/time.svg',
    color: Colors.greenAccent,
    height: 30,
    width: 30,
    destinationPageBuilder: StudentMarksChartView.new,
  ),
  MenuChoice(
    name: 'Time Table',
    svgAssetPath: 'svgimage/timetable.svg',
    color: Colors.green,
    height: 30,
    width: 30,
    destinationPageBuilder: TimeTableView.new,
  ),
  MenuChoice(
    name: 'Notices',
    svgAssetPath: 'svgimage/messages.svg',
    color: Colors.purple,
    height: 30,
    width: 30,
    destinationPageBuilder: NewsView.new,
  ),
  MenuChoice(
    name: 'View Data',
    svgAssetPath: 'svgimage/more.svg',
    color: Colors.blue,
    height: 30,
    width: 30,
    destinationPageBuilder: View3Data.new,
  ),
];