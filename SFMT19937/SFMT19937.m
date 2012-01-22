#import "SFMT19937.h"

#define ARYSIZE(A) (sizeof(A) / sizeof(A[0]))


static SFMT19937 *_instance = nil;
static int x[624];
static int parity[] = {0x00000001, 0x00000000, 0x00000000, 0x13c9e684};


@interface SFMT19937(Private)

- (void) initMtEx:(int *)init_key: keySize:(int)size;

@end


@implementation SFMT19937

+ (SFMT19937 *) instance {
    if (!_instance) {
        int ts = (int)[[NSDate date] timeIntervalSince1970];
        _instance = [[SFMT19937 alloc] initWithS:ts];
    }
    return _instance;
}

- (NSString *) getSymbol {
    return @"SFMT-19937:122-18-1-11-1:dfffffef-ddfecb7f-bffaffff-bffffff6";
}

- (const int *) getParity {
    return parity;
}

- (void) genRandomAll {
    int a = 0, b = 488, c = 616, d = 620, y;
    int *p = x;
    
    do {
        y = p[a + 3] ^ (p[a + 3] << 8) ^ (p[a + 2] >> 24) ^ ((p[b + 3] >> 11) & 0xbffffff6);
        p[a + 3] = y ^ (p[c + 3] >> 8) ^ (p[d + 3] << 18);
        y = p[a + 2] ^ (p[a + 2] << 8) ^ (p[a + 1] >> 24) ^ ((p[b + 2] >> 11) & 0xbffaffff);
        p[a + 2] = y ^ ((p[c + 2] >> 8) | (p[c + 3] << 24)) ^ (p[d + 2] << 18);
        y = p[a + 1] ^ (p[a + 1] << 8) ^ (p[a] >> 24) ^ ((p[b + 1] >> 11) & 0xddfecb7f);
        p[a + 1] = y ^ ((p[c + 1] >> 8) | (p[c + 2] << 24)) ^ (p[d + 1] << 18);
        y = p[a] ^ (p[a] << 8) ^ ((p[b] >> 11) & 0xdfffffef);
        p[a] = y ^ ((p[c] >> 8) | (p[c + 1] << 24)) ^ (p[d] << 18);
        c = d;
        d = a;
        a += 4;
        b += 4;
        if (b == 624) {
            b = 0;
        }
    }
    while (a != 624);
}

- (void) periodCertification {
    int work, inner = 0;
    int i, j;
    index = 624;
    range = 0;
    normalSw = 0;
    coinBits = 0;
    bytePos = 0;
    
    for (i = 0; i < 4; i++) {
        inner ^= x[i] & parity[i];
    }
    
    
    for (i = 16; i > 0; i >>= 1) {
        inner ^= inner >> i;
    }
    
    inner &= 1;
    if (inner == 1) {
        return;
    }
    
    for (i = 0; i < 4; i++) {
        
        for (j = 0, work = 1; j < 32; j++, work <<= 1) {
            if ((work & parity[i]) != 0) {
                x[i] ^= work;
                return;
            }
        }
        
    }
    
}

- (void) initMt:(int)s {
    x[0] = s;
    
    for (int p = 1; p < 624; p++) {
        x[p] = s = 1812433253 * (s ^ (s >> 30)) + p;
    }
    
    [self periodCertification];
}

- (id) initWithS:(int)s {
    if (self = [super init]) {
        bzero(x, sizeof(x));
        [self initMt:s];
    }
    return self;
}

