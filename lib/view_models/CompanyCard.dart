import 'package:flutter/material.dart';
import 'package:meal_it_admin/Classes/Company.dart';

class CompanyCard extends StatefulWidget {
  CompanyCard({Key? key}) : super(key: key);

  late Company company;

  CompanyCard setCompany(Company value) {
    this.company = value;
    return this;
  }

  @override
  State<CompanyCard> createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 4.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.company.companyName,style: TextStyle(

                    fontSize: 21
                ),
                  // textAlign: TextAlign.end,
                ),
                SizedBox(height: 10),
                Text(widget.company.email, style:TextStyle(
                    fontSize: 19
                ),

                ),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.store),
                    Text("20"),
                    SizedBox(width: 10,)
                  ],
                ),

              ],
            ),
          ),
          Container(
            width: 120,
            height: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.company.companyImgUrl.isEmpty ?  AssetImage("assets/Images/dog.jpg") : Image.network(widget.company.companyImgUrl).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),

    );
  }
}
