//
//  JSONUtils.m
//  xcuitest-server
//

#import "CBApplication.h"
#import "CBConstants.h"
#import "JSONUtils.h"

@implementation JSONUtils

static NSDictionary *elementTypeToString;
static NSDictionary *typeStringToElementType;

//TODO: apparenty this causes some lag... how to optimize?
+ (NSMutableDictionary *)snapshotToJSON:(XCElementSnapshot *)snapshot {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    json[CB_TYPE_KEY] = elementTypeToString[@(snapshot.elementType)];
    json[CB_TITLE_KEY] = snapshot.title ?: CB_EMPTY_STRING;
    json[CB_LABEL_KEY] = snapshot.label ?: CB_EMPTY_STRING;
    json[CB_VALUE_KEY] = snapshot.value ?: CB_EMPTY_STRING;
    json[CB_RECT_KEY] = [self rectToJSON:snapshot.frame];
    json[CB_IDENTIFIER_KEY] = snapshot.identifier ?: CB_EMPTY_STRING;
    json[CB_ENABLED_KEY] = @(snapshot.isEnabled);
    json[CB_TEST_ID] = [CBApplication cacheElement:(XCUIElement *)snapshot];
    
    //TODO: visibility?
    return json;
}

+ (NSMutableDictionary *)elementToJSON:(XCUIElement *)element {
    return [self snapshotToJSON:(XCElementSnapshot *)element];
}

+ (NSDictionary *)rectToJSON:(CGRect)rect {
    return @{
             CB_X_KEY : @(rect.origin.x),
             CB_Y_KEY : @(rect.origin.y),
             CB_HEIGHT_KEY : @(rect.size.height),
             CB_WIDTH_KEY : @(rect.size.width)
             };
}

+ (XCUIElementType)elementTypeForString:(NSString *)typeString {
    NSNumber *typeNumber = typeStringToElementType[[typeString lowercaseString]];
    return typeNumber ? [typeNumber intValue] : -1;
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
                                @(XCUIElementTypeMenuButton) : @"Button",
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
        
    });
}
@end
