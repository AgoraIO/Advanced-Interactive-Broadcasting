
// LiveStreamingDlg.h : 
//

#pragma once
#include "AgoraAudInputManager.h"
#include "AgoraCameraManager.h"

// CLiveStreamingDlg Dialog
class CLiveStreamingDlg : public CDialogEx
{
// Construct
public:
	CLiveStreamingDlg(CWnd* pParent = NULL);	

// Dialog Data
	enum { IDD = IDD_LIVESTREAMING_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV Support


// Implement
protected:
	HICON m_hIcon;

	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg void OnDestroy();
	afx_msg void OnClose();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()

public:
	afx_msg void OnBnClickedButtonStartrtmp();
	afx_msg void OnBnClickedButtonStoprtmp();
	afx_msg void OnBnClickedButtonSignlescreen();
	afx_msg void OnBnClickedButtonDouble1();
	afx_msg void OnBnClickedButtonDouble2();
	afx_msg void OnBnClickedButtonThree1();
	afx_msg void OnBnClickedButtonThree2();
	afx_msg void OnBnClickedButtonThree3();
	afx_msg void OnBnClickedButtonFour1();
	afx_msg void OnBnClickedButtonFour2();
	afx_msg void OnBnClickedButtonJoinroom();
	afx_msg void OnCbnSelchangeComboCameralist();
	afx_msg void OnCbnSelchangeComboMicinlist();

	LRESULT onJoinChannelSuccess(WPARAM wParam, LPARAM lParam);
	LRESULT onWarning(WPARAM wParam, LPARAM lParam);
	LRESULT onError(WPARAM wParam, LPARAM lParam);
	LRESULT onLeaveChannel(WPARAM wParam, LPARAM lParam);
	LRESULT onRequestChannelKey(WPARAM wParam, LPARAM lParam);
	LRESULT onLastMileQuality(WPARAM wParam, LPARAM lParam);
	LRESULT onFirstLocalVideoFrame(WPARAM wParam, LPARAM lParam);
	LRESULT onFirstRemoteVideoDecoded(WPARAM wParam, LPARAM lParam);
	LRESULT onFirstRmoteVideoFrame(WPARAM wParam, LPARAM lParam);
	LRESULT onUserJoined(WPARAM wParam, LPARAM lParam);
	LRESULT onUserOff(WPARAM wParam, LPARAM lParam);
	LRESULT onUserMuteVideo(WPARAM wParam, LPARAM lParam);
	LRESULT onConnectionLost(WPARAM wParam, LPARAM lParam);


protected:

	void initCtrl();
	void uninitCtrl();

	void initAgoraMeida();
	void uninitAgoraMedia();

	void initDeviceManager();
	void uninitDeviceManager();

	void RebindVideoWnd();
	void ReSetLayOut();

private:
	bool m_bStartRtmp;
	CString m_strRtmpURL;
	CString m_strRoomID;

	CStatic m_PicCtlRemote1;
	CStatic m_PicCtlRemote2;
	CStatic m_PicCtlRemote3;
	CStatic m_PicCtlLocal;

	CEdit m_EditRtmpUrl;
	CEdit m_EditRoomID;
	CButton m_btJoinRoom;
	CStatic m_stCtlVersion;

	CButton m_btnSignleScreen;
	CButton m_btnDouble_1;
	CButton m_btnDouble_2;
	CButton m_btnThree_1;
	CButton m_btnThree_2;
	CButton m_btnThree_3;
	CButton m_btnFour_1;
	CButton m_btnFour_2;

	CComboBox m_comCameraList;
	CComboBox m_comIMicList;

	AG_LiveStream_Layout m_eCurLayoutStatus;

	std::string m_strAppId;
	CAgoraObject* m_lpAgoraObject;
	IRtcEngine* m_lpRtcEngine;
	uid_t m_uId;
	
	CAgoraAudInputManager m_AgoraInputManager;
	CAgoraCameraManager m_AgoraCameraManager;
	
	typedef struct eTagRemoteWnd{

		uid_t uid;
		int nIndex;

	}AGVIDEO_WNDINFO, *PAGVIDEO_WNDINFO, *LPAGVIDEO_WNDINFO;

	typedef struct eTagLayoutPosInfo{
		int nRouteId;
		double dxPos;
		double dyPos;
		double dWidth;
		double dHeight;
		double dAlpha;
		int nZIndex;
	}AG_LayoutPosInfo,PAG_LayoutPosInfo,*LPAG_LayoutPosInfo;

	CList<AGVIDEO_WNDINFO> m_ListRemoteWnd;
	CStatic* m_wndVideo[3];
	std::map<CStatic*, UINT> m_mapWndUser;
};
