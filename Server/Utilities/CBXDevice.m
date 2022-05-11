
#import "CBXDevice.h"
#import "CBX-XCTest-Umbrella.h"
#import "JSONUtils.h"
#import <sys/utsname.h>
#import "CBXConstants.h"
#import "CBXOrientation.h"

NSString *const CBXDeviceSimKeyModelIdentifier = @"SIMULATOR_MODEL_IDENTIFIER";
NSString *const CBXDeviceSimKeyVersionInfo = @"SIMULATOR_VERSION_INFO";

@interface CBXDevice ()

@property(strong, nonatomic, readonly) NSDictionary *screenDimensions;
@property(assign, nonatomic, readonly) CGFloat sampleFactor;
@property(strong, nonatomic) NSDictionary *processEnvironment;
@property(strong, nonatomic) NSDictionary *instructionSetMap;
@property(copy, nonatomic, readonly) NSString *physicalDeviceModelIdentifier;
@property(copy, nonatomic, readonly) NSString *deviceFamily;

- (id) init_private;

- (UIScreen *)mainScreen;
- (UIScreenMode *)currentScreenMode;
- (CGSize)sizeForCurrentScreenMode;
- (CGFloat)scaleForMainScreen;
- (CGFloat)heightForMainScreenBounds;
- (NSString *)physicalDeviceModelIdentifier;
- (NSString *)simulatorModelIdentifier;
- (NSString *)simulatorVersionInfo;
- (BOOL)isLetterBox;

@end

@implementation CBXDevice

@synthesize screenDimensions = _screenDimensions;
@synthesize sampleFactor = _sampleFactor;
@synthesize modelIdentifier = _modelIdentifier;
@synthesize formFactor = _formFactor;
@synthesize processEnvironment = _processEnvironment;
@synthesize instructionSetMap = _instructionSetMap;
@synthesize armVersion = _armVersion;
@synthesize deviceFamily = _deviceFamily;
@synthesize name = _name;
@synthesize iOSVersion = _iOSVersion;
@synthesize physicalDeviceModelIdentifier = _physicalDeviceModelIdentifier;

- (id)init {
    @throw [NSException exceptionWithName:@"Cannot call init"
                                   reason:@"This is a singleton class"
                                 userInfo:nil];
}

+ (CBXDevice *)sharedDevice {
    static CBXDevice *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[CBXDevice alloc] init_private];
    });
    return shared;
}

- (id)init_private {
    self = [super init];
    if (self) {
        // For memoizing.
        _sampleFactor = CGFLOAT_MAX;
    }
    return self;
}

#pragma mark - Convenience Methods for Testing

- (UIScreen *)mainScreen {
    return [UIScreen mainScreen];
}

- (UIScreenMode *)currentScreenMode {
    return [[self mainScreen] currentMode];
}

- (CGSize)sizeForCurrentScreenMode {
    return [self currentScreenMode].size;
}

- (CGFloat)scaleForMainScreen {
    return [[self mainScreen] scale];
}

- (CGFloat)heightForMainScreenBounds {
    return [[self mainScreen] bounds].size.height;
}

#pragma mark - Sample Factor

// http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
// Thanks for the inspiration for iPhone 6 form factor sample.
- (CGFloat)sampleFactor {
    if (_sampleFactor != CGFLOAT_MAX) { return _sampleFactor; }
    return 1.0;
}

- (NSDictionary *)screenDimensions {
    if (_screenDimensions) { return _screenDimensions; }

    UIScreen *screen = [UIScreen mainScreen];
    UIScreenMode *screenMode = [screen currentMode];
    CGSize size = screenMode.size;
    CGFloat scale = screen.scale;

    CGFloat nativeScale = scale;
    if ([screen respondsToSelector:@selector(nativeScale)]) {
        nativeScale = screen.nativeScale;
    }

    _screenDimensions = @{
                          @"height" : @(size.height),
                          @"width" : @(size.width),
                          @"scale" : @(scale),
                          @"sample" : @([self sampleFactor]),
                          @"native_scale" : @(nativeScale)
                          };

    return _screenDimensions;
}

