#if defined _quaternions_included
	#endinput
#endif
#define _quaternions_included

// Copyright (C) 2022 Martin Weigel <mail@MartinWeigel.com>
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/**
 * @file    Quaternion.c
 * @brief   A basic quaternion library written in C
 * @date    2022-05-16
 */
 
// #define 0.0001 (0.0001)

 
stock void Quaternion_set(float w, float v1, float v2, float v3, float output[2][3])
{
    output[0][0] = w;
    output[1][0] = v1;
    output[1][1] = v2;
    output[1][2] = v3;
}

stock void Quaternion_setIdentity(float q[2][3])
{
    
    Quaternion_set(1.0, 0.0, 0.0, 0.0, q);
}

stock void Quaternion_copy(float q[2][3], float output[2][3])
{
    Quaternion_set(q[0][0], q[1][0], q[1][1], q[1][2], output);
}

stock bool Quaternion_equal(float q1[2][3], float q2[2][3])
{
    return (
	   (FloatAbs(q1[0][0] - q2[0][0]) <= 0.0001)
    && (FloatAbs(q1[1][0] - q2[1][0]) <= 0.0001)
    && (FloatAbs(q1[1][1] - q2[1][1]) <= 0.0001)
    && (FloatAbs(q1[1][2] - q2[1][2]) <= 0.0001));
}

stock void Quaternion_fprint(float q[2][3])
{
	new String:aaa[512];
	Format(aaa, 512, "(%f, %f, %f, %f)", q[0][0], q[1][0], q[1][1], q[1][2]);
	PrintToServer(aaa);
}

stock void Quaternion_fromAxisAngle(float axis[3], float angle, float output[2][3])
{
    // Formula from http://www.euclideanspace.com/maths/geometry/rotations/conversions/angleToQuaternion/
    output[0][0] = Cosine(angle / 2.0);
    float c = Sine(angle / 2.0);
    output[1][0] = c * axis[0];
    output[1][1] = c * axis[1];
    output[1][2] = c * axis[2];
}

stock float Quaternion_toAxisAngle(float q[2][3], float output[3])
{
    // Formula from http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle/
    float angle = 2.0 * ArcCosine(q[0][0]);
    float divider = SquareRoot(1.0 - q[0][0] * q[0][0]);

    if(divider != 0.0) {
        // Calculate the axis
        output[0][0] = q[1][0] / divider;
        output[1] = q[1][1] / divider;
        output[2] = q[1][2] / divider;
    } else {
        // Arbitrary normalized axis
        output[0][0] = 1.0;
        output[1] = 0.0;
        output[2] = 0.0;
    }
    return angle;
}

stock void Quaternion_fromXRotation(float angle, float output[2][3])
{
    float axis[3] = {1.0, 0.0, 0.0};
    Quaternion_fromAxisAngle(axis, angle, output);
}

stock void Quaternion_fromYRotation(float angle, float output[2][3])
{
    float axis[3] = {0.0, 1.0, 0.0};
    Quaternion_fromAxisAngle(axis, angle, output);
}

stock void Quaternion_fromZRotation(float angle, float output[2][3])
{
    float axis[3] = {0.0, 0.0, 1.0};
    Quaternion_fromAxisAngle(axis, angle, output);
}

stock void Quaternion_fromEulerZYX(float eulerZYX[3], float output[2][3])
{
    // Based on https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
    float cy = Cosine(eulerZYX[2] * 0.5);
    float sy = Sine(eulerZYX[2] * 0.5);
    float cr = Cosine(eulerZYX[0] * 0.5);
    float sr = Sine(eulerZYX[0] * 0.5);
    float cp = Cosine(eulerZYX[1] * 0.5);
    float sp = Sine(eulerZYX[1] * 0.5);

    output[0][0] = cy * cr * cp + sy * sr * sp;
    output[1][0] = cy * sr * cp - sy * cr * sp;
    output[1][1] = cy * cr * sp + sy * sr * cp;
    output[1][2] = sy * cr * cp - cy * sr * sp;
}

stock void Quaternion_toEulerZYX(float q[2][3], float output[3])
{

    // Roll (x-axis rotation)
    float sinr_cosp = 2.0 * (q[0][0] * q[1][0] + q[1][1] * q[1][2]);
    float cosr_cosp = 1.0 - 2.0 * (q[1][0] * q[1][0] + q[1][1] * q[1][1]);
    output[0][0] = ArcTangent2(sinr_cosp, cosr_cosp);

    // Pitch (y-axis rotation)
    float sinp = 2.0 * (q[0][0] * q[1][1] - q[1][2] * q[1][0]);
    if (FloatAbs(sinp) >= 1.0)
	{
        // output[1] = copysign(M_PI / 2, sinp); // use 90 degrees if out of range
	}
    else
	{
        output[1] = ArcSine(sinp);
	}
    // Yaw (z-axis rotation)
    float siny_cosp = 2.0 * (q[0][0] * q[1][2] + q[1][0] * q[1][1]);
    float cosy_cosp = 1.0 - 2.0 * (q[1][1] * q[1][1] + q[1][2] * q[1][2]);
    output[2] = ArcTangent2(siny_cosp, cosy_cosp);
}

stock void Quaternion_conjugate(float q[2][3], float output[2][3])
{
    output[0][0] = q[0][0];
    output[1][0] = -q[1][0];
    output[1][1] = -q[1][1];
    output[1][2] = -q[1][2];
}

stock float Quaternion_norm(float q[2][3])
{
    
    return SquareRoot(q[0][0]*q[0][0] + q[1][0]*q[1][0] + q[1][1]*q[1][1] + q[1][2]*q[1][2]);
}

