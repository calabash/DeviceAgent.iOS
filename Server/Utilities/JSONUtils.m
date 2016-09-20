
#import "JSONUtils.h"
#import "XCElementSnapshot.h"
#import "XCElementSnapshot-Hitpoint.h"
#import "InvalidArgumentException.h"
#import "Application.h"
#import "CBXConstants.h"
#import "XCUICoordinate.h"

@implementation JSONUtils

static NSDictionary *elementTypeToString;
static NSDictionary *typeStringToElementType;
static NSDictionary *unhitablePoint;

//TODO: apparenty this causes some lag... how to optimize?
+ (NSMutableDictionary *)snapshotToJSON:(NSObject<FBElement> *)snapshot {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];

    if ([snapshot isKindOfClass:[XCUIElement class]]) {
        XCUIElement *el = (XCUIElement *)snapshot;
        if (![el exists]) {
            return [@{} mutableCopy];
        }

    }
    json[CBX_TYPE_KEY] = snapshot.wdType;
    json[CBX_LABEL_KEY] = snapshot.wdLabel;
    json[CBX_TITLE_KEY] = snapshot.wdTitle;
    json[CBX_VALUE_KEY] = snapshot.wdValue;
    json[CBX_PLACEHOLDER_KEY] = snapshot.wdPlaceholderValue;
    json[CBX_RECT_KEY] = [self rectToJSON:snapshot.wdFrame];
    json[CBX_IDENTIFIER_KEY] = snapshot.wdName;
    json[CBX_ENABLED_KEY] = @(snapshot.wdEnabled);
    json[CBX_TEST_ID] = [Application cacheElement:(XCUIElement *)snapshot];

    NSDictionary *visibilityInfo;
    if ([[snapshot class] isSubclassOfClass:[XCElementSnapshot class]]) {
        visibilityInfo = [JSONUtils visibilityInfoWithSnapshot:(XCElementSnapshot *)snapshot];
    } else if ([[snapshot class] isSubclassOfClass:[XCUIElement class]]) {
        visibilityInfo = [JSONUtils visibilityInfoWithElement:(XCUIElement *)snapshot];
    } else {
        visibilityInfo = @{ CBX_HITABLE_KEY : @(NO),
                            CBX_HIT_POINT_KEY : unhitablePoint };
    }

    json[CBX_HITABLE_KEY] = visibilityInfo[CBX_HITABLE_KEY];
    json[CBX_HIT_POINT_KEY] = visibilityInfo[CBX_HIT_POINT_KEY];

    return json;
}

+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element {
    return [self snapshotToJSON:(XCElementSnapshot *)element];
}

+ (NSDictionary *)rectToJSON:(CGRect)rect {
    return @{
             CBX_X_KEY : @(rect.origin.x),
             CBX_Y_KEY : @(rect.origin.y),
             CBX_HEIGHT_KEY : @(rect.size.height),
             CBX_WIDTH_KEY : @(rect.size.width)
             };
}

+ (NSDictionary *)visibilityInfoWithElement:(XCUIElement *)element {
    return @{ CBX_HITABLE_KEY : @([JSONUtils elementHitable:element]),
             CBX_HIT_POINT_KEY : [JSONUtils elementHitPointToJSON:element] };
}

+ (NSDictionary *)visibilityInfoWithSnapshot:(XCElementSnapshot *)snapshot {
    if ([snapshot respondsToSelector:@selector(hitPoint)]) {
        CGPoint point = [snapshot hitPoint];

        id value = [snapshot hitTest:point];
        BOOL hitable = (value && value == snapshot);

        return @{ CBX_HITABLE_KEY : @(hitable),
                  CBX_HIT_POINT_KEY : @{ @"x" : @(point.x), @"y": @(point.y) } };
    } else {
        return @{ CBX_HITABLE_KEY : @(NO),
                  CBX_HIT_POINT_KEY : unhitablePoint };
    }
}

+ (BOOL)elementHitable:(XCUIElement *)element {
    if (![element respondsToSelector:@selector(isHittable)]) {
        return NO;
    } else {
        return [element isHittable];
    }
}

+ (NSDictionary *)elementHitPointToJSON:(XCUIElement *)element {
    id hitPoint = nil;
    XCUICoordinate *coordinate = nil;
    NSDictionary *dictionary = nil;
    if ([element respondsToSelector:@selector(hitPointCoordinate)]) {
        hitPoint = [element hitPointCoordinate];
        if (hitPoint) {
            if ([hitPoint respondsToSelector:@selector(screenPoint)]) {

                coordinate = (XCUICoordinate *)hitPoint;
                CGPoint point = [coordinate screenPoint];
                dictionary = @{ @"x" : @(point.x), @"y": @(point.y) };
            }
        }
    }

    if (!dictionary) { dictionary = unhitablePoint; }

    return dictionary;
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
        NSLog(@"Error: %@", error);
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
                                @(XCUIElementTypeSplitGroup) : @"SplitGroupe",
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

        unhitablePoint = @{ @"x" : @(-1), @"y" : @(-1) };
    });
}
@end