- (void) initMtEx:(int *)init_key keySize:(int)size; {
    int r, i, j, c, key_len = size;
    
    for (i = 0; i < 624; i++) {
        x[i] = 0x8b8b8b8b;
    }
    
    if (key_len + 1 > 624) {
        c = key_len + 1;
    }
    else {
        c = 624;
    }
    r = x[0] ^ x[306] ^ x[623];
    r = (r ^ (r >> 27)) * 1664525;
    x[306] += r;
    r += key_len;
    x[317] += r;
    x[0] = r;
    c--;
    
    for (i = 1, j = 0; j < c && j < key_len; j++) {
        r = x[i] ^ x[(i + 306) % 624] ^ x[(i + 623) % 624];
        r = (r ^ (r >> 27)) * 1664525;
        x[(i + 306) % 624] += r;
        r += init_key[j] + i;
        x[(i + 317) % 624] += r;
        x[i] = r;
        i = (i + 1) % 624;
    }
    
    
    for (; j < c; j++) {
        r = x[i] ^ x[(i + 306) % 624] ^ x[(i + 623) % 624];
        r = (r ^ (r >> 27)) * 1664525;
        x[(i + 306) % 624] += r;
        r += i;
        x[(i + 317) % 624] += r;
        x[i] = r;
        i = (i + 1) % 624;
    }
    
    
    for (j = 0; j < 624; j++) {
        r = x[i] + x[(i + 306) % 624] + x[(i + 623) % 624];
        r = (r ^ (r >> 27)) * 1566083941;
        x[(i + 306) % 624] ^= r;
        r -= i;
        x[(i + 317) % 624] ^= r;
        x[i] = r;
        i = (i + 1) % 624;
    }
    
    [self periodCertification];
}

- (id) initWithInitKey:(int *)initKey keySize:(int)size; {
    if (self = [super init]) {
        bzero(x, sizeof(x));
        [self initMtEx:initKey keySize:size];
    }
    return self;
}

- (int) nextMt {
    if (index == 624) {
        [self genRandomAll];
        index = 0;
    }
    return x[index++];
}

- (int) nextInt:(int)n {
    double z = [self nextMt];
    if (z < 0) {
        z += 4294967296.0;
    }
    return (int)(n * (1.0 / 4294967296.0) * z);
}

- (double) nextUnif {
    double z = [self nextMt] >> 11, y = [self nextMt];
    if (y < 0) {
        y += 4294967296.0;
    }
    return (y * 2097152.0 + z) * (1.0 / 9007199254740992.0);
}

- (int) nextBit {
    if (--coinBits == -1) {
        coinBits = 31;
        return (coinSave = [self nextMt]) & 1;
    } else {
        return (coinSave >>= 1) & 1;
    }
}

- (int) nextByte {
    if (--bytePos == -1) {
        bytePos = 3;
        return (int)(byteSave = [self nextMt]) & 255;
    } else {
        return (int)(byteSave >>= 8) & 255;
    }
}

- (int) nextIntEx:(int)range_ {
    int y_, base_, remain_;
    int shift_;
    if (range_ <= 0) {
        return 0;
    }
    if (range_ != range) {
        base = (range = range_);
        
        for (shift = 0; base <= (1 << 30) && base != 1 << 31; shift++) {
            base <<= 1;
        }
        
    }
    
    while (YES) {
        y_ = [self nextMt] >> 1;
        if (y_ < base || base == 1 << 31) {
            return (int)(y_ >> shift);
        }
        base_ = base;
        shift_ = shift;
        y_ -= base_;
        remain_ = (1 << 31) - base_;
        
        for (; remain_ >= (int)range_; remain_ -= base_) {
            
            for (; base_ > remain_; base_ >>= 1) {
                shift_--;
            }
            
            if (y_ < base_) {
                return (int)(y_ >> shift_);
            } else {
                y_ -= base_;
            }
        }
        
    }
    
}

- (double) nextChisq:(double)n {
    return 2 * [self nextGamma:0.5 * n];
}

- (double) nextGamma:(double)a {
    double t, u, X, y;
    if (a > 1) {
        t = sqrt(2 * a - 1);
        
        do {
            do {
                do {
                    X = 1 - [self nextUnif];
                    y = 2 * [self nextUnif] - 1;
                } while (X * X + y * y > 1);
                y /= X;
                X = t * y + a - 1;
            } while (X <= 0);
            u = (a - 1) * log(X / (a - 1)) - t * y;
        } while (u < -50 || [self nextUnif] > (1 + y * y) * exp(u));
    } else {
        t = 2.718281828459045235 / (a + 2.718281828459045235);
        
        do {
            if ([self nextUnif] < t) {
                X = pow([self nextUnif], 1 / a);
                y = exp(-X);
            } else {
                X = 1 - log(1 - [self nextUnif]);
                y = pow(X, a - 1);
            }
        } while ([self nextUnif] >= y);
    }
    return X;
}

