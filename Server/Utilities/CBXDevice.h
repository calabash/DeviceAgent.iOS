#import <UIKit/UIKit.h>

extern NSString *const LPDeviceSimKeyModelIdentifier;
extern NSString *const LPDeviceSimKeyVersionInfo;
extern NSString *const LPDeviceSimKeyIphoneSimulatorDevice_LEGACY;

@interface CBXDevice : NSObject

@property(strong, nonatomic, readonly) NSDictionary *screenDimensions;
@property(assign, nonatomic, readonly) CGFloat sampleFactor;
@property(copy, nonatomic, readonly) NSString *modelIdentifier;
@property(copy, nonatomic, readonly) NSString *formFactor;
@property(copy, nonatomic, readonly) NSString *deviceFamily;
@property(copy, nonatomic, readonly) NSString *name;
@property(copy, nonatomic, readonly) NSString *iOSVersion;
@property(copy, nonatomic, readonly) NSString *physicalDeviceModelIdentifier;

+ (CBXDevice *)sharedDevice;
- (NSString *)simulatorVersionInfo;
- (BOOL)isSimulator;
- (BOOL)isPhysicalDevice;
- (BOOL)isIPhone6Like;
- (BOOL)isIPhone6PlusLike;
- (BOOL)isIPad;
- (BOOL)isIPadPro;
- (BOOL)isIPhone4Like;
- (BOOL)isIPhone5Like;
- (BOOL)isLetterBox;
- (NSDictionary *)dictionaryRepresentation;

@end
