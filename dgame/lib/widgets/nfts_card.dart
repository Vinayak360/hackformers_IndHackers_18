import 'package:dgame/pages/nft_details.dart';
import 'package:dgame/providers/wallet_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NFTs extends StatefulWidget {
  const NFTs({Key? key}) : super(key: key);

  @override
  State<NFTs> createState() => _NFTsState();
}

class _NFTsState extends State<NFTs> {
  Widget nftcard({
    required int index,
    required Map jsonData,
  }) {
    return NFTCard(
      context: context,
      index: index,
      jsonData: jsonData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<WalletProvider>().nftData.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var data = context.read<WalletProvider>().nftData[index];
        return nftcard(index: index, jsonData: data);
      },
    );
  }
}

class NFTCard extends StatelessWidget {
  const NFTCard({
    super.key,
    required this.context,
    required this.index,
    required this.jsonData,
    this.isMyNft = false,
  });

  final BuildContext context;
  final int index;
  final Map jsonData;
  final bool isMyNft;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("TApped");
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => NFTDetailsPage(
                  index: index, jsonData: jsonData, isMyNft: isMyNft),
            ));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0xff424242), borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Hero(
              tag: "image$index",
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: ClipRRect(
                  child: Image.network(
                    jsonData["viewurl"],
                    // context.read<WalletProvider>().nftData[index]["viewurl"],
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, bottom: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: "name$index",
                        child: Text(
                          jsonData["name"],
                          // "Lucy",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      isMyNft
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Color(0xffFF2281)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      size: 20,
                                    ),
                                    Text(
                                      "3.5 ETH",
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                  isMyNft
                      ? Container()
                      : Hero(
                          tag: "buyButton$index",
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => NFTDetailsPage(
                                          index: index,
                                          jsonData: jsonData,
                                          isMyNft: isMyNft),
                                    ));
                              },
                              child: Text("View NFT"),
                              style: ElevatedButton.styleFrom(
                                  //fixedSize: Size(120, 25),
                                  backgroundColor: Color(0xffFF2281),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)))),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
