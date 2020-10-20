import 'package:cached_network_image/cached_network_image.dart';
import 'package:estilos/src/pages/detail.dart';
import 'package:estilos/src/pages/update.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilos/src/pages/add.dart';
import 'package:estilos/src/services/auth_service.dart';
import 'package:flutter_image/network.dart';
import 'package:google_sign_in/google_sign_in.dart';

final AuthService _auth = AuthService();

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final db = Firestore.instance;
  final FirebaseAuth _authG = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController searchController = TextEditingController();
  TextEditingController priceInputController;
  TextEditingController nameInputController;

  Future resultsLoaded;
  List allResults = [];
  List resultsList = [];


  String id;
  String name;
  String price;

  bool searchState = false;

  @override
  void initState(){
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose(){
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getPosts();
  }

  onSearchChanged(){
    searchResultList();
  }

  searchResultList(){
    
    var showResults = [];

    if(searchController.text != ""){
      for(var tripSnapshot in allResults){
        var title = Trip.fromSnapshot(tripSnapshot).nameFB.toLowerCase();
        if(title.contains(searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    }else{
      showResults = List.from(allResults);
    }

    setState(() {
      resultsList = showResults;
    });
  }

  getPosts() async {
    var datos = await db.collection("ropaEstilos").getDocuments();

    setState(() {
      allResults = datos.documents;
    });

    searchResultList();

    return 'Complete';

  }


  //create function for delete one register
  void deleteData(DocumentSnapshot doc) async {
    await db.collection('ropaEstilos').document(doc.documentID).delete();
    setState(() => id = null);
  }

  navigateToDetail(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  ds: ds,
                )));
  }

  navigateToUpdate(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateProduct(
                  ds: ds,
                )));
  }

  //Sign in with google
  bool isSignIn = false;

  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final AuthResult result = await _authG.signInWithCredential(credential);
    final FirebaseUser user = result.user;

    final FirebaseUser currentUser = await _authG.currentUser();
    assert(user.uid == currentUser.uid);

    print('FOTO GOOGLE INICIO');
    print(user.photoUrl);
    print(user.uid);

    return Future.value(true);
  }

  //Sign out with google
  Future<void> signOutGoogle() async {
    return await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: !searchState
            ? Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Image.asset(
                      "assets/estilos_logo.png",
                      fit: BoxFit.contain,
                      height: 32,
                    ),
                  ])
            : TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.red),
                    hintText: 'Buscar...',
                    hintStyle: TextStyle(color: Colors.red)),
              ),
        actions: <Widget>[
          !searchState
              ? IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.cancel),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      searchState = !searchState;
                    });
                  }),
          /* Container(
                              margin: EdgeInsets.only(right: 1.0),
                              child: CircleAvatar(
                               //backgroundImage: NetworkImage(),
                              ),
                            ), */
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
              await _auth.signOutGoogle();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            label: Text('Salir'),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("ropaEstilos").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text('"Loading...');
            }
            //int length = snapshot.data.documents.length;
            return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //two columns
                  mainAxisSpacing: 0.1, //space the card
                  childAspectRatio: 0.60, //space largo de cada card
                ),
                itemCount: resultsList.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  final DocumentSnapshot doc = resultsList[index];
                  return Container(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () => navigateToDetail(doc),
                                child: Container(
                                  child: Image(
                                    image: CachedNetworkImageProvider(
                                        doc.data["image"]),
                                  ),
                                  width: 190,
                                  height: 200,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    doc.data["name"],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 19.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    doc.data["price"],
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15.0),
                                  ),
                                  //onTap: () => navigateToDetail(doc),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => navigateToUpdate(doc),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                          '¿Quieres eliminar esta prenda?'),
                                      actions: <Widget>[
                                        FlatButton(
                                            textColor: Colors.red,
                                            child: Text('Eliminar'),
                                            onPressed: () {
                                              deleteData(doc);
                                              Navigator.pop(context, true);
                                            }),
                                        FlatButton(
                                          textColor: Colors.black,
                                          child: Text('Regresar'),
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  

}

//Trip para el buscador
class Trip{
  String nameFB;

  Trip(this.nameFB);

  Trip.fromSnapshot(DocumentSnapshot snapshot) :
  nameFB = snapshot['name'];
}