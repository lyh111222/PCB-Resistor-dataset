#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>


#ifndef max
#define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifndef min
#define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
#endif

// Evaluate configs with NCC!!
void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    // parameters
    int h1, w1, h2, w2;
    int r1x, r1y, r2x, r2y;
    
    int numPoints, numConfigs;
    double a11, a12, a13, a21, a22, a23;
    
    // input variables
    double *img1, *img2;
    double *configs;
    int *xs, *ys;
    
    // Should we use photometrics? 
	// No in NCC!
	int usePhotometrics = 0;
    
    // helper variables
    int *xs_centered, *ys_centered;
    double *valsI1;
    int targetPoint_x, targetPoint_y;
    int targetInd;
    double score;
    int maxInd2img2;
    
    double sigX;
    double sigY;
    double meanX;
    double meanY;

	// �ȶ�ÿ��ͨ������NCC�÷֣����ƽ��ÿ��ͨ��
	double* vecMeanX;
	double* vecMeanY;
	double* vecSigX;
	double* vecSigY;
	double* vecScore;
    
    // output variables
    double *distances;
    
    
    //// checking inputs
    //if (nrhs != 5)
    //	mexErrMsgTxt("The number of input arguments must be 5.");
    //if (nlhs != 1)
    //	mexErrMsgTxt("The number of output arguments must be 5.");
    
    
    // inputs:     dimensions
    // ------	    -----------
    // image I1     h1 x w1
    // image I2     h2 x w2
    // configs      numConfigs x 6
    // xs           1 x numPoints
    // ys1			1 x numPoints
    
    // outputs:     dimensions
    // -------	    -----------
    // distances    1 x numConfigs
    
    
    /* Find the dimensions of the data */
//    h1 = mxGetN(prhs[0]);
//    w1 = mxGetM(prhs[0]);
//    h2 = mxGetN(prhs[1]);
//    w2 = mxGetM(prhs[1]);
    h1 = mxGetDimensions(prhs[0])[2];
    w1 = mxGetDimensions(prhs[0])[1];
    h2 = mxGetDimensions(prhs[1])[2];
    w2 = mxGetDimensions(prhs[1])[1];
	int vecLen = mxGetDimensions(prhs[1])[0];

    numConfigs = mxGetN(prhs[2]);
    numPoints = mxGetN(prhs[3]);
    
    r1x = 0.5*(w1-1);
    r1y = 0.5*(h1-1);
    r2x = 0.5*(w2-1);
    r2y = 0.5*(h2-1);
    
    maxInd2img2 = h2*w2 - 1;
    
    
    /* Create an mxArray for the output data */
    plhs[0] = mxCreateDoubleMatrix(1, numConfigs, mxREAL );
    
    /* Create an mxArrays for temporary data */
    xs_centered = (int *)malloc(numPoints*sizeof(int));
    ys_centered = (int *)malloc(numPoints*sizeof(int));
    valsI1 = (double *)malloc(numPoints*vecLen*sizeof(double));
    
    /* Store target pixel locations - x and y */
    double* xs_target = (double *)malloc(numPoints*sizeof(double));
    double* ys_target = (double *)malloc(numPoints*sizeof(double));
    
	// ����vecMean��vecSig�ռ�
	vecMeanX = (double*)malloc(vecLen * sizeof(double));
	vecMeanY = (double*)malloc(vecLen * sizeof(double));
	vecSigX = (double*)malloc(vecLen * sizeof(double));
	vecSigY = (double*)malloc(vecLen * sizeof(double));
	vecScore = (double*)malloc(vecLen * sizeof(double));

    /* Retrieve the input data */
    img1 = mxGetPr(prhs[0]);
    double* tmp_img2 = mxGetPr(prhs[1]);
    configs = mxGetPr(prhs[2]);
    xs = (int*)mxGetPr(prhs[3]);
    ys = (int*)mxGetPr(prhs[4]);
    usePhotometrics = mxGetScalar(prhs[5]);
	assert(usePhotometrics == 0); //Don't use photometrics! NCC already handles it
    // img2 is of height 3*img2 (this padding is for not needing to check bounds)
	img2 = (double*)malloc(5 * h2*w2*vecLen * sizeof(double));
	memset(img2, 2, 5 * h2*w2*vecLen * sizeof(double));
	memcpy(img2 + 2 * h2*w2*vecLen, tmp_img2, h2*w2*vecLen * sizeof(double));
    
    
    int cN = mxGetN(prhs[2]);
    int cM = mxGetM(prhs[2]);
    
    
    /*Centered pointes*/
    for (int i = 0 ; i < numPoints ; i++) {
        xs_centered[i] = xs[i]-(r1x+1);
        ys_centered[i] = ys[i]-(r1y+1);
    }
    
    /*Precalculating source point indices into I1 (and the values themselves)*/

    for (int j = 0; j < numPoints ; j++) {
		for (int k = 0; k < vecLen ; k++)
			valsI1[j*vecLen+k] = img1[k + vecLen*((ys[j] - 1)*w1 + xs[j]-1)]; // -1 is for c		
    }
    
    
    /* Create a pointer to the output data */
    distances = mxGetPr(plhs[0]);

