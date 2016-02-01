# calabash-xcuitest-server

## Adding New Routes

To add a new route, simply create a new object that implements the
`<CBRouteProvider>` protocol defined in `CBProtocols.h`. Implement the following
method:
```Objective-C
+ (NSArray<CBRoute *> *)getRoutes;
```

Generally the method definition should be something like:
```Objective-C
+ (NSArray<CBRoute *> *)getRoutes {
    return @[
    
        [CBRoute get:@"/foo/bar/calabash" withBlock:^(RouteRequest *request, RouteResponse *response) {
            [response respondWithString:@"qux"];
        }],
        
        [CBRoute post:@"/baz/bar/calabash" withBlock:^(RouteRequest *request, RouteResponse *response) {
            NSDictionary *requestData = DATA_TO_JSON(request.body);
            NSString *param = requestData[@"key"];
            [Foo theBarBaz:param];
            
            [response respondWithJSON:@{ @"status" : @"success!" }];
        }],
        ...
    ];
}
```

The route will automatically be picked up via objc runtime reflection. You can confirm
by reading the console logs.
