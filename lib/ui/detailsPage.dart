import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  final Map<String, dynamic> post;
  final String imagePath;

  const ArticlePage({
    super.key,
    required this.post,
    required this.imagePath,
  });

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool isLiked = false;
  int likeCount = 285;

  void handleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount + 1 : likeCount - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                Stack(
                  children: [
                    // Background Image
                    Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/ancient.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Header Overlay
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.arrow_back,
                                      color: Colors.black)),
                            ),
                            const Icon(Icons.bookmark,
                                color: Colors.white, size: 28),
                          ],
                        ),
                      ),
                    ),

                    // Title Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 320,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Passeios em veneza: como gastar economizar",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 6,
                                    color: Colors.black45,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  // backgroundImage: AssetImage("assets/avatar.png"),
                                  child: Text("J",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                ),
                                SizedBox(width: 8),
                                Text("João",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                SizedBox(width: 16),
                                Icon(Icons.access_time,
                                    size: 14, color: Colors.white70),
                                SizedBox(width: 4),
                                Text("5 min",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Content Section
                Container(
                  transform: Matrix4.translationValues(0, -20, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. "
                        "Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. "
                        "Curabitur non nulla sit amet nisl tempus convallis quis ac lectus.",
                        style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Donec sollicitudin molestie malesuada. Mauris blandit aliquet elit, "
                        "eget tincidunt nibh pulvinar a. Proin eget tortor risus.",
                        style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Quisque velit nisi, pretium ut lacinia in, elementum id enim. "
                        "Donec sollicitudin molestie malesuada. Vestibulum ac diam sit amet "
                        "quam vehicula elementum sed sit amet dui.",
                        style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Pellentesque habitant morbi tristique senectus et netus et malesuada "
                        "fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, "
                        "ultricies eget, tempor sit amet, ante.",
                        style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. "
                        "Mauris placerat eleifend leo. Quisque sit amet est et sapien ullamcorper pharetra.",
                        style: TextStyle(
                            fontSize: 16, height: 1.5, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Like Button
          Positioned(
              bottom: 24,
              right: 24,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLiked = !isLiked;
                    likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                  });
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                      Text("$likeCount"),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
