package org.cityfly.common 
{
	/**
	 * Inline math static methods and constants from Half-baked raycaster
	 * @author Glenn Ko
	 */
	public class MATH
	{
/**
 * Work out which scalar value is smaller, and return it
**/
public static function ppMin(a:Number, b:Number):Number {
	return Math.min(a, b);
}

/**
 * Work out which scalar value is bigger, and return it
**/
#define ppMax(a,b) Math.max((a),(b))

/**
 * Make sure a >= b; a receives b if it's lesser
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppMost(a,b)		{ if( (a) < (b) ) (a)=(b); }

/**
 * Make sure a <= b; a receives b if it's greater 
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppLeast(a,b)	{ if( (a) > (b) ) (a)=(b); }

/** 
 * Round a value up to a preferred modulus
 * @param val value to round up
 * @param mod The value you want v to be divisible by
 * @return Nearest higher value evenly divisible by 'mod'
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppRoundUpSigned(val,mod)	(int((val)+((val)<0?-(mod)+1:(mod)-1))/(mod)*(mod))
#define ppRoundUp(val,mod)			( int((val)+(mod)-1)/(mod)*(mod))

/** 
 * Round a value down to a preferred modulus
 * @param val value to round up
 * @param mod The value you want v to be divisible by
 * @return Nearest lower value evenly divisible by 'mod'
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppRoundDown(val,mod)	(int((val)/(mod))*(mod))

/**
 * Get the next round value after the present value
 * @param val value to round up
 * @param mod The value you want v to be divisible by
 * @return Next higher value divisible by mod; if val and mod are 16, returns 32
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppNextRound(val,mod)	(rounddown(val,(mod))+(mod))

/**
 * Determine if an integer type is a power of 2
 * @param val value to check
 * @return true if this value is a power of 2
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppIsPow2(val)			(0 == ((uint(val)-1) & uint(val)))

/** 
 * Increment and wrap an unsigned value at a limit
 * @param val value to increment
 * @param limit the last valid value
 * @return new value
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppIncWrap(val,limit)	(++(val) > (limit) ? ((val) = 0) : (val))

/** 
 * Decrement a value and wrap at zero to some limit value
 * @param val value to increment
 * @param limit value to assume if below zero
 * @return new value
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppDecWrap(val,limit)	(--(val) < (0) ? ((val) = (limit)) : (val))

/** 
 * Tell us if a value is within a range
 * @param val value to limit
 * @param lmin Minimum value val is allowed to have
 * @param lmax Maximum value val is allowed to have
 * @return new value
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppValid(val,lmin,lmax)	((val)>=(lmin)&&(val)<=lmax)

/** 
 * Limit a value between lmin and lmax
 * @param val value to limit
 * @param lmin Minimum value val is allowed to have
 * @param lmax Maximum value val is allowed to have
 * @return new value
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppLimit(val,lmin,lmax)	((val)<(lmin)?(lmin):((val)>(lmax)?(lmax):(val)))

/** 
 * Wrap a value between two limits
 * @param val value to limit
 * @param lmin Minimum value val is allowed to have
 * @param lmax Maximum value val is allowed to have
 * @return new value
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppWrap(val,lmin,lmax)		( (val)=( (val)<(lmin) ? ( 1+(lmax) - (((lmin)-(val))%(1+(lmax)-(lmin))) ) : ((val)%(1+(lmax)-(lmin))) ) )

/**
 * Moves a value 'distance' further away from zero
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppFurther(val,distance)		((val)<0?(val)-(distance):(val)+(distance))

/**
 * Get a random integer between 0 and (count-1), from rand()
 * @param count Count of values this may return
 * @return Any value from 0 to (count-1)
**/
#define ppRandom(count)				int(Math.random()*(count))

/**
 * Get a random integer between low and high, from rand()
 * @param low The lowest value this should return
 * @param high The highest value this should return
 * @return Any value between low and high, inclusively
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppRandomBetween(low,high)	( (low) + ppRandom(1+(high)-(low)) )

/**
 * Negate a value half the time
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppRandNegate(val)			( Math.random()>=0.5 ? (val) : -(val) )


/**
 * Uh, PI (180 degrees)
**/
public static const ppPI:Number = 		3.1415926535897932384626433832795

/**
 * 2 times PI (360 degrees)
**/
public static const pp2PI:Number=	6.2831853071795864769252867665590

/**
 * PI/2 (90 degrees)
**/
public static const ppHalfPI:Number=	1.5707963267948966192313216916398

/**
 * Square root of 2
**/
public static const ppSQRT2:Number =	1.4142135623730950488016887242097

/**
 * Multiply by degrees to get radians (PI/180)
**/
public static const ppDeg2Rad:Number =	0.017453292519943295769236907684886

/**
 * Multiply by radians to get degrees (180/PI)
**/
public static const ppRad2Deg:Number=	57.295779513082320876798154814105

/**
 * Turn a value between 0 and 2pi to degrees
 * Caution: Macro parameters may be evaluated multiple times
**/
public static const ppDegrees(radians)			((radians)*ppRad2Deg)

/**
 * Wrap a degree value between 0 and 360
 * Caution: Macro parameters may be evaluated multiple times
**/
public static const ppDegreeWrap(degrees)		( ((degrees)<0) ? (360+((degrees)%360)) : ((degrees)%360) )

/**
 * Wrap a degree value between +180 and -180
 * Caution: Macro parameters may be evaluated multiple times
**/
public static const ppDegreeWrap180(degrees)	( ((degrees)<-180) ? (360+((degrees)%360)) : ((degrees)>180) ? ((degrees)%360)-360 : (degrees) )

/**
 * Get a stable degree difference between deg1 and deg2; 359-1 = 2, not 358
 * Caution: Macro parameters may be evaluated multiple times
**/
public static const ppDegreeDiff(deg1,deg2)		ppDegreeWrap180(ppDegreeWrap180(deg1)-ppDegreeWrap180(deg2))

/**
 * Turn a value between 0 and 360 to radians
**/
public static const ppRadians(degrees):Number {
	return ((degrees) * ppDeg2Rad);
}

/**
 * Wrap a radian value between 0 and 2PI
 * Caution: Macro parameters may be evaluated multiple times
**/
public static const ppRadianWrap(radians):Numbeer {
	return ( ((radians) < 0) ? (pp2PI + ((radians) % pp2PI)) : ((radians) % pp2PI) );
}

/**
 * Wrap a radian value between +PI and -PI
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppRadianWrapPI(radians)		( ((radians)<=-ppPI) ? (pp2PI+((radians)%pp2PI)) : ((radians)>ppPI) ? ((radians)%pp2PI)-pp2PI : (radians) )

/**
 * Get a stable radian difference between rad1 and rad2
 * Caution: Macro parameters may be evaluated multiple times
**/
#define ppRadianDiff(rad1,rad2)		ppRadianWrapPI(ppRadianWrap(rad1)-ppRadianWrap(rad2))

#endif /* PP_H */


		
		
	}

}