- (int) nextGeometric:(double)p {
    return (int)ceil(log(1.0 - [self nextUnif] / log(1 - p)));
}

- (double) nextTriangle {
    double a = [self nextUnif], b = [self nextUnif];
    return a - b;
}

- (double) nextExp {
    return -(log(1 - [self nextUnif]));
}

- (double) nextNormal {
    if (normalSw == 0) {
        double t = sqrt(-2 * log(1.0 - [self nextUnif]));
        double u = 3.141592653589793 * 2 * [self nextUnif];
        normalSave = t * sin(u);
        normalSw = 1;
        return t * cos(u);
    } else {
        normalSw = 0;
        return normalSave;
    }
}

- (double *) nextUnitVect:(int)n vect:(double *)v {
    int i;
    double r = 0;
    
    for (i = 0; i < n; i++) {
        v[i] = [self nextNormal];
        r += v[i] * v[i];
    }
    
    if (r == 0.0) {
        r = 1.0;
    }
    r = sqrt(r);
    
    for (i = 0; i < n; i++) {
        v[i] /= r;
    }
    
    return v;
}

- (int) nextBinomial:(int)n p:(double)p {
    int i, r = 0;
    
    for (i = 0; i < n; i++) {
        if ([self nextUnif] < p) {
            r++;
        }
    }
    
    return r;
}

- (double *) nextBinormal:(double)r vect:(double *)v {
    double r1, r2, s;
    
    do {
        r1 = 2 * [self nextUnif] - 1;
        r2 = 2 * [self nextUnif] - 1;
        s = r1 * r1 + r2 * r2;
    } while (s > 1 || s == 0);
    s = -(log(s)) / s;
    r1 = sqrt((1 + r) * s) * r1;
    r2 = sqrt((1 - r) * s) * r2;
    v[0] = r1 + r2;
    v[1] = r1 - r2;
    return v;
}

- (double) nextBeta:(double)a b:(double)b {
    double temp = [self nextGamma:a];
    return temp / (temp + [self nextGamma:b]);
}

- (double) nextPower:(double)n {
    return pow([self nextUnif], 1.0 / (n + 1));
}

- (double) nextLogistic {
    double r;
    
    do {
        r = [self nextUnif];
    } while (r == 0);
    return log(r / (1 - r));
}

- (double) nextCauchy {
    double z, y;
    
    do {
        z = 1 - [self nextUnif];
        y = 2 * [self nextUnif] - 1;
    } while (z * z + y * y > 1);
    return y / z;
}

- (double) nextFDist:(double)n1 n2:(double)n2 {
    double nc1 = [self nextChisq:n1], nc2 = [self nextChisq:n2];
    return (nc1 * n2) / (nc2 * n1);
}

- (int) nextPoisson:(double)lambda {
    int k;
    lambda = exp(lambda) * [self nextUnif];
    
    for (k = 0; lambda > 1; k++) {
        lambda *= [self nextUnif];
    }
    
    return k;
}

- (double) nextTDist:(double)n {
    double a, b, c;
    if (n <= 2) {
        
        do {
            a = [self nextChisq:n];
        } while (a == 0);
        return [self nextNormal] / sqrt(a / n);
    }
    
    do {
        a = [self nextNormal];
        b = a * a / (n - 2);
        c = log(1 - [self nextUnif]) / (1 - 0.5 * n);
    } while (exp(-b - c) > 1 - b);
    return a / sqrt((1 - 2.0 / n) * (1 - b));
}

- (double) nextWeibull:(double)alpha {
    return pow(-log(1 - [self nextUnif]), 1 / alpha);
}

- (void) dealloc {
    
}

@end
