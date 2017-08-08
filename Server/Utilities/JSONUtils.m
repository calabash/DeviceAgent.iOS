
#import "JSONUtils.h"
#import "XCElementSnapshot-Hitpoint.h"
#import "InvalidArgumentException.h"
#import "Application.h"
#import "CBXConstants.h"
#import "CBXDecimalRounder.h"

@implementation JSONUtils

static NSDictionary *elementTypeToString;
static NSDictionary *typeStringToElementType;

+ (NSMutableDictionary *)snapshotOrElementToJSON:(NSObject<FBElement> *)snapshotOrElement {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];

    if ([snapshotOrElement isKindOfClass:[XCUIElement class]]) {
        XCUIElement *element = (XCUIElement *)snapshotOrElement;
        if (![element exists]) {
            return [@{} mutableCopy];
        }
    }

    json[CBX_TYPE_KEY] = snapshotOrElement.wdType;
    json[CBX_LABEL_KEY] = snapshotOrElement.wdLabel;
    json[CBX_TITLE_KEY] = snapshotOrElement.wdTitle;
    json[CBX_VALUE_KEY] = snapshotOrElement.wdValue;
    json[CBX_PLACEHOLDER_KEY] = snapshotOrElement.wdPlaceholderValue;
    json[CBX_RECT_KEY] = [self rectToJSON:snapshotOrElement.wdFrame];
    json[CBX_IDENTIFIER_KEY] = snapshotOrElement.wdName;
    json[CBX_ENABLED_KEY] = @(snapshotOrElement.wdEnabled);
    json[CBX_SELECTED_KEY] = @(snapshotOrElement.wdSelected);
    json[CBX_HAS_FOCUS_KEY] = @(snapshotOrElement.wdHasFocus);
    json[CBX_HAS_KEYBOARD_FOCUS_KEY] = @(snapshotOrElement.wdHasKeyboardFocus);

    BOOL visible;
    CGPoint hitPoint;
    [snapshotOrElement getHitPoint:&hitPoint visibility:&visible];

    json[CBX_HITABLE_KEY] = @(visible);
    json[CBX_HIT_POINT_KEY] = @{@"x" : @(hitPoint.x), @"y" : @(hitPoint.y)};

    return json;
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

+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element {
    return [self snapshotOrElementToJSON:element];
}

+ (NSDictionary *)rectToJSON:(CGRect)rect {
    return @{
             CBX_X_KEY : @(rect.origin.x),
             CBX_Y_KEY : @(rect.origin.y),
             CBX_HEIGHT_KEY : @(rect.size.height),
             CBX_WIDTH_KEY : @(rect.size.width)
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
                                };
        NSMutableDictionary *_typeStringToElementType = [NSMutableDictionary dictionaryWithCapacity:elementTypeToString.count];
        for (NSNumber *type in elementTypeToString) {
            _typeStringToElementType[[elementTypeToString[type] lowercaseString]] = type;
        }
        typeStringToElementType = _typeStringToElementType;
    });
}
@end
