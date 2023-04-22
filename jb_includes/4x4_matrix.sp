#if defined _4x4_matrix_included
	#endinput
#endif
#define _4x4_matrix_included



// https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/mp/src/utils/motionmapper/motionmapper.cpp

//--------------------------------------------------------------------
// mikes right handed row based linear algebra
//--------------------------------------------------------------------
// struct M_matrix4x4_t
// {
	// M_matrix4x4_t() {
	
		// m_flMatVal[0][0] = 1.0;	m_flMatVal[0][1] = 0.0; m_flMatVal[0][2] = 0.0; m_flMatVal[0][3] = 0.0;
		// m_flMatVal[1][0] = 0.0;	m_flMatVal[1][1] = 1.0; m_flMatVal[1][2] = 0.0;	m_flMatVal[1][3] = 0.0;
		// m_flMatVal[2][0] = 0.0;	m_flMatVal[2][1] = 0.0; m_flMatVal[2][2] = 1.0;	m_flMatVal[2][3] = 0.0;
		// m_flMatVal[3][0] = 0.0;	m_flMatVal[3][1] = 0.0; m_flMatVal[3][2] = 0.0;	m_flMatVal[3][3] = 1.0;

//	// }	
//	// M_matrix3x4_t( 
//		// float m00, float m01, float m02, 
//		// float m10, float m11, float m12,
//		// float m20, float m21, float m22,
//		// float m30, float m31, float m32)
//	// {
//		// m_flMatVal[0][0] = m00;	m_flMatVal[0][1] = m01; m_flMatVal[0][2] = m02;
//		// m_flMatVal[1][0] = m10;	m_flMatVal[1][1] = m11; m_flMatVal[1][2] = m12;
//		// m_flMatVal[2][0] = m20;	m_flMatVal[2][1] = m21; m_flMatVal[2][2] = m22;
//		// m_flMatVal[3][0] = m30;	m_flMatVal[3][1] = m31; m_flMatVal[3][2] = m32;
//
//	// }

	// float *operator[]( int i )				{ Assert(( i >= 0 ) && ( i < 4 )); return m_flMatVal[i]; }
	// const float *operator[]( int i ) const	{ Assert(( i >= 0 ) && ( i < 4 )); return m_flMatVal[i]; }
	// float *Base()							{ return &m_flMatVal[0][0]; }
	// const float *Base() const				{ return &m_flMatVal[0][0]; }

	// float m_flMatVal[4][4];
// };


stock void M_MatrixInit(const float matrix[4][4])
{
	matrix[0][0] = 1.0; matrix[0][1] = 0.0; matrix[0][2] = 0.0; matrix[0][3] = 0.0;
	matrix[1][0] = 0.0; matrix[1][1] = 1.0; matrix[1][2] = 0.0; matrix[1][3] = 0.0;
	matrix[2][0] = 0.0; matrix[2][1] = 0.0; matrix[2][2] = 1.0; matrix[2][3] = 0.0;
	matrix[3][0] = 0.0; matrix[3][1] = 0.0; matrix[3][2] = 0.0; matrix[3][3] = 1.0;
}


stock void M_MatrixAngles( const float matrix[4][4], float angles[3], float position[3])
{
	float cX, sX, cY, sY, cZ, sZ;

	sY = -matrix[0][2];
	cY = SquareRoot(1.0-(sY*sY));

	if (cY != 0.0)
	{
		sX = matrix[1][2];
		cX = matrix[2][2];
		sZ = matrix[0][1];
		cZ = matrix[0][0];
	}
	else
	{
		sX = -matrix[2][1];
		cX = matrix[1][1];
		sZ = 0.0;
		cZ = 1.0;
	}

	angles[0] = ArcTangent2( sX, cX );
	angles[2] = ArcTangent2( sZ, cZ );

	sX = Sine(angles[0]);
	cX = Cosine(angles[0]);

	if (sX > cX)
		cY = matrix[1][2] / sX;
	else
		cY = matrix[2][2] / cX;

	angles[1] = ArcTangent2( sY, cY );
	

	position[0] = matrix[3][0];
	position[1] = matrix[3][1];
	position[2] = matrix[3][2];

}


// void M_MatrixCopy( const M_matrix4x4_t& in, M_matrix4x4_t& out )
// {
	// memcpy( out.Base(), in.Base(), sizeof( float ) * 4 * 4 );
