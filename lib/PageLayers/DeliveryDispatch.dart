import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_it_admin/Classes/BL.dart';
import 'package:meal_it_admin/Classes/DispatchTimes.dart';


class DeliveryDispatchPage extends StatefulWidget {

  GlobalKey<ScaffoldState> sacfFoldStatekey;


  DeliveryDispatchPage({required this.sacfFoldStatekey});

  @override
  _DeliveryDispatchPageState createState() => _DeliveryDispatchPageState();
}

class _DeliveryDispatchPageState extends State<DeliveryDispatchPage> {

  BusinessLayer _businessL = BusinessLayer();
  late List<DispatchTimes> dispatchTimes = [];



  Future<void> getDispatchTimes() async {
    dispatchTimes = await _businessL.getAllDispatchTimes();
    setState(() {

    });
  }


  @override
  void initState() {
    super.initState();
    getDispatchTimes();
    // Text(
    //   'Finish collecting orders',
    //   style: TextStyle(
    //     fontSize: 16.0,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 2,),
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                SizedBox(width: 2,),
                Text(
                  'Delivery Dispatch',
                  style: TextStyle(fontSize: 24.0),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                    itemCount: dispatchTimes.length,
                    itemBuilder: (context, index) {

                      final finishOrdersTime = dispatchTimes[index].finishingTime;
                      final startDeliveriesTime = dispatchTimes[index].startingTime;

                      return GestureDetector(
                        onTap: () {
                          _showUpdateDialog(context, dispatchTimes[index]);
                        },
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                'Finish collecting orders : ${finishOrdersTime.format(context)}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Start deliveries : ${startDeliveriesTime.format(context)}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    getStatus(finishOrdersTime, startDeliveriesTime),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog(context);
          },
          child: Icon(Icons.more_time),
          backgroundColor:  Color.fromRGBO(224, 76, 43, 1),

        ),
      ),
    );
  }


  String getStatus(TimeOfDay startTime, TimeOfDay endTime) {
    final now = TimeOfDay.now();
    final startDateTime = DateTime(1, 1, 1, startTime.hour, startTime.minute);
    final endDateTime = DateTime(1, 1, 1, endTime.hour, endTime.minute);

    if (startTime.hour < now.hour ||
        (startTime.hour == now.hour && startTime.minute <= now.minute)) {
      if (endTime.hour < now.hour ||
          (endTime.hour == now.hour && endTime.minute <= now.minute)) {
        return "OVER";
      } else {
        final duration = endDateTime.difference(DateTime(1, 1, 1, now.hour, now.minute));
        final hours = duration.inHours;
        final minutes = duration.inMinutes.remainder(60);
        return "Active (${hours}h ${minutes}m left)";
      }
    } else {
      final duration = startDateTime.difference(DateTime(1, 1, 1, now.hour, now.minute));
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return "In  (${hours}h ${minutes}m)";
    }
  }

  Future<void> _showAddDialog(BuildContext context) async {
    TextEditingController _controllerFinished = TextEditingController();
    TextEditingController _controllerStart = TextEditingController();

    TimeOfDay? _finishOrdersTimestamp = TimeOfDay.now();
    TimeOfDay? _startDeliveriesTimestamp = TimeOfDay.now();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        GlobalKey<FormState> _formKey=GlobalKey<FormState>();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            width: MediaQuery.of(context).size.width*.8,
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Text("Delivery dispatch time",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8,),
                  GestureDetector(
                    onTap: () async {
                      _finishOrdersTimestamp = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now()
                      );

                      _controllerFinished.text = _finishOrdersTimestamp!.format(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _controllerFinished,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.timer),
                          labelText: 'Finish Collecting Orders Time',
                          border: OutlineInputBorder(),
                        ),
                        // controller: _timeController,

                        validator: (value) {
                          if(value==null || value.trim().isEmpty){
                            return "Please select Time";
                          }

                          // if(_selectedDate.compareTo(DateTime.now())<0){
                          //   return "Please enter valid time It's recommended to give at least 1h";
                          // }

                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  GestureDetector(
                    onTap: () async {
                      _startDeliveriesTimestamp = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now()
                      );

                      _controllerStart.text = _startDeliveriesTimestamp!.format(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _controllerStart,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.timer),
                          labelText: 'Start deliver time',
                          border: OutlineInputBorder(),
                        ),
                        // controller: _timeController,

                        validator: (value) {
                          if(value==null || value.trim().isEmpty){
                            return "Please select Time";
                          }

                          if(_finishOrdersTimestamp == null){
                            return null;
                          }

                          if(_startDeliveriesTimestamp!.hour < _finishOrdersTimestamp!.hour || (_startDeliveriesTimestamp!.hour == _finishOrdersTimestamp!.hour && _startDeliveriesTimestamp!.minute < _finishOrdersTimestamp!.minute)){
                            return "Please enter valid time It's recommended to give at least 1h";
                          }

                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 8,),
                  Row(

                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,

                          ),

                        ),
                      ),
                      SizedBox(width: 8,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if(!_formKey.currentState!.validate()){
                              return;
                            }

                            if(_finishOrdersTimestamp == null || _startDeliveriesTimestamp == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please Selected an time"))
                              );
                              return;
                            }
                            DispatchTimes times = DispatchTimes.empty();
                            times.finishingTime = _finishOrdersTimestamp!;
                            times.startingTime = _startDeliveriesTimestamp!;
                            times.status = "Active";
                            String result = await _businessL.addDispatchTime(times);
                            if(result == "Success"){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Dispatch Time Added"))
                              );


                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Something when wrong while adding dispatch time"))
                              );
                            }

                            _controllerFinished.dispose();
                            _controllerStart.dispose();

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(225, 77, 42, 1),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Add'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showUpdateDialog(BuildContext context, DispatchTimes time) async {
    TextEditingController controllerFinished = TextEditingController();
    TextEditingController controllerStart = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    TimeOfDay? finishOrdersTime = time.finishingTime;
    TimeOfDay? startDeliveriesTime = time.startingTime;
    String status = time.status;
    await showDialog(
      context: context,


      builder: (BuildContext context) {
        controllerFinished.text = time.finishingTime.format(context);
        controllerStart.text = time.startingTime.format(context);
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width*.9,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  //Title
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: const Text("Update delivery dispatch time",
                            softWrap: true,
                            maxLines: null,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold

                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 16.0),

                  //Finished Time Picker
                  GestureDetector(
                    onTap: () async {
                      finishOrdersTime = await showTimePicker(
                          context: context, initialTime: finishOrdersTime!
                      );

                      if(finishOrdersTime != null){
                        controllerFinished.text = finishOrdersTime!.format(context);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: controllerFinished,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.timer),
                          labelText: 'Finish Collecting Orders Time',
                          border: OutlineInputBorder(),
                        ),
                        // controller: _timeController,

                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
                            return "Please select Time";
                          }

                          if(finishOrdersTime == null){
                            return null;
                          }

                          if(startDeliveriesTime!.hour < finishOrdersTime!.hour || (startDeliveriesTime!.hour == finishOrdersTime!.hour && startDeliveriesTime!.minute < finishOrdersTime!.minute)){
                            return "Please enter valid time It's recommended to give at least 1h";
                          }


                          return null;
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  //Start Time Picker
                  GestureDetector(
                    onTap: () async {
                      startDeliveriesTime = await showTimePicker(
                          context: context, initialTime: startDeliveriesTime!
                      );
                      if(startDeliveriesTime != null){
                        controllerStart.text = startDeliveriesTime!.format(context);
                      }

                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: controllerStart,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.timer),
                          labelText: 'Start deliver time',
                          border: OutlineInputBorder(),
                        ),


                        validator: (value) {
                          if (value == null || value
                              .trim()
                              .isEmpty) {
                            return "Please select Time";
                          }

                          // if(_selectedDate.compareTo(DateTime.now())<0){
                          //   return "Please enter valid time It's recommended to give at least 1h";
                          // }

                          return null;
                        },
                      ),
                    ),
                  ),


                  SizedBox(height: 16.0),

                  //Status
                  Row(
                    children: [
                      Text('Status:',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                      SizedBox(width: 4,),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: status,
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                status = value;
                              });
                            }
                          },
                          items: ["Deactivate", "Active"]
                              .map((status) =>
                              DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),



                  //Cancel and update Buttons
                  Row(
                    children: [

                      //Cancel
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,

                          ),
                          child: Text('Cancel'),
                        ),
                      ),

                      SizedBox(width: 4,),

                      //Update
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if(!formKey.currentState!.validate()){
                              return ;
                            }

                            if(startDeliveriesTime ==null || finishOrdersTime ==null || status.trim().isEmpty ){

                              return;
                            }

                            time.startingTime = startDeliveriesTime!;
                            time.finishingTime = finishOrdersTime!;
                            time.status = status;

                            String result = await  _businessL.updateDispatchTime(time);

                            if(result == "Success"){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Dispatch Time updated"))
                              );


                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Something when wrong while updating dispatch time"))
                              );
                            }

                            controllerFinished.dispose();
                            controllerStart.dispose();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(225, 77, 42, 1),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Update'),
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}