import 'package:dgame/pages/metamask.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';
import '../widgets/nfts_card.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({Key? key}) : super(key: key);

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  getNfts() async {
    await context.read<WalletProvider>().getAllNft();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getNfts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0F0F0F),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Marketplace",
                  style: TextStyle(fontSize: 25),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: ImageIcon(
                      size: 60,
                      AssetImage(
                        "assets/images/metamask.gif",
                      ),
                      color: Colors.orange,
                    ))
              ],
            ),
          ),
          Expanded(
              child: context.watch<WalletProvider>().loadingNFT
                  ? Center(
                      child: Image.asset("assets/images/metamask.gif",
                          fit: BoxFit.fitHeight),
                    )
                  : NFTs()),
        ],
      )),
    );
  }
}