// }


// void M_RotateZMatrix(float radian, M_matrix4x4_t &resultMatrix)
// {

	// resultMatrix[0][0] = Cosine(radian);
	// resultMatrix[0][1] = sin(radian);
	// resultMatrix[0][2] = 0.0;
	// resultMatrix[1][0] =-sin(radian);
	// resultMatrix[1][1] =  cos(radian);
	// resultMatrix[1][2] = 0.0;
	// resultMatrix[2][0] = 0.0;
	// resultMatrix[2][1] =  0.0;
	// resultMatrix[2][2] = 1.0;
// }


// !!! THIS SHIT DOESN'T WORK!! WHY? HAS I EVER?
// void M_AngleAboutAxis(Vector &axis, float radianAngle, M_matrix4x4_t &result)
// {
	// float c = Cosine(radianAngle);
	// float s = Sine(radianAngle);
	// float t = 1.0 - c;
	// // axis.normalize();
	
	// result[0][0] = t * axis[0] * axis[0] + c;
	// result[0][1] = t * axis[0] * axis[1] - s * axis[2];
	// result[0][2] = t * axis[0] * axis[2] + s * axis[1];          
	// result[1][0] = t * axis[0] * axis[1] + s * axis[2];
	// result[1][1] = t * axis[1] * axis[1] + c;
	// result[1][2] = t * axis[1] * axis[2] - s * axis[0];
	// result[2][0] = t * axis[1] * axis[2] - s;
	// result[2][1] = t * axis[1] * axis[2] + s * axis[1];
	// result[2][2] = t * axis[2] * axis[2] + c * axis[0];

// }


stock void M_MatrixInvert( const float im[4][4], float out[4][4] )
{
	// if ( &im == &out )
	// {
		// M_matrix4x4_t in2;
		// M_MatrixCopy( im, in2 );
		// M_MatrixInvert( in2, out );
		// return;
	// }
	float tmp[3];

	// I'm guessing this only works on a 3x4 orthonormal matrix
	out[0][0] = im[0][0];
	out[1][0] = im[0][1];
	out[2][0] = im[0][2];

	out[0][1] = im[1][0];
	out[1][1] = im[1][1];
	out[2][1] = im[1][2];

	out[0][2] = im[2][0];
	out[1][2] = im[2][1];
	out[2][2] = im[2][2];

	tmp[0] = im[3][0];
	tmp[1] = im[3][1];
	tmp[2] = im[3][2];

	float v1[3], v2[3], v3[3];
	v1[0] = out[0][0];
	v1[1] = out[1][0];
	v1[2] = out[2][0];
	v2[0] = out[0][1];
	v2[1] = out[1][1];
	v2[2] = out[2][1];
	v3[0] = out[0][2];
	v3[1] = out[1][2];
	v3[2] = out[2][2];

	// out[3][0] = -DotProduct( tmp, v1 );
	// out[3][1] = -DotProduct( tmp, v2 );
	// out[3][2] = -DotProduct( tmp, v3 );
	
							// function vecDotProduct( v1, v2 )
							// return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
							// end
	
	out[0][3] = -( tmp[0]*v1[0] + tmp[1]*v1[1] + tmp[2]*v1[2] );
	out[1][3] = -( tmp[0]*v2[0] + tmp[1]*v2[1] + tmp[2]*v2[2] );
	out[2][3] = -( tmp[0]*v3[0] + tmp[1]*v3[1] + tmp[2]*v3[2] );
}

// #define MULT(i,j) (in1[i][0]*in2[0][j] + in1[i][1]*in2[1][j] + in1[i][2]*in2[2][j] + in1[i][3]*in2[3][j]);
			 
