import 'dart:isolate';

void main() {
  // Isolate.spawn(subMian, 'message');
  testIsolate();
}

void subMian(String sub) {
  print('object - ' + sub);
}

// void main() {
//   testIsolate();
// }

void coding(SendPort port) {
  const sum = 1 + 2;
  // 给调用方发送结果
  port.send(sum);
}

testIsolate() async {
  ReceivePort receivePort = ReceivePort(); // 创建管道
  Isolate isolate = await Isolate.spawn(
      coding, receivePort.sendPort); // 创建 Isolate，并传递发送管道作为参数
  // 监听消息
  receivePort.listen((message) {
    print("data: $message");
    receivePort.close();
    isolate?.kill(priority: Isolate.immediate);
    isolate = null;
  });
}
