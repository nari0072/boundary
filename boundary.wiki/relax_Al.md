# pure Al
potcar_paw_pbe

32原子のpure Alのrelaxさせた値は
```
-0.119664039852E+03 eV/32atoms
```
したがって，1原子に換算すると
```
-3.739501247 eV/atom
```
となる．

```
       N       E                     dE             d eps       ncg     rms          rms(c)
RMM:   1     0.256104069448E+03    0.25610E+03   -0.16703E+04  1440   0.564E+02
RMM:   2    -0.365839177351E+02   -0.29269E+03   -0.28077E+03  1440   0.117E+02
RMM:   3    -0.996570960751E+02   -0.63073E+02   -0.61451E+02  1440   0.380E+01
RMM:   4    -0.113597800455E+03   -0.13941E+02   -0.12433E+02  1440   0.204E+01
RMM:   5    -0.118124048579E+03   -0.45262E+01   -0.34061E+01  1440   0.976E+00
RMM:   6    -0.119620213886E+03   -0.14962E+01   -0.11279E+01  1440   0.512E+00
RMM:   7    -0.120122960396E+03   -0.50275E+00   -0.39158E+00  1440   0.270E+00
RMM:   8    -0.120298133174E+03   -0.17517E+00   -0.14310E+00  1440   0.146E+00
RMM:   9    -0.120373505499E+03   -0.75372E-01   -0.66592E-01  2906   0.785E-01
RMM:  10    -0.120390443726E+03   -0.16938E-01   -0.14120E-01  2775   0.210E-01
RMM:  11    -0.120391312691E+03   -0.86896E-03   -0.35629E-03  2291   0.323E-02
RMM:  12    -0.120391321173E+03   -0.84825E-05   -0.44654E-05  1849   0.677E-03    0.529E+00
RMM:  13    -0.119972224092E+03    0.41910E+00   -0.45885E-02  2880   0.603E-01    0.329E+00
RMM:  14    -0.119663767492E+03    0.30846E+00   -0.15076E-01  2880   0.102E+00    0.138E-01
RMM:  15    -0.119664026645E+03   -0.25915E-03   -0.19323E-03  2880   0.137E-01    0.346E-02
RMM:  16    -0.119664043547E+03   -0.16902E-04   -0.37553E-05  2201   0.167E-02    0.523E-03
RMM:  17    -0.119664039863E+03    0.36845E-05   -0.57246E-06  1794   0.897E-03
   1 F= -.11966404E+03 E0= -.11965530E+03  d E =-.119664E+03
 curvature:   0.00 expect dE= 0.000E+00 dE for cont linesearch  0.000E+00
 trial: gam= 0.00000 g(F)=  0.409E-60 g(S)=  0.646E-03 ort = 0.000E+00 (trialstep = 0.100E+01)
 search vector abs. value=  0.646E-03
 reached required accuracy - stopping structural energy minimisation
```
となって，fullrelaxが終了している．

つぎに，外部緩和と内部緩和の違いについてチェックしてみる．

