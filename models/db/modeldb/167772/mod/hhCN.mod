TITLE hh.mod   squid sodium, potassium, and leak channels
 
COMMENT
Stochastic Hodgkin and Huxley equations with colored noise (hhCN)
Equations as in Guler (2013) Neural Comp. 25:46-74
Implemented for Pezo, Soudry and Orio (2014) Front Comp Neurosci

ENDCOMMENT
 
UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
	(S) = (siemens)
}
 
NEURON {
	SUFFIX hhCN
	USEION na READ ena WRITE ina
	USEION k READ ek WRITE ik
	NONSPECIFIC_CURRENT il
	RANGE gnabar, gkbar, gl, el, NNa, NK, se, m, h, n, phiNa, phiK
}
 
PARAMETER {
    se = -1
	gnabar = .12 (S/cm2)	<0,1e9>
	gkbar = .036 (S/cm2)	<0,1e9>
	gl = .0003 (S/cm2)	<0,1e9>
	el = -54.3 (mV)
	NNa = 50000
	NK = 15000 
	tau = 1 (ms)
	gamK = 10
	wK2 = 150
	TK = 400
	gamNa = 10
	wNa2 = 200
	TNa = 800
}
 
ASSIGNED {
	v (mV)
	celsius (degC)
	ena (mV)
	ek (mV)
	dt (ms)
	ina (mA/cm2)
	ik (mA/cm2)
	il (mA/cm2)
	am	(/ms)
	ah	(/ms)
	an	(/ms)
	bm	(/ms)
	bh	(/ms)
	bn	(/ms)
	phiK
	phiNa
	xiK	(/ms)
	xiNa	(/ms)
}
 
STATE {	
	n
	m
	h
	qK
	pK
	qNa
	pNa
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	ina = gnabar*(m^3*h+phiNa)*(v - ena)
	ik = gkbar*(n^4+phiK)*(v - ek)
	il = gl*(v - el)
}
 
INITIAL {
	func(v)
    if (se>0) {set_seed(se)} 
    n=an/(an+bn)
	m=am/(am+bm)
	h=ah/(ah+bh)
	qK=0
	pK=0
	qNa=0
	pNa=0
}

DERIVATIVE states {  
	LOCAL flag, n0, m0, h0
	func(v)

	flag=0
	n0=n
    : If the variable leaves [0,1] then random numbers are drawn again
	while (flag==0) {
		n'=an*(1-n)-bn*n+etan(an,bn)
		if (n<0 || n>1) {
			n=n0
		} else {flag=1}
	}
	flag=0
	m0=m
	while (flag==0) {
		m'=am*(1-m)-bm*m+etam(am,bm)
		if (m<0 || m>1) {
			m=m0
		} else {flag=1}		
	}
	flag=0
	h0=h
	while (flag==0) {
		h'=ah*(1-h)-bh*h+etah(ah,bh)
		if (h<0 || h>1) {
			h=h0
		} else {flag=1}
	}

	qK'=pK/tau
	pK'=(-gamK*pK/tau-wK2*(an*(1-n)+bn*n)*qK)+xiK
	
	qNa'=pNa/tau
	pNa'=(-gamNa*pNa/tau-wNa2*(am*(1-m)+bm*m)*qNa)+xiNa
}

FUNCTION etan (an (/ms), bn (/ms)) (/ms) {
	UNITSOFF
	etan = normrand(0,1/sqrt(4*NK*dt))*sqrt(an*(1-n)+bn*n)
	UNITSON
}

FUNCTION etam (am (/ms), bm (/ms)) (/ms) {
	UNITSOFF
	etam = normrand(0,1/sqrt(3*NK*dt))*sqrt(am*(1-m)+bm*m)
	UNITSON
}

FUNCTION etah (ah (/ms), bh (/ms)) (/ms) {
	UNITSOFF
	etah = normrand(0,1/sqrt(NNa*dt))*sqrt(ah*(1-h)+bh*h)
	UNITSON
}

PROCEDURE func(v(mV)) {  :Computes rate and other constants at current v.
	LOCAL q10
	UNITSOFF
	am = 0.1*(v+40)/(1-exp(-(v+40)/10))
	bm = 4*exp(-(v+65)/18)
	ah = 0.07*exp(-(v+65)/20) 
	bh = 1/(1+exp(-(v+35)/10))
	an = 0.01*(v+55)/(1-exp(-(v+55)/10))
	bn = 0.125*exp(-(v+65)/80)

	xiK=normrand(0,1/sqrt(tau*dt))*sqrt(gamK*TK*(an*(1-n)+bn*n))
	xiNa=normrand(0,1/sqrt(tau*dt))*sqrt(gamNa*TNa*(am*(1-m)+bm*m))

	phiK=sqrt((n^4*(1-n^4))/NK)*qK
	phiNa=sqrt((m^3*(1-m^3))/NNa)*h*qNa
	UNITSON 
}