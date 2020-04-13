import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class UploadTaskLoadingList extends StatelessWidget {

  const UploadTaskLoadingList(
      {Key key, this.task, this.onDismissed, this.onDownload,this.onUploaded})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;
  final VoidCallback onUploaded;

  String get status {
    String result;

    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Completado';
      } else if (task.isCanceled) {
        result = 'Cancelado';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Cargando';
    } else if (task.isPaused) {
      result = 'Pausado';
    }
    //print('ESTAO !!!!!!!!!!!: ' +result + ': '+task.hashCode.toString());
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,

      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {

        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text(
            '$status: ${_bytesTransferred(snapshot)} bytes Enviados', textScaleFactor: 0.6,
            style: TextStyle(
                color: status.contains('Completado') ? Colors.green : Colors.amber
            ),
          );


          if(task.isComplete && task.isSuccessful){
            onUploaded();
          }

        } else {
          subtitle = const Text('Empezando...');
        }

        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Subiendo: ${task.lastSnapshot != null ? task.lastSnapshot.ref .path : ''}' , textScaleFactor: 0.7,),
                subtitle,
                Divider()
              ],
            )

           /* trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /* Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
              Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),*/
              ],
            ),*/

          ),
        );
      },
    );
  }
}