
import requests
import json

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

class XCUITestBridge(object):
    def __init__(self, device_ip):
        self.ip_address = device_ip

    def debug(self, s):
        print bcolors.WARNING + "#", s, bcolors.ENDC

    def _url(self, ip_address, endpoint):
        return ip_address + endpoint

    def post(self, url, data = {}):
        self.debug("POST " + url)
        return requests.post(url, json.dumps(data))

    def delete(self, url):
        self.debug("DELETE " + url)
        return requests.delete(url)

    def get(self, url):
        self.debug("GET " + url)
        return requests.get(url)

    def start_session(self, bundle_id):
        url  = self._url(self.ip_address, "/session")
        ret = self.post(url, { "bundleID" : bundle_id })
        self.debug("Session Started for " + bundle_id)

    def stop_session(self):
        self.debug("Killing current session")
        url = self._url(self.ip_address, "/session")
        self.delete(url)

    def tree(self):
        url = self._url(self.ip_address, "/tree")
        return self.get(url).json()

    def query(self, queryType, queryValue):
        url = self._url(self.ip_address, "/query/%s/%s" % (queryType, queryValue))
        return self.get(url).json()

    def tap(self, idType, identifier):
        url = self._url(self.ip_address, "/tap/%s/%s" % (idType, identifier))
        return self.post(url).json()

    def type_text(self, idType, identifier, text):
        url = self._url(self.ip_address, "/typeText/%s/%s" % (idType, identifier))
        return self.post(url, { 'text' : text })
