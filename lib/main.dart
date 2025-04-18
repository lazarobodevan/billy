import 'package:billy/presentation/screens/balance_editor/bloc/balance_bloc.dart';
import 'package:billy/presentation/screens/bank/screens/add_mass_transactions/bloc/mass_transactions_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/more/screens/backup_and_restore/bloc/drive_backup_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/more/screens/categories/category_bloc/category_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/more/screens/categories/subcategory_bloc/subcategory_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/more/screens/credit_card_invoices/bloc/credit_card_invoice_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/more/screens/limits/bloc/limits_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/more/screens/limits/limit_editor/widgets/limit_picker/bloc/limit_picker_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/nav_page.dart';
import 'package:billy/presentation/screens/transaction/bloc/transaction_bloc.dart';
import 'package:billy/presentation/screens/transaction/transactions/bloc/list_transactions_bloc.dart';
import 'package:billy/presentation/shared/blocs/google_auth_bloc/google_auth_bloc.dart';
import 'package:billy/repositories/balance/balance_repository.dart';
import 'package:billy/repositories/category/category_repository.dart';
import 'package:billy/repositories/credit_card_invoices/credit_card_invoices_repository.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/repositories/limit/limit_repository.dart';
import 'package:billy/repositories/subcategory/subcategory_repository.dart';
import 'package:billy/repositories/transaction/transaction_repository.dart';
import 'package:billy/services/file_service/file_service.dart';
import 'package:billy/services/file_service/i_file_service.dart';
import 'package:billy/use_cases/google_drive/google_drive_backup_and_restore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'presentation/screens/transaction/add_transaction/add_transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.instance.database;
  await initializeDateFormatting('pt_BR', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (context) => TransactionRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => SubcategoryRepository()),
        RepositoryProvider(create: (context) => BalanceRepository()),
        RepositoryProvider(create: (context) => LimitRepository()),
        RepositoryProvider(create: (context) => CreditCardInvoicesRepository()),
        RepositoryProvider<IFileService>(create: (context) => FileService()),
        BlocProvider(
          create: (context) => TransactionBloc(
              transactionRepository:
                  RepositoryProvider.of<TransactionRepository>(context),
              balanceRepository:
                  RepositoryProvider.of<BalanceRepository>(context),
              invoicesRepository:
                  RepositoryProvider.of<CreditCardInvoicesRepository>(context)),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(
            RepositoryProvider.of<CategoryRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => SubcategoryBloc(
            categoryBloc: BlocProvider.of<CategoryBloc>(context),
            repository: RepositoryProvider.of<SubcategoryRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => ListTransactionsBloc(
              transactionRepository:
                  RepositoryProvider.of<TransactionRepository>(context),
              balanceRepository:
                  RepositoryProvider.of<BalanceRepository>(context),
              invoicesRepository:
                  RepositoryProvider.of<CreditCardInvoicesRepository>(context)),
        ),
        BlocProvider(
          create: (context) => DriveBackupBloc(
            googleDriveBackupAndRestore: GoogleDriveBackupAndRestore(),
            secureStorage: FlutterSecureStorage()
          ),
        ),
        BlocProvider(create: (context) => GoogleAuthBloc()),
        BlocProvider(
          create: (context) => BalanceBloc(
              balanceRepository:
                  RepositoryProvider.of<BalanceRepository>(context),
              invoicesRepository:
                  RepositoryProvider.of<CreditCardInvoicesRepository>(context)),
        ),
        BlocProvider(
          create: (context) => LimitsBloc(
            limitRepository: RepositoryProvider.of<LimitRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => LimitPickerBloc(
              categoryRepository:
                  RepositoryProvider.of<CategoryRepository>(context),
              subcategoryRepository:
                  RepositoryProvider.of<SubcategoryRepository>(context)),
        ),
        BlocProvider(
          create: (context) => CreditCardInvoiceBloc(
            creditCardInvoicesRepository:
                RepositoryProvider.of<CreditCardInvoicesRepository>(context),
            balanceRepository:
                RepositoryProvider.of<BalanceRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => MassTransactionsBloc(
            fileService: RepositoryProvider.of<IFileService>(context),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: NavigationPage(),
        routes: {
          "/transaction": (context) => AddTransaction(),
        },
      ),
    );
  }
}
