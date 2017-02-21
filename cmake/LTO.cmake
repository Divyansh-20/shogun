set(LTO_FOUND FALSE)
macro(FIND_LTO_FLAG compiler_flag linker_flag)
	include(TestCXXAcceptsFlag)
	check_cxx_accepts_flag(-flto=thin CXX_ACCEPTS_THIN_LTO)
	set(${compiler_flag} $<$<BOOL:${CXX_ACCEPTS_THIN_LTO}>:-flto=thin>)

	if (NOT CXX_ACCEPTS_THIN_LTO)
		if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Intel")
			check_cxx_accepts_flag(-flto CXX_ACCEPTS_LTO)
			set(${compiler_flag} $<$<BOOL:${CXX_ACCEPTS_LTO}>:-flto>)
		else()
			check_cxx_accepts_flag(-ipo CXX_ACCEPTS_IPO)
			set(${compiler_flag} $<$<BOOL:${CXX_ACCEPTS_IPO}>:-ipo>)
		endif()
	else()
		# ThinLTO's incremental linking
		if (INCREMENTAL_LINKING)
			if (LDGOLD_FOUND)
				set(${linker_flag} $<1:-Wl,-plugin-opt,cache-dir=${INCREMENTAL_LINKING_DIR}>)
			elseif(APPLE)
				set(${linker_flag} $<1:-Wl,-cache_path_lto,${INCREMENTAL_LINKING_DIR}>)
			else()
				# FIXME: find out the linker type 
				MESSAGE(WARNING "Unknown parameters for your linker for caching")
			endif()
		endif()
	endif()
endmacro()

FIND_LTO_FLAG(LTO_FLAG LINKER_FLAG)
if(NOT ${LTO_FLAG} STREQUAL "")
	set(LTO_FOUND TRUE)
endif()

function(SET_LTO)
	foreach(t ${ARGN})
		if (TARGET ${t})
			get_target_property(TARGET_TYPE ${t} TYPE)
			if (${TARGET_TYPE} STREQUAL INTERFACE_LIBRARY)
				target_compile_options(${t} INTERFACE ${LTO_FLAG})
			else()
				target_compile_options(${t} PRIVATE ${LTO_FLAG})	
				if (NOT ${TARGET_TYPE} STREQUAL OBJECT_LIBRARY)
					target_link_libraries(${t} PRIVATE ${LINKER_FLAG})
				endif()
			endif()
		endif()
	endforeach()
endfunction()