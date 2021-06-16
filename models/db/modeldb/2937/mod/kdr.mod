TITLE Borg-Graham-like K-A channel
: INACTIVATING, M.Migliore, BJ, 1996
: Modified to be used with cvode M.Migliore 2001

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)

}

PARAMETER {
        dt (ms)
	v (mV)
        ek (mV)
	celsius 	(degC)
	gkdrbar=.003 (mho/cm2)
        vhalfn=-40   (mV)
        vhalfl=-60   (mV)
        a0l=0.001      (/ms)
        a0n=0.03      (/ms)
        zetan=-5    (1)
        zetal=2    (1)
        gmn=0.7   (1)
        gml=1.0   (1)
	nmax=0.3  (1)
}


NEURON {
	SUFFIX borgkdr
	USEION k READ ek WRITE ik
        RANGE gkdr,gkdrbar
	GLOBAL ninf,linf,taun,taul
}

STATE {
	n
        l
}

ASSIGNED {
	ik (mA/cm2)
        ninf
        linf      
        gkdr
        taun
        taul
}

INITIAL {
        rates(v)
        n=ninf
        l=linf

}
BREAKPOINT {
	SOLVE states METHOD cnexp
	gkdr = gkdrbar*n^3*l
	ik = gkdr*(v-ek)

}

FUNCTION alpn(v(mV)) {
  alpn = exp(1.e-3*zetan*(v-vhalfn)*9.648e4/(8.315*(273.16+celsius))) 
}

FUNCTION betn(v(mV)) {
  betn = exp(1.e-3*zetan*gmn*(v-vhalfn)*9.648e4/(8.315*(273.16+celsius))) 
}

FUNCTION alpl(v(mV)) {
  alpl = exp(1.e-3*zetal*(v-vhalfl)*9.648e4/(8.315*(273.16+celsius))) 
}

FUNCTION betl(v(mV)) {
  betl = exp(1.e-3*zetal*gml*(v-vhalfl)*9.648e4/(8.315*(273.16+celsius))) 
}

DERIVATIVE states {  
        rates(v)
        n' = (ninf - n)/taun
        l' = (linf - l)/taul
}

PROCEDURE rates(v (mV)) { :callable from hoc
        LOCAL a,q10
        q10=3^((celsius-30)/10)
        a = alpn(v)
        ninf = 1/(1+a)
        taun = betn(v)/(q10*a0n*(1+a))
	if (taun<nmax) {taun=nmax}
        a = alpl(v)
        linf = 1/(1+a)
        taul = betl(v)/(q10*a0l*(1 + a))
}














