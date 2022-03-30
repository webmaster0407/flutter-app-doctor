import 'dart:convert';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/purchaseSubscription.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:fluttertoast/fluttertoast.dart';

class Stripe extends StatefulWidget {

    final String? plan;
    final int? value;
    final int? id;

    Stripe({
    this.plan,
    this.id,
    this.value});

  @override
  _StripeState createState() => _StripeState();
}

class _StripeState extends State<Stripe> {
  stripe.CardFieldInputDetails? _card;

  stripe.TokenData? tokenData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setKey();
  }

  Future setKey() async {
    stripe.Stripe.publishableKey = SharedPreferenceHelper.getString(Preferences.stripPublicKey);
    await stripe.Stripe.instance.applySettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: stripe.CardField(
                  autofocus: true,
                  onCardChanged: (card) {
                    setState(() {
                      _card = card;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: _card?.complete == true ? _handleCreateTokenPress : null,
                  child:Text(getTranslated(context,payment_gateway_pay).toString()),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreateTokenPress() async {
    if (_card == null) {
      return;
    }

    try {

      final tokenData = await stripe.Stripe.instance.createToken(
        const stripe.CreateTokenParams(type: stripe.TokenType.Card),
      );
      setState(() {

        this.tokenData = tokenData;

        purchasesubscriptions();

      });

      return;
    } catch (e) {

      rethrow;
    }
  }

  Future<BaseModel<PurchaseSubscription>> purchasesubscriptions() async {

    var parsedata = json.decode(widget.plan!);

    Map<String, dynamic> body = {
      "subscription_id": widget.id,
      "payment_token": tokenData!.id,
      "payment_status": 1,
      "payment_type":"Stripe",
      "duration": ("${parsedata[widget.value]['month']}"),
      "amount": ("${parsedata[widget.value]['price']}"),
    };

    PurchaseSubscription response;

    try {
      response = await RestClient(RetroApi().dioData()).purchasesubscriptionrequest(body);
      setState(() {
        Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          msg: getTranslated(context,payment_success).toString(),);
        Navigator.pushNamed(context, "loginhome") ;
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

}


