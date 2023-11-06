import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class BasisNumbers extends StatefulWidget {
  int value = 0;
  var _controller = TextEditingController();

  BasisNumbers({super.key});

  @override
  State<BasisNumbers> createState() => _BasisNumbersState();
}

class _BasisNumbersState extends State<BasisNumbers> {
  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Basis Converter"),
        backgroundColor: Colors.blueGrey,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: showFab
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.small(
                    onPressed: () {
                      setState(() {
                        widget.value--;
                      });
                    },
                    child: Icon(Icons.remove),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {
                      setState(() {
                        widget.value = 0;
                      });
                    },
                    child: Icon(Icons.restore),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {
                      setState(() {
                        widget.value++;
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              )
            : null,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValuesOutput(data: widget.value),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
            child: TextField(
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: false),
              autocorrect: false,
              controller: widget._controller,
              maxLength: 18,
              onChanged: (val) {
                setState(() {
                  if (val.isEmpty) {
                    widget.value = 0;
                  } else {
                    widget.value = int.parse(val);
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Decimal Input',
                border: OutlineInputBorder(),
                hintText: 'Input',
                suffixIcon: IconButton(
                  onPressed: () {
                    widget._controller.clear();
                    setState(() {
                      widget.value = 0;
                    });
                  },
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ValuesOutput extends StatelessWidget {
  final int data;

  const ValuesOutput({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ValueOutput(
                  name: "Decimal",
                  data: this.data,
                  function: (a) {
                    return a.toRadixString(10);
                  }),
              Divider(
                color: Colors.black12,
                thickness: 2,
              ),
              ValueOutput(
                  name: "Hex",
                  data: this.data,
                  function: (a) {
                    return a.toRadixString(16).toUpperCase();
                  }),
              Divider(
                color: Colors.black12,
                thickness: 2,
              ),
              ValueOutput(
                  name: "Oct",
                  data: this.data,
                  function: (a) {
                    return a.toRadixString(8);
                  }),
              Divider(
                color: Colors.black12,
                thickness: 2,
              ),
              ValueOutput(
                  name: "Binary",
                  data: this.data,
                  function: (a) {
                    return a.toRadixString(2);
                  }),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ValueOutput extends StatelessWidget {
  final int data;
  final Function function;
  final String name;

  const ValueOutput(
      {super.key,
      required this.name,
      required this.data,
      required this.function});

  @override
  Widget build(BuildContext context) {
    String strData = function(data);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              child: Center(
                child: Text(
                  this.name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              width: 82,
            ),
          ),
          VerticalDivider(
            thickness: 1,
            indent: 8,
            endIndent: 8,
          ),
          Spacer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Text(
                strData,
                softWrap: true,
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20),
              ),
            ),
            flex: 10,
          ),
          Spacer(),
          ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: strData));
              },
              style: ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(0, 50))),
              child: Icon(
                Icons.copy,
              ))
        ],
      ),
    );
  }
}