# 外部緩和と内部緩和
[vasp manual](http://cms.mpi.univie.ac.at/vasp/vasp/ISIF_tag.html)によると，
ISIF-tagを使ってstress tensor計算をcontrollするようにしている．forceは常に計算される．

## ISIF

|ISIF	|calculate	|calculate	|relax	|change	|change|
|:----|:----|:----|:----|:----|:----|:----|
| 	|force	|stress |tensor	|ions	|cell shape	|cell volume|
|0|yes|no|yes|no|no|
|1|yes|trace only*|yes|no|no|
|2|yes|yes|yes|no|no|
|3|yes|yes|yes|yes|yes|
|4|yes|yes|yes|yes|no|
|5|yes|yes|no|yes|no|
|6|yes|yes|no|yes|yes|
|7|yes|yes|no|no|yes|


体積変化させる場合は，
```
In general volume changes should be done
only with a slightly increased energy cutoff
(i.e. ENCUT=1.3 * default value , or PREC=High in VASP.4.4).
```
とするように指示されている．

[FAQ: Why is my energy vs. volume plot jagged](http://cms.mpi.univie.ac.at/vasp/vasp/FAQ_Why_is_my_energy_vs_volume_plot_jagged.html)というのもあるので，PREC=Highを推奨．

## IBRION
<dl>
<dt>IBRION=0</dt><dd> a molecular dynamics is performed, whereas all other algorithms are destined for relaxations into a local energy minimum. </dd>
<dt>IBRION=1</dt><dd> Close to the local minimum the RMM-DIIS (IBRION=1) is usually the best choice.</dd>
<dt>IBRION=2</dt><dd>For difficult relaxation problems it is recommended to use the conjugate gradient algorithm (IBRION=2), which presently possesses the most reliable backup routines. </dd>
<dt>IBRION=3</dt><dd>Damped molecular dynamics (IBRION=3) are often useful when starting from very bad initial guesses. </dd>
</dl>

[IBRION some general comments (ISIF, POTIM)](http://cms.mpi.univie.ac.at/vasp/vasp/IBRION_some_general_comments_ISIF_POTIM.html)は重要なparameter設定についてのコメント．

まだ，POSCARで固定する方法は見当たらん．

selective dynamicsでやるんやろな．
外部緩和はrubyによる手動みたいやな．．．
/home/yosuke/testTi
に痕跡発見．

[東北大の誰か](http://www.aki.che.tohoku.ac.jp/~miyatani/vasp.html)のサイトにkeyが詰まっている．

# 竹國宏紀のSiCの表面緩和計算
## POSCAR
```
4H-SiC
      1.00000000000000
   3.0935700000000000    0.0000000000000000     0.0000000000000000
  -1.5467850000000000    2.6791102083854259     0.0000000000000000
   0.0000000000000000    0.0000000000000000    10.1287000000000000
  4 4
Selective dynamics 
Direct
  0.0000000000000000 0.0000000000000000 0.0000000000000000 F F F
  0.0000000000000000 0.0000000000000000 0.5000000000000000 F F F
  0.3333333333333333 0.6666666666666667 0.2500000000000000 F F T
  0.6666666666666667 0.3333333333333333 0.7500000000000000 F F F
  0.0000000000000000 0.0000000000000000 0.1874200000000000 F F F
  0.0000000000000000 0.0000000000000000 0.6874200000000000 F F F
  0.3333333333333333 0.6666666666666667 0.4374200000000000 F F F
  0.6666666666666667 0.3333333333333333 0.9374200000000000 F F F
```

## INCAR  
```
# SCF input for VASP
# Note that VASP uses the FIRST occurence of a keyword
  SYSTEM = Diamond-Si_unitcell_fix_toga
    PREC = Accurate
   ENCUT = 1000
  IBRION = 2
     NSW = 100
    ISIF = 3
    ALGO = Normal (blocked Davidson)
    NELM = 60
  NELMIN = 2
   EDIFF = 1.0e-05
  EDIFFG = -0.01
 VOSKOWN = 1
  NBLOCK = 1
   ISPIN = 1
  INIWAV = 1
  ISTART = 0
  ICHARG = 2
   LWAVE = .FALSE.
  LCHARG = .FALSE.
 ADDGRID = .FALSE.
  ISMEAR = 1
   SIGMA = 0.2
   LREAL = .FALSE.
   RWIGS = 1.11
```

## C. POSCAR
以下の記述は，[第一原理計算入門](http://www5.hp-ez.com/hp/calculations/page99)にある．

- MDでの構造最適化を行う場合に、動かしたい原子に対して、T T Tを記述する（Tは動かす。Fは動かさない）。例えば下記のようになる（Directの次の行から座標と緩和の有無が記述される）。

```
Selective dynamics
Cartesian
  0.5000 0.5000 0.5000 T T T
```

もし、Selective dynamics がなければ、T T T の記述が無視されて、全て T になる。If the line ’Selective dynamics’ is removed from the file POSCAR these flag will be ignored (and internally set to .T.).

## 山本のINCAR full desc version
```
# SCF input for VASP# Note that VASP uses the FIRST occurence of a keyword
 
   SYSTEM = yosuke_model
     PREC = Accurate
    ENCUT = 350
# Relax
  #IBRION = -1              #Fix ions
  #IBRION = 0               #Relax ions with molecular dynamics
  #IBRION = 1               #Relax ions with quasi-Newton
   IBRION = 2               #Relax ions with conjugate-gradient
  #IBRION = 3               #Relax ions with Steepest descent method
      NSW = 60              #The maximum number of ionic steps
    #ISIF = 0               #Relax ions
    #ISIF = 1               #Relax ions, calc stress(trace only)
    #ISIF = 2               #Relax ions, calc stress
     ISIF = 3               #Relax ions,shape,volume
    #ISIF = 4               #Relax ions,shape
    #ISIF = 5               #Relax shape
    #ISIF = 6               #Relax shape,volume
    #ISIF = 7               #Relax volume
     ALGO = V               #N(Normal):Davidson, F(Fast):Davidson(5 initial steps) & DIIS, V(Very Fast):DIIS
     NELM = 60              #The maximum number of electronic SC (selfconsistency) steps
   NELMIN = 12              #The minimum number of electronic SC (selfconsistency) steps
   NELMDL = -12             #number of non-selfconsistent steps at the beginning
    EDIFF = 1.0e-05         #Specifies the global break condition for the electronic SC-loop
   EDIFFG = -0.02           #Defines the break condition for the ionic relaxation loop

# Spin or magnetic
  VOSKOWN = 1               #This usually enhances the magnetic moments and the magnetic energies.
  #NBLOCK = 1
    ISPIN = 1
  #MAGMOM = 23*1 1*7        #Number of atoms x magnetic momet

# Cont
 #NUPDOWN = 7               #set this for the first runs(s) only, for the finals run(s) comment this out!!!!
   INIWAV = 1               #Fill wavefunction arrays with random numbers. Use whenever possible.
   ISTART = 0               #Don't read WAVCAR file, and set default
  #ISTART = 1               #Read WAVECAR file
  #ICHARG = 0               #Don't read CHGCAR file, and set charge density from default wave function
  #ICHARG = 1               #Read CHGCAR file
   ICHARG = 2               #Don't read CHGCAR file, and set charge density from super position
  #ICHARG = 11              #read CHGCAR file, all k-points can be treated independently to write accurate DOS
  #ICHARG = 12              #No charge update
    LWAVE = .FALSE.         #Whether wave function written in WAVECAR file or not. TRUE or FALSE
   LCHARG = .TRUE.          #Whether charge density written in CHGCAR file or not  TRUE or FALSE
  ADDGRID = .TRUE.

# DOS
   ISMEAR = 1               #For relaxations in metals always use ISMEAR=1 or ISMEAR=2
  #ISMEAR = -5              #For the calculations of the DOS and very accurate total energy calculations (no relaxation in metals)
   #SIGMA = 0.01            #Determines the width of the smearing in eV
    LREAL = Auto            #Projection done in reciprocal space
   #LREAL = .FALSE.
   #RWIGS = 1.524 1.482     #The Wigner Seitz radius is optional. Default value is written by POTCAR
  #NBANDS = 72
    #EMIN = -10             #Minimum energy for evaluation of DOS
    #EMAX = 10              #Maximum energy for evaluation of DOS
   #NEDOS = 901
    #NPAR = 1               #sqrt(number of nodes)
    #AMIX = 0.1
#AMIX_MAG = 0.5
    #AMIN = 0.1
 #LMAXMIX = 6
#AMIX_MAG = 0.2
    #BMIX = 0.01
#-----first-----
    #AMIX = 0.1
    #BMIX = 0.01
#----second-----
    #AMIX = 0.1
    #AMIN = 0.01
    #BMIX = 3.0             #increase
```
