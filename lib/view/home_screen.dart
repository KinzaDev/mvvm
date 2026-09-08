import 'package:flutter/material.dart';
import 'package:mvvm/data/response/status.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/utils/routes/routes_name.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view_model/home_view_model.dart';
import 'package:mvvm/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeViewViewModel homeViewViewModel = HomeViewViewModel();

  @override
  void initState() {
    super.initState();
    homeViewViewModel.fetchMoviesListApi();
  }

  @override
  void dispose() {
    homeViewViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Movies List'),
        centerTitle: true,
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.whiteColor,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              userViewModel.remove().then((value) {
                Utils.toastMessage('Logged out successfully');
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.login,
                  (route) => false,
                );
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ChangeNotifierProvider<HomeViewViewModel>.value(
        value: homeViewViewModel,
        child: Consumer<HomeViewViewModel>(
          builder: (context, value, _) {
            switch (value.moviesList.status) {
              case Status.loading:
                return const Center(child: CircularProgressIndicator());
              case Status.error:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          value.moviesList.message.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            homeViewViewModel.fetchMoviesListApi();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              case Status.completed:
                final movies = value.moviesList.data?.movies;
                if (movies == null || movies.isEmpty) {
                  return const Center(child: Text('No movies found'));
                }
                return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 45,
                              height: 50,
                              child: (movie.posterurl != null &&
                                      movie.posterurl!.isNotEmpty)
                                  ? Image.network(
                                      movie.posterurl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.blue.shade50,
                                          child: const Icon(
                                            Icons.movie_creation_outlined,
                                            color: AppColors.primaryBlue,
                                            size: 24,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.blue.shade50,
                                      child: const Icon(
                                        Icons.movie_creation_outlined,
                                        color: AppColors.primaryBlue,
                                        size: 24,
                                      ),
                                    ),
                            ),
                          ),
                          title: Text(movie.title?.toString() ?? 'No Title'),
                          subtitle: Text(movie.year?.toString() ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(Utils.averageRating(movie.ratings).toStringAsFixed(1)),
                              const Icon(Icons.star, color: Colors.amber),
                            ],
                          ),
                        ),
                      );
                    });
              default:
                return const Text('Nothing to show');
            }
          },
        ),
      ),
    );
  }
}

