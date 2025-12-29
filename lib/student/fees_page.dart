import 'package:flutter/material.dart';
//     class FeesPage extends StatefulWidget {
//       const FeesPage({super.key});
//
//       @override
//       State<FeesPage> createState() => _FeesPageState();
//     }
//
//     class _FeesPageState extends State<FeesPage> {
//       @override
//       Widget build(BuildContext context) {
//
//         String firstName;
//         String? middleName;
//         String? lastName;
//         String Class;
//         String section;
//         String amountFees;
//         DateTime dueDate;
//         DateTime lastDateFilled;
//         return  Scaffold(
//           appBar: AppBar(
//             title: const Text("Fees" ,style: TextStyle(color: Colors.black)),
//             backgroundColor: Colors.blue,
//             elevation: 0,
//             iconTheme: const IconThemeData(color: Colors.white),
//             centerTitle: false,
//           ),
//           backgroundColor: Colors.white,
//             body:  SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column( children: [
//                 _buildNextInstallmentCard(),
//                 const SizedBox(height: 25),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Past Installments",
//                         style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18 )),
//                     TextButton(
//                         onPressed: () {}, child: const Text("View Structure"))
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//               _buildPastItem(date: "1-Jan-2015", amount: "9,000"),
//               _buildPastItem(date: "1-Jan-2015", amount: "9,000"),
//                _buildPastItem(date: "1-Jan-2015", amount: "9,000"),
//               ],
//               )
//             )
//         );
//
//         }
//
//         Widget _buildNextInstallmentCard(){
//           return Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: Padding(padding: const EdgeInsets.all(20),
//             child: Column( crossAxisAlignment: CrossAxisAlignment.start,children:[
//                  const Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                    Text("Next Installment", style: TextStyle(fontSize: 16)),
//                    Text("Due Date", style: TextStyle(fontSize: 16)),
//                  ] ),
//               const SizedBox(height: 10),
//               const Row(mainAxisAlignment:  MainAxisAlignment.spaceBetween, children: [
//                 Text("11,0000", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
//                 Text("11-Jan-2015", style: TextStyle(fontSize: 16, color: Colors.grey)),
//               ]),
//               const SizedBox(height: 20),
//                 OutlinedButton(onPressed: (){},
//                     style: OutlinedButton.styleFrom(
//                       //foregroundColor: Colors.blue,
//                       backgroundColor: Colors.lightBlue,
//                       side: const BorderSide(color: Colors.black), // Red border
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//
//                     ),
//                   child: const Text("Pay Now", style: TextStyle(color: Colors.black)),
//                 )
//                 ]  ),
//             ),
//
//           );
//         }
//
//         Widget _buildPastItem({required String date, required String amount}) {
//           return Card(
//             elevation: 2,
//             margin: const EdgeInsets.only(bottom: 12),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 4),
//                       GestureDetector(
//                         onTap: () {},
//                         child: const Text("view details", style: TextStyle(color: Colors.blue, fontSize: 12)),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           );
//         }
//       }









///Screen 2
// import 'package:flutter/material.dart';
//
// class FeesScreen extends StatelessWidget {
//   const FeesScreen({super.key});
//
//   static const BorderRadius _radius = BorderRadius.all(Radius.circular(14));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7FB),
//       appBar: AppBar(
//         title: const Text("Fees", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _nextInstallmentCard(),
//             const SizedBox(height: 28),
//             _pastHeader(),
//             const SizedBox(height: 12),
//             _pastItem(date: "1-Jan-2015", amount: "9,000"),
//             _pastItem(date: "1-Jan-2015", amount: "9,000"),
//             _pastItem(date: "1-Jan-2015", amount: "9,000"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _nextInstallmentCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: _radius,
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _Label("Next Installment"),
//               _Label("Due Date"),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "11,000",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
//               ),
//               Text(
//                 "11-Jan-2015",
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           OutlinedButton(
//             onPressed: () {},
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//               side: const BorderSide(color: Colors.redAccent),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               "Pay Now",
//               style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _pastHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "Past Installments",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//         ),
//         TextButton(
//           onPressed: () {},
//           child: const Text("View Structure"),
//         ),
//       ],
//     );
//   }
//
//   Widget _pastItem({required String date, required String amount}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: _radius,
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             date,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 amount,
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(height: 4),
//               GestureDetector(
//                 onTap: () {},
//                 child: const Text(
//                   "view details",
//                   style: TextStyle(color: Colors.blue, fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Label extends StatelessWidget {
//   final String text;
//   const _Label(this.text);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 13,
//         color: Colors.black54,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }
// }




/// Screen-3
class FeesScreen extends StatelessWidget {
  const FeesScreen({super.key});

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(14));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text("Fees", style: TextStyle(color: Color(0xFF111827))),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _nextInstallmentCard(),
            const SizedBox(height: 28),
            _pastHeader(),
            const SizedBox(height: 12),
            _pastItem(date: "1-Jan-2015", amount: "9,000"),
            _pastItem(date: "1-Jan-2015", amount: "9,000"),
            _pastItem(date: "1-Jan-2015", amount: "9,000"),
          ],
        ),
      ),
    );
  }

  Widget _nextInstallmentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _radius,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Accent Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: const Text(
              "Upcoming Payment",
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Label("Next Installment"),
                    _Label("Due Date"),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹11,000",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    Text(
                      "11-Jan-2015",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEFF6FF),
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pastHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Past Installments",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "View Structure",
            style: TextStyle(color: Color(0xFF2563EB)),
          ),
        ),
      ],
    );
  }

  Widget _pastItem({required String date, required String amount}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _radius,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹$amount",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "view details",
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF6B7280),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

