# ruby adjuster 
```
ruby adjuster
```
で起動．
```
  0.888889  0.914846  0.250000      162.7128     -183.5608       -0.0000 -3.060281  25
  0.888889  0.914846  0.750000      181.4626     -176.9452       -0.0000 -3.060281  29
  0.555556  0.711547  0.750000     -321.2105     -165.0115       -0.0000 -3.050481  11
  0.444444  0.711547  0.250000      342.8841     -161.9153       -9.7912 -3.050481  10
  0.055556  0.609897  0.500000     -344.8535      120.7856        9.7912 -3.036120  22
  16.70493 eV,    2.63371 J/m^2 (area:  50.81106 A^2)
Input [l]og, [q]uit or indexes of deleting atoms(87,12,...)] : q
"q"
#<MatchData "">
"quitting..."
:POSCAR_2223:  35.15646 eV,    5.54279 J/m^2 (area:  50.81106 A^2)
:13:  30.49895 eV,    4.80848 J/m^2 (area:  50.81106 A^2)
:10:  25.86568 eV,    4.07800 J/m^2 (area:  50.81106 A^2)
:17:  21.27658 eV,    3.35448 J/m^2 (area:  50.81106 A^2)
:23:  16.75310 eV,    2.64130 J/m^2 (area:  50.81106 A^2)
:17:  16.70493 eV,    2.63371 J/m^2 (area:  50.81106 A^2)
:q:
```
としている．

結果は
```
cat POSCAR_2223_4
```

```
(Al)4  (Fm-3m) 
1.000000
11.502026 0.000000 0.000000
0.000000 6.286319 0.000000
0.000000 0.000000 8.082800
31
Selective dynamics
Direct
  0.500000  0.000000  0.000000 T T T
  0.666667  0.101650  0.250000 T T T
中略
  0.111111  0.914846  0.750000 T T T
```