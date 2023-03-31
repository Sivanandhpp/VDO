import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vdo/theme/theme_color.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: ThemeColor.shimmerBG,
          highlightColor: ThemeColor.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          // Container(
                          //   height: 30,
                          //   width: 120,
                          //   decoration: BoxDecoration(
                          //     color: ThemeColor.white,
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          // ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 210,
                      decoration: const BoxDecoration(
                        color: ThemeColor.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ThemeColor.primary,
                          border: Border.all(
                              color: ThemeColor.primary, width: 0.1)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          // color:TheneData,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ThemeColor.secondary, width: 0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 15,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          // color:TheneData,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ThemeColor.secondary, width: 0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 15,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          // color:TheneData,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ThemeColor.secondary, width: 0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 15,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          // color:TheneData,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ThemeColor.secondary, width: 0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 15,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          // color:TheneData,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ThemeColor.secondary, width: 0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 15,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          // color:TheneData,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ThemeColor.secondary, width: 0.5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 15,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: ThemeColor.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: ThemeColor.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
