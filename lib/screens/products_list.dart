import 'dart:convert';
import 'dart:io';
import 'package:d_element_test/models/article.dart';
import 'package:d_element_test/widgets/product_short.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Map<String, String> headers = {HttpHeaders.contentTypeHeader: "application/json;"};

class ProductsList extends StatefulWidget {
  ProductsList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProductsListState createState() => _ProductsListState();
}



class _ProductsListState extends State<ProductsList> {

  List<Article> itemsAll = [];
  List<Article> itemsLocal = [];
  bool loadingData =false;
  bool loadingPage =false;

  int itemsCount;
  int countOnPage = 6;
  int currentPage;
  int totalPages;


  int fromItem;
  int toItem;

  @override
  void initState() {
    super.initState();
    getData('loadingData');
  }


  void getData(String type) async {

    try {
      setState(() {
        loadingData = true;
      });
      var response = await http.get('https://d-element.ru/test_api.php', headers: headers);
      if (200 != response.statusCode) {
        throw HttpException('HttpException');
      }

      Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
       List<Article> dataArr =  jsonData['items'].map<Article>((json) => Article.fromJson(json)).toList();
      /*setState(() {
        items =  jsonData['items'].map<Article>((json) => Article.fromJson(json)).toList();
        loadingData = false;
      });*/
      itemsAll = dataArr;
      //itemsAll = dataArr.getRange(0, 1).toList();
      await _localPagination('init');


    }on SocketException catch (e) {
      print(e.toString());
    }on HttpException  catch (e){
      print(e.toString());
    }on FormatException  catch (e){
      print(e.toString());
    }on AppException catch (e){
      print(e.toString());
    }catch (e, stacktrace) {
      print(e.toString());
      print('s = $stacktrace');
    }finally{
      http.Client().close();
    }
  }


    _localPagination(String type) async{

        if(itemsAll.length == 0) {
          setState(() {
            loadingData = false;
            loadingPage = false;
          });
          return;
        }



        if(type=='init'){
          itemsCount = itemsAll.length;
          //totalPages = (itemsCount / countOnPage).ceil();
          //currentPage = 1;

          fromItem = 0;
          toItem = fromItem + countOnPage ;
          print('itemsCount = $itemsCount');
          print('fromItem = $fromItem');
          print('toItem = $toItem');

           if(itemsCount <countOnPage ) { /// если всего одна страница
              itemsLocal = itemsAll;
              setState(() {
                loadingData = false;
              });
              return;
           }else{ /// если более одной
             //Iterable<Article> t= itemsAll.getRange(fromItem, toItem) ;
             itemsLocal = itemsAll.getRange(fromItem, fromItem + countOnPage).toList();
             print('first l ${itemsLocal.length}');
             fromItem = fromItem +countOnPage;
             setState(() {
               loadingData = false;
             });
             return;
           }



        } else if (type=='next'){


          if (itemsLocal.length == itemsAll.length) {
            print('количество равно');
            return;
          }

            print('show next');
            setState(() {
              loadingPage = true;
            });

            await Future.delayed(Duration(seconds: 5));


            if(itemsCount <countOnPage) { /// если всего одна страница
              //itemsLocal = itemsAll;
              setState(() {
                loadingPage = false;
              });
              return;
            }else{ /// если более одной
              //Iterable<Article> t= itemsAll.getRange(fromItem, toItem) ;
              //itemsLocal = itemsAll.getRange(fromItem, fromItem + countOnPage).toList();
              //print('first l ${itemsLocal.length}');

              setState(() {
                loadingPage = false;
                itemsLocal.addAll( itemsAll.getRange(fromItem, fromItem + countOnPage).toList());
              });

            }






        }







    }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    print('main height  = ${screenSize.height}');
    print('main width = ${screenSize.width}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(243, 244, 246, 0.94),
        centerTitle: true,
        title: Text('Список товаров'),
        bottom: PreferredSize(
            child: Container(
              color: Colors.grey,
              height: 1,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body:


      loadingData == true ?
      Center(
        child: Container(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      )
          : Column(
children: [

  Expanded(
    child: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !loadingPage ) {
            _localPagination('next');
          return true;
        }else{
          return false;
        }
      },
      child:

      /*ListView.builder(
        itemCount: itemsLocal.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${index.toString()} - ${itemsLocal[index].name}'),
          );
        },
      ),*/

      GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: itemsLocal.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
              child: ProductShort(data: itemsLocal[index],),
            )

              ;
              /*ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                    itemsLocal[index].image,
                   fit: BoxFit.fill,

                  //height: 150.0,
                  //width: 100.0,
                ),
              );*/
          }
      )

     /* MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount:itemsLocal.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.amber,
                child: Center(child: Text('$index')),
              );
            }
        ),
      )*/




    ),
  ),
      //*/

  Container(
    height: loadingPage ? 50.0 : 0,
    color: Colors.transparent,
    child: Center(
      child: new CircularProgressIndicator(),
    ),
  ),
],
      )
    );
  }
}



class AppException implements Exception {

  String _message;
  String _code;
  AppException([String message = 'Invalid value', String code = '']) {
    this._message = message;
    this._code = code;
  }

  @override
  String toString() {
    return _message;
  }
}