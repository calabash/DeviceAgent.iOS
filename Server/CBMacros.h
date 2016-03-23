//
//  CBMacros.h
//  xcuitest-server
//

#ifndef CBMacros_h
#define CBMacros_h

#define DATA_TO_JSON( data ) [NSJSONSerialization JSONObjectWithData: ( data ) options:0 error:NULL]
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

#define _must_override_exception NSString *msg = [NSString stringWithFormat:@"Must override [%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd)]; @throw [CBException withMessage:msg]

/*
    endpoint should have the leading slash. Version should be a float with 1 decimal place. 
 */
#define endpoint( endpoint, version ) [NSString stringWithFormat:@"/%0.1f%@", version, endpoint]

#endif /* CBMacros_h */
