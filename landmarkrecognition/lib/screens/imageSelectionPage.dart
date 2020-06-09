import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landmarkrecognition/mix/baseAuth.dart';
import 'package:landmarkrecognition/mix/landmark.dart';
import 'package:landmarkrecognition/mix/tools.dart';
import 'package:landmarkrecognition/screens/landmarkInfo.dart';
import 'dart:async';

class ImageSelectionP extends StatefulWidget {
  ImageSelectionP({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  State<StatefulWidget> createState() => _ImageSelectionPState();
}

class _ImageSelectionPState extends State<ImageSelectionP> with Tools {
  String _email = "";
  File _pickedImage;

  List<Landmark> _landmarkList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription<Event> _landmarkAddSubscription;
  StreamSubscription<Event> _landmarkChangedSubscription;
  Query _landmarkQuery;


  @override
  void initState() {
    super.initState();
    if(!Tools.isNotGuest){
      _email = "GUEST";
    } else{
      _email = Tools.email;
      _landmarkList = new List();
      _landmarkQuery = _database
          .reference()
          .child("landmark")
          .orderByChild("userId")
          .equalTo(widget.userId);
      _landmarkAddSubscription = _landmarkQuery.onChildAdded.listen(onEntryAdded);
      _landmarkChangedSubscription =
          _landmarkQuery.onChildChanged.listen(onEntryChanged);
    }
}

  @override
  void dispose() {
    if(Tools.isNotGuest) {
      _landmarkAddSubscription.cancel();
      _landmarkChangedSubscription.cancel();
    }
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _landmarkList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _landmarkList[_landmarkList.indexOf(oldEntry)] =
          Landmark.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _landmarkList.add(Landmark.fromSnapshot(event.snapshot));
    });
  }

  addNewLandmark(String name, String id) {
    if(name != null && id != null) {
      Landmark landmark = new Landmark(name, id, widget.userId,);
      _database.reference().child("landmark").push().set(landmark.toJson());
    }
  }

  updateLandmark(Landmark landmark) {
      _database.reference().child("landmark").child(landmark.key).set(landmark.toJson());
  }

  deleteLandmark(String landmarkId, int index) {
    _database.reference().child("landmark").child(landmarkId).remove().then((_) {
      print("Delete $landmarkId successful");
      setState(() {
        _landmarkList.removeAt(index);
      });
    });
  }

  Widget showLandmarkList() {
    if(Tools.isNotGuest) {
      if (_landmarkList.length > 0) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: _landmarkList.length,
            itemBuilder: (BuildContext context, int index) {
              String name = _landmarkList[index].name;
              String id = _landmarkList[index].id;
              String landmarkId = _landmarkList[index].key;
              String userId = _landmarkList[index].userId;
              return Dismissible(
                key: Key(landmarkId),
                background: Container(color: Colors.red),
                onDismissed: (direction) async {
                  deleteLandmark(landmarkId, index);
                },
                child: ListTile(
                  title: Text(
                    name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  /*
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                      Icons.done_outline,
                      color: Colors.green,
                      size: 20.0,
                    )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      updateTodo(_landmarkList[index]);
                 */
                ),
              );
            });
      } else {
        return Center(
            child: Text(
              "Welcome. Your list is empty",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ));
      }
    }else{
      return Container(
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logOutButton = Visibility(
        visible: Tools.isNotGuest,
        child: RaisedButton(
          onPressed: () {
            pressLogOut(context);
          },
          textColor: Colors.white,
          color: Colors.red,
          padding: const EdgeInsets.all(10.0),
          child: new Text(
            "Log-Out",
          ),
        ));

    Widget drawer(){
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  SizedBox(
                    height: 100,
                    child: Image.asset(
                      'assets/images/account.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Visibility(
                    child: Text(
                      _email,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                height: 40,
                child: Visibility(
                  visible: Tools.isNotGuest,
                  child: Text(
                    "The History",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                )),
            ListTile(
              title: Visibility(
                visible: Tools.isNotGuest,
                child:showLandmarkList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: logOutButton,
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          ClipPath(
            clipper: MyClipper(),
            child: GestureDetector(
              onTap: () {
                pickImageFromCamera(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.red),
                child: Center(
                  child: Container(
                    alignment: Alignment(0.5, -0.5),
                    child: Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height / 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipPath(
            clipper: MyClipper2(),
            child: GestureDetector(
              onTap: () {
                pickImageFromGallery(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Container(
                      alignment: Alignment(-0.5, 0.5),
                      child: Icon(
                        Icons.photo_album,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.height / 5,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: drawer(),
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  pressLogOut(BuildContext context) async{
    Navigator.of(context).pop();
    await signOut();
  }

  void goToLandmarkInformation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LandmarkInfoP()),
    );
  }

  pickImageFromCamera(BuildContext context) async {
    final navigator = Navigator.of(context);
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      print(pickedImage.path);
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => LandmarkInfoP(),
        ),
      );
    }
  }

  pickImageFromGallery(BuildContext context) async {
    final navigator = Navigator.of(context);
    _pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      await navigator.push(
        MaterialPageRoute(
          builder: (context) => LandmarkInfoP(pickedImage: _pickedImage,database: _database,userId: widget.userId,),
        ),
      );
    }
  }

  Future drawerProfile() async {}

  Future drawerHistory() async {}

  void drawerLogOut() {}

}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(size.width / 2, size.width - 70);
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    //path.quadraticBezierTo(controllPoint.dx, controllPoint.dy,
    //endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height);
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width, size.height);
    //path.quadraticBezierTo(controllPoint.dx, controllPoint.dy,
    //endPoint.dx, endPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
