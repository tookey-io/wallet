import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyImportPage extends StatefulWidget {
  const KeyImportPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeyImportPageData();
}

class _KeyImportPageData extends State<KeyImportPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  List<PlatformFile>? _paths;
  FileType _pickingType = FileType.any;
  String? _fileName;
  String? _saveAsFileName;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => log(status.toString()),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _clearCachedFiles() async {
    _resetState();
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    _resetState();
    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: _pickingType,
      );
      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    log(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Picker example app'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: DropdownButton<FileType>(
                      hint: const Text('LOAD PATH FROM'),
                      value: _pickingType,
                      items: FileType.values
                          .map((fileType) => DropdownMenuItem<FileType>(
                                value: fileType,
                                child: Text(fileType.toString()),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() {
                            _pickingType = value!;
                            if (_pickingType != FileType.custom) {
                              _controller.text = _extension = '';
                            }
                          })),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 100.0),
                  child: _pickingType == FileType.custom
                      ? TextFormField(
                          maxLength: 15,
                          autovalidateMode: AutovalidateMode.always,
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'File extension',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                        )
                      : const SizedBox(),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 200.0),
                  child: SwitchListTile.adaptive(
                    title: const Text(
                      'Pick multiple files',
                      textAlign: TextAlign.right,
                    ),
                    onChanged: (bool value) =>
                        setState(() => _multiPick = value),
                    value: _multiPick,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _pickFiles(),
                        child: Text(_multiPick ? 'Pick files' : 'Pick file'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _selectFolder(),
                        child: const Text('Pick folder'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _saveFile(),
                        child: const Text('Save file'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _clearCachedFiles(),
                        child: const Text('Clear temporary files'),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) => _isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: CircularProgressIndicator(),
                        )
                      : _userAborted
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'User has aborted the dialog',
                              ),
                            )
                          : _directoryPath != null
                              ? ListTile(
                                  title: const Text('Directory path'),
                                  subtitle: Text(_directoryPath!),
                                )
                              : _paths != null
                                  ? Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      child: Scrollbar(
                                          child: ListView.separated(
                                        itemCount:
                                            _paths != null && _paths!.isNotEmpty
                                                ? _paths!.length
                                                : 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final bool isMultiPath =
                                              _paths != null &&
                                                  _paths!.isNotEmpty;
                                          final String name =
                                              'File $index: ${isMultiPath ? _paths!.map((e) => e.name).toList()[index] : _fileName ?? '...'}';
                                          final path = _paths
                                                  ?.map((e) => e.path)
                                                  .toList()[index]
                                                  .toString() ??
                                              "";

                                          return ListTile(
                                            title: Text(
                                              name,
                                            ),
                                            subtitle: Text(path),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      )),
                                    )
                                  : _saveAsFileName != null
                                      ? ListTile(
                                          title: const Text('Save file'),
                                          subtitle: Text(_saveAsFileName!),
                                        )
                                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
