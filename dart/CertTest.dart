import 'dart:io';

printCertificate(cert) {
  print('${cert.issuer}');
  print('${cert.subject}');
  print('${cert.startValidity}');
  print('${cert.endValidity}');
}

main() {
  var client = new HttpClient();
  client.badCertificateCallback = (cert, host, port) {
    print('Bad certificate connecting to $host:$port:');
    printCertificate(cert);
    print('');
    return true;
  };
  client.getUrl(Uri.parse('https://pub.dartlang.org/api/packages/browser'))
      .then((request) => request.close())
      .then((response) {
        print('Response certificate:');
        printCertificate(response.certificate);
        response.drain();
        client.close();
      });
}
