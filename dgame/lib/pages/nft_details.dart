import 'package:dgame/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/buttons.dart';

class NFTDetailsPage extends StatefulWidget {
  const NFTDetailsPage(
      {super.key,
      required this.index,
      required this.jsonData,
      this.isMyNft = false});
  final int index;
  final Map jsonData;
  final bool isMyNft;

  @override
  State<NFTDetailsPage> createState() => _NFTDetailsPageState();
}

class _NFTDetailsPageState extends State<NFTDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: "image${widget.index}",
              child: Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  child: Image.network(
                    widget.jsonData["viewurl"],
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Hero(
              tag: "name${widget.index}",
              child: Text(
                widget.jsonData["name"],
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xffFF2281),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.jsonData["decription"],
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            widget.isMyNft
                ? Container()
                : Hero(
                    tag: "buyButton${widget.index}",
                    child: FancyButton(
                      child: Text(
                        "Buy Now",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'PressStart2P',
                        ),
                      ),
                      size: 35,
                      color: Color(0xffFF2281),
                      onPressed: () async {
                        await context.read<WalletProvider>().buyNFT(
                            tokenID: widget.jsonData['tokenId'],
                            context: context);
                        // Navigator.pushReplacement(
                        //     context,
                        //     CupertinoPageRoute(
                        //       builder: (context) => GamePage(),
                        //     ));
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
