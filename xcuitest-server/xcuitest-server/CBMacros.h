//
//  CBMacros.h
//  xcuitest-server
//

#ifndef CBMacros_h
#define CBMacros_h

#define DATA_TO_JSON( data ) [NSJSONSerialization JSONObjectWithData: ( data ) options:0 error:NULL]
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

#endif /* CBMacros_h */