void M_ConcatTransforms(const float in1[4][4], const float in2[4][4], float out[4][4])
{
    out[0][0] = (in1[0][0]*in2[0][0] + in1[0][1]*in2[1][0] + in1[0][2]*in2[2][0] + in1[0][3]*in2[3][0]);
    out[0][1] = (in1[0][0]*in2[0][1] + in1[0][1]*in2[1][1] + in1[0][2]*in2[2][1] + in1[0][3]*in2[3][1]);
    out[0][2] = (in1[0][0]*in2[0][2] + in1[0][1]*in2[1][2] + in1[0][2]*in2[2][2] + in1[0][3]*in2[3][2]);
    out[0][3] = (in1[0][0]*in2[0][3] + in1[0][1]*in2[1][3] + in1[0][2]*in2[2][3] + in1[0][3]*in2[3][3]);
    out[1][0] = (in1[1][0]*in2[0][0] + in1[1][1]*in2[1][0] + in1[1][2]*in2[2][0] + in1[1][3]*in2[3][0]);
    out[1][1] = (in1[1][0]*in2[0][1] + in1[1][1]*in2[1][1] + in1[1][2]*in2[2][1] + in1[1][3]*in2[3][1]);
    out[1][2] = (in1[1][0]*in2[0][2] + in1[1][1]*in2[1][2] + in1[1][2]*in2[2][2] + in1[1][3]*in2[3][2]);
    out[1][3] = (in1[1][0]*in2[0][3] + in1[1][1]*in2[1][3] + in1[1][2]*in2[2][3] + in1[1][3]*in2[3][3]);
    out[2][0] = (in1[2][0]*in2[0][0] + in1[2][1]*in2[1][0] + in1[2][2]*in2[2][0] + in1[2][3]*in2[3][0]);
    out[2][1] = (in1[2][0]*in2[0][1] + in1[2][1]*in2[1][1] + in1[2][2]*in2[2][1] + in1[2][3]*in2[3][1]);
    out[2][2] = (in1[2][0]*in2[0][2] + in1[2][1]*in2[1][2] + in1[2][2]*in2[2][2] + in1[2][3]*in2[3][2]);
    out[2][3] = (in1[2][0]*in2[0][3] + in1[2][1]*in2[1][3] + in1[2][2]*in2[2][3] + in1[2][3]*in2[3][3]);
    out[3][0] = (in1[3][0]*in2[0][0] + in1[3][1]*in2[1][0] + in1[3][2]*in2[2][0] + in1[3][3]*in2[3][0]);
    out[3][1] = (in1[3][0]*in2[0][1] + in1[3][1]*in2[1][1] + in1[3][2]*in2[2][1] + in1[3][3]*in2[3][1]);
    out[3][2] = (in1[3][0]*in2[0][2] + in1[3][1]*in2[1][2] + in1[3][2]*in2[2][2] + in1[3][3]*in2[3][2]);
    out[3][3] = (in1[3][0]*in2[0][3] + in1[3][1]*in2[1][3] + in1[3][2]*in2[2][3] + in1[3][3]*in2[3][3]);
}

stock void M_AngleMatrix( const float angles[3], const float position[3], float matrix[4][4] )
{
	// Assert( s_bMathlibInitialized );
	float		sx, sy, sz, cx, cy, cz;
	

	sx = Sine(angles[0]);
	cx = Cosine(angles[0]);
	
	sy = Sine(angles[1]);
	cy = Cosine(angles[1]);
	
	sz = Sine(angles[2]);
	cz = Cosine(angles[2]);
	
	// SinCos( angles[0], &sx, &cx ); // 2
	// SinCos( angles[1], &sy, &cy ); // 1
	// SinCos( angles[2], &sz, &cz ); // 0
	
	// M_matrix4x4_t mx, my, mz, temp1;
	
	float mx[4][4];
	float my[4][4];
	float mz[4][4];
	float temp1[4][4];
	
	M_MatrixInit(mx);
	M_MatrixInit(my);
	M_MatrixInit(mz);
	M_MatrixInit(temp1);
	
	// rotation about x
	mx[1][1] = cx;
	mx[1][2] = sx;
	mx[2][1] = -sx;
	mx[2][2] = cx;
 
	// rotation about y
	my[0][0] = cy;
	my[0][2] = -sy;
	my[2][0] = sy;
	my[2][2] = cy;
	
    // rotation about z
	mz[0][0] = cz;
	mz[0][1] = sz;
	mz[1][0] = -sz;
	mz[1][1] = cz;

	// z * y * x
	M_ConcatTransforms(mx, my, temp1);
	M_ConcatTransforms(temp1, mz, matrix);

	// put position in
	matrix[3][0] = position[0];
	matrix[3][1] = position[1];
	matrix[3][2] = position[2];

}

