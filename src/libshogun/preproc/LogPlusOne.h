/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 1999-2009 Soeren Sonnenburg
 * Copyright (C) 1999-2009 Fraunhofer Institute FIRST and Max-Planck-Society
 */

#ifndef _CLOGPLUSONE__H__
#define _CLOGPLUSONE__H__

#include "preproc/SimplePreProc.h"
#include "features/Features.h"
#include "lib/common.h"

#include <stdio.h>

namespace shogun
{
/** @brief Preprocessor LogPlusOne does what the name says, it adds one to a dense
 * real valued vector and takes the logarithm of each component of it.
 *
 * \f[
 * {\bf x}\leftarrow \log({\bf x}+{\bf 1})
 * \f]
 * It therefore does not need any initialization. It is most useful in
 * situations where the inputs are counts: When one compares differences of
 * small counts any difference may matter a lot, while small differences in
 * large counts don't. This is what this log transformation controls for.
 */
class CLogPlusOne : public CSimplePreProc<float64_t>
{
	public:
		/** default constructor */
		CLogPlusOne();
		virtual ~CLogPlusOne();

		/// initialize preprocessor from features
		virtual bool init(CFeatures* f);

		/// cleanup
		virtual void cleanup();
		/// initialize preprocessor from file
		virtual bool load(FILE* f);
		/// save preprocessor init-data to file
		virtual bool save(FILE* f);

		/// apply preproc on feature matrix
		/// result in feature matrix
		/// return pointer to feature_matrix, i.e. f->get_feature_matrix();
		virtual float64_t* apply_to_feature_matrix(CFeatures* f);

		/// apply preproc on single feature vector
		/// result in feature matrix
		virtual float64_t* apply_to_feature_vector(float64_t* f, int32_t &len);

		/** @return object name */
		inline virtual const char* get_name() { return "LogPlusOne"; }
};
}
#endif
