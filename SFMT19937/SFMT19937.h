#import <Foundation/Foundation.h>

//
//  SIMD-oriented Fast Mersenne Twister(SFMT)
//  http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/index.html
//
//  
//  Copyright (c) 2006,2007 Mutsuo Saito, Makoto Matsumoto and Hiroshima
//  University. All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//  
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above
//  copyright notice, this list of conditions and the following
//  disclaimer in the documentation and/or other materials provided
//  with the distribution.
//  * Neither the name of the Hiroshima University nor the names of
//  its contributors may be used to endorse or promote products
//  derived from this software without specific prior written
//  permission.
//  
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//                                                LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//                                                DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


@interface SFMT19937 : NSObject {
    int index;
    int coinBits;
    int coinSave;
    int bytePos;
    int byteSave;
    int range;
    int base;
    int shift;
    int normalSw;
    double normalSave;
}

+ (SFMT19937 *) instance;
- (NSString *) getSymbol;
- (const int *) getParity;
- (void) genRandomAll;
- (void) periodCertification;
- (id) initWithS:(int)s;
- (id) initWithInitKey:(int *)initKey keySize:(int)size;
- (int) nextMt;
- (int) nextInt:(int)n;
- (double) nextUnif;
- (int) nextBit;
- (int) nextByte;
- (int) nextIntEx:(int)range_;
- (double) nextChisq:(double)n;
- (double) nextGamma:(double)a;
- (int) nextGeometric:(double)p;
- (double) nextTriangle;
- (double) nextExp;
- (double) nextNormal;
- (double *) nextUnitVect:(int)n vect:(double *)v;
- (int) nextBinomial:(int)n p:(double)p;
- (double *) nextBinormal:(double)r vect:(double *)v;
- (double) nextBeta:(double)a b:(double)b;
- (double) nextPower:(double)n;
- (double) nextLogistic;
- (double) nextCauchy;
- (double) nextFDist:(double)n1 n2:(double)n2;
- (int) nextPoisson:(double)lambda;
- (double) nextTDist:(double)n;
- (double) nextWeibull:(double)alpha;

@end
