import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class Temperatures extends StatefulWidget {
  double value = 0;
  int inputtype = 0;
  var _controller = TextEditingController();

  Temperatures({super.key});

  @override
  State<Temperatures> createState() => _TemperaturesState();
}

class _TemperaturesState extends State<Temperatures> {
  void setInputType(int a) {
    setState(() {
      widget.inputtype = a;
    });
  }
  String getSelectedType(){
    if(widget.inputtype == 0){
      return "Kelvin";
    }else if(widget.inputtype == 1){
      return "Celsius";
    }else if(widget.inputtype == 2){
      return "Fahrenheit";
    }else{
      return "Input";
    }
  }
  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Basis Converter"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
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
          ValuesOutput(
              data: widget.value,
              inputtype: widget.inputtype,
              function: setInputType),
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
                    widget.value = double.parse(val);
                  }
                });
              },
              decoration: InputDecoration(
                labelText: getSelectedType(),
                border: OutlineInputBorder(),
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
  final double data;
  final int inputtype;
  final Function function;

  const ValuesOutput(
      {super.key,
      required this.data,
      required this.inputtype,
      required this.function});

  String calculatevalues(double data, int inputtype, int outputtype) {
    List<String> result = [];
    switch (inputtype) {
      case 0:
        result.add(data.toStringAsFixed(2));
        result.add((data - 273.15).toStringAsFixed(2));
        result.add(((data - 273.15) * 1.8 + 32).toStringAsFixed(2));
        break;
      case 1:
        result.add((data + 273.15).toStringAsFixed(2));
        result.add(data.toStringAsFixed(2));
        result.add((data * 1.8 + 32).toStringAsFixed(2));
        break;
      case 2:
        result.add(((data - 32) * (5 / 9) + 273.15).toStringAsFixed(2));
        result.add(((data - 32) * (5 / 9)).toStringAsFixed(2));
        result.add(data.toStringAsFixed(2));
        break;
    }
    if (outputtype >= result.length) {
      return "No Data!";
    }
    return result[outputtype];
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ValueOutput(
                name: "K",
                data: calculatevalues(data, inputtype, 0),
                inputtype: inputtype,
                type: 0,
                function: function,
              ),
              Divider(
                color: Theme.of(context).brightness==Brightness.light?Colors.black12:Colors.white30,
                thickness: 2,
              ),
              ValueOutput(
                name: "°C",
                data: calculatevalues(data, inputtype, 1),
                inputtype: inputtype,
                type: 1,
                function: function,
              ),
              Divider(
                color: Theme.of(context).brightness==Brightness.light?Colors.black12:Colors.white30,
                thickness: 2,
              ),
              ValueOutput(
                name: "°F",
                data: calculatevalues(data, inputtype, 2),
                inputtype: inputtype,
                type: 2,
                function: function,
              ),
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
  final String data;
  final String name;
  final Function function;
  final int inputtype;
  final int type;

  const ValueOutput({
    super.key,
    required this.name,
    required this.data,
    required this.function,
    required this.type,
    required this.inputtype,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              child: Center(
                child: MaterialButton(
                  elevation: 1,
                  color: inputtype == type
                      ? Colors.blue
                      : Colors.white54,
                  onPressed: () {
                    function(type);
                  },
                  child: Text(
                    this.name,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              width: 82,
            ),
          ),
          Spacer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Text(
                data,
                softWrap: true,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 20,
                  color: inputtype == type
                      ? Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white
                      : Theme.of(context).brightness==Brightness.light?Colors.black45:Colors.white54,
                ),
              ),
            ),
            flex: 10,
          ),
          Spacer(),
          ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: data));
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
