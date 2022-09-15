import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty? 
    LayoutBuilder(builder: (ctx, Constraints ){
      return Column(
          children: [
            Text('No Transaction added yet!',
            style: Theme.of(context).textTheme.headline6,),
            SizedBox(
              height: 10,
            ),
            Container(
              height: Constraints.maxHeight * 0.6,
              child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,))
          ],
        );
    }) : ListView.builder(
          itemBuilder: (ctx,index){
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5,),  
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: FittedBox(
                      child: Text('\₹${transactions[index].amount}'
                      )),
                  ),
                ),
                title: Text(
                  transactions[index].title as String,
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  DateFormat.yMMMd().format(transactions[index].date as DateTime),
                ),
                trailing: MediaQuery.of(context).size.width > 460 
                ? FlatButton.icon(
                  label: Text('Delete'),
                  icon: Icon(Icons.delete),
                  textColor: Theme.of(context).errorColor,
                  onPressed: () => deleteTx(transactions[index].id),)
                 :IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () => deleteTx(transactions[index].id),),
              ),
            );
          },
          itemCount: transactions.length,
              );
  }
}

/*



*/