- (NSString *)armVersion {
    if (_armVersion) { return _armVersion; }
    _armVersion = @"arm64";
    return _armVersion;
}

- (NSDictionary *)processEnvironment {
    if (_processEnvironment) { return _processEnvironment; }
    _processEnvironment = [[NSProcessInfo processInfo] environment];
    return _processEnvironment;
}

- (NSString *)simulatorModelIdentifier {
    return [self.processEnvironment objectForKey:CBXDeviceSimKeyModelIdentifier];
}

- (NSString *)simulatorVersionInfo {
    return [self.processEnvironment objectForKey:CBXDeviceSimKeyVersionInfo];
}

- (NSString *)physicalDeviceModelIdentifier {
    if (_physicalDeviceModelIdentifier) { return _physicalDeviceModelIdentifier; }
    struct utsname systemInfo;
    uname(&systemInfo);
    _physicalDeviceModelIdentifier = @(systemInfo.machine);
    return _physicalDeviceModelIdentifier;
}

- (NSString *)deviceFamily {
    if (_deviceFamily) { return _deviceFamily; }
    _deviceFamily = [[UIDevice currentDevice] model];
    return _deviceFamily;
}

- (NSString *)name {
    if (_name) { return _name; }
    _name = [[UIDevice currentDevice] name];
    return _name;
}

- (NSString *)iOSVersion {
    if (_iOSVersion) { return _iOSVersion; }
    _iOSVersion = [[UIDevice currentDevice] systemVersion];
    return _iOSVersion;
}

// The hardware name of the device.
- (NSString *)modelIdentifier {
    if (_modelIdentifier) { return _modelIdentifier; }
    if ([self isSimulator]) {
        _modelIdentifier = [self simulatorModelIdentifier];
    } else {
        _modelIdentifier = [self physicalDeviceModelIdentifier];
    }
    return _modelIdentifier;
}

- (NSString *)formFactor {
    if (_formFactor) { return _formFactor; }
    _formFactor = [self modelIdentifier];
    return _formFactor;
}

- (BOOL)isSimulator {
    return [self simulatorModelIdentifier] != nil;
}

- (BOOL)isPhysicalDevice {
    return ![self isSimulator];
}

- (BOOL)isIPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (BOOL)isIPadPro {
    return [self isIPad] && [[self modelIdentifier] containsString:@"Pro"];
}

- (BOOL)isLetterBox {
    CGFloat scale = [self scaleForMainScreen];
    if ([self isIPad] || scale != 2.0) {
        return NO;
    } else {
        return [self heightForMainScreenBounds] * scale == 960;
    }
}

- (NSDictionary *)dictionaryRepresentation {
  UIDeviceOrientation orientation = [CBXOrientation XCUIDeviceOrientation];
  return
    @{
      @"simulator" : @([self isSimulator]),
      @"physical_device" : @([self isPhysicalDevice]),
      @"iphone6" : @(NO),
      @"iphone6+" : @(NO),
      @"ipad" : @([self isIPad]),
      @"ipad_pro" : @([self isIPadPro]),
      @"iphone4" : @(NO),
      @"iphone5" : @(NO),
      @"letter_box" : @([self isLetterBox]),
      @"screen" : [self screenDimensions],
      @"sample_factor" : @([self sampleFactor]),
      @"model_identifier" : [self modelIdentifier],
      @"form_factor" : [self formFactor],
      @"family" : [self deviceFamily],
      @"name" : [self name],
      @"ios_version" : [self iOSVersion],
      @"physical_device_model_identifier" : [self physicalDeviceModelIdentifier],
      @"arm_version" : [self armVersion],
      @"orientation_numeric" : @(orientation),
      @"orientation_string" : [CBXOrientation stringForOrientation:orientation]
    };
}

- (NSString *)JSONRepresentation {
    NSDictionary *dictionary = [self dictionaryRepresentation];
    return [JSONUtils objToJSONString:dictionary];
}

@end
