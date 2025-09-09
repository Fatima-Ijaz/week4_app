import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<dynamic>> _futureAll;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() {
    _futureAll = Future.wait([
      ApiService.fetchUser(widget.userId),
      ApiService.fetchPostsByUser(widget.userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureAll,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Error: ${snapshot.error}'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => setState(() => _loadAll()),
                  child: const Text('Retry'),
                )
              ]),
            );
          }

          final user = snapshot.data![0] as User;
          final posts = (snapshot.data![1] as List<Post>);

          final avatarUrl = 'https://i.pravatar.cc/200?u=${user.id}';

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 40, backgroundImage: NetworkImage(avatarUrl)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(user.email),
                          const SizedBox(height: 4),
                          Text('@${user.username}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: posts.isEmpty
                      ? const Center(child: Text('No posts found.'))
                      : ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, i) {
                            final p = posts[i];
                            return Card(
                              child: ListTile(
                                title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                                subtitle: Text(p.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
