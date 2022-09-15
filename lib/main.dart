import 'dart:io';
import 'package:flutter/cupertino.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            fontSize: 18
          ),
          button: TextStyle(
            color: Colors.white
          )
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
               fontWeight: FontWeight.bold,
               fontFamily: 'OpenSans',
               fontSize: 20
            )
          )
        ),
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

//  String? titleInput;
final List<Transaction> _userTransactions = [
  //    Transaction(
  //   id: 't1', 
  //   title: 'new shoes', 
  //   amount: 99.99, 
  //   date: DateTime.now(),
  // ),
  // Transaction(
  //   id: 't2', 
  //   title: 'weekly grocery', 
  //   amount: 20.09, 
  //   date: DateTime.now(),
  // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransaction{
    return _userTransactions.where((tx){
      return tx.date!.isAfter(
        DateTime.now().subtract(
        Duration(days: 7)
        ),
        );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate ){
    final newTx = Transaction(
      title: txTitle, 
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString()
      );

      setState(() {
        _userTransactions.add(newTx);
      });
  }

void _startAddNewTransaction(BuildContext ctx){
  showModalBottomSheet(context: ctx, builder: (_){
    return GestureDetector(
      onTap: (){},
      child: NewTransaction(_addNewTransaction),
      behavior: HitTestBehavior.opaque,
      );
  },);
}

void _deleteTransaction(String id){
  setState(() {
    _userTransactions.removeWhere((tx) => tx.id == id);
  });
}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS 
    ? CupertinoNavigationBar(
      middle: Text('Expense track'),
    ) 
    : AppBar(
        title: Text('Expense track'),
        actions: [
          IconButton(
            onPressed: () => _startAddNewTransaction(context), 
            icon: Icon(Icons.add)
            )
        ],
      );

      final txListWidget = Container(
              height: (mediaQuery.size.height - 
              appBar.preferredSize.height - 
               mediaQuery.padding.top) * 0.7,
              child: TransactionList(_userTransactions, _deleteTransaction)
              );
            
    final pageBody = SingleChildScrollView(
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Show Chart'),
              Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                value: _showChart, 
                onChanged: (val){
                  setState(() {
                    _showChart = val;
                  });    
                }
                )
            ],),

            if(!isLandscape) Container(
              height: (mediaQuery.size.height - 
              appBar.preferredSize.height -
               mediaQuery.padding.top) * 0.3,
              child: Chart(_recentTransaction)
              ),

              if(!isLandscape) txListWidget,
              if(isLandscape) _showChart 
              ? Container(
              height: (mediaQuery.size.height - 
              appBar.preferredSize.height -
               mediaQuery.padding.top) * 0.7,
              child: Chart(_recentTransaction)
              ): txListWidget     
          ],
        ),
      );

    return Platform.isIOS 
    ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar) 
    : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS 
      ? Container() 
      : FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
        ),
   );
  }
}