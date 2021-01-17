import 'package:bibliography/models/biblio.dart';
import 'package:flutter/material.dart';

class EntryForm extends StatefulWidget {
  final Biblio biblio;

  EntryForm(this.biblio);

  @override
  EntryFormState createState() => EntryFormState(this.biblio);
}

class EntryFormState extends State<EntryForm> {
  Biblio biblio;

  EntryFormState(this.biblio);

  TextEditingController titleController = TextEditingController();
  TextEditingController publisherController = TextEditingController();
  TextEditingController publishYearController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController synopsisController = TextEditingController();
  TextEditingController authorsController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController editionController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  String typeValue = 'Book';

  @override
  Widget build(BuildContext context) {
    if (biblio != null) {
      titleController.text = biblio.title;
      publisherController.text = biblio.publisher;
      publishYearController.text = biblio.publishYear;
      isbnController.text = biblio.isbn;
      synopsisController.text = biblio.synopsis;
      authorsController.text = biblio.authors;
      subjectController.text = biblio.subject;
      editionController.text = biblio.edition;
      sourceController.text = biblio.source;
      notesController.text = biblio.notes;
      linkController.text = biblio.link;
      if(typeValue != biblio.type && biblio.type != null)
        setState(() {
          typeValue = biblio.type;
        });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bibliography'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: InputDecorator(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: typeValue,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        typeValue = newValue;
                      });
                    },
                    items: <String>[
                      'Book',
                      'Article',
                      'News'
                    ].map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    )).toList(),
                  ),
                ),
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: authorsController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Authors',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: editionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Edition',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: publisherController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Publisher',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: publishYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Publish Year',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: isbnController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: 'ISBN',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: subjectController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: sourceController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Source',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: linkController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                    labelText: 'Online Resources',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                onChanged: (value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: synopsisController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelText: 'Synopsis',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                maxLines: null,
                onChanged: (value) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: notesController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                maxLines: null,
                onChanged: (value) {},
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (biblio == null) {
            biblio = Biblio(null);
          }

          biblio.title = titleController.text.trim();
          biblio.publisher = publisherController.text.trim();
          biblio.publishYear = publishYearController.text.trim();
          biblio.isbn = isbnController.text.trim();
          biblio.synopsis = synopsisController.text;
          biblio.authors = authorsController.text;
          biblio.subject = subjectController.text;
          biblio.edition = editionController.text;
          biblio.source = sourceController.text;
          biblio.notes = notesController.text;
          biblio.type = typeValue;
          biblio.link = linkController.text;

          Navigator.pop(context, biblio);
        },
        child: const Icon(Icons.save),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
