from xcuitestbridge import XCUITestBridge
from xcuielement import XCUIElement

class App(object):
    def __init__(self, bundle_id, xcbridge):
        self.bundle_id = bundle_id
        self.xcbridge = xcbridge

    def tree(self):
        return self.xcbridge.tree()

    def query_by_type(self, elementType):
        elements = self.xcbridge.query("type", elementType)
        return [XCUIElement(e, self.xcbridge) for e in elements]

    def query_by_identifier(self, identifier):
        elements = self.xcbridge.query("id", identifier)
        return [XCUIElement(e, self.xcbridge) for e in elements]

    def first_element_with_id(self, identifier):
        ret = self.query_by_identifier(identifier)
        if len(ret) > 0:
            return ret[0]
        else:
            return None

    def first_element_marked(self, mark):
        ret = self.query_by_mark(mark)
        if len(ret) > 0:
            return ret[0]
        else:
            return None

    def query_by_mark(self, mark):
        elements = self.xcbridge.query("marked", mark)
        return [XCUIElement(e, self.xcbridge) for e in elements]

    def type_with_label(self, elementType, label):
        elements = self.query_by_type(elementType)
        match = None
        for e in elements:
            if e.label == label:
                match = e
                break
        return match


class TestRun(object):
    def __init__(self, device_ip, bundle_id):
        self.xcbridge = XCUITestBridge(device_ip)
        self.app = App(bundle_id, self.xcbridge)

    def change_app(self, bundle_id):
        self.app = App(bundle_id, self.xcbridge)

    def execute(self, test_func):
        self.start_session()
        try:
            print "\n\t>>> Test Case: '%s'\n" % (test_func.__name__)
            test_func(self.app)
        except Exception as e:
            print "Error performing test:", e
        finally:
            self.stop_session()
            print "\n\t>>> Test Complete"

    def start_session(self):
        try:
            self.xcbridge.start_session(self.app.bundle_id)
        except Exception as e:
            print "Unable to start session. Is the XCUITEstServer running?\n", e
            exit(1)

    def stop_session(self):
        self.xcbridge.stop_session()
