#!/usr/bin/env python
import shogun as sg
traindat = '../data/fm_train_real.dat'
testdat = '../data/fm_test_real.dat'

parameter_list=[[traindat,testdat, 1.0],[traindat,testdat, 5.0]]

def kernel_inversemultiquadric (train_fname=traindat,test_fname=testdat, shift_coef=1.0):
	from shogun import CSVFile

	feats_train=sg.create_features(CSVFile(train_fname))
	feats_test=sg.create_features(CSVFile(test_fname))

	distance = sg.create_distance('EuclideanDistance')
	kernel = sg.create_kernel('InverseMultiQuadricKernel', coef=shift_coef,
			   distance=distance)
	kernel.init(feats_train, feats_train)
	km_train=kernel.get_kernel_matrix()

	kernel.init(feats_train, feats_test)
	km_test=kernel.get_kernel_matrix()
	return km_train,km_test,kernel


if __name__=='__main__':
	print('InverseMultiquadric')
	kernel_inversemultiquadric(*parameter_list[0])
