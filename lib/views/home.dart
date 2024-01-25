import 'package:wishes_app/export.dart';
import 'package:wishes_app/views/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset('assets/images/home.png'),
          title: Text(
            'Home',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'For You',
              ),
              Tab(
                text: 'Followers',
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ));
              },
              icon: const Icon(Icons.notifications),
            ),
            SizedBox(width: 2.w),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ));
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
              stream: PostServices.forYouStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  debugPrint(snapshot.data?.length.toString());

                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var snap in snapshot.data!) ...{
                            PostContainer(
                              user: snap['user'],
                              post: snap['post'],
                            ),
                          }
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No Post',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    );
                  }
                }
              },
            ),
            StreamBuilder(
                stream:
                    UserServices.stream(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    return StreamBuilder(
                      stream: PostServices.followerStream(snapshot2.data!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var snap in snapshot.data!) ...{
                                    PostContainer(
                                      user: snap['user'],
                                      post: snap['post'],
                                    ),
                                  }
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                'No Post',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            );
                          }
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ),
      ),
    );
  }
}
