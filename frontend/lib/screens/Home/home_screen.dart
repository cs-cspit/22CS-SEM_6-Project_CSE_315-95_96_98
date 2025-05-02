import 'package:driver_app/api_helper/Driver_basic/driver_basic.dart';
import 'package:driver_app/state_classes/Authentication/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/state_classes/localization_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    // Initialize _isOnDuty from the provider state
    _isOnDuty = authState.onDuty == 1;
  }

  Future<void> _toggleDuty(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await DriverBasic.toggleDuty(value);

      if (response.statusCode == 200) {
        setState(() {
          _isOnDuty = value;
        });

        // Update the provider state
        final authState = Provider.of<AuthState>(context, listen: false);
        authState.updateOnDuty(value ? 1 : 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update duty status.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late bool _isOnDuty;

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localization.translate("on_duty"),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _isOnDuty,
                  onChanged: (value) {
                    _toggleDuty(value);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEarningsCard(context, localization, "today_earnings", "270 ₹"),
                _buildEarningsCard(context, localization, "weekly_earnings", "3032 ₹"),
              ],
            ),
            SizedBox(height: 32),
            Text(
              localization.translate("incoming_ride_requests"),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        _buildRideRequestCard(
                          context,
                          localization,
                          "ride_start_location_1",
                          "ride_end_location_1",
                          "6:00 P.M",
                          5,
                          250,
                          true,
                        ),
                        _buildRideRequestCard(
                          context,
                          localization,
                          "ride_start_location_2",
                          "ride_end_location_2",
                          "6:45 P.M",
                          3,
                          200,
                          false,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard(
      BuildContext context, LocalizationProvider localization, String key, String amount) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            localization.translate(key),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(amount, style: TextStyle(fontSize: 18, color: Color(0xFF0E6E2F))),
        ],
      ),
    );
  }

  Widget _buildRideRequestCard(
    BuildContext context,
    LocalizationProvider localization,
    String startKey,
    String endKey,
    String time,
    int passengers,
    int price,
    bool isTwoWay,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 8),
                Text(localization.translate(startKey)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text(localization.translate(endKey)),
                if (isTwoWay)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        localization.translate("two_way"),
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${passengers.toString()} ${localization.translate("person")}",
                ),
                Text("$price ₹"),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(localization.translate("accept"), style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0E6E2F),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(localization.translate("reject"), style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
