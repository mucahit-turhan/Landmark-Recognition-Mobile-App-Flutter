import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:landmarkrecognition/mix/landmark.dart';
import 'package:landmarkrecognition/mix/tools.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bloc/bloc.dart';
import 'package:landmarkrecognition/screens/weather.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';

final String nodeEndPoint = 'YOUR IPV4 ADDRESS/landmark';

// ignore: must_be_immutable
class LandmarkInfoP extends StatefulWidget {
  String cityWeather= "";
  File pickedImage; //file,path,message
  FirebaseDatabase database;
  String userId;
  LandmarkInfoP({Key key, this.pickedImage, this.database,this.userId})
      : super(key: key);
  @override
  _LandmarkInfoPState createState() => _LandmarkInfoPState();
}

class _LandmarkInfoPState extends State<LandmarkInfoP>{
  Future<List> future;

  @override
  void initState() {
    future = upload(widget.pickedImage);
    super.initState();
  }

  addNewLandmark(String name, String id) {
    if(name != null && id != null) {
      Landmark landmark = new Landmark(name, id, widget.userId,);
      widget.database.reference().child("landmark").push().set(landmark.toJson());
    }
  }

  List<Widget> imageSliders(List<File> imageList){
    return imageList.map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.file(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0
                    ),
                  ),
                ),
              ],
            )),
      ),
    ))
        .toList();
  }

  Future<List> upload(File pickedImage) async {
      imageCache.clear();
      File file;
      List<String> rtnMessage;
      if (pickedImage == null) return [];
      String base64Image = base64Encode(pickedImage.readAsBytesSync());
      String fileName = pickedImage.path.split("/").last;
      await http.post(nodeEndPoint, body: {
        "image": base64Image,
        "name": fileName,
      }).then((res) async {
        String streams = res.headers["name"];
        List<String> stream = streams.split(",");
        List <int> lint = stream.map(int.parse).toList();
        var decoded = utf8.decode(lint);
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String p = '$tempPath/respond.jpg';
        File f = new File(p);
        await f.writeAsBytes(res.bodyBytes);
        file = f;
        rtnMessage = decoded.split("##");
      }).catchError((err) {
        print("Coneection Time Out");
        print(err);
      });
      return [file, rtnMessage];
  }

  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocSupervisor().delegate = SimpleBlocDelegate();
    return FutureBuilder<List>(
        future: future,
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            String id = snapshot.data[1][0];
            String name = snapshot.data[1][1];
            widget.cityWeather = snapshot.data[1][2];
            String info = snapshot.data[1][3];
            String url = snapshot.data[1][4];
            List<File> images = [widget.pickedImage,snapshot.data[0]];
            if(Tools.isNotGuest) {
              addNewLandmark(name, id);
            }
            return Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    color: Colors.indigo,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 34.0),
                          ),
                          SizedBox(
                            height: 261,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                autoPlay: false,
                              ),
                              items: imageSliders(images),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                //                   <--- border color
                                width: 5.0,
                              ),
                            ),
                            child: GestureDetector(
                              onTap: (){
                                //_launchInWebViewWithJavaScript(url);
                                _launchInWebViewOrVC(url);
                                //_launchInBrowser(url);
                              },
                              child: Text(
                                info,
                                overflow: TextOverflow.ellipsis,
                                style:
                                TextStyle(fontSize: 17, color: Colors.white),
                                maxLines: 10,
                              ),
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 30.0),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                goToWeather();
                              });
                            },
                            child:SizedBox(
                                height: 70,
                                child: AppStateContainer(child: WeatherApp(cityName: widget.cityWeather,flag: true,))
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                          ),
                          Container(
                            color: Colors.indigo,
                            width: 50,
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Container(
                color: Colors.indigo,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.cyan,
                    strokeWidth: 5,
                  ),
                ),
              ),
            );
          }
        });
  }

  void goToWeather(){
    BlocSupervisor().delegate = SimpleBlocDelegate();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppStateContainer(child: WeatherApp(cityName: widget.cityWeather,flag: false,))),
    );
  }
}