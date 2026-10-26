import 'package:drift/drift.dart';
import 'package:starelectricerp/data/tables/customers.dart';
import 'package:starelectricerp/data/tables/enums.dart';

class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNo => text().unique()();
  TextColumn get invoiceType => textEnum<InvoiceType>()();
  IntColumn get customerId => integer().references(Customers, #id)();
  DateTimeColumn get invoiceDate => dateTime()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  RealColumn get subtotal => real()();
  RealColumn get cgstAmount => real()();
  RealColumn get sgstAmount => real()();
  
  /// Added for standard GST format completeness.
  /// Remains 0.0 for this business since all trade is intra-state (Gujarat),
  /// but required for the 3-column GST breakup on PDFs.
  RealColumn get igstAmount => real().withDefault(const Constant(0.0))();
  BoolColumn get useIgst => boolean().withDefault(const Constant(false))();
  RealColumn get discountAmount => real()();
  BoolColumn get isDiscountPercentage => boolean().withDefault(const Constant(false))();
  RealColumn get discountRate => real().nullable()();
  BoolColumn get distributeDiscountAcrossItems => boolean().withDefault(const Constant(true))();
  RealColumn get deliveryCharge => real().nullable()();
  RealColumn get grandTotal => real()();
  TextColumn get amountInWords => text()();
  TextColumn get status => textEnum<InvoiceStatus>()();
  BoolColumn get requiresEWayBill => boolean().withDefault(const Constant(false))();
  BoolColumn get requiresEInvoice => boolean().withDefault(const Constant(false))();
  TextColumn get irnNumber => text().nullable()();
  TextColumn get signedPdfPath => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get reminderSentDate => dateTime().nullable()();

  TextColumn get shipToName => text().nullable()();
  TextColumn get shipToAddress => text().nullable()();
  TextColumn get placeOfSupply => text().nullable()();

  TextColumn get poNumber => text().nullable()();
  DateTimeColumn get poDate => dateTime().nullable()();
  TextColumn get gpNumber => text().nullable()();
  DateTimeColumn get gpDate => dateTime().nullable()();
  IntColumn get paymentTermDays => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