// plhs[1] = mxCreateDoubleMatrix(1, numConfigs, mxREAL);
// plhs[2] = mxCreateDoubleMatrix(1, numConfigs, mxREAL);
// plhs[3] = mxCreateDoubleMatrix(1, numConfigs, mxREAL);
// plhs[4] = mxCreateDoubleMatrix(1, numConfigs, mxREAL);
// double* outMeanX = mxGetPr(plhs[1]);
// double* outMeanY = mxGetPr(plhs[2]);
// double* outSigX = mxGetPr(plhs[3]);
// double* outSigY = mxGetPr(plhs[4]);

        
    // MAIN LOOP
    
    for (int i = 0 ; i < numConfigs ; i++) {
        
        if (i%100000==0)
            mexPrintf("MAIN LOOP: config %d out of %d\n", i+1, numConfigs);
        
        a11 = configs[6*i];
        a12 = configs[6*i+1];
        a13 = configs[6*i+2];
        a21 = configs[6*i+3];
        a22 = configs[6*i+4];
        a23 = configs[6*i+5];
        
        
        double score = 0;
        
        double tmp1 = (r2x+1) + a13 + 0.5;
        double tmp2 = (r2y+1) + a23 + 0.5 + 2*h2;
        double* ptrVals = valsI1;
        int* ptrXsc = xs_centered;
        int* ptrYsc = ys_centered;

		//����
		for (int k = 0; k < vecLen; k++) {
			vecMeanX[k] = 0;
			vecMeanY[k] = 0;
			vecScore[k] = 0;
			vecSigX[k] = 0;
			vecSigY[k] = 0;
		}

		// �ȼ���Mean��Sig
		for (int j = 0; j < numPoints; j++) {
			targetPoint_x = int(a11*(*ptrXsc) + a12*(*ptrYsc) + tmp1); // includes rounding
			targetPoint_y = int(a21*(*ptrXsc) + a22*(*ptrYsc) + tmp2); // includes rounding

			int baseInd = vecLen*((targetPoint_y - 1)*w2 + targetPoint_x - 1);
			for (int k = 0; k < vecLen; k++) {
				targetInd = baseInd + k; // -1 is for c
				vecMeanX[k] += *ptrVals;
				vecSigX[k] += (*ptrVals)*(*ptrVals);
				vecMeanY[k] += img2[targetInd];
				vecSigY[k] += img2[targetInd] * img2[targetInd];

				ptrVals++;
			}

			ptrXsc++;
			ptrYsc++;
		}
		for (int k = 0; k < vecLen; k++) {
			vecMeanX[k] /= numPoints;
			vecMeanY[k] /= numPoints;
			vecSigX[k] = sqrt(vecSigX[k] / numPoints - vecMeanX[k] * vecMeanX[k]); //E(X^2) - E^2(X)
			vecSigY[k] = sqrt(vecSigY[k] / numPoints - vecMeanY[k] * vecMeanY[k]);
		}

		if (i % 100000 == 0) {
			printf("means[0]: %.4f, %.4f\n", vecMeanX[0], vecMeanY[0]);
			printf("stds[0]: %.4f, %.4f\n", vecSigX[0], vecSigY[0]);
		}
		// ָ�븴λ������NCC�÷�
		ptrVals = valsI1;
		ptrXsc = xs_centered;
		ptrYsc = ys_centered;
		double xval = 0, yval = 0;
		if (!usePhotometrics){
			for (int j = 0; j < numPoints; j++) {
				targetPoint_x = int(a11*(*ptrXsc) + a12*(*ptrYsc) + tmp1); // includes rounding
				targetPoint_y = int(a21*(*ptrXsc) + a22*(*ptrYsc) + tmp2); // includes rounding

				int baseInd = vecLen*((targetPoint_y - 1)*w2 + targetPoint_x - 1);
				for (int k = 0; k < vecLen; k++) {
					xval = *ptrVals;
					yval = img2[targetInd];
					targetInd = baseInd + k; // -1 is for c
					vecScore[k] += yval * (xval - vecMeanX[k]);

					ptrVals++;
				}

				ptrXsc++;
				ptrYsc++;
			}
			for (int k = 0; k < vecLen; k++) {
				vecScore[k] /= numPoints * (vecSigX[k] * vecSigY[k] + 1e-7);
				score += vecScore[k];
			}
			if (i % 100000 == 0) {
				printf("scores[0:2]: %.4f, %.4f, %.4f\n", vecScore[0], vecScore[1], vecScore[2]);
			}
			score /= vecLen;
		}

		distances[i] = (1 - score) / 2;
	}
    
    /* Free the allocated arrays */
    free(xs_centered);
    free(ys_centered);
    free(valsI1);
    free(img2);
    
}