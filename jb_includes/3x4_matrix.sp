#if defined _3x4_matrix_included
	#endinput
#endif
#define _3x4_matrix_included

// concat !matrixNormalOld,matrixNormalNew = matrixDiff
// concat matrixPropAnglesOld,matrixDiff = matrixRotated
// reverse right&up vec inside matrixRotated (rotated[*][1] = -rotated[*][1], rotated[*][2] = -rotated[*][2])
// getMatrixangles(matrixRotated)
				
// Relt: 1. get position and rotation of the first prop, and the normal and hit position of the ray on the first click 
// Relt: 2. get matrix of the prop angles and save it for later
// Relt: 3. subtract position of the prop from the hit pos (hitpos-proppos) and save it for later
// Relt: 4. create a matrix out of the normal and save it for later
// Relt: now the second click
// Relt: 5. get the his pos and normal of the second ray 
// Relt: 6.  invert the matrix of the saved normal matrix from step 4 and save it in variable A
// Relt: 7. concatenate variable A, with the normal matrix of the new hit pos, we will call this the difference 
// Relt: 8. concatenate prop angles matrix from step 2 with the difference, we will call this the rotated matrix 
// Relt: 9. reverse the right and up vectors in the rotated matrix!!! (rotated[*][1] = -rotated[*][1], same thing for 2)
// Relt: 9.1. leave forward vector alone
// Relt: 10. get the angle of the rotated matrix, thats your angle of the prop

/*
float proppos[3];
float propang[3];
GetEntPropVector(entity,Prop_Send,"m_vecOrigin",proppos);
GetEntPropVector(entity,Prop_Send,"m_angRotation",propang);
GetAngleMatrix(propang,motormatrix[client]);
//float propmatrix[4][3];
//TransformToMatrix(propang,proppos,propmatrix);
//float idkmatrix[4][3];
//VectorTo4x3Matrix(normal,idkmatrix);
//idkmatrix[3] = endpos;
//float invertedpropmatrix[4][3];
//Invert4x3Matrix(propmatrix,invertedpropmatrix);
//Concatenate4x3Matrixes(idkmatrix,invertedpropmatrix,motorlocalmatrix[client]);
//float subtracted[3];
motorlocalpos[client][0] = endpos[0]-proppos[0];
motorlocalpos[client][1] = endpos[1]-proppos[1];
motorlocalpos[client][2] = endpos[2]-proppos[2];
//LocalizePosAroundMatrix(motormatrix[client],subtracted,motorlocalpos[client]);
VectorToMatrix(normal,motornormal[client]);
*/
				

// float normalmatrix[3][3];
// VectorToMatrix(normal,normalmatrix);
// float invertedmotornormalmatrix[3][3];
// InvertMatrix(motornormal[client],invertedmotornormalmatrix);
// float difference[3][3];
// ConcatenateAngleMatrixes(invertedmotornormalmatrix,normalmatrix,difference);
// float rotated[3][3];
// ConcatenateAngleMatrixes(motormatrix[client],difference,rotated);
// rotated[1][0] = -rotated[1][0];
// rotated[1][1] = -rotated[1][1];
// rotated[1][2] = -rotated[1][2];
// rotated[2][0] = -rotated[2][0];
// rotated[2][1] = -rotated[2][1];
// rotated[2][2] = -rotated[2][2];
// GetMatrixAngle(rotated,angle);


stock void Matrix_ReverseRightAndUp( float out[3][4] )
{
	out[1][0] = -out[1][0];
	out[1][1] = -out[1][1];
	out[1][2] = -out[1][2];
	
	out[2][0] = -out[2][0];	
	out[2][1] = -out[2][1];	
	out[2][2] = -out[2][2];
}



