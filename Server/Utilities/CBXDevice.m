
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
@property(strong, nonatomic) NSDictionary *formFactorMap;
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
@synthesize formFactorMap = _formFactorMap;
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

    _sampleFactor = 1.0;

    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    CGFloat screenHeight = MAX(screenSize.height, screenSize.width);
    CGFloat scale = screen.scale;

    CGFloat nativeScale = scale;
    if ([screen respondsToSelector:@selector(nativeScale)]) {
        nativeScale = screen.nativeScale;
    }

    // Never used, but we should keep this magic number around because at one
    // point we thought it was useful (see the Paint Code URL above).
    // CGFloat iphone6p_zoom_sample = 0.96;

    CGFloat iphone6_zoom_sample = 1.171875;
    // This was derived by trial and error.
    // This is sufficient for touching a 2x2 pixel button.
    CGFloat iphone6p_legacy_app_sample = 1.296917;

    CGFloat ipad_pro_10dot5_sample = 1.0859375;

    UIScreenMode *screenMode = [screen currentMode];
    CGSize screenSizeForMode = screenMode.size;
    CGFloat pixelAspectRatio = screenMode.pixelAspectRatio;

    DDLogDebug(@"         Form factor: %@", [self formFactor]);
    DDLogDebug(@" Current screen mode: %@", screenMode);
    DDLogDebug(@"Screen size for mode: %@", NSStringFromCGSize(screenSizeForMode));
    DDLogDebug(@"       Screen height: %@", @(screenHeight));
    DDLogDebug(@"        Screen scale: %@", @(scale));
    DDLogDebug(@" Screen native scale: %@", @(nativeScale));
    DDLogDebug(@"Pixel Aspect Ratio: %@", @(pixelAspectRatio));

    if ([self isIPhone6PlusLike]) {
        if (screenHeight == 568.0) {
            if (nativeScale > scale) {
                DDLogDebug(@"iPhone 6 Plus: Zoom display and app is not optimized for screen size - adjusting sampleFactor");
                // native => 2.88
                // Displayed with iPhone _6_ zoom sample
                _sampleFactor = iphone6_zoom_sample;
            } else {
                DDLogDebug(@"iPhone 6 Plus: Standard display and app is not optimized for screen size - adjusting sampleFactor");
                // native == scale == 3.0
                _sampleFactor = iphone6p_legacy_app_sample;
            }
        } else if (screenHeight == 667.0 && nativeScale <= scale) {
            // native => ???
            DDLogDebug(@"iPhone 6 Plus: Zoomed display - sampleFactor remains the same");
        } else if (screenHeight == 736 && nativeScale < scale) {
            // native => 2.61
            DDLogDebug(@"iPhone 6 Plus: Standard display and app is not optimized for screen size - sampleFactor remains the same");
        } else {
            DDLogDebug(@"iPhone 6 Plus: Standard display and app is optimized for screen size");
        }
    } else if ([self isIPhone6Like]) {
        if (screenHeight == 568.0 && nativeScale <= scale) {
            DDLogDebug(@"iPhone 6: Standard display and app not optimized for screen size - adjusting sampleFactor");
            _sampleFactor = iphone6_zoom_sample;
        } else if (screenHeight == 568.0 && nativeScale > scale) {
            DDLogDebug(@"iPhone 6: Zoomed display mode - sampleFactor remains the same");
        } else {
            DDLogDebug(@"iPhone 6: Standard display and app optimized for screen size - sampleFactor remains the same");
        }
    } else if ([self isIPadPro10point5inch]) {
        if (screenHeight == 1024) {
            DDLogDebug(@"iPad 10.5 inch: app is not optimized for screen size - adjusting sampleFactor");
            _sampleFactor = ipad_pro_10dot5_sample;
        } else {
            DDLogDebug(@"iPad 10.5 inch: app is optimized for screen size");
        }
    }

    DDLogDebug(@"sampleFactor = %@", @(_sampleFactor));
    return _sampleFactor;
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

