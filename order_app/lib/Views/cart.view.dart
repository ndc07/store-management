import 'package:flutter/material.dart';

import './../Controllers/cart.controller.dart';

import './../Models/home.model.dart' as home;
import './../Models/menu.model.dart' as menu;

import './../Constants/theme.dart' as theme;

class CartScreen extends StatefulWidget {
  CartScreen({key, this.table, this.menuContext}):super(key: key);

  final home.Table table;
  final BuildContext menuContext;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  double _discount;
  TextEditingController _textController = new TextEditingController();

  @override
    void initState() {
      _discount = 0.0;
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildListFoods(context),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildListFoods(BuildContext context) {
    return Expanded(
      child: new Container(
        width: double.infinity,
        margin: EdgeInsets.all(5.0),
        child: new ListView.builder(
            itemExtent: 130.0,
            itemCount: widget.table.foods.length,
            itemBuilder: (_, index) => _buildFood(context, widget.table.foods[index])),
      ),
    );
  }

  Widget _buildFood(BuildContext context, menu.Food food) {
    return new Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: new Card(
          color: theme.primaryColor,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: new Container()),
              new Image.memory(
                food.image,
                width: 120.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
              new Expanded(child: new Container()),
              new Column(
                children: <Widget>[
                  new Expanded(child: new Container()),
                  new Text(
                    food.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: theme.fontColor, fontFamily: 'Dosis', fontSize: 20.0),
                  ),
                  new Text(
                    '\$' + food.price.toString(),
                    style: const TextStyle(
                        color: theme.fontColor,
                        fontFamily: 'Dosis',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  new Expanded(child: new Container())
                ],
              ),
              new Expanded(child: new Container()),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(
                      Icons.remove,
                      size: 16.0,
                      color: theme.fontColorLight,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.table.subFood(food);
                      });
                    },
                  ),
                  new Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: theme.fontColor
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 4.0, right: 4.0),
                      child: new Text(
                        food.quantity.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'Dosis',
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center
                      ),
                    )
                  ),
                  new IconButton(
                    icon: new Icon(
                      Icons.add,
                      size: 16.0,
                      color: theme.fontColorLight,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.table.addFood(food);
                      });
                    },
                  ),
                ],
              ),
              new Expanded(child: new Container()),
              new IconButton(
                icon: new Icon(
                  Icons.delete,
                  size: 20.0,
                  color: theme.fontColorLight,
                ),
                onPressed: () {
                  setState(() {
                    widget.table.deleteFood(food);
                  });
                },
              ),
              new Expanded(child: new Container()),
            ],
          ),
        ));
  }

  Widget _buildControls(BuildContext context) {

    TextStyle _itemStyle = new TextStyle(
      color: theme.fontColor, 
      fontFamily: 'Dosis', 
      fontSize: 16.0,
      fontWeight: FontWeight.w500
    );

    return new Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: theme.fontColorLight.withOpacity(0.2)),
        color: theme.primaryColor
      ),
      margin: EdgeInsets.only(top: 2.0, bottom: 7.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                'Total price: ',
                style: _itemStyle,
              ),
              new Expanded(child: Container()),
              new Text(
                '\$' + widget.table.getTotalPrice().toString(),
                style: _itemStyle,
              )
            ],
          ),
          new Divider(),
          new Row(
            children: <Widget>[
              new Text(
                'Discount: ',
                style: _itemStyle,
              ),
              new Expanded(child: Container()),
              new Container(
                width: 35.0,
                alignment: Alignment(1.0, 0.0),
                child: new TextField(
                  controller: _textController,
                  style: _itemStyle,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (double.parse(value) > 100 || double.parse(value) < 0) {
                      _textController.clear();
                      value = '0.0';
                    }
                    
                    setState(() {
                      _discount = double.parse(value);
                    }); 
                  },
                  onSubmitted: null,
                  decoration: InputDecoration.collapsed(
                    hintText: '0%', hintStyle: _itemStyle)
                  ),
              ),

            ],
          ),
          new Divider(),
          new Row(
            children: <Widget>[
              new Text(
                'Final total price: ',
                style: _itemStyle,
              ),
              new Expanded(child: Container()),
              new Text(
                '\$' + (widget.table.getTotalPrice()*(100 - _discount)/100).toString(),
                style: _itemStyle,
              )
            ],
          ),
          new Divider(),
          new GestureDetector(
            onTap: () {
              if (widget.table.foods.length > 0)
                _checkOut(context);
              else _error(context);

            },
            child: new Container(
              alignment: Alignment(0.0, 0.0),
              color: Color.fromARGB(255, 243, 73, 73),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 8.0),
              width: double.infinity,
              child: new Text(
                'Checkout',
                style: _itemStyle,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _error(BuildContext cartContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            'Error',
            style: theme.titleStyle
          ),
          content: new Text(
            'Can\'t be checkout for ' + widget.table.name + '!' + '\nPlease select foods!',
            style: theme.contentStyle 
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                'Ok',
                style: theme.okButtonStyle 
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(cartContext).pop();
              },
            )
          ],
        );
      }
    );
  }

  void _checkOut(BuildContext cartContext) async {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            'Confirm',
            style: theme.titleStyle
          ),
          content: new Text(
            'Do you want to be checkout for ' + widget.table.name + '?',
            style: theme.contentStyle 
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                'Ok',
                style: theme.okButtonStyle 
              ),
              onPressed: () async {

                /* Pop screens */
                Navigator.of(context).pop();
                Navigator.of(cartContext).pop();
                Navigator.of(widget.menuContext).pop();

                home.Table table = widget.table;
                setState(() {
                  table.status = -1;
                  table.foods.clear();
                });

                await Controller.instance.insertBill(table.id, table.dateCheckIn, DateTime.now(), _discount, table.getTotalPrice(), 1);
                int idBill = await Controller.instance.getIdBillMax();
                for (var food in table.foods) {
                  await Controller.instance.insertBillDetail(idBill, food.id, food.quantity);
                }

              },
            ),
            new FlatButton(
              child: new Text(
                'Cancel',
                style: theme.cancelButtonStyle  
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );

  }

}
