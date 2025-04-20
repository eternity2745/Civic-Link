import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:userapp/Database/methods.dart';
import 'package:userapp/Screens/searchUserProfile.dart';
import 'package:userapp/Utilities/state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();

  bool searchEmpty = true;
  bool noUserFound = false;

  void search() async {
    List<Map<String, dynamic>> usersData = await DatabaseMethods().searchUser(_searchController.text);
    if(usersData.isNotEmpty) {
      if(mounted) {
        Provider.of<StateManagement>(context, listen: false).setSearchUsersData(
          usersData
        );
      }
    }else{
      if(mounted) {
        Provider.of<StateManagement>(context, listen: false).setSearchUsersData([]);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 0.4.dp,
            fontWeight: FontWeight.bold
          ),
          ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (value) {
                if(value.isNotEmpty) {
                  searchEmpty = false;
                  setState(() {
                    
                  });
                  search();
                }else{
                  searchEmpty = true;
                  setState(() {
                    
                  });
                }
              },
              cursorColor: Colors.green,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: "Search for users",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.green, width: 0.7.w)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
            ),
            Expanded(
              child: Consumer<StateManagement>(
                builder: (context, value, child) { 
                  if(searchEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 2.w),
                      child: Text(
                        "Search For Users",
                        style: TextStyle(
                          fontSize: 0.4.dp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade300
                        ),
                      ),
                    );}
                  if(value.searchUsersData.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 2.w),
                      child: Text(
                        "No Users Found",
                        style: TextStyle(
                          fontSize: 0.4.dp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade300
                        ),
                      ),
                    );
                  } 
                  return ListView.builder(
                    itemCount: value.searchUsersData.length,
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<StateManagement>(context, listen: false).setSearchUserIndex(index);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchUserScreen()));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  maxRadius: 20,
                                  minRadius: 20,
                                  backgroundImage: NetworkImage(value.searchUsersData[index]['profilePic']),
                                  // child: Image.network("https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?t=st=1742383909~exp=1742387509~hmac=0131701366007062d1e104fe4dac9b7953670db65383cf80fe00003bc07896f6&w=900"),
                                ),
                              title: Text(value.searchUsersData[index]['displayname']),
                              subtitle: Text("@${value.searchUsersData[index]['username']}")
                            ),
                          ),
                          if(index != value.searchUsersData.length -1)...{
                            Divider(color: Colors.grey.shade700, thickness: 0.8,)
                          }
                        ],
                      );
                    }
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}