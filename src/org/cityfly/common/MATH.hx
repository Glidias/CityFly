﻿/**
 * ...
 * @author Glenn Ko
 */

package org.cityfly.common;

import flash.Error;
import flash.Vector;
import Math;

class MATH 
{	
	private static var _SIN:Vector<Float> = new Vector<Float>(7200,true);
	private static var _COS:Vector<Float> = new Vector<Float>(7200,true);
	private static var _TAN:Vector<Float> = new Vector<Float>(7200,true);
	private static var _INSTANCE:MATH;
	
	public static var instance(getInstance, null) : MATH;
	public static function getInstance():MATH
	{
		if (_INSTANCE == null) _INSTANCE = new MATH();
		return _INSTANCE;
	}
	public var sinTable(getSinTable, null):Vector<Float>;
	public function getSinTable():Vector<Float> {
		return _SIN;
	}
	public var cosTable(getCosTable, null):Vector<Float>;
	public function getCosTable():Vector<Float> {
		return _COS;
	}
	public var tanTable(getTanTable, null):Vector<Float>;
	public function getTanTable():Vector<Float> {
		return _TAN;
	}
	
	private function new() 
	{

		for( i in 0...7200 ) {
			_SIN[i] = Math.sin( i / 3600 * ppPI );
			_COS[i] = Math.cos( i / 3600 * ppPI );
			_TAN[i] = Math.tan( i / 3600 * ppPI );
		}

	}
		
//Uh, PI (180 degrees)
//
public static inline var ppPI:Float =		3.1415926535897932384626433832795;

//
//2 times PI (360 degrees)
//
public static inline var pp2PI:Float =		6.2831853071795864769252867665590;

//
//PI/2 (90 degrees)
//
public static inline var ppHalfPI:Float =	1.5707963267948966192313216916398;


public static inline var LOG2E:Float = 1.442695040888963387;
//
//Square root of 2
//
public static inline var ppSQRT2:Float =		1.4142135623730950488016887242097;

//
//Multiply by degrees to get radians (PI/180)
//
public static inline var ppDeg2Rad:Float =	0.017453292519943295769236907684886;

//
//Multiply by radians to get degrees (180/PI)
//
public static inline var ppRad2Deg:Float =	57.295779513082320876798154814105;

// Convert degree to radians
public static inline function ppRadians(deg:Float):Float {
	return deg * ppDeg2Rad;
}

// convert radians to degree
public static inline function ppDegrees(rad:Float):Float {
	return rad * ppRad2Deg;
}


/**
 * Wrap a degree value between 0 and 360
 * Caution: Macro parameters may be evaluated multiple times
**/
public static inline function ppDegreeWrap(degrees:Float):Float {
	return ( ((degrees) < 0) ? (360 + ((degrees) % 360)) : ((degrees) % 360) );
}

/**
 * Wrap a degree value between +180 and -180
 * Caution: Macro parameters may be evaluated multiple times
**/
public static inline function ppDegreeWrap180(degrees:Float):Float { return ( ((degrees)<-180) ? (360+((degrees)%360)) : ((degrees)>180) ? ((degrees)%360)-360 : (degrees) );
}

/**
 * Get a stable degree difference between deg1 and deg2; 359-1 = 2, not 358
 * Caution: Macro parameters may be evaluated multiple times
**/
public static inline function ppDegreeDiff(deg1:Float, deg2:Float):Float { return		ppDegreeWrap180(ppDegreeWrap180(deg1) - ppDegreeWrap180(deg2));
}


/**
 * Wrap a radian value between 0 and 2PI
 * Caution: Macro parameters may be evaluated multiple times
**/
public static inline function ppRadianWrap(radians:Float):Float	{ return ( ((radians) < 0) ? (pp2PI + ((radians) % pp2PI)) : ((radians) % pp2PI) );
}

/**
 * Wrap a radian value between +PI and -PI
 * Caution: Macro parameters may be evaluated multiple times
**/
public static inline function ppRadianWrapPI(radians:Float):Float	{ return	( ((radians)<=-ppPI) ? (pp2PI+((radians)%pp2PI)) : ((radians)>ppPI) ? ((radians)%pp2PI)-pp2PI : (radians) );
}

/**
 * Get a stable radian difference between rad1 and rad2
 * Caution: Macro parameters may be evaluated multiple times
**/
public static inline function ppRadianDiff(rad1:Float, rad2:Float):Float	{ return	ppRadianWrapPI(ppRadianWrap(rad1) - ppRadianWrap(rad2));
}

public static inline function ppMax(val:Float, val2:Float):Float {
	return val < val2 ? val2 : val;
}
public static inline function ppMin(val:Float, val2:Float):Float {
	return val < val2 ? val : val2;
}
public static inline function ppAbs(val:Float):Float {
	return val < 0 ? -val : val;
}


public static inline function log2(x:Int):Int {
	var num:Int = x >> 16;
	var sign:Int = num!=0 ? 0 : 1;
	var ans:Int = (sign << 4) ^ 24;
 
	num = x >> (ans);
	sign =  num!=0 ? 0 : 1;
	ans = (sign << 3) ^ (ans + 4);		
 
	num = x >> (ans);
	sign =  num!=0 ? 0 : 1;
	ans = (sign << 2) ^ (ans + 2);
 
	num = x >> (ans);
	sign =  num!=0 ? 0 : 1;
	ans = (sign << 1) ^ (ans + 1);		
 
	num = x >> (ans);
	sign =  num!=0 ? 0 : 1;
	ans = sign ^ ans;
 
	return ans;
}

public static inline function isPower2(x:Int):Bool {
	return x != 0 && (x & (x - 1)) == 0; 
}


	
}