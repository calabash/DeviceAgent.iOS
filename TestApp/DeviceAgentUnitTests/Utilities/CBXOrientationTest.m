
#import "CBXServerUnitTestUmbrellaHeader.h"
#import "CBXOrientation.h"

@interface CBXOrientation (CBXTEST)

+ (UIDeviceOrientation)deviceOrientation:(UIInterfaceOrientation)orientation;

@end

@interface CBXOrientationTest : XCTestCase

@end

@implementation CBXOrientationTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testConvertingInterfaceOrientation {
    UIInterfaceOrientation interface;
    UIDeviceOrientation actual;
    
    interface = UIInterfaceOrientationPortrait;
    actual = [CBXOrientation deviceOrientation:interface];
    expect(actual).to.equal(UIDeviceOrientationPortrait);
    
    interface = UIInterfaceOrientationPortraitUpsideDown;
    actual = [CBXOrientation deviceOrientation:interface];
    expect(actual).to.equal(UIDeviceOrientationPortraitUpsideDown);
    
    interface = UIInterfaceOrientationLandscapeLeft;
    actual = [CBXOrientation deviceOrientation:interface];
    expect(actual).to.equal(UIDeviceOrientationLandscapeRight);
    
    interface = UIInterfaceOrientationLandscapeRight;
    actual = [CBXOrientation deviceOrientation:interface];
    expect(actual).to.equal(UIDeviceOrientationLandscapeLeft);
    
    interface = UIInterfaceOrientationUnknown;
    actual = [CBXOrientation deviceOrientation:interface];
    expect(actual).to.equal(UIDeviceOrientationUnknown);
    
    interface = (UIInterfaceOrientation)NSNotFound;
    actual = [CBXOrientation deviceOrientation:interface];
    expect(actual).to.equal(UIDeviceOrientationUnknown);
}

- (void)testStringForOrientation {
    NSString *actual;
    
    actual = [CBXOrientation stringForOrientation:UIDeviceOrientationUnknown];
    expect(actual).to.equal(@"unknown");
    actual = [CBXOrientation stringForOrientation:UIInterfaceOrientationUnknown];
    expect(actual).to.equal(@"unknown");
    
    actual = [CBXOrientation stringForOrientation:UIDeviceOrientationPortrait];
    expect(actual).to.equal(@"portrait");
    actual = [CBXOrientation stringForOrientation:UIInterfaceOrientationPortrait];
    expect(actual).to.equal(@"portrait");
    
    actual = [CBXOrientation stringForOrientation:UIDeviceOrientationPortraitUpsideDown];
    expect(actual).to.equal(@"upside_down");
    actual = [CBXOrientation stringForOrientation:UIInterfaceOrientationPortraitUpsideDown];
    expect(actual).to.equal(@"upside_down");
    
    actual = [CBXOrientation stringForOrientation:UIDeviceOrientationLandscapeLeft];
    expect(actual).to.equal(@"left");
    actual = [CBXOrientation stringForOrientation:UIInterfaceOrientationLandscapeRight];
    expect(actual).to.equal(@"left");
    
    actual = [CBXOrientation stringForOrientation:UIDeviceOrientationLandscapeRight];
    expect(actual).to.equal(@"right");
    actual = [CBXOrientation stringForOrientation:UIInterfaceOrientationLandscapeLeft];
    expect(actual).to.equal(@"right");
    
    actual = [CBXOrientation stringForOrientation:UIDeviceOrientationFaceUp];
    expect(actual).to.equal(@"face_up");
    
    actual = [CBXOrientation stringForOrientation:UIDeviceOrientationFaceDown];
    expect(actual).to.equal(@"face_down");
    
    actual = [CBXOrientation stringForOrientation:NSNotFound];
    expect(actual).to.equal(@"");
}

- (void)testOrientationForString {
    UIDeviceOrientation actual;
    
    actual = [CBXOrientation orientationForString:@"portrait"];
    expect(actual).to.equal(UIDeviceOrientationPortrait);
    
    actual = [CBXOrientation orientationForString:@"upside_down"];
    expect(actual).to.equal(UIDeviceOrientationPortraitUpsideDown);
    
    actual = [CBXOrientation orientationForString:@"right"];
    expect(actual).to.equal(UIDeviceOrientationLandscapeRight);
    
    actual = [CBXOrientation orientationForString:@"left"];
    expect(actual).to.equal(UIDeviceOrientationLandscapeLeft);
    
    actual = [CBXOrientation orientationForString:@"face_up"];
    expect(actual).to.equal(UIDeviceOrientationFaceUp);
    
    actual = [CBXOrientation orientationForString:@"face_down"];
    expect(actual).to.equal(UIDeviceOrientationFaceDown);
    
    actual = [CBXOrientation orientationForString:@"unknown"];
    expect(actual).to.equal(UIDeviceOrientationUnknown);
    
    actual = [CBXOrientation orientationForString:@"any other string"];
    expect(actual).to.equal(UIDeviceOrientationUnknown);
}

@end
