import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: Colors.deepOrange.withOpacity(0.23),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.deepOrange.withOpacity(0.5),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  // surffix isn't working properly  with SVG
                  // thats why we use row
                  // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                ),
              ),
            ),
            Icon(Icons.search_rounded),
          ],
        ),
      ),
    );
  }

}