stock void AlignAngles(const float propAngles[3], const float normalOld[3], const float normalNew[3], float outangle[3])
{
	
	
	// MatrixInvert( const float in1[3][4], float out[3][4] )
	// ConcatTransforms(const float in1[3][4], const float in2[3][4], float out[3][4])
	// MatrixAngles( const float matrix[3][4], float angles[3] )
	// AngleMatrix( const float angles[3], float matrix[3][4] )
	
	// concat !matrixNormalOld,matrixNormalNew = matrixDiff
	// concat matrixPropAnglesOld,matrixDiff = matrixRotated
	// reverse right&up vec inside matrixRotated (rotated[*][1] = -rotated[*][1], rotated[*][2] = -rotated[*][2])
	// getMatrixangles(matrixRotated)
	
	float matrixNormalOld[3][4];
	float matrixNormalOldInv[3][4];
	float matrixNormalNew[3][4];
	float matrixDiff[3][4];
	float matrixPropAnglesOld[3][4];
	float matrixRotated[3][4];

	AngleMatrix( propAngles, matrixPropAnglesOld );
	AngleMatrix( normalOld, matrixNormalOld );
	AngleMatrix( normalNew, matrixNormalNew );
	
	MatrixInvert( matrixNormalOld, matrixNormalOldInv );
	
	ConcatTransforms(matrixNormalOldInv, matrixNormalNew, matrixDiff);
	ConcatTransforms(matrixPropAnglesOld, matrixDiff, matrixRotated);
	
	// Matrix_ReverseRightAndUp(matrixRotated);
	
	MatrixAngles( matrixRotated, outangle );
}



stock float FixAngleSingle(float a)
{
    while (a < 0.0) {
        a = a + 360.0
    }
     
    while (a >= 360.0) {
        a = a - 360.0
    }
     
    if ( a > 180.0 ) {
        return a - 360.0
    }
 
    return a
}


stock void FixAngle(float vector[3])
{
	vector[0] = FixAngleSingle(vector[0]);
	vector[1] = FixAngleSingle(vector[1]);
	vector[2] = FixAngleSingle(vector[2]);
}


stock void ZeroVector(float vector[3])
{
	vector[0] = 0.0;
	vector[1] = 0.0;
	vector[2] = 0.0;
}


stock void CopyVector(const float input[3], float out[3])
{
	out[0] = input[0];
	out[1] = input[1];
	out[2] = input[2];
}


stock VecMulSingle(const float inVec[3], const float mul, float out[3] )
{
	// vector3( v1.x*v2.x, v1.y*v2.y, v1.z*v2.z )	
	out[0] = inVec[0] * mul;
	out[1] = inVec[1] * mul;
	out[2] = inVec[2] * mul;
}


stock VecMul(const float inVec[3], const float mul[3], float out[3] )
{
	// vector3( v1.x*v2.x, v1.y*v2.y, v1.z*v2.z )	
	out[0] = inVec[0] * mul[0];
	out[1] = inVec[1] * mul[1];
	out[2] = inVec[2] * mul[2];
}


// NOTE: This is just the transpose not a general inverse
stock void MatrixInvert( const float in1[3][4], float out[3][4] )
{
	// Assert( s_bMathlibInitialized );
	// if ( &in1 == &out )
	// {
		// V_swap(out[0][1],out[1][0]);
		// V_swap(out[0][2],out[2][0]);
		// V_swap(out[1][2],out[2][1]);
	// }
	// else
	// {
		// transpose the matrix
	out[0][0] = in1[0][0];
	out[0][1] = in1[1][0];
	out[0][2] = in1[2][0];

	out[1][0] = in1[0][1];
	out[1][1] = in1[1][1];
	out[1][2] = in1[2][1];

	out[2][0] = in1[0][2];
	out[2][1] = in1[1][2];
	out[2][2] = in1[2][2];
	// }

	// now fix up the translation to be in1 the other space
	float tmp[3];
	tmp[0] = in1[0][3];
	tmp[1] = in1[1][3];
	tmp[2] = in1[2][3];

	// out[0][3] = -DotProduct( tmp, out[0] );
	// out[1][3] = -DotProduct( tmp, out[1] );
	// out[2][3] = -DotProduct( tmp, out[2] );
	
	out[0][3] = -(tmp[0]*out[0][0] + tmp[1]*out[0][1] + tmp[2]*out[0][2]);
	out[1][3] = -(tmp[0]*out[1][0] + tmp[1]*out[1][1] + tmp[2]*out[1][2]);
	out[2][3] = -(tmp[0]*out[2][0] + tmp[1]*out[2][1] + tmp[2]*out[2][2]);

}


//-----------------------------------------------------------------------------
// Purpose: Generates Euler angles given a left-handed orientation matrix. The
//			columns of the matrix contain the forward, left, and up vectors.
// Input  : matrix - Left-handed orientation matrix.
//			angles[PITCH, YAW, ROLL]. Receives right-handed counterclockwise
//				rotations in degrees around Y, Z, and X respectively.
//-----------------------------------------------------------------------------
stock void MatrixAngles( const float matrix[3][4], float angles[3] )
{
	float frward[3] = {0.0,0.0,0.0};
	float left[3] = {0.0,0.0,0.0};
	float up[3] = {0.0,0.0,0.0};

	//
	// Extract the basis vectors from the matrix. Since we only need the Z
	// component of the up vector, we don't get X and Y.
	//
	frward[0] = matrix[0][0];
	frward[1] = matrix[1][0];
	frward[2] = matrix[2][0];
	left[0] = matrix[0][1];
	left[1] = matrix[1][1];
	left[2] = matrix[2][1];
	up[2] = matrix[2][2];

	float xyDist = SquareRoot( frward[0] * frward[0] + frward[1] * frward[1] );
	
	// enough here to get angles?
	if ( xyDist > 0.001 )
	{
		// (yaw)	y = ATAN( frward.y, frward.x );		-- in our space, frward is the X axis
		angles[1] = RadToDeg( ArcTangent2( frward[1], frward[0] ) );

		// (pitch)	x = ATAN( -frward.z, sqrt(frward.x*frward.x+frward.y*frward.y) );
		angles[0] = RadToDeg( ArcTangent2( -frward[2], xyDist ) );

		// (roll)	z = ATAN( left.z, up.z );
		angles[2] = RadToDeg( ArcTangent2( left[2], up[2] ) );
	}
	else	// frward is mostly Z, gimbal lock-
	{
		// (yaw)	y = ATAN( -left.x, left.y );			-- frward is mostly z, so use right for yaw
		angles[1] = RadToDeg( ArcTangent2( -left[0], left[1] ) );

		// (pitch)	x = ATAN( -frward.z, sqrt(frward.x*frward.x+frward.y*frward.y) );
		angles[0] = RadToDeg( ArcTangent2( -frward[2], xyDist ) );

		// Assume no roll in this case as one degree of freedom has been lost (i.e. yaw == roll)
		angles[2] = 0.0;
	}
}


//-----------------------------------------------------------------------------
// Purpose: converts engine euler angles into a matrix
// Input  : vec3_t angles - PITCH, YAW, ROLL
// Output : *matrix - left-handed column matrix
//			the basis vectors for the rotations will be in the columns as follows:
//			matrix[][0] is forward
//			matrix[][1] is left
//			matrix[][2] is up
//-----------------------------------------------------------------------------
stock void AngleMatrix( const float angles[3], float matrix[3][4] )
{
	float sr, sp, sy, cr, cp, cy;

	// SinCos( DEG2RAD( angles[YAW] ), &sy, &cy );
	// SinCos( DEG2RAD( angles[PITCH] ), &sp, &cp );
	// SinCos( DEG2RAD( angles[ROLL] ), &sr, &cr );
	
	sy = Sine(DegToRad(  angles[1]  ))
	cy = Cosine(DegToRad(  angles[1]  ))
	
	sp = Sine(DegToRad(  angles[0]  ))
	cp = Cosine(DegToRad(  angles[0]  ))
	
	sr = Sine(DegToRad(  angles[2]  ))
	cr = Cosine(DegToRad(  angles[2]  ))

	// matrix = (YAW * PITCH) * ROLL
	matrix[0][0] = cp*cy;
	matrix[1][0] = cp*sy;
	matrix[2][0] = -sp;

	float crcy = cr*cy;
	float crsy = cr*sy;
	float srcy = sr*cy;
	float srsy = sr*sy;
	matrix[0][1] = sp*srcy-crsy;
	matrix[1][1] = sp*srsy+crcy;
	matrix[2][1] = sr*cp;

	matrix[0][2] = (sp*crcy+srsy);
	matrix[1][2] = (sp*crsy-srcy);
	matrix[2][2] = cr*cp;

	matrix[0][3] = 0.0;
	matrix[1][3] = 0.0;
	matrix[2][3] = 0.0;
}


// https://www.unknowncheats.me/forum/counterstrike-global-offensive/248930-multiplymatrix-function.html
stock void ConcatTransforms(const float in1[3][4], const float in2[3][4], float out[3][4])
{
	// if (&in1 == &out)
	// {
		// matrix3x4_t in1b;
		// MatrixCopy(in1, in1b);
		// ConcatTransforms(in1b, in2, out);
		// return;
	// }
	// if (&in2 == &out)
	// {
		// matrix3x4_t in2b;
		// MatrixCopy(in2, in2b);
		// ConcatTransforms(in1, in2b, out);
		// return;
	// }
	out[0][0] = in1[0][0] * in2[0][0] + in1[0][1] * in2[1][0] +	in1[0][2] * in2[2][0];
	out[0][1] = in1[0][0] * in2[0][1] + in1[0][1] * in2[1][1] +	in1[0][2] * in2[2][1];
	out[0][2] = in1[0][0] * in2[0][2] + in1[0][1] * in2[1][2] +	in1[0][2] * in2[2][2];
	out[0][3] = in1[0][0] * in2[0][3] + in1[0][1] * in2[1][3] +	in1[0][2] * in2[2][3] + in1[0][3];
	out[1][0] = in1[1][0] * in2[0][0] + in1[1][1] * in2[1][0] +	in1[1][2] * in2[2][0];
	out[1][1] = in1[1][0] * in2[0][1] + in1[1][1] * in2[1][1] +	in1[1][2] * in2[2][1];
	out[1][2] = in1[1][0] * in2[0][2] + in1[1][1] * in2[1][2] +	in1[1][2] * in2[2][2];
	out[1][3] = in1[1][0] * in2[0][3] + in1[1][1] * in2[1][3] +	in1[1][2] * in2[2][3] + in1[1][3];
	out[2][0] = in1[2][0] * in2[0][0] + in1[2][1] * in2[1][0] +	in1[2][2] * in2[2][0];
	out[2][1] = in1[2][0] * in2[0][1] + in1[2][1] * in2[1][1] +	in1[2][2] * in2[2][1];
	out[2][2] = in1[2][0] * in2[0][2] + in1[2][1] * in2[1][2] +	in1[2][2] * in2[2][2];
	out[2][3] = in1[2][0] * in2[0][3] + in1[2][1] * in2[1][3] +	in1[2][2] * in2[2][3] + in1[2][3];
}


stock void MatrixMultiply(const float in1[3][4], const float in2[3][4], float out[3][4])
{
	ConcatTransforms(in1, in2, out);
}


// transform a set of angles in the output space of parentMatrix to the input space
stock void TransformAnglesToLocalSpace( const float angles[3], const float parentMatrix[3][4], float out[3] )
{
	// matrix3x4_t angToWorld, worldToParent, localMatrix;
	float angToWorld[3][4];
	float worldToParent[3][4];
	float localMatrix[3][4];
	
	MatrixInvert( parentMatrix, worldToParent );
	AngleMatrix( angles, angToWorld );
	ConcatTransforms( worldToParent, angToWorld, localMatrix );
	
	// float out[3] = {0.0,0.0,0.0};
	MatrixAngles( localMatrix, out );
	
	// return out;
}


// transform a set of angles in the input space of parentMatrix to the output space
stock void TransformAnglesToWorldSpace( const float angles[3], const float parentMatrix[3][4], float out[3] )
{
	// matrix3x4_t angToParent, angToWorld;	
	float angToParent[3][4];
	float angToWorld[3][4];
	
	AngleMatrix( angles, angToParent );
	ConcatTransforms( parentMatrix, angToParent, angToWorld );
	
	// float out[3] = {0.0,0.0,0.0};
	MatrixAngles( angToWorld, out );
	
	// return out;
}