// http://www.everyi.com/by-identifier/ipod-iphone-ipad-specs-by-model-identifier.html
- (NSDictionary *)formFactorMap {
    if (_formFactorMap) { return _formFactorMap; }

    _formFactorMap =

    @{

      // iPhone 4/4s and iPod 4th
      @"iPhone3,1" : @"iphone 3.5in",
      @"iPhone3,3" : @"iphone 3.5in",
      @"iPhone4,1" : @"iphone 3.5in",
      @"iPod4,1"   : @"iphone 3.5in",

      // iPhone 5/5c/5s, iPod 5th + 6th, and 6se
      @"iPhone5,1" : @"iphone 4in",
      @"iPhone5,2" : @"iphone 4in",
      @"iPhone5,3" : @"iphone 4in",
      @"iPhone5,4" : @"iphone 4in",
      @"iPhone6,1" : @"iphone 4in",
      @"iPhone6,2" : @"iphone 4in",
      @"iPhone6,3" : @"iphone 4in",
      @"iPhone6,4" : @"iphone 4in",
      @"iPod5,1"   : @"iphone 4in",
      @"iPod6,1"   : @"iphone 4in",
      @"iPhone8,4" : @"iphone 4in",

      // iPhone 6/6+ - pattern looks wrong, but it is correct
      @"iPhone7,2" : @"iphone 6",
      @"iPhone7,1" : @"iphone 6+",

      // iPhone 6s/6s+
      @"iPhone8,1" : @"iphone 6",
      @"iPhone8,2" : @"iphone 6+",

      // iPhone 7/7+
      @"iPhone9,1" : @"iphone 6",
      @"iPhone9,3" : @"iphone 6",
      @"iPhone9,2" : @"iphone 6+",
      @"iPhone9,4" : @"iphone 6+",

      // iPhone 8/8+/X
      @"iPhone10,1" : @"iphone 6",
      @"iPhone10,4" : @"iphone 6",
      @"iPhone10,5" : @"iphone 6+",
      @"iPhone10,2" : @"iphone 6+",
      @"iPhone10,3" : @"iphone 10",
      @"iPhone10,6" : @"iphone 10",

      // iPhone XS/XS Max/XR - derived from Simulator
      @"iPhone11,2" : @"iphone 10",
      @"iPhone11,4" : @"iphone 10s max",
      @"iPhone11,6" : @"iphone 10s max",
      @"iPhone11,8" : @"iphone 10r",

      // iPad Pro 13in
      @"iPad6,7" : @"ipad pro",
      @"iPad6,8" : @"ipad pro",

      // iPad Pro 9in
      @"iPad6,3" : @"ipad pro",
      @"iPad6,4" : @"ipad pro",
      @"iPad6,11" : @"ipad pro",
      @"iPad6,12" : @"ipad pro",

      // iPad Pro 10.5in
      @"iPad7,4" : @"ipad pro",
      @"iPad7,3" : @"ipad pro",
      @"iPad7,2" : @"ipad pro",
      @"iPad7,1" : @"ipad pro",
      @"iPad7,5" : @"ipad pro",
      @"iPad7,6" : @"ipad pro",

      // iPad Pro 11in
      @"iPad8,1" : @"ipad pro",
      @"iPad8,2" : @"ipad pro",
      @"iPad8,3" : @"ipad pro",
      @"iPad8,4" : @"ipad pro",

      // iPad Pro 12.9in
      @"iPad8,5" : @"ipad pro",
      @"iPad8,6" : @"ipad pro",
      @"iPad8,7" : @"ipad pro",
      @"iPad8,8" : @"ipad pro"
      };

    return _formFactorMap;
}

