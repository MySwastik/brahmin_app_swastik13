import 'package:brahminapp/enpty_content.dart';
import 'package:brahminapp/services/database.dart';
import 'package:brahminapp/user_profile/search_bar.dart';
import 'package:brahminapp/user_profile/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brahminapp/common_widgets/platform_alert_dialog.dart';
import 'package:brahminapp/services/auth.dart';

class HomePage extends StatefulWidget {
  final uid;

  const HomePage({Key key, @required this.uid}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;
  final _pageOptions = [
    EmptyContent(),
    Provider<AuthBase>(builder: (context) => Auth(), child: SearchUsers()),
    EmptyContent(),
  ];


  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseL>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('mishragovind418@gmail.com'),
              accountName: Text('Govind mishra'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.account_circle,
                size: 30,
              ),
              contentPadding: EdgeInsets.fromLTRB(25, 3, 25, 3),
              title: Text(
                'User profile',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context){
                        //database.setData(data: {'firstName':'Edit','lastName':' your name'});
                       return UserProfilePage(database: database,
                          uid: widget.uid,
                        );
                      }),
                );
              },
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (int index) {
          setState(() {
            _selectedTab = index;
          });
        },
        elevation: 20,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Search'),
          ),
        ],
      ),
    );
  }
}
