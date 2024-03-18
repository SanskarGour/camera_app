import 'package:camera/camera.dart';
import 'package:camera_app/screen/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


late List<CameraDescription> cameras;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras =await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraApp(),
    );
  }
}


class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  @override
  void initState(){
    super.initState();
    _controller =CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_){
if(!mounted){
  return;
}

setState(() {});

    }).catchError((Object e){
      if(e is CameraException){
        switch (e.code){
          case 'CameraAccessDenied': print("access was denied");
          break;
          default: print(e.description);
          break;
        }
      }
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      //camera
      body:Stack(children: [
        Container(height: double.infinity,child: CameraPreview(_controller),
        ),
        //button to click
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: MaterialButton(onPressed: ()async{
                  if(!_controller.value.isInitialized){
                    return null;
                  }
                  if(_controller.value.isTakingPicture){
                    return null;
                  }

                  //screen to display the image            
                  try{
                    await _controller.setFlashMode(FlashMode.auto);
                    XFile file =await _controller.takePicture();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ImagePreview(file)));
                  }on CameraException catch(e){
                    debugPrint("Error occured while takig pciture: $e");
                    return null;
                  }
                },
                color: Colors.white,
                child: Text("Take a Picture"),
                            ),
              ),
            )
          ],
        )
      ],)
    );
  }
}