stock VectorsToAngles(const float fw[3], const float rg[3], const float up[3], float final[3])
{
	new Float:xyDist = SquareRoot( fw[0] * fw[0] + fw[1] * fw[1]);
	
	if (xyDist > 0.001)
	{
		final[0] = ArcTangent2( -fw[2], xyDist ) * 57.3
		final[1] = ArcTangent2( fw[1], fw[0] ) * 57.3
		final[2] = (ArcTangent2( rg[2], up[2] ) * 57.3) * -1
	}
	else
	{
		final[0] = ArcTangent2( -rg[0], rg[1] ) * 57.3
		final[1] = ArcTangent2( -fw[2], xyDist ) * 57.3
		final[2] = 0.0
	}
}


stock LTOW(const float localPos[3], const float localAngle[3], const float originPos[3], const float originAngle[3], float finalpos[3], float finalang[3])
{
	new Float:fw[3];
	new Float:rg[3];
	new Float:up[3];
	GetAngleVectors(originAngle, fw, rg, up);
	ScaleVector(rg, -1.0);
	
	new Float:fwLocal[3];
	new Float:rgLocal[3];
	new Float:upLocal[3];
	GetAngleVectors( localAngle, fwLocal, rgLocal, upLocal );
	
	new Float:muX[3];
	new Float:muY[3];
	new Float:muZ[3];	
	VecMulSingle(fw, localPos[0], muX);
	VecMulSingle(rg, localPos[1], muY);
	VecMulSingle(up, localPos[2], muZ);

	new Float:newOrigin[3];
	CopyVector(originPos, newOrigin);
	AddVectors(newOrigin, muX, newOrigin);
	AddVectors(newOrigin, muY, newOrigin);
	AddVectors(newOrigin, muZ, newOrigin);
	CopyVector(newOrigin, finalpos);
	
	float worldMatrix[3][4];
	AngleMatrix(originAngle, worldMatrix);
	TransformAnglesToWorldSpace(localAngle, worldMatrix, finalang);
}


stock WTOL(const float position[3], const float angle[3], const float newSystemOrigin[3], const float newSystemAngles[3], float finalpos[3], float finalang[3])
{
	new Float:fw[3];
	new Float:rg[3];
	new Float:up[3];
	GetAngleVectors( newSystemAngles, fw, rg, up );
	ScaleVector(rg, -1.0);
	
	new Float:v1[3];
	SubtractVectors( position, newSystemOrigin, v1 )
	
	new Float:f1 = GetVectorDotProduct(v1, fw);
	new Float:r1 = GetVectorDotProduct(v1, rg);
	new Float:u1 = GetVectorDotProduct(v1, up);
	
	finalpos[0] = f1;
	finalpos[1] = r1;
	finalpos[2] = u1;
	
	float localMatrix[3][4];
	AngleMatrix(newSystemAngles, localMatrix);
	TransformAnglesToLocalSpace(angle, localMatrix, finalang);
}


// assume in2 is a rotation and rotate the input vector
stock void VectorRotate_Matrix( const float in1[3], const float in2[3][4], float out[3] )
{
	// out[0] = DotProduct( in1, in2[0] );
	// out[1] = DotProduct( in1, in2[1] );
	// out[2] = DotProduct( in1, in2[2] );
	out[0] = -(in1[0]*in2[0][0] + in1[1]*in2[0][1] + in1[2]*in2[0][2]);
	out[1] = -(in1[0]*in2[1][0] + in1[1]*in2[1][1] + in1[2]*in2[1][2]);
	out[2] = -(in1[0]*in2[2][0] + in1[1]*in2[2][1] + in1[2]*in2[2][2]);	
}


// assume in2 is a rotation and rotate the input vector
stock void VectorRotate(const float in1[3], const float in2[3], float out[3] )
{
	float matRotate[3][4];
	AngleMatrix( in2, matRotate );
	VectorRotate_Matrix( in1, matRotate, out );
}

