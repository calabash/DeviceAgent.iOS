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
return @[
    [CBRoute get:@"/foo/bar/calabash" withBlock:^(RouteRequest *request, RouteResponse *response) {
        [response respondWithString:@"qux"];
    }],
    ...
]
```

The route will automatically be picked up via objc runtime reflection. You can confirm
by reading the console logs.
