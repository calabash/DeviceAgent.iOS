
#ifndef CBXMacros_h
#define CBXMacros_h

#define DATA_TO_JSON( data ) [NSJSONSerialization JSONObjectWithData: ( data ) options:0 error:NULL]
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

/*
    endpoint should have the leading slash. Version should be a float with 1 decimal place. 
 */
#define endpoint( endpoint, version ) [NSString stringWithFormat:@"/%0.1f%@", version, endpoint]

#endif /* CBXMacros_h */
