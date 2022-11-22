// import 'dart:developer';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class KeyImport {
//   final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

//   List<PlatformFile>? _paths;
//   FileType _pickingType = FileType.any;
//   String? _fileName;
//   String? _directoryPath;
//   String? _extension;
//   bool _isLoading = false;
//   bool _userAborted = false;
//   bool _multiPick = false;

//   static void pickFile() async {
//     try {
//       var file = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['json'],
//         onFileLoading: (FilePickerStatus status) => log(status.toString()),
//       );

//       _directoryPath = null;
//       _paths = (await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['json'],
//         onFileLoading: (FilePickerStatus status) => log(status.toString()),
//       ))
//           ?.files;
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation ${e.toString()}');
//     } catch (e) {
//       _logException(e.toString());
//     }

//     if (!mounted) return;

//     setState(() {
//       _isLoading = false;
//       _fileName =
//           _paths != null ? _paths!.map((e) => e.name).toString() : '...';
//       _userAborted = _paths == null;
//     });
//   }

//   void _clearCachedFiles() async {
//     resetState();
//     try {
//       await FilePicker.platform.clearTemporaryFiles();
//     } on PlatformException catch (e) {
//       _logException('Unsupported operation ${e.toString()}');
//     } catch (e) {
//       _logException(e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _logException(String message) {
//     log(message);
//     _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
//     _scaffoldMessengerKey.currentState?.showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     throw UnimplementedError();
//   }
// }
