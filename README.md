Advanced Machine Learning Project - COMS 4772, Spring 2014, Columbia University
===============================================================================

Hosted on: https://github.com/dkdfirefly/aml

Team Members
============

Dhaivat Deepak Shah (ds3267)
Gaurav Ahuja (ga2371)
Sarah Panda (sp3206)

Presentation: Ahuja,Shah,Panda.pptx
------------

Paper: paper/AML.pdf 
-----

L1 Sovlers
==========

1. FISTA: l1Solvers/SolveFISTA.m
2. OMP: l1Solvers/SolveOMP
3. Dual Augmented Lagrange Method: l1Solvers/SolveDALM.m
4. Truncated Newton Interior-Point Method: l1Solvers/SolveL1LS.m
5. Primal Augmented Lagrange Method: l1Solvers/SolvePALM.m
6. Matching Pursuit: l1Solvers/SolveMP.m
7. Feature Sign: l1Solvers/l1ls_featuresign.m

Build Dependencies
==================

cd private
matlab -nodesktop -nosplash -r 'make'
cd ..

Running
=======

In ksvddenoisedemo.m line 44
Set params.method = 'Method Name';
Default Value: params.method = 'MP';

In ksvd.m line 615
Set Gamma = [Gamma FunctionName(D, data(:,i))];
Default Value: Gamma = [Gamma SolveMP(D, data(:,i))];

FuncitonName can be 
1. SolveFISTA
2. SolveOMP
3. SolveDALM
4. SolveL1LS
5. SolvePALM
6. SolveMP
7. l1ls_featuresign

To Run: matlab -nosplash -nodesktop -r 'ksvddenoisedemo'



