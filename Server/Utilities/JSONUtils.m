
#import "JSONUtils.h"
#import "XCElementSnapshot-Hitpoint.h"
#import "XCUIElement+WebDriverAttributes.h"
#import "XCUIElement+FBIsVisible.h"
#import "InvalidArgumentException.h"
#import "CBXConstants.h"
#import "CBXDecimalRounder.h"

@implementation JSONUtils

static NSDictionary *elementTypeToString;
static NSDictionary *typeStringToElementType;

+ (NSArray *)elementTypes {
    return [[typeStringToElementType allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

+ (NSString *)stringByInvokingSelector:(SEL)selector
                              onTarget:(id)target {
  NSMethodSignature *signature;
  Class klass = [target class];
  signature = [klass instanceMethodSignatureForSelector:selector];
  NSInvocation *invocation;
  invocation = [NSInvocation invocationWithMethodSignature:signature];
  invocation.target = target;
  invocation.selector = selector;

  NSString *string = nil;
  void *buffer;
  [invocation invoke];
  [invocation getReturnValue:&buffer];
  string = (__bridge NSString *)buffer;
  return string;
}



// we want the most information
// [snapshot performSelector:]
// or NSInvocation
+ (NSString *)labelForElement:(id)element
                     snapshot:(id)snapshot {
  SEL selector = @selector(label);
  NSString *snapshotLabel = [JSONUtils stringByInvokingSelector:selector onTarget:element];
  NSString *elementLabel = [JSONUtils stringByInvokingSelector:selector onTarget:snapshot];

  if (!element || elementLabel.length != 0) {
    return elementLabel;
  } else {
    return snapshotLabel;
  }
}

+ (NSString * ) titleForElement:(id)element
                       snapshot:(id)snapshot {
  SEL selector = @selector(title);
  NSString *snapshotTitle = [JSONUtils stringByInvokingSelector:selector onTarget:element];
  NSString *elementTitle = [JSONUtils stringByInvokingSelector:selector onTarget:element];

  if (!element || elementTitle.length != 0) {
   return elementTitle;
  } else {
   return snapshotTitle;
  }
}

+ (NSDictionary *)snapshotOrElementToJSON:(id)element {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    XCElementSnapshot *snapshot;
    if ([element isKindOfClass:[XCElementSnapshot class]]) {
        snapshot = element;
    } else {
        if (![(XCUIElement *)element lastSnapshot]) {
            [(XCUIElement *)element resolve];
        }
        snapshot = [(XCUIElement *)element lastSnapshot];
    }


    // Occasionally XCUIElement with type 'Any' are not responding to the
    // WebDriverAgent methods.
    // See https://github.com/calabash/DeviceAgent.iOS/pull/255 for analysis
    @try {
        json[CBX_TYPE_KEY] = elementTypeToString[@(snapshot.elementType)];
        json[CBX_LABEL_KEY] = snapshot.label;
        json[CBX_TITLE_KEY] = snapshot.title;
        json[CBX_VALUE_KEY] = snapshot.value;
        json[CBX_PLACEHOLDER_KEY] = snapshot.placeholderValue;
        json[CBX_RECT_KEY] = [self rectToJSON:snapshot.frame];
        json[CBX_IDENTIFIER_KEY] = snapshot.identifier;
        json[CBX_ENABLED_KEY] = @(snapshot.isEnabled);
        json[CBX_SELECTED_KEY] = @(snapshot.isSelected);
        json[CBX_HAS_FOCUS_KEY] = @(NO);
        json[CBX_HAS_KEYBOARD_FOCUS_KEY] = @(snapshot.hasKeyboardFocus);

        CBXVisibilityResult *result = [snapshot visibilityResult];

        json[CBX_HITABLE_KEY] = @(result.isVisible);
        json[CBX_HIT_POINT_KEY] = @{@"x" : [JSONUtils normalizeFloat:result.point.x],
                                    @"y" : [JSONUtils normalizeFloat:result.point.y]};
    } @catch (NSException *exception) {
        DDLogError(@"Caught an exception converting '%@' with class '%@' to JSON:\n%@",
                   snapshot, [snapshot class], [exception reason]);
        DDLogError(@"returning an empty dictionary after converting this much of the"
                   "instance to JSON:\n%@", json);
        return [NSDictionary dictionary];
    }

    return [NSDictionary dictionaryWithDictionary:json];
}

+ (NSNumber *)normalizeFloat:(CGFloat) x {
    if (isinf(x)) {
        return (x == INFINITY ? @(INT32_MAX) : @(INT32_MIN));
    } else if (x == CGFLOAT_MIN) {
        return @(INT32_MIN);
    } else if (x == CGFLOAT_MAX) {
        return @(INT32_MAX);
    } else if (x > (1.0 * INT32_MAX)) {
        return @(INT32_MAX);
    } else if (x < (1.0 * INT32_MIN)) {
        return @(INT32_MIN);
    } else {
        CBXDecimalRounder *rounder = [CBXDecimalRounder new];
        return @([rounder integerByRounding:x]);
    }
}

+ (NSDictionary *)rectToJSON:(CGRect)rect {
    return @{
             CBX_X_KEY : [JSONUtils normalizeFloat:rect.origin.x],
             CBX_Y_KEY : [JSONUtils normalizeFloat:rect.origin.y],
             CBX_HEIGHT_KEY :  [JSONUtils normalizeFloat:rect.size.height],
             CBX_WIDTH_KEY :  [JSONUtils normalizeFloat:rect.size.width]
             };
}

+ (XCUIElementType)elementTypeForString:(NSString *)typeString {
    NSNumber *typeNumber = typeStringToElementType[[typeString lowercaseString]];
    if (typeNumber) {
        return [typeNumber unsignedIntegerValue];
    }
    @throw [CBXException withFormat:@"Invalid type '%@'", typeString];
}

+ (NSString *)stringForElementType:(XCUIElementType)type {
    return elementTypeToString[@(type)];
}

+ (void)validatePointJSON:(id)json {
    if ([json isKindOfClass:[NSArray class]]) {
        if ([json count] < 2) {
            @throw [InvalidArgumentException withMessage:[NSString stringWithFormat:
                                                            @"Error validating point JSON: expected [x, y], got %@",
                                                            [JSONUtils objToJSONString:json]]];
        }
    } else {
        if (![json isKindOfClass:[NSDictionary class]]) {
            @throw [InvalidArgumentException withMessage:[NSString stringWithFormat:
                                                            @"Error validating point JSON: expected dictionary, got %@",
                                                            NSStringFromClass([json class])]];
        }
        if (!([[json allKeys] containsObject:@"x"] && [[json allKeys] containsObject:@"y"])) {
            @throw [InvalidArgumentException withMessage:[NSString stringWithFormat:
                                                            @"Error validating point JSON: expected { x : #, y : # }, got %@",
                                                            [JSONUtils objToJSONString:json]]];
        }
    }
}

+ (CGPoint)pointFromCoordinateJSON:(id)json {
    [self validatePointJSON:json];

    if ([json isKindOfClass:[NSArray class]]) {
        return CGPointMake([json[0] floatValue],
                           [json[1] floatValue]);
    } else {
        return CGPointMake([json[CBX_X_KEY] floatValue],
                           [json[CBX_Y_KEY] floatValue]);
    }
}

+ (NSString *)objToJSONString:(id)objcJsonObject {
    if (!objcJsonObject) {
        return @"";
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objcJsonObject
                                                       options:0 error:&error];
    if (error) {
        DDLogError(@"Error serializing object: %@: %@", objcJsonObject, error);
        return error.localizedDescription;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (void)load {
    static dispatch_once_t oncet;
    dispatch_once(&oncet, ^{
        elementTypeToString = @{
                                @(XCUIElementTypeAny) : @"Any",
                                @(XCUIElementTypeOther) : @"Other",
                                @(XCUIElementTypeApplication) : @"Application",
                                @(XCUIElementTypeGroup) : @"Group",
                                @(XCUIElementTypeWindow) : @"Window",
                                @(XCUIElementTypeSheet) : @"Sheet",
                                @(XCUIElementTypeDrawer) : @"Drawer",
                                @(XCUIElementTypeAlert) : @"Alert",
                                @(XCUIElementTypeDialog) : @"Dialog",
                                @(XCUIElementTypeButton) : @"Button",
                                @(XCUIElementTypeRadioButton) : @"RadioButton",
                                @(XCUIElementTypeRadioGroup) : @"RadioGroup",
                                @(XCUIElementTypeCheckBox) : @"CheckBox",
                                @(XCUIElementTypeDisclosureTriangle) : @"DisclosureTriangle",
                                @(XCUIElementTypePopUpButton) : @"PopUpButton",
                                @(XCUIElementTypeComboBox) : @"ComboBox",
                                @(XCUIElementTypeMenuButton) : @"MenuButton",
                                @(XCUIElementTypeToolbarButton) : @"ToolbarButton",
                                @(XCUIElementTypePopover) : @"Popover",
                                @(XCUIElementTypeKeyboard) : @"Keyboard",
                                @(XCUIElementTypeKey) : @"Key",
                                @(XCUIElementTypeNavigationBar) : @"NavigationBar",
                                @(XCUIElementTypeTabBar) : @"TabBar",
                                @(XCUIElementTypeTabGroup) : @"TabGroup",
                                @(XCUIElementTypeToolbar) : @"Toolbar",
                                @(XCUIElementTypeStatusBar) : @"StatusBar",
                                @(XCUIElementTypeStatusItem) : @"StatusItem",
                                @(XCUIElementTypeTable) : @"Table",
                                @(XCUIElementTypeTableRow) : @"TableRow",
                                @(XCUIElementTypeTableColumn) : @"TableColumn",
                                @(XCUIElementTypeOutline) : @"Outline",
                                @(XCUIElementTypeOutlineRow) : @"OutlineRow",
                                @(XCUIElementTypeBrowser) : @"Browser",
                                @(XCUIElementTypeCollectionView) : @"CollectionView",
                                @(XCUIElementTypeSlider) : @"Slider",
                                @(XCUIElementTypePageIndicator) : @"PageIndicator",
                                @(XCUIElementTypeProgressIndicator) : @"ProgressIndicator",
                                @(XCUIElementTypeActivityIndicator) : @"ActivityIndicator",
                                @(XCUIElementTypeSegmentedControl) : @"SegmentedControl",
                                @(XCUIElementTypePicker) : @"Picker",
                                @(XCUIElementTypePickerWheel) : @"PickerWheel",
                                @(XCUIElementTypeSwitch) : @"Switch",
                                @(XCUIElementTypeToggle) : @"Toggle",
                                @(XCUIElementTypeLink) : @"Link",
                                @(XCUIElementTypeImage) : @"Image",
                                @(XCUIElementTypeIcon) : @"Icon",
                                @(XCUIElementTypeSearchField) : @"SearchField",
                                @(XCUIElementTypeScrollView) : @"ScrollView",
                                @(XCUIElementTypeScrollBar) : @"ScrollBar",
                                @(XCUIElementTypeStaticText) : @"StaticText",
                                @(XCUIElementTypeTextField) : @"TextField",
                                @(XCUIElementTypeSecureTextField) : @"SecureTextField",
                                @(XCUIElementTypeDatePicker) : @"DatePicker",
                                @(XCUIElementTypeTextView) : @"TextView",
                                @(XCUIElementTypeMenu) : @"Menu",
                                @(XCUIElementTypeMenuItem) : @"MenuItem",
                                @(XCUIElementTypeMenuBar) : @"MenuBar",
                                @(XCUIElementTypeMenuBarItem) : @"MenuBarItem",
                                @(XCUIElementTypeMap) : @"Map",
                                @(XCUIElementTypeWebView) : @"WebView",
                                @(XCUIElementTypeIncrementArrow) : @"IncrementArrow",
                                @(XCUIElementTypeDecrementArrow) : @"DecrementArrow",
                                @(XCUIElementTypeTimeline) : @"TimeLine",
                                @(XCUIElementTypeRatingIndicator) : @"RatingIndicator",
                                @(XCUIElementTypeValueIndicator) : @"ValueIndicator",
                                @(XCUIElementTypeSplitGroup) : @"SplitGroup",
                                @(XCUIElementTypeSplitter) : @"Splitter",
                                @(XCUIElementTypeRelevanceIndicator) : @"RelevanceIndicator",
                                @(XCUIElementTypeColorWell) : @"ColorWell",
                                @(XCUIElementTypeHelpTag) : @"HelpTag",
                                @(XCUIElementTypeMatte) : @"Matte",
                                @(XCUIElementTypeDockItem) : @"DockItem",
                                @(XCUIElementTypeRuler) : @"Ruler",
                                @(XCUIElementTypeRulerMarker) : @"RulerMarker",
                                @(XCUIElementTypeGrid) : @"Grid",
                                @(XCUIElementTypeLevelIndicator) : @"LevelIndicator",
                                @(XCUIElementTypeCell) : @"Cell",
                                @(XCUIElementTypeLayoutArea) : @"LayoutArea",
                                @(XCUIElementTypeLayoutItem) : @"LayoutItem",
                                @(XCUIElementTypeHandle) : @"Handle",
                                @(XCUIElementTypeStepper) : @"Stepper",
                                @(XCUIElementTypeTab) : @"Tab",
                                @(XCUIElementTypeTouchBar) : @"TouchBar",
                                };
        NSMutableDictionary *_typeStringToElementType = [NSMutableDictionary dictionaryWithCapacity:elementTypeToString.count];
        for (NSNumber *type in elementTypeToString) {
            _typeStringToElementType[[elementTypeToString[type] lowercaseString]] = type;
        }
        typeStringToElementType = _typeStringToElementType;
    });
}
@end
