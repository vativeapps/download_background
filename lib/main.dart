import 'dart:developer';
import 'dart:io';

import 'package:download_background/app_service.dart';
import 'package:download_background/files_model.dart';
import 'package:download_background/spring_widget.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';

import 'event_bus.dart';

// QueueDownload globalQueueDownload = QueueDownload.getInstance;
EventBus eventBus = EventBus();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Downloading Queue Based'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _counter1 = 0;
  String filesDir = '';

  // void _incrementCounter() async {
  //   // setState(() {
  //   //   _counter++;
  //   // });
  //   startDownloading();
  // }

  startDownloading(int id, String name) async {
    String pathToSave = await getFileDirectory();
    // pathToSave.s
    // if (id == 12) {
    //   var file = File('$pathToSave/$name.pdf');
    //   log('pathToSave: ${file.path}');
    //   AppService.getInstance.addDownload(
    //       id, 'https://research.nhm.org/pdfs/10840/10840-002.pdf', file.path);
    // } else if (id == 54) {
    //   var file1 = File('$pathToSave/$name.pdf');
    //   log('pathToSave: ${file1.path}');
    //   AppService.getInstance.addDownload(
    //       id,
    //       'https://freetestdata.com/wp-content/uploads/2022/11/Free_Test_Data_10.5MB_PDF.pdf',
    //       file1.path);
    // }
    var file = File('$pathToSave/$name.pdf');
    log('pathToSave: ${file.path}');
    AppService.getInstance.addDownload(
        id, 'https://research.nhm.org/pdfs/10840/10840-002.pdf', file.path);
  }

  showFiles() async {
    Directory? appDocDir = await getTemporaryDirectory();
    // String appDocPath = appDocDir!.path;
    log('Temp Directory: ${appDocDir.path}');
    var values = await appDocDir.list().toList();
    setState(() {
      filesDir = values.toString();
    });
    log('Temp Directory Files: $values');
  }

  Future<String> getFileDirectory() async {
    Directory? tempDir = await getTemporaryDirectory();
    String tempDirPath = tempDir.path;

    log('getFileDirectory: $tempDirPath');
    return tempDirPath;
  }

  @override
  void initState() {
    super.initState();

    eventBus.on<DownloadProgress>().listen((event) {
      setState(() {
        if (event.id == 12) {
          _counter = event.progress;
        } else if (event.id == 54) {
          _counter1 = event.progress;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Downloading Files',
            // ),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return FileItemWidget(
                    fileModel: dummyFileList[index],
                    index: index,
                    onTap: () {
                      log('tapped $index');
                      AppService.getInstance.addToQueue(dummyFileList[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemCount: dummyFileList.length),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Text(
            //       '$_counter',
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Text(
            //       '$_counter1',
            //       style: Theme.of(context).textTheme.headline4,
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Downloaded Files: ',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    filesDir,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton(
          //   onPressed: () {
          //     startDownloading(12, 'file1');
          //   },
          //   tooltip: 'Increment',
          //   backgroundColor: Colors.red,
          //   child: const Icon(Icons.add),
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          // FloatingActionButton(
          //   onPressed: () {
          //     startDownloading(54, 'file2');
          //   },
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          FloatingActionButton(
            onPressed: () {
              showFiles();
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const NewScreen()));
            },
            child: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class FileItemWidget extends StatefulWidget {
  final FileModel fileModel;
  final VoidCallback onTap;
  final int index;
  const FileItemWidget(
      {Key? key,
      required this.fileModel,
      required this.onTap,
      required this.index})
      : super(key: key);

  @override
  State<FileItemWidget> createState() => _FileItemWidgetState();
}

class _FileItemWidgetState extends State<FileItemWidget> {
  bool inProgress = false;
  @override
  void initState() {
    super.initState();

    // eventBus.on<AddedToQueue>().listen((event) {

    // });
    AppService.getDownloadQueueMap.contains(widget.fileModel);
    inProgress = true;
    // setState(() {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          SpringWidget(
            onTap: widget.onTap,
            child: inProgress
                ? const CircularProgressIndicator(
                    color: Colors.green,
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/download.svg',
                      color: Colors.green,
                      // height: 20,
                      // width: 20,
                    ),
                  ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.fileModel.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}

class NewScreen extends StatelessWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('This is new screen')));
  }
}
