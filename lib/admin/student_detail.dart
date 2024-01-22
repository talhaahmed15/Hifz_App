import 'package:flutter/material.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:hafiz_diary/widget/app_text.dart';
import 'package:hafiz_diary/widget/common_button.dart';

class StudentDetail extends StatefulWidget {
  const StudentDetail({Key? key}) : super(key: key);

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  String dropdownvalue = 'Item 1';
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: "April 16,2023",
                clr: primaryColor,
                fontWeight: FontWeight.bold,
                size: 22,
              ),
              AppText(
                text: "Wednesday",
                clr: Colors.grey,
              ),
              SizedBox(
                height: defPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      AppText(text: "Sabaq"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      AppText(text: "Sabqi"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      AppText(text: "Manzil"),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: defPadding,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defPadding),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton(
                  hint: AppText(text: "Parah"),
                  // Initial Value
                  borderRadius: BorderRadius.circular(defPadding),
                  isExpanded: true, underline: const SizedBox(),
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: defPadding,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defPadding),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton(
                  hint: AppText(text: "Parah"),
                  // Initial Value
                  borderRadius: BorderRadius.circular(defPadding),
                  isExpanded: true, underline: const SizedBox(),
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: defPadding,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defPadding),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton(
                  hint: AppText(text: "Parah"),
                  // Initial Value
                  borderRadius: BorderRadius.circular(defPadding),
                  isExpanded: true, underline: const SizedBox(),
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: defPadding,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defPadding),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton(
                  hint: AppText(text: "Parah"),
                  // Initial Value
                  borderRadius: BorderRadius.circular(defPadding),
                  isExpanded: true, underline: const SizedBox(),
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: defPadding,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defPadding),
                    border: Border.all(color: Colors.grey)),
                child: DropdownButton(
                  hint: AppText(text: "Parah"),
                  // Initial Value
                  borderRadius: BorderRadius.circular(defPadding),
                  isExpanded: true, underline: const SizedBox(),
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: defPadding,
              ),
              AppText(
                text: "Namaz",
                clr: primaryColor,
                fontWeight: FontWeight.bold,
                size: 20,
              ),
              SizedBox(
                height: defPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      const Text("Fajar"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      const Text("Zuhr"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      const Text("Asar"),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: defPadding / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(),
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      const Text("Maghrib"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: defPadding / 2,
                      ),
                      const Text("Esha"),
                    ],
                  ),
                  const SizedBox(),
                ],
              ),
              SizedBox(
                height: defPadding / 2,
              ),
              CommonButton(
                text: "Download Report",
                onTap: () {},
                color: primaryColor,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
