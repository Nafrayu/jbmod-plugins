#if defined _toScreen_included
	#endinput
#endif
#define _toScreen_included


 
//-----------------------------------------------------------------------------
// Purpose: Transforms a world-space position into a 2D position inside a supplied frustum.
//-----------------------------------------------------------------------------
stock int FrustumTransform( const float camerapos[3], const float cameraang[3], const float point[3], float screen[2] )
{
	float worldToCamera[4][4]; M_MatrixInit(worldToCamera);
	M_AngleMatrix(cameraang, camerapos, worldToCamera);
	
	float worldToSurface[4][4]; M_MatrixInit(worldToSurface);
	M_MatrixInvert(worldToCamera, worldToSurface);
	
	// float worldToSurface[4][4]; M_MatrixInit(worldToSurface);
	// M_AngleMatrix(cameraang, camerapos, worldToSurface);
		
	// PrintToServer("%f %f %f %f", worldToSurface[0][0], worldToSurface[0][1], worldToSurface[0][2], worldToSurface[0][3] );
	// PrintToServer("%f %f %f %f", worldToSurface[1][0], worldToSurface[1][1], worldToSurface[1][2], worldToSurface[1][3] );
	// PrintToServer("%f %f %f %f", worldToSurface[2][0], worldToSurface[2][1], worldToSurface[2][2], worldToSurface[2][3] );
	// PrintToServer("%f %f %f %f", worldToSurface[3][0], worldToSurface[3][1], worldToSurface[3][2], worldToSurface[3][3] );
	
	// UNDONE: Clean this up some, handle off-screen vertices
	float w;

	screen[0] = worldToSurface[0][0] * point[0] + worldToSurface[0][1] * point[1] + worldToSurface[0][2] * point[2] + worldToSurface[0][3];
	screen[1] = worldToSurface[1][0] * point[0] + worldToSurface[1][1] * point[1] + worldToSurface[1][2] * point[2] + worldToSurface[1][3];
	//	z     = worldToSurface[2][0] * point[0] + worldToSurface[2][1] * point[1] + worldToSurface[2][2] * point[2] + worldToSurface[2][3];
	w		  = worldToSurface[3][0] * point[0] + worldToSurface[3][1] * point[1] + worldToSurface[3][2] * point[2] + worldToSurface[3][3];

	// Just so we have something valid here
	// screen[2] = 0.0;

	// PrintToServer("screen %f %f", screen[0], screen[1]);

	bool behind;
	if( w < 0.001 )
	{
		behind = true;
		screen[0] = screen[0] * 100000.0;
		screen[1] = screen[1] * 100000.0;
	}
	else
	{
		behind = false;
		float invw = 1.0 / w;
		screen[0] *= invw;
		screen[1] *= invw;
	}

	return behind;
}



// https://www.scratchapixel.com/lessons/3d-basic-rendering/computing-pixel-coordinates-of-3d-point/mathematics-computing-2d-coordinates-of-3d-points

stock bool computePixelCoordinates( const float camerapos[3], const float cameraang[3], const float point[3], float screen[2] ) 
{

	// WTOL(const float position[3], const float angle[3], const float newSystemOrigin[3], const float newSystemAngles[3], float finalpos[3], float finalang[3])

	float finalpos[3];
	float finalang[3];
	WTOL(point, Float:{0.0,0.0,0.0}, camerapos, cameraang, finalpos, finalang);

	// Coordinates of the point on the canvas. Use perspective projection.

	screen[0] = (finalpos[1] / -finalpos[0]);
	screen[1] = (finalpos[2] / -finalpos[0]);
	screen[0] = (screen[0] + 2.0 / 2.0) / 2.0;
	screen[1] = (screen[1] + 2.0 / 2.0) / 2.0;

	if (finalpos[0] < 0.0
	|| screen[0] < 0.0 || screen[0] > 1.0 
	|| screen[1] < 0.0 || screen[1] > 1.0
	)
	{
		return false;
	}
	// if (FloatAbs(screen[0]) > 4.0 || FloatAbs(screen[1]) > 3.0)
	// {
		// return false; 
	// }
	return true; 
}


// https://www.scratchapixel.com/lessons/3d-basic-rendering/computing-pixel-coordinates-of-3d-point/mathematics-computing-2d-coordinates-of-3d-points
/*
bool computePixelCoordinates( 
    const Vec3f &pWorld, 
    const Matrix44f &cameraToWorld, 
    const float &canvasWidth, 
    const float &canvasHeight, 
    const int &imageWidth, 
    const int &imageHeight, 
    Vec2i &pRaster) 
{ 
    // First transform the 3D point from world space to camera space. 
    // It is of course inefficient to compute the inverse of the cameraToWorld
    // matrix in this function. It should be done outside the function, only once
    // and the worldToCamera should be passed to the function instead. 
    // We are only compute the inverse of this matrix in this function ...
	
     Vec3f pCamera;
     Matrix44f worldToCamera = cameraToWorld.inverse(); 
     worldToCamera.multVecMatrix(pWorld, pCamera); 
	 
     // Coordinates of the point on the canvas. Use perspective projection.
     Vec2f pScreen; 
     pScreen.x = pCamera.x / -pCamera.z; 
     pScreen.y = pCamera.y / -pCamera.z; 
	 
     // If the x- or y-coordinate absolute value is greater than the canvas width 
     // or height respectively, the point is not visible
     if (std::abs(pScreen.x) > canvasWidth || std::abs(pScreen.y) > canvasHeight) 
         return false; 
	 
     // Normalize. Coordinates will be in the range [0,1]
     Vec2f pNDC; 
     pNDC.x = (pScreen.x + canvasWidth / 2) / canvasWidth; 
     pNDC.y = (pScreen.y + canvasHeight / 2) / canvasHeight; 
	 
     // Finally convert to pixel coordinates. Don't forget to invert the y coordinate
     // pRaster.x = std::floor(pNDC.x * imageWidth); 
     // pRaster.y = std::floor((1 - pNDC.y) * imageHeight); 
 
     return true; 
}
*/