
// LiveStreaming.h : PROJECT_NAME 
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		


// CLiveStreamingApp: 
//

class CLiveStreamingApp : public CWinApp
{
public:
	CLiveStreamingApp();

// override
public:
	virtual BOOL InitInstance();

// implement

	DECLARE_MESSAGE_MAP()
};

extern CLiveStreamingApp theApp;