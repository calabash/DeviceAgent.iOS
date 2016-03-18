//
//  CBMacros.h
//  xcuitest-server
//

#ifndef CBMacros_h
#define CBMacros_h

#define DATA_TO_JSON( data ) [NSJSONSerialization JSONObjectWithData: ( data ) options:0 error:NULL]
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

#define _must_override_exception NSString *msg = [NSString stringWithFormat:@"Must override [%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd)]; @throw [CBException withMessage:msg]

#endif /* CBMacros_h */
