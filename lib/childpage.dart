import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'model/file_path_res_entity.dart';
import 'pop.dart';
import 'httpmanager.dart';

import 'life/life_state.dart';

class ChildPage extends StatefulWidget {
  final String childName;
  final String childPath;

  const ChildPage({Key key, @required this.childName, @required this.childPath})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChildPageState();
  }
}

class ChildPageState extends LifeState<ChildPage> {
  List<FilePathResFolderlist> _folderList = [];
  List<FilePathResFilelist> _fileList = [];

  @override
  void onStart() {
    super.onStart();
    _getFilePathData();
  }

  void _getFilePathData() async {
    Pop.showLoading(context);
    try {
      FilePathRes filePathRes = await KAPI.getFilePathList(widget.childPath);
      setState(() {
        _folderList = filePathRes.folderList;
        _fileList = filePathRes.fileList;
      });
    } catch (e) {
      Pop.showToast(context, e.message);
    } finally {
      Pop.dissLoading(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.childName),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index < _folderList.length) {
                return FolderItem(_folderList[index]);
              } else {
                return FileItem(_fileList[index - _folderList.length]);
              }
            },
            itemCount: _folderList.length + _fileList.length,
          ))
        ],
      )),
    );
  }
}

class FolderItem extends StatelessWidget {
  const FolderItem(this._item);

  final FilePathResFolderlist _item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChildPage(childName: _item.name, childPath: _item.path);
          }));
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.folder,
                  color: Colors.blue[500],
                )),
            Expanded(
              child: Text(
                _item.name,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ));
  }
}

class FileItem extends StatelessWidget {
  const FileItem(this._item);

  final FilePathResFilelist _item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: Icon(
              Icons.book,
              color: Colors.blue[500],
            )),
        Expanded(
          child: Text(
            _item.name,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    ));
  }
}
