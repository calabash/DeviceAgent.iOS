#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "FLWebViewProvider.h"

@interface XamWKWebViewController : UIViewController
<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>

@end