// https://www.innerfence.com/howto/apple-ios-devices-dates-versions-instruction-sets
- (NSDictionary *)instructionSetMap {
    if (_instructionSetMap) { return _instructionSetMap; }

    _instructionSetMap =

    @{
      @"armv7" : @[
              // iPhone 4/4s and iPod 4th
              @"iPhone3,1",
              @"iPhone3,3",
              @"iPhone4,1",
              @"iPod4,1",
              @"iPod5,1",

              // iPad 2 and 3 and iPad Mini
              @"iPad2,1",
              @"iPad2,2",
              @"iPad2,3",
              @"iPad2,4",
              @"iPad2,5",
              @"iPad2,6",
              @"iPad2,7",
              @"iPad3,1",
              @"iPad3,2",
              @"iPad3,3",
              ],
      @"armv7s" : @[
              // iPhone 5/5c
              @"iPhone5,1",
              @"iPhone5,2",
              @"iPhone5,3",
              @"iPhone5,4",

              // iPad 4
              @"iPad3,4",
              @"iPad3,5",
              @"iPad3,6"
              ]
      };

    return _instructionSetMap;
}

- (NSString *)armVersion {
    if (_armVersion) { return _armVersion; }

    NSString *match = nil;
    NSString *model = [self modelIdentifier];
    NSDictionary *map = [self instructionSetMap];
    for(NSString *arch in [map allKeys]) {
        NSArray *models = map[arch];
        if ([models containsObject:model]) {
            match = arch;
            break;
        }
    }

    if (match) {
        _armVersion = match;
    } else {
        _armVersion = @"arm64";
    }
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

    NSString *modelIdentifier = [self modelIdentifier];
    NSString *value = [self.formFactorMap objectForKey:modelIdentifier];

    if (value) {
        _formFactor = value;
    } else {
        if ([self isIPad]) {
            _formFactor = @"ipad";
        } else {
            _formFactor = modelIdentifier;
        }
    }
    return _formFactor;
}

- (BOOL)isSimulator {
    return [self simulatorModelIdentifier] != nil;
}

- (BOOL)isPhysicalDevice {
    return ![self isSimulator];
}

- (BOOL)isIPhone6Like {
    return [[self formFactor] isEqualToString:@"iphone 6"];
}

- (BOOL)isIPhone6PlusLike {
    return [[self formFactor] isEqualToString:@"iphone 6+"];
}

- (BOOL)isIPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (BOOL)isIPadPro {
    return [[self formFactor] isEqualToString:@"ipad pro"];
}

- (BOOL)isIPhone4Like {
    return [[self formFactor] isEqualToString:@"iphone 3.5in"];
}

- (BOOL)isIPhone5Like {
    return [[self formFactor] isEqualToString:@"iphone 4in"];
}

- (BOOL)isLetterBox {
    CGFloat scale = [self scaleForMainScreen];
    if ([self isIPad] || [self isIPhone4Like] || scale != 2.0) {
        return NO;
    } else {
        return [self heightForMainScreenBounds] * scale == 960;
    }
}

- (BOOL) isIPadPro10point5inch {
    return [[self modelIdentifier] containsString:@"iPad7"];
}

- (BOOL) isIPhone10Like {
    return [[self formFactor] isEqualToString:@"iphone 10"];
}

- (BOOL)isArm64 {
    return [self.armVersion containsString:@"arm64"];
}

- (NSDictionary *)dictionaryRepresentation {
  UIDeviceOrientation orientation = [CBXOrientation XCUIDeviceOrientation];
  return
    @{
      @"simulator" : @([self isSimulator]),
      @"physical_device" : @([self isPhysicalDevice]),
      @"iphone6" : @([self isIPhone6Like]),
      @"iphone6+" : @([self isIPhone6PlusLike]),
      @"ipad" : @([self isIPad]),
      @"ipad_pro" : @([self isIPadPro]),
      @"iphone4" : @([self isIPhone4Like]),
      @"iphone5" : @([self isIPhone5Like]),
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
