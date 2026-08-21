import 'package:starelectricerp/core/utils/permission_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';

class ExcelExport {
  static Future<String?> exportData(String defaultFileName, List<List<dynamic>> rows) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      for (int i = 0; i < rows.length; i++) {
        for (int j = 0; j < rows[i].length; j++) {
          var value = rows[i][j];
          var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i));
          if (value is num) {
            cell.value = DoubleCellValue(value.toDouble());
          } else if (value is String) {
            cell.value = TextCellValue(value);
          } else if (value == null) {
            cell.value = null;
          } else {
            cell.value = TextCellValue(value.toString());
          }
        }
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {

        final hasPermission = await PermissionUtil.requestStoragePermission();
        if (!hasPermission) {
          throw Exception('Storage permission denied');
        }

        final Uri? selectedFilePath = await FilePicker.saveFile(

          dialogTitle: 'Save Excel Report',
          fileName: '$defaultFileName.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
          bytes: Uint8List.fromList(fileBytes),
        );

        if (selectedFilePath == null) {
          return null; // User canceled
        }
        
        return selectedFilePath.toFilePath();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to export Excel: $e');
    }
  }
}
