#pragma once

typedef enum eTagLiveStreamLayout
{
	eLayout_Invalid,
	eLayout_SingleScreen,
	eLayout_Double_Equal,
	eLayout_Double_PIP,
	eLayout_Three_Shape,
	eLayout_Three_Covered,
	eLayout_Three_PIP_TWO,
	eLayout_Four_Equal,
	eLayout_Four_Covered,

	eLayout_UnKnown = 0xff,

}AG_LiveStream_Layout,*PAG_LiveStream_Layout,*LPAG_LiveStream_Layout;

