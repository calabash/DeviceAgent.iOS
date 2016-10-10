//
//  CBXConstants.h
//  xcuitest-server
//

#import <Foundation/Foundation.h>

static NSUInteger const CBX_DEFAULT_SERVER_PORT = 27753;
static NSString *const CBXWebServerErrorDomain = @"sh.calaba.xcuitest-server";
static NSString *const CBX_BUNDLE_PATH_KEY = @"bundlePath";
static NSString *const CBX_BUNDLE_ID_KEY = @"bundleID";
static NSString *const CBX_LAUNCH_ARGS_KEY = @"launchArgs";
static NSString *const CBX_ENVIRONMENT_KEY = @"environment";

static NSString *const CBX_X_KEY = @"x";
static NSString *const CBX_Y_KEY = @"y";
static NSString *const CBX_X1_KEY = @"x1";
static NSString *const CBX_Y1_KEY = @"y1";
static NSString *const CBX_X2_KEY = @"x2";
static NSString *const CBX_Y2_KEY = @"y2";

static NSString *const CBX_ERROR_KEY = @"error";
static NSString *const CBX_REPETITIONS_KEY = @"repetitions";
static NSString *const CBX_GESTURE_KEY = @"gesture";
static NSString *const CBX_OPTIONS_KEY = @"options";
static NSString *const CBX_SPECIFIERS_KEY = @"specifiers";
static NSString *const CBX_QUERY_KEY = @"query";
static NSString *const CBX_PINCH_AMOUNT_KEY = @"amount";
static NSString *const CBX_DEGREES_KEY = @"degrees";
static NSString *const CBX_PINCH_DIRECTION_KEY = @"pinch_direction";
static NSString *const CBX_ROTATION_DIRECTION_KEY = @"rotation_direction";
static NSString *const CBX_RADIUS_KEY = @"radius";
static NSString *const CBX_DURATION_KEY = @"duration";
static NSString *const CBX_ALLOW_INERTIA_DRAG_KEY = @"allow_inertia";
static NSString *const CBX_CLOCKWISE_KEY = @"clockwise";
static NSString *const CBX_COUNTERCLOCKWISE_KEY = @"counterclockwise";
static NSString *const CBX_COORDINATE_KEY = @"coordinate";
static NSString *const CBX_COORDINATES_KEY = @"coordinates";
static NSString *const CBX_HEIGHT_KEY = @"height";
static NSString *const CBX_STRING_KEY = @"string";
static NSString *const CBX_WIDTH_KEY = @"width";
static NSString *const CBX_TYPE_KEY = @"type";
static NSString *const CBX_TITLE_KEY = @"title";
static NSString *const CBX_LABEL_KEY = @"label";
static NSString *const CBX_KEY_KEY = @"key";
static NSString *const CBX_VALUE_KEY = @"value";
static NSString *const CBX_PLACEHOLDER_KEY = @"placeholder";
static NSString *const CBX_ORIENTATION_KEY = @"orientation";
static NSString *const CBX_VOLUME_KEY = @"volume";
static NSString *const CBX_RECT_KEY = @"rect";
static NSString *const CBX_IDENTIFIER_KEY = @"id";
static NSString *const CBX_IDENTIFIER1_KEY = @"id1";
static NSString *const CBX_IDENTIFIER2_KEY = @"id2";
static NSString *const CBX_ENABLED_KEY = @"enabled";
static NSString *const CBX_HITABLE_KEY = @"hitable";
static NSString *const CBX_HIT_POINT_KEY = @"hit_point";
static NSString *const CBX_INDEX_KEY = @"index";
static NSString *const CBX_PROPERTY_KEY = @"property";
static NSString *const CBX_PROPERTY_LIKE_KEY = @"property_like";
static NSString *const CBX_TEST_ID = @"test_id";
static NSString *const CBX_TEST_ID_KEY = @"test_id";
static NSString *const CBX_TEXT_KEY = @"text";
static NSString *const CBX_TEXT_LIKE_KEY = @"text_like";
static NSString *const CBX_TEXT1_KEY = @"text1";
static NSString *const CBX_TEXT2_KEY = @"text2";
static NSString *const CBX_SCALE_KEY = @"scale";
static NSString *const CBX_VELOCITY_KEY = @"velocity";
static NSString *const CBX_ROTATION_START_KEY = @"rotation_start";
static NSString *const CBX_NUM_TAPS_KEY = @"taps";
static NSString *const CBX_NUM_TOUCHES_KEY = @"touches";
static NSString *const CBX_NUM_FINGERS_KEY = @"num_fingers";
static NSString *const CBX_PINCH_IN = @"in";
static NSString *const CBX_PINCH_OUT = @"out";

static NSString *const CBX_DIRECTION_KEY = @"direction";
static NSString *const CBX_UP_KEY = @"up";
static NSString *const CBX_DOWN_KEY = @"down";
static NSString *const CBX_LEFT_KEY = @"left";
static NSString *const CBX_RIGHT_KEY = @"right";

static NSString *const CBX_DEFAULT_PINCH_DIRECTION = @"out";
static NSString *const CBX_DEFAULT_ROTATION_DIRECTION = @"clockwise";

static NSString *const CBX_EMPTY_STRING = @"";

static NSUInteger const HTTP_STATUS_CODE_EVERYTHING_OK = 200;
static NSUInteger const HTTP_STATUS_CODE_INVALID_REQUEST = 400;
static NSUInteger const HTTP_STATUS_CODE_SERVER_ERROR = 500;

static int const CBX_MIN_NUM_FINGERS = 1;
static int const CBX_MAX_NUM_FINGERS = 5;

static float const CBX_MIN_ROTATION_START = 0;      //degrees
static float const CBX_MAX_ROTATION_START = 360;    //degrees
static float const CBX_MIN_LONG_PRESS_DURATION = 0.5; //determined through trial and error w/UILongPressGestureRecognizer
static float const CBX_RUNLOOP_INTERVAL = 0.1;
static float const CBX_DEFAULT_DURATION = 0.1;
static BOOL const CBX_DEFAULT_ALLOW_INERTIA_IN_DRAG = YES;
static float const CBX_DOUBLE_TAP_PAUSE_DURATION = 0.1;
static float const CBX_DEFAULT_ROTATE_DURATION = .8;
static float const CBX_DEFAULT_PINCH_AMOUNT = 50;
static float const CBX_GESTURE_EPSILON = 0.001;
static float const CBX_SERVER_SHUTDOWN_DELAY = 0.2;

static float const CBX_DEFAULT_DEGREES = 90;
static float const CBX_DEFAULT_ROTATION_START = 0;
static float const CBX_DEFAULT_RADIUS = 25;
static float const CBX_ROTATE_INCREMENT_DEGREES = 1;
// Determined by the width of a two-finger touch.
static float const CBX_FINGER_WIDTH = 78;

static int const CBX_DEFAULT_NUM_FINGERS = 1;
static int const CBX_DEFAULT_REPETITIONS = 1;

static unsigned long long CBX_DEFAULT_SEND_STRING_FREQUENCY = 0.4; //seconds per letter
