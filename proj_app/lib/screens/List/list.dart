import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/models/product.dart';
import 'package:namer_app/screens/List/product_selection_page.dart';
import 'package:namer_app/screens/Products/productDetail.dart';
import 'package:namer_app/services/database_service.dart';

class ListItem {
  final String name;
  final List<Product> products;

  ListItem(this.name, {List<Product>? products}) : products = products ?? [];
}

class ListProvider extends ChangeNotifier {
  List<ListItem> _lists = [];

  List<ListItem> get lists => _lists;

  void addList(String name) {
    _lists.add(ListItem(name));
    notifyListeners();
  }

  void removeList(int index) {
    _lists.removeAt(index);
    notifyListeners();
  }

  void addProductToList(int listIndex, Product product, BuildContext context) {
  if (listIndex >= 0 && listIndex < _lists.length) {
    if (_lists[listIndex].products.any((p) => p.name == product.name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product "${product.name}" is already in the list.')),
      );
      return;
    }
      _lists[listIndex].products.add(product);
      notifyListeners();
    } else {
      throw Exception('Invalid list index');
    }
  }

  void removeProductFromList(int listIndex, int productIndex) {
    if (listIndex >= 0 && listIndex < _lists.length) {
      if (productIndex >= 0 && productIndex < _lists[listIndex].products.length) {
        _lists[listIndex].products.removeAt(productIndex);
        notifyListeners();
      } else {
        throw Exception('Invalid product index');
      }
    } else {
      throw Exception('Invalid list index');
    }
  }

}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(('Lists'), style: TextStyle(color: Colors.black),),
      ),
      body: Consumer<ListProvider>(
        builder: (context, listProvider, _) => ListView.builder(
          itemCount: listProvider.lists.length,
          itemBuilder: (context, index) {
            final List<Product> products = listProvider.lists[index].products;
            final double meanScore = products.isNotEmpty ? _calculateMeanScore(products) : 0;

            return Column(
              children: [
                ListTile(
                  title: Text(listProvider.lists[index].name),
                  subtitle: Text('Mean Score: $meanScore'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListDetailsPage(
                          listIndex: index,
                          listName: listProvider.lists[index].name,
                          products: listProvider.lists[index].products,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      listProvider.removeList(index);
                    },
                  ),
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListForm()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 148, 176, 116),
        child: Icon(Icons.add,color:Colors.white,),
      ),
    );
  }

  double _calculateMeanScore(List<Product> products) {
  int totalScore = 0;
  for (final product in products) {
    totalScore += product.score;
  }
  if (products.isNotEmpty) {
    double meanScore = totalScore / products.length;
    return double.parse(meanScore.toStringAsFixed(1));
  } else {
    return 0.0;
  }
}
}

class ListDetailsPage extends StatelessWidget {
  final int listIndex;
  final String listName;
  final List<Product> products;

  const ListDetailsPage({
    required this.listIndex,
    required this.listName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final ListProvider listProvider = Provider.of<ListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit List', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 148, 176, 116),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(listName, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  child: ListTile(
                    title: Text(products[index].name),
                    subtitle: Text(
                      'Price: \$${products[index].price.toString()}, Origin: ${products[index].originCountry}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: products[index]),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () => _showEditNoteDialog(context, products[index], index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            listProvider.removeProductFromList(listIndex, index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.swap_horiz),
                          onPressed: () => _showSuggestedProducts(context, products[index], listProvider, listIndex, index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductSelectionPage(listIndex: listIndex),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 148, 176, 116), // Set the button color to match the app bar
              ),
              child: Text('Add Product', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, Product product, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String note = product.note;

        return AlertDialog(
          title: Text('Edit Note'),
          content: TextFormField(
            initialValue: note,
            onChanged: (value) {
              note = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter your note',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                product.note = note;
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSuggestedProducts(BuildContext context, Product product, ListProvider listProvider, int listIndex, int productIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<List<Product>>(
          stream: DatabaseService().getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Product>? allProducts = snapshot.data;
              if (allProducts != null && allProducts.isNotEmpty) {
                List<Product> suggestions = allProducts.where((p) => p.score > product.score).toList();
                if (suggestions.isNotEmpty) {
                  return ListView.builder(
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(suggestions[index].name),
                        subtitle: Text('Score: ${suggestions[index].score}'),
                        onTap: () {
                          listProvider.removeProductFromList(listIndex, productIndex);
                          listProvider.addProductToList(listIndex, suggestions[index], context);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No suggestions available'));
                }
              } else {
                return Center(child: Text('No products available'));
              }
            }
          },
        );
      },
    );
  }
}

class ListForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New List', style: TextStyle(color: Colors.white),),
        backgroundColor:Color.fromARGB(255, 148, 176, 116),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'List Name', focusColor: Colors.lightGreen[200]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String name = controller.text;
                if (name.isNotEmpty) {
                  Provider.of<ListProvider>(context, listen: false).addList(name);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('List created successfully')),
                );
                Navigator.pop(context);
              },
              child: Text('Create List', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            ),
          ],
        ),
      ),
    );
  }
}
