

class XCUIElement(object):
    def __init__(self, props, xcbridge):
        self.props = props # for __str__
        self.xcbridge = xcbridge
        self.rect = props['rect']
        self.test_id = props['test_id']
        self.label = props['label']
        self.value = props['value']
        self.title = props['title']
        self.type = props['type']
        self.enabled = props['enabled']
        self.identifier = props['id']

    def __str__(self):
        return "%s: %s - %s - %s" % (self.type,
            self.identifier,
            self.title,
            self.label)

    def tap(self):
        print "\tTapping '%s'" % (self.label)
        self.xcbridge.tap("test_id", self.test_id)

    def type_text(self, text):
        print "\tTyping '%s' on element '%s'" % (text, self.label)
        self.xcbridge.type_text("test_id", self.test_id, text)
