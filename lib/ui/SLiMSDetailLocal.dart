import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bibliography/helpers/dbhelper.dart';
import 'package:bibliography/models/biblio.dart';
import 'package:bibliography/ui/DescriptionTextWidget.dart';
import 'package:bibliography/ui/pdfview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class SLiMSDetailLocal extends StatefulWidget {
  Biblio biblio;

  SLiMSDetailLocal(this.biblio);

  @override
  _SLiMSDetailLocalState createState() => _SLiMSDetailLocalState(biblio);
}

// ignore: must_be_immutable
class _SLiMSDetailLocalState extends State<SLiMSDetailLocal> {
  Biblio biblio;
  bool _permissionReady;
  ReceivePort _port = ReceivePort();
  String _localPath;
  _TaskInfo _taskInfo;
  bool _isLoading;

  _SLiMSDetailLocalState(this.biblio);

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
    _permissionReady = false;
    _isLoading = false;
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Detail'),
      ),
      body: ListView(
        children: <Widget>[
          _buildImageTitleSection(),
          SizedBox(
            height: 30.0,
          ),
          _buildSectionTitle('Book Description'),
          _buildDivider(),
          SizedBox(
            height: 10.0,
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: DescriptionTextWidget(text: biblio.synopsis ?? '-')),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(height: 30.0),
          _buildSectionTitle('Attachment'),
          _buildDivider(),
          SizedBox(height: 10.0),
          biblio.link != null
              ? _buildAttachment()
              : Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Not found!'),
                )
        ],
      ),
    );
  }

  _buildImageTitleSection() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            child: Hero(
              tag: 'tag_image',
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CachedNetworkImage(
                  imageUrl: biblio.image ??
                      'https://slims.web.id/demo/images/default/image.png',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => LinearProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            width: 136.0,
            height: 160.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Flexible(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Hero(
                tag: 'tag_title',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    biblio.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Hero(
                  tag: 'tag_author',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      biblio.authors,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey),
                    ),
                  ))
            ],
          ))
        ],
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        '$title',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _buildDivider() => Divider(
        color: Theme.of(context).textTheme.caption.color,
      );

  _buildAttachment() {
    return Stack(
      children: <Widget>[
        ListTile(
          title: Text('View Book'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  if (biblio.path != null) return PdfView.fromPath(biblio.path);
                  return PdfView(biblio.link);
                }));
          },
          trailing: !File(biblio.path ?? '/xxx.xx').existsSync() ? IconButton(
            icon: Icon(_showIcon()),
            onPressed: () async {
              // check permission
              _permissionReady = await _checkPermission();

              if (_taskInfo == null) {
                setState(() {
                  this._isLoading = true;
                });

                _TaskInfo tInfo =
                    _TaskInfo(name: biblio.title, link: biblio.link);
                tInfo.taskId = await FlutterDownloader.enqueue(
                  url: biblio.link,
                  savedDir: _localPath,
                  showNotification: false,
                );

                setState(() {
                  this._taskInfo = tInfo;
                });
              }
            },
          ) : null,
        ),
        _showIndicator()
      ],
    );
  }

  Future<bool> _checkPermission() async {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _prepare() async {
    _localPath = (await getExternalStorageDirectory()).path +
        Platform.pathSeparator +
        'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) savedDir.create();
  }

  _showIcon() {
    if (_taskInfo == null) {
      return Icons.download_rounded;
    } else if (_taskInfo.status == DownloadTaskStatus.complete) {
      return Icons.download_done_rounded;
    } else {
      return Icons.sync;
    }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_taskInfo != null) {
        setState(() {
          _taskInfo.status = status;
          _taskInfo.progress = progress;
        });

        // if task is complete
        if (_taskInfo.status == DownloadTaskStatus.complete) {
          // update biblio
          final tasks = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE task_id='${_taskInfo.taskId}'");
          DownloadTask _downloadTask = tasks.first;
          biblio.path = _downloadTask.savedDir + Platform.pathSeparator + _downloadTask.filename;
          await DbHelper().update(biblio);
          print(biblio.path);
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  _showIndicator() {
    if (_taskInfo != null) {
      return _taskInfo.status == DownloadTaskStatus.running ||
              _taskInfo.status == DownloadTaskStatus.paused
          ? Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: LinearProgressIndicator(
                value: _taskInfo.progress / 100,
              ),
            )
          : Container();
    }
    return Container();
  }
}

class _TaskInfo {
  final String name;
  final String link;

  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}
