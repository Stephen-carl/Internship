import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';
import 'detailsPage.dart';

// Post model to parse the API response
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class TravelContentPage extends StatefulWidget {
  const TravelContentPage({super.key});

  @override
  State<TravelContentPage> createState() => _TravelContentPageState();
}



class _TravelContentPageState extends State<TravelContentPage> {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";
  List<Post> posts = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          posts = data.map((json) => Post.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load posts';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left icons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDarkMode = !isDarkMode;
                          });
                          themeProvider.toggleTheme(isDarkMode);
                        },
                        child: Icon(
                            themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                            size: 28, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                  // Right icons
                  Row(
                    children: [
                      Icon(Icons.search,
                          size: 24,
                          color: Theme.of(context).colorScheme.onSurface),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Text("U"),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Main content scroll
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Section
                              const SizedBox(height: 12),
                              Text("Conteúdo diário",
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 14,
                                  )),
                              const SizedBox(height: 4),
                              Text("Recomendação",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )),

                              const SizedBox(height: 20),

                              // Featured cards (horizontal scroll)
                              SizedBox(
                                height: 400,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: posts.length > 2 ? 2 : posts.length,
                                  itemBuilder: (context, index) {
                                   final post = posts[index];
                                    return _buildFeaturedCard( // Ensure this widget also adapts to theme changes if needed
                                      image: index % 2 == 0 
                                          ? "assets/venice.png" 
                                          : "assets/ancient.png",
                                      title: post.title,
                                      author: "User ${post.userId}",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ArticlePage(
                                              post: {
                                                'id': post.id,
                                                'userId': post.userId,
                                                'title': post.title,
                                                'body': post.body,
                                              },
                                              imagePath: index % 2 == 0
                                                  ? "assets/venice.png"
                                                  : "assets/ancient.png",
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Tabs
                              SizedBox(
                                height: 40,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _buildTab("Top", true),
                                    _buildTab("Popular", false),
                                    _buildTab("Trending", false),
                                    _buildTab("Favoritos", false),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Articles list
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: posts.length > 8 ? 8 : posts.length,
                                itemBuilder: (context, index) {
                                  final post = posts[index + 2 >= posts.length
                                      ? index 
                                      : index + 2];
                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset( // Consider how this image might look in dark mode
                                              "assets/starry-night-camping.png",
                                              width: 64,
                                              height: 64,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 24,
                                                          width: 24,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[300],
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              post.userId.toString(),
                                                              style: const TextStyle(fontSize: 10),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Text(
                                                          "User ${post.userId}",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme.bodySmall,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard({
    required String image,
    required String title,
    required String author,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          author[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        author,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.grey[300]!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Theme.of(context).hintColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
