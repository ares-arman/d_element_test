import 'package:d_element_test/models/article.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductShort extends StatefulWidget {

  final Article data;

  ProductShort({Key key, @required this.data }) : super(key: key);

  @override
  _ProductShortState createState() => _ProductShortState();
}

class _ProductShortState extends State<ProductShort> with SingleTickerProviderStateMixin {



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    print('height = ${screenSize.height}');
    print('width = ${screenSize.width}');
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            //color: Colors.blue,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                widget.data.image,
                fit: BoxFit.fill,
                //height: 150.0,
                //width: 100.0,
              ),
            ),
          )),
        SizedBox(height: 5,),
        Expanded(
            flex: 1,
            child: Container(
              //margin: const EdgeInsets.only(top: 5),
              width: double.infinity,
              //color: Colors.red,
              child: Text('${widget.data.article}', style: TextStyle(color: Color.fromRGBO(139, 155, 169, 1), fontSize: 12),),
            )),
        SizedBox(height: 5,),
        Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              //color: Colors.red,
              child: Text('${widget.data.name}', maxLines: 3, overflow: TextOverflow.fade),
            )),
        SizedBox(height: 5,),
        Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              //color: Colors.red,
              child: Text('${widget.data.price} руб.',overflow: TextOverflow.fade, style: TextStyle(fontWeight: FontWeight.bold),),
            )),
      ],
    );
  }
}
