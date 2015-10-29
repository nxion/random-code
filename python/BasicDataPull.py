import urllib2
import base64
import xml.etree.ElementTree as etree
import httplib
import ssl
import socket


"========BEGIN SSL CHANGE

'''
Becasue OSX has a older version of OpenSSL installed, I had to write
a wrapper to change the connection type to a less secure version of SSL/TLS
just to connect to the JSS. This script works as is on RHEL and Mac even though
the above here could be commented out. The version of OpenSSL installed by
default on RHEL is a more up to date version. If you didnt want to enclude this
in the ode you can always install a differant version of OpenSSL on Mac via Brew
'''

class TLS1Connection(httplib.HTTPSConnection):
    """Like HTTPSConnection but more specific"""
    def __init__(self, host, **kwargs):
        httplib.HTTPSConnection.__init__(self, host, **kwargs)

    def connect(self):
        """Overrides HTTPSConnection.connect to specify TLS version"""
        # Standard implementation from HTTPSConnection, which is not
        # designed for extension, unfortunately
        sock = socket.create_connection((self.host, self.port),
                self.timeout, self.source_address)
        if getattr(self, '_tunnel_host', None):
            self.sock = sock
            self._tunnel()

        # This is the only difference; default wrap_socket uses SSLv23
        self.sock = ssl.wrap_socket(sock, self.key_file, self.cert_file,
                ssl_version=ssl.PROTOCOL_TLSv1)

class TLS1Handler(urllib2.HTTPSHandler):
    """Like HTTPSHandler but more specific"""
    def __init__(self):
        urllib2.HTTPSHandler.__init__(self)

    def https_open(self, req):
        return self.do_open(TLS1Connection, req)


# Override default handler
urllib2.install_opener(urllib2.build_opener(TLS1Handler()))

"=======END SSL CHANGE


def call(resource, username, password, method = '', data = None):
    request = urllib2.Request(resource)
    request.add_header('Authorization', 'Basic ' + base64.b64encode(username + ':' + password))
    if method.upper() in ('POST', 'PUT', 'DELETE'):
        request.get_method = lambda: method

    if method.upper() in ('POST', 'PUT') and data:
        request.add_header('Content-Type', 'text/xml')
        return urllib2.urlopen(request, data)
    else:
        return urllib2.urlopen(request)

response = call('''PLACE URL HERE''')

xml = etree.fromstring(response.read())

print ("\nBasic Computer Info\n")
print xml.find('hardware/model').text
print xml.find('location/email_address').text
print xml.find('general/id').text
print xml.find('general/ip_address').text