stock void Quaternion_normalize(float q[2][3], float output[2][3])
{
    float len = Quaternion_norm(q);
    Quaternion_set(
        q[0][0] / len,
        q[1][0] / len,
        q[1][1] / len,
        q[1][2] / len,
        output);
}

stock void Quaternion_multiply(float q1[2][3], float q2[2][3], float output[2][3])
{
    // new result[2][3];

    /*
    Formula from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/arithmetic/index.htm
             a*e - b*f - c*g - d*h
        + i (b*e + a*f + c*h- d*g)
        + j (a*g - b*h + c*e + d*f)
        + k (a*h + b*g - c*f + d*e)
    */
    output[0][0] =    q1[0][0]   *q2[0][0]    - q1[1][0]*q2[1][0] - q1[1][1]*q2[1][1] - q1[1][2]*q2[1][2];
    output[1][0] = q1[1][0]*q2[0][0]    + q1[0][0]   *q2[1][0] + q1[1][1]*q2[1][2] - q1[1][2]*q2[1][1];
    output[1][1] = q1[0][0]   *q2[1][1] - q1[1][0]*q2[1][2] + q1[1][1]*q2[0][0]    + q1[1][2]*q2[1][0];
    output[1][2] = q1[0][0]   *q2[1][2] + q1[1][0]*q2[1][1] - q1[1][1]*q2[1][0] + q1[1][2]*q2[0][0]   ;

    // *output = result;
	// output[0][0] = result[0][0];
	// output[0][0] = result[0][0];
	
}

stock void Quaternion_rotate(float q[2][3], float v[3], float output[3])
{
    float result[3];
    float ww = q[0][0] * q[0][0];
    float xx = q[1][0] * q[1][0];
    float yy = q[1][1] * q[1][1];
    float zz = q[1][2] * q[1][2];
    float wx = q[0][0] * q[1][0];
    float wy = q[0][0] * q[1][1];
    float wz = q[0][0] * q[1][2];
    float xy = q[1][0] * q[1][1];
    float xz = q[1][0] * q[1][2];
    float yz = q[1][1] * q[1][2];

    // Formula from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/transforms/index.htm
    // p2.x = w*w*p1.x + 2*y*w*p1.z - 2*z*w*p1.y + x*x*p1.x + 2*y*x*p1.y + 2*z*x*p1.z - z*z*p1.x - y*y*p1.x;
    // p2.y = 2*x*y*p1.x + y*y*p1.y + 2*z*y*p1.z + 2*w*z*p1.x - z*z*p1.y + w*w*p1.y - 2*x*w*p1.z - x*x*p1.y;
    // p2.z = 2*x*z*p1.x + 2*y*z*p1.y + z*z*p1.z - 2*w*y*p1.x - y*y*p1.z + 2*w*x*p1.y - x*x*p1.z + w*w*p1.z;

    result[0] = ww*v[0] + 2*wy*v[2] - 2*wz*v[1] +
                xx*v[0] + 2*xy*v[1] + 2*xz*v[2] -
                zz*v[0] - yy*v[0];
    result[1] = 2*xy*v[0] + yy*v[1] + 2*yz*v[2] +
                2*wz*v[0] - zz*v[1] + ww*v[1] -
                2*wx*v[2] - xx*v[1];
    result[2] = 2*xz*v[0] + 2*yz*v[1] + zz*v[2] -
                2*wy*v[0] - yy*v[2] + 2*wx*v[1] -
                xx*v[2] + ww*v[2];

    // Copy result to output
    output[0] = result[0];
    output[1] = result[1];
    output[2] = result[2];
}

stock void Quaternion_slerp(float q1[2][3], float q2[2][3], float t, float output[2][3])
{
	new Float:result[2][3];

	// Based on http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/index.htm
	float cosHalfTheta = q1[0][0]*q2[0][0] + q1[1][0]*q2[1][0] + q1[1][1]*q2[1][1] + q1[1][2]*q2[1][2];

    // if q1=q2 or qa=-q2 then theta = 0 and we can return qa
	if (FloatAbs(cosHalfTheta) >= 1.0) {
		Quaternion_copy(q1, output);
		return;
	}

	float halfTheta = ArcCosine(cosHalfTheta);
	float sinHalfTheta = SquareRoot(1.0 - cosHalfTheta*cosHalfTheta);
    // If theta = 180 degrees then result is not fully defined
    // We could rotate around any axis normal to q1 or q2
	if (FloatAbs(sinHalfTheta) < 0.0001) {
		result[0][0] = (q1[0][0] * 0.5 + q2[0][0] * 0.5);
		result[1][0] = (q1[1][0] * 0.5 + q2[1][0] * 0.5);
		result[1][1] = (q1[1][1] * 0.5 + q2[1][1] * 0.5);
		result[1][2] = (q1[1][2] * 0.5 + q2[1][2] * 0.5);
	} else {
		// Default quaternion calculation
		float ratioA = Sine((1 - t) * halfTheta) / sinHalfTheta;
		float ratioB = Sine(t * halfTheta) / sinHalfTheta;
		result[0][0] = (q1[0][0] * ratioA + q2[0][0] * ratioB);
		result[1][0] = (q1[1][0] * ratioA + q2[1][0] * ratioB);
		result[1][1] = (q1[1][1] * ratioA + q2[1][1] * ratioB);
		result[1][2] = (q1[1][2] * ratioA + q2[1][2] * ratioB);
	}
	// *output = result;

	output[0][0] = result[0][0];
	output[1][0] = result[1][0];
	output[1][1] = result[1][1];
	output[1][2] = result[1][2];
}

