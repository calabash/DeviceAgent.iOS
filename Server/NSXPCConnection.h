#import <XCTest/XCTest.h>
#import "XCTestConfiguration.h"

@interface XCTouchPath : NSObject <NSSecureCoding>
{
    NSMutableArray *_touchEvents;
    _Bool _immutable;
    unsigned long long _index;
    long long _interfaceOrientation;
}

+ (_Bool)supportsSecureCoding;
- (void)_addTouchEvent:(_Nonnull id)arg1;
@property(readonly) _Bool complete;
- (void)dealloc;
- (id _Nullable)description;
- (void)encodeWithCoder:(id _Nonnull)arg1;
- (id _Nullable)firstEventAfterOffset:(double)arg1;
@property _Bool immutable; // @synthesize immutable=_immutable;
@property unsigned long long index; // @synthesize index=_index;
- (id _Nullable)init;
- (id _Nullable)initWithCoder:(id _Nonnull)arg1;
- (id _Nullable)initWithTouchDown:(struct CGPoint)arg1 orientation:(long long)arg2 offset:(double)arg3;
@property(readonly) long long interfaceOrientation; // @synthesize interfaceOrientation=_interfaceOrientation;
- (id _Nullable)lastEventBeforeOffset:(double)arg1;
- (void)liftUpAtPoint:(struct CGPoint)arg1 offset:(double)arg2;
- (void)moveToPoint:(struct CGPoint)arg1 atOffset:(double)arg2;
@property(readonly) NSArray *_Nullable touchEvents;

@end

@interface XCTouchGesture : NSObject <NSSecureCoding>
{
    NSMutableArray *_touchPaths;
    _Bool _immutable;
    NSString *_name;
}

+ (_Bool)supportsSecureCoding;
- (void)addTouchPath:(id _Nonnull)arg1;
- (void)dealloc;
- (id _Nonnull)description;
- (void)encodeWithCoder:(id _Nonnull)arg1;
@property _Bool immutable; // @synthesize immutable=_immutable;
- (id _Nullable)init;
- (id _Nullable)initWithCoder:(id _Nonnull)arg1;
- (id _Nullable)initWithName:(id _Nonnull)arg1;
- (void)makeImmutable;
@property(readonly) double maximumOffset;
@property(readonly, copy) NSString *_Nullable name; // @synthesize name=_name;
@property(readonly) NSArray *_Nonnull touchPaths;

@end

@class XCSynthesizedEventRecord;
@class XCElementSnapshot;

@protocol XCTestManager_TestsInterface
- (void)_XCT_receivedAccessibilityNotification:(int)arg1 withPayload:(NSData *_Nonnull)arg2;
- (void)_XCT_applicationWithBundleID:(NSString *_Nonnull)arg1 didUpdatePID:(int)arg2 andState:(unsigned long long)arg3;
@end

//TODO Just add the header
@interface XCAccessibilityElement : NSObject
@end

@class XCDeviceEvent;


extern BOOL _XCTestMain (XCTestConfiguration *_Nonnull config);

@class DTXRemoteInvocationReceipt;

@interface Runner : UIResponder <UIApplicationDelegate, XCTestManager_TestsInterface>
@property (strong, nonatomic) UIWindow *_Nonnull window;
@end

@class NSMethodSignature, NSInvocation;


typedef NS_OPTIONS(NSUInteger, NSXPCConnectionOptions) {
    // Use this option if connecting to a service in the privileged Mach bootstrap (for example, a launchd.plist in /Library/LaunchDaemons).
    NSXPCConnectionPrivileged = (1 << 12UL)
} ;

@interface NSXPCListenerEndpoint : NSObject <NSSecureCoding> {
@private
    void *_internal;
}
@end

@protocol NSXPCProxyCreating

// Returns a proxy object with no error handling block. Messages sent to the proxy object will be sent over the wire to the other side of the connection. All messages must be 'oneway void' return type. Control may be returned to the caller before the message is sent. This proxy object will conform with the NSXPCProxyCreating protocol.
- (id _Nullable)remoteObjectProxy;

// Returns a proxy object which will invoke the error handling block if an error occurs on the connection. If the message sent to the proxy has a reply handler, then either the error handler or the reply handler will be called exactly once. This proxy object will also conform with the NSXPCProxyCreating protocol.
- (id _Nullable)remoteObjectProxyWithErrorHandler:(nullable void (^)(NSError *_Nullable error))handler;

@end

@interface NSXPCInterface : NSObject {
@private
    Protocol *_protocol;
    CFMutableDictionaryRef _methods2;
    id _reserved1;
}

// Factory method to get an NSXPCInterface instance for a given protocol. Most interfaces do not need any further configuration. Interfaces with collection classes or additional proxy objects should be configured using the methods below.
+ (NSXPCInterface *_Nonnull)interfaceWithProtocol:(Protocol * _Nonnull)protocol;

// The Objective C protocol this NSXPCInterface is based upon.
@property (assign) Protocol *_Nonnull protocol;

// If an argument to a method in your protocol is a collection class (for example, NSArray or NSDictionary), then the interface must be configured with the set of expected classes contained inside of the collection. The classes argument to this method should be an NSSet containing Class objects, like [MyObject class]. The selector argument specifies which method in the protocol is being configured. The argumentIndex parameter specifies which argument of the method the NSSet applies to. If the NSSet is for an argument of the reply block in the method, pass YES for the ofReply: argument. The first argument is index 0 for both the method and the reply block.
// If the expected classes are all property list types, calling this method is optional (property list types are automatically whitelisted for collection objects). You may use this method to further restrict the set of allowed classes.
- (void)setClasses:(NSSet<Class> *_Nonnull)classes forSelector:(SEL _Nonnull)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;
- (NSSet<Class> *_Nonnull)classesForSelector:(SEL _Nonnull)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;

// If an argument to a method in your protocol should be sent as a proxy object instead of by copy, then the interface must be configured with the interface of that new proxy object. If the proxy object is to be an argument of the reply block, pass YES for ofReply. The first argument is index 0 for both the method and the reply block.
- (void)setInterface:(NSXPCInterface *_Nonnull)ifc forSelector:(SEL _Nonnull)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;
- (nullable NSXPCInterface *)interfaceForSelector:(_Nonnull SEL)sel argumentIndex:(NSUInteger)arg ofReply:(BOOL)ofReply;

@end

@interface NSXPCConnection : NSObject <NSXPCProxyCreating> {
@private
    void *_xconnection;
    id _repliesExpected;
    dispatch_queue_t _userQueue;
    uint32_t _state;
    uint32_t _state2;
    void (^_interruptionHandler)();
    void (^_invalidationHandler)();
    id _exportInfo;
    id _repliesRequested;
    id _importInfo;
    id <NSObject> _otherInfo;
    id _reserved1;
    id _lock;
    NSXPCInterface *_remoteObjectInterface;
    NSString *_serviceName;
    NSXPCListenerEndpoint *_endpoint;
    id _eCache;
    id _dCache;
}

// Initialize an NSXPCConnection that will connect to the specified service name. Note: Receiving a non-nil result from this init method does not mean the service name is valid or the service has been launched. The init method simply constructs the local object.
- (instancetype _Nullable)initWithServiceName:(NSString *_Nonnull)serviceName;
@property (nullable, readonly, copy) NSString *serviceName;

// Use this if looking up a name advertised in a launchd.plist. For example, an agent with a launchd.plist in ~/Library/LaunchAgents. If the connection is being made to something in a privileged Mach bootstrap (for example, a daemon with a launchd.plist in /Library/LaunchDaemons), then use the NSXPCConnectionPrivileged option. Note: Receiving a non-nil result from this init method does not mean the service name is valid or the service has been launched. The init method simply constructs the local object.
- (nullable instancetype)initWithMachServiceName:(nonnull NSString *)name options:(NSXPCConnectionOptions)options;

// Initialize an NSXPCConnection that will connect to an NSXPCListener (identified by its NSXPCListenerEndpoint).
- (nullable instancetype)initWithListenerEndpoint:(nonnull NSXPCListenerEndpoint *)endpoint;
@property (readonly, retain, nonnull) NSXPCListenerEndpoint *endpoint;

- (void)_setQueue:(nonnull dispatch_queue_t)q;

// The interface that describes messages that are allowed to be received by the exported object on this connection. This value is required if a exported object is set.
@property (nullable, retain) NSXPCInterface *exportedInterface;

// Set an exported object for the connection. Messages sent to the remoteObjectProxy from the other side of the connection will be dispatched to this object. Messages delivered to exported objects are serialized and sent on a non-main queue. The receiver is responsible for handling the messages on a different queue or thread if it is required.
@property (nullable, retain) id exportedObject;

// The interface that describes messages that are allowed to be received by object that has been "imported" to this connection (exported from the other side). This value is required if messages are sent over this connection.
@property (nullable, retain) NSXPCInterface *remoteObjectInterface;

// Get a proxy for the remote object (that is, the object exported from the other side of this connection). See descriptions in NSXPCProxyCreating for more details.
@property (readonly, retain, nullable) id remoteObjectProxy;

- (nullable id)remoteObjectProxyWithErrorHandler:(nullable void (^)(NSError *_Nullable error))handler;

// The interruption handler will be called if the remote process exits or crashes. It may be possible to re-establish the connection by simply sending another message. The handler will be invoked on the same queue as replies and other handlers, but there is no guarantee of ordering between those callbacks and this one.
// The interruptionHandler property is cleared after the connection becomes invalid. This is to mitigate the impact of a retain cycle created by referencing the NSXPCConnection instance inside this block.
@property (nullable, copy) void (^interruptionHandler)(void);

// The invalidation handler will be called if the connection can not be formed or the connection has terminated and may not be re-established. The handler will be invoked on the same queue as replies and other handlers, but there is no guarantee of ordering between those callbacks and this one.
// You may not send messages over the connection from within an invalidation handler block.
// The invalidationHandler property is cleared after the connection becomes invalid. This is to mitigate the impact of a retain cycle created by referencing the NSXPCConnection instance inside this block.
@property (nullable, copy) void (^invalidationHandler)(void);

// All connections start suspended. You must resume them before they will start processing received messages or sending messages through the remoteObjectProxy. Note: Calling resume does not immediately launch the XPC service. The service will be started on demand when the first message is sent. However, if the name specified when creating the connection is determined to be invalid, your invalidation handler will be called immediately (and asynchronously) after calling resume.
- (void)resume;

// Suspend the connection. Suspends must be balanced with resumes before the connection may be invalidated.
- (void)suspend;

// Invalidate the connection. All outstanding error handling blocks and invalidation blocks will be called on the message handling queue. The connection must be invalidated before it is deallocated. After a connection is invalidated, no more messages may be sent or received.
- (void)invalidate;

// These attributes describe the security attributes of the connection. They may be used by the listener delegate to accept or reject connections.
//@property (readonly) au_asid_t auditSessionIdentifier;
@property (readonly) pid_t processIdentifier;
@property (readonly) uid_t effectiveUserIdentifier;
@property (readonly) gid_t effectiveGroupIdentifier;

@end