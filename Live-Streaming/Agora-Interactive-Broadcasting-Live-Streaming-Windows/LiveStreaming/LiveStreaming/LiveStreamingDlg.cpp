
// LiveStreamingDlg.cpp : Implement File
//

#include "stdafx.h"
#include "LiveStreaming.h"
#include "LiveStreamingDlg.h"
#include "afxdialogex.h"
#include "commonfun.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg Dialog

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV Support

// Implement
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CLiveStreamingDlg Dialog



CLiveStreamingDlg::CLiveStreamingDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CLiveStreamingDlg::IDD, pParent),
	m_eCurLayoutStatus(eLayout_Invalid),
	m_bStartRtmp(FALSE),
	m_lpAgoraObject(nullptr),
	m_lpRtcEngine(nullptr)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CLiveStreamingDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_STATIC_REMOTE1, m_PicCtlRemote1);
	DDX_Control(pDX, IDC_STATIC_REMOTE2, m_PicCtlRemote2);
	DDX_Control(pDX, IDC_STATIC_REMOTE3, m_PicCtlRemote3);
	DDX_Control(pDX, IDC_STATIC_LOCAL, m_PicCtlLocal);
	DDX_Control(pDX, IDC_EDIT_RTMPURL, m_EditRtmpUrl);
	DDX_Control(pDX, IDC_EDIT_MediaRoomID, m_EditRoomID);
	DDX_Control(pDX, IDC_BUTTON_JoinRoom, m_btJoinRoom);
	DDX_Control(pDX, IDC_STATIC_LiveStream_Version, m_stCtlVersion);
	DDX_Control(pDX, IDC_BUTTON_SIGNLESCREEN, m_btnSignleScreen);
	DDX_Control(pDX, IDC_BUTTON_Double_1, m_btnDouble_1);
	DDX_Control(pDX, IDC_BUTTON_Double_2, m_btnDouble_2);
	DDX_Control(pDX, IDC_BUTTON_Three_1, m_btnThree_1);
	DDX_Control(pDX, IDC_BUTTON_Three_2, m_btnThree_2);
	DDX_Control(pDX, IDC_BUTTON_Three_3, m_btnThree_3);
	DDX_Control(pDX, IDC_BUTTON_FOUR_1, m_btnFour_1);
	DDX_Control(pDX, IDC_BUTTON_FOUR_2, m_btnFour_2);
	DDX_Control(pDX, IDC_COMBO_CameraList, m_comCameraList);
	DDX_Control(pDX, IDC_COMBO_MicInList, m_comIMicList);
}

BEGIN_MESSAGE_MAP(CLiveStreamingDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_CLOSE()
	ON_WM_DESTROY()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_STARTRTMP, &CLiveStreamingDlg::OnBnClickedButtonStartrtmp)
	ON_BN_CLICKED(IDC_BUTTON_STOPRTMp, &CLiveStreamingDlg::OnBnClickedButtonStoprtmp)
	ON_BN_CLICKED(IDC_BUTTON_SIGNLESCREEN, &CLiveStreamingDlg::OnBnClickedButtonSignlescreen)
	ON_BN_CLICKED(IDC_BUTTON_Double_1, &CLiveStreamingDlg::OnBnClickedButtonDouble1)
	ON_BN_CLICKED(IDC_BUTTON_Double_2, &CLiveStreamingDlg::OnBnClickedButtonDouble2)
	ON_BN_CLICKED(IDC_BUTTON_Three_1, &CLiveStreamingDlg::OnBnClickedButtonThree1)
	ON_BN_CLICKED(IDC_BUTTON_Three_2, &CLiveStreamingDlg::OnBnClickedButtonThree2)
	ON_BN_CLICKED(IDC_BUTTON_Three_3, &CLiveStreamingDlg::OnBnClickedButtonThree3)
	ON_BN_CLICKED(IDC_BUTTON_FOUR_1, &CLiveStreamingDlg::OnBnClickedButtonFour1)
	ON_BN_CLICKED(IDC_BUTTON_FOUR_2, &CLiveStreamingDlg::OnBnClickedButtonFour2)
	ON_MESSAGE(WM_MSGID(EID_JOINCHANNEL_SUCCESS), onJoinChannelSuccess)
	ON_MESSAGE(WM_MSGID(EID_WARNING), onWarning)
	ON_MESSAGE(WM_MSGID(EID_ERROR), onError)
	ON_MESSAGE(WM_MSGID(EID_LEAVE_CHANNEL), onLeaveChannel)
	ON_MESSAGE(WM_MSGID(EID_REQUEST_CHANNELKEY), onRequestChannelKey)
	ON_MESSAGE(WM_MSGID(EID_LASTMILE_QUALITY), onLastMileQuality)
	ON_MESSAGE(WM_MSGID(EID_FIRST_LOCAL_VIDEO_FRAME), onFirstLocalVideoFrame)
	ON_MESSAGE(WM_MSGID(EID_FIRST_REMOTE_VIDEO_DECODED), onFirstRemoteVideoDecoded)
	ON_MESSAGE(WM_MSGID(EID_FIRST_REMOTE_VIDEO_FRAME), onFirstRmoteVideoFrame)
	ON_MESSAGE(WM_MSGID(EID_USER_JOINED), onUserJoined)
	ON_MESSAGE(WM_MSGID(EID_USER_OFFLINE), onUserOff)
	ON_MESSAGE(WM_MSGID(EID_USER_MUTE_VIDEO), onUserMuteVideo)
	ON_MESSAGE(WM_MSGID(EID_CONNECTION_LOST), onConnectionLost)
	ON_BN_CLICKED(IDC_BUTTON_JoinRoom, &CLiveStreamingDlg::OnBnClickedButtonJoinroom)
	ON_CBN_SELCHANGE(IDC_COMBO_CameraList, &CLiveStreamingDlg::OnCbnSelchangeComboCameralist)
	ON_CBN_SELCHANGE(IDC_COMBO_MicInList, &CLiveStreamingDlg::OnCbnSelchangeComboMicinlist)
END_MESSAGE_MAP()


// CLiveStreamingDlg Message Handler

BOOL CLiveStreamingDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}


	SetIcon(m_hIcon, TRUE);
	SetIcon(m_hIcon, FALSE);

	SetBackgroundColor(RGB(0xff, 0xff, 0xff), TRUE);

	m_strAppId = gLiveStreamConfig.getAppId();
	if ("" == m_strAppId){
		AfxMessageBox(_T("APPID Œ™ø’.«Î÷ÿ–¬≈‰÷√"));
		std::string iniFilePath = gLiveStreamConfig.getFilePah();
		gLiveStreamConfig.setAppId("");
		ShellExecute(NULL, _T("open"), s2cs(iniFilePath), NULL, NULL, SW_SHOW);
		::PostQuitMessage(0);
		return FALSE;
	}

	initCtrl();
	initAgoraMeida();
	initDeviceManager();

	return TRUE;
}

void CLiveStreamingDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

void CLiveStreamingDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this);

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

HCURSOR CLiveStreamingDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CLiveStreamingDlg::OnBnClickedButtonStartrtmp()
{
	
	m_lpAgoraObject->enablePublish(true);
}


void CLiveStreamingDlg::OnBnClickedButtonStoprtmp()
{
	m_lpAgoraObject->enablePublish(false);
}

void CLiveStreamingDlg::OnBnClickedButtonSignlescreen()
{
	
	//GetLayouPositon

	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[1];
	canvasRegion[0].x = 0;
	canvasRegion[0].y = 0;
	canvasRegion[0].width = 1.0;
	canvasRegion[0].height = 1.0;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_uId;
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	liveStreamLayoute.regionCount = 1;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}


void CLiveStreamingDlg::OnBnClickedButtonDouble1()
{
	
	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[2];
	canvasRegion[0].x = 0;
	canvasRegion[0].y = 0;
	canvasRegion[0].width = 0.5;
	canvasRegion[0].height = 1.0;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_uId;
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	canvasRegion[1].x = 0.5;
	canvasRegion[1].y = 0;
	canvasRegion[1].width = 0.5;
	canvasRegion[1].height = 1.0;
	canvasRegion[1].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[1].uid = m_mapWndUser[&m_PicCtlRemote1];
	canvasRegion[1].alpha = 1.0;
	canvasRegion[1].zOrder = 0;

	liveStreamLayoute.regionCount = 2;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}


void CLiveStreamingDlg::OnBnClickedButtonDouble2()
{
	
	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[2];
	canvasRegion[0].x = 0;
	canvasRegion[0].y = 0;
	canvasRegion[0].width = 1.0;
	canvasRegion[0].height = 1.0;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_uId;
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	canvasRegion[1].x = 0.6;
	canvasRegion[1].y = 0.1;
	canvasRegion[1].width = 0.3;
	canvasRegion[1].height = 0.3;
	canvasRegion[1].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[1].uid = m_mapWndUser[&m_PicCtlRemote1];
	canvasRegion[1].alpha = 1.0;
	canvasRegion[1].zOrder = 1;

	liveStreamLayoute.regionCount = 2;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}


void CLiveStreamingDlg::OnBnClickedButtonThree1()
{
	
	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[3];
	canvasRegion[0].x = 0.25;
	canvasRegion[0].y = 0;
	canvasRegion[0].width = 0.5;
	canvasRegion[0].height = 0.5;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_uId;
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	canvasRegion[1].x = 0;
	canvasRegion[1].y = 0.5;
	canvasRegion[1].width = 0.5;
	canvasRegion[1].height = 0.5;
	canvasRegion[1].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[1].uid = m_mapWndUser[&m_PicCtlRemote1];
	canvasRegion[1].alpha = 1.0;
	canvasRegion[1].zOrder = 0;

	canvasRegion[2].x = 0.5;
	canvasRegion[2].y = 0.5;
	canvasRegion[2].width = 0.5;
	canvasRegion[2].height = 0.5;
	canvasRegion[2].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[2].uid = m_mapWndUser[&m_PicCtlRemote2];
	canvasRegion[2].alpha = 1.0;
	canvasRegion[2].zOrder = 0;

	liveStreamLayoute.regionCount = 3;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}


void CLiveStreamingDlg::OnBnClickedButtonThree2()
{
	
	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[3];
	canvasRegion[0].x = 0;
	canvasRegion[0].y = 0;
	canvasRegion[0].width = 0.25;
	canvasRegion[0].height = 0.25;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_mapWndUser[&m_PicCtlRemote1];
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	canvasRegion[1].x = 0;
	canvasRegion[1].y = 0.25;
	canvasRegion[1].width = 0.25;
	canvasRegion[1].height = 0.25;
	canvasRegion[1].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[1].uid = m_mapWndUser[&m_PicCtlRemote2];
	canvasRegion[1].alpha = 1.0;
	canvasRegion[1].zOrder = 0;

	canvasRegion[2].x = 0.25;
	canvasRegion[2].y = 0;
	canvasRegion[2].width = 0.75;
	canvasRegion[2].height = 1;
	canvasRegion[2].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[2].uid = m_uId;
	canvasRegion[2].alpha = 1.0;
	canvasRegion[2].zOrder = 0;

	liveStreamLayoute.regionCount = 3;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}


void CLiveStreamingDlg::OnBnClickedButtonThree3()
{
	
	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[3];
	canvasRegion[0].x = 0.0;
	canvasRegion[0].y = 0.0;
	canvasRegion[0].width = 1.0;
	canvasRegion[0].height = 1.0;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_uId;
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	canvasRegion[1].x = 0.1;
	canvasRegion[1].y = 0.1;
	canvasRegion[1].width = 0.3;
	canvasRegion[1].height = 0.3;
	canvasRegion[1].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[1].uid = m_mapWndUser[&m_PicCtlRemote1];
	canvasRegion[1].alpha = 1.0;
	canvasRegion[1].zOrder = 1;

	canvasRegion[2].x = 0.5;
	canvasRegion[2].y = 0.1;
	canvasRegion[2].width = 0.3;
	canvasRegion[2].height = 0.3;
	canvasRegion[2].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[2].uid = m_mapWndUser[&m_PicCtlRemote2];
	canvasRegion[2].alpha = 1.0;
	canvasRegion[2].zOrder = 1;

	liveStreamLayoute.regionCount = 3;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}


void CLiveStreamingDlg::OnBnClickedButtonFour1()
{
	
	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[4];
	canvasRegion[0].x = 0;
	canvasRegion[0].y = 0;
	canvasRegion[0].width = 0.5;
	canvasRegion[0].height = 0.5;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_mapWndUser[&m_PicCtlRemote1];
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	canvasRegion[1].x = 0.5;
	canvasRegion[1].y = 0;
	canvasRegion[1].width = 0.5;
	canvasRegion[1].height = 0.5;
	canvasRegion[1].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[1].uid = m_mapWndUser[&m_PicCtlRemote2];
	canvasRegion[1].alpha = 1.0;
	canvasRegion[1].zOrder = 0;

	canvasRegion[2].x = 0;
	canvasRegion[2].y = 0.5;
	canvasRegion[2].width = 0.5;
	canvasRegion[2].height = 0.5;
	canvasRegion[2].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[2].uid = m_mapWndUser[&m_PicCtlRemote3];
	canvasRegion[2].alpha = 1.0;
	canvasRegion[2].zOrder = 0;

	canvasRegion[3].x = 0.5;
	canvasRegion[3].y = 0.5;
	canvasRegion[3].width = 0.5;
	canvasRegion[3].height = 0.5;
	canvasRegion[3].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[3].uid = m_uId;
	canvasRegion[3].alpha = 1.0;
	canvasRegion[3].zOrder = 0;

	liveStreamLayoute.regionCount = 4;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}


void CLiveStreamingDlg::OnBnClickedButtonFour2()
{
	
	VideoCompositingLayout liveStreamLayoute;
	VideoCompositingLayout::Region canvasRegion[4];
	canvasRegion[0].x = 0;
	canvasRegion[0].y = 0;
	canvasRegion[0].width = 0.3;
	canvasRegion[0].height = 0.3;
	canvasRegion[0].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[0].uid = m_mapWndUser[&m_PicCtlRemote1];
	canvasRegion[0].alpha = 1.0;
	canvasRegion[0].zOrder = 0;

	canvasRegion[1].x = 0;
	canvasRegion[1].y = 0.3;
	canvasRegion[1].width = 0.3;
	canvasRegion[1].height = 0.3;
	canvasRegion[1].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[1].uid = m_mapWndUser[&m_PicCtlRemote2];
	canvasRegion[1].alpha = 1.0;
	canvasRegion[1].zOrder = 0;

	canvasRegion[2].x = 0;
	canvasRegion[2].y = 0.6;
	canvasRegion[2].width = 0.3;
	canvasRegion[2].height = 0.3;
	canvasRegion[2].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[2].uid = m_mapWndUser[&m_PicCtlRemote3];
	canvasRegion[2].alpha = 1.0;
	canvasRegion[2].zOrder = 0;

	canvasRegion[3].x = 0.3;
	canvasRegion[3].y = 0;
	canvasRegion[3].width = 0.7;
	canvasRegion[3].height = 1;
	canvasRegion[3].renderMode = RENDER_MODE_HIDDEN;
	canvasRegion[3].uid = m_uId;
	canvasRegion[3].alpha = 1.0;
	canvasRegion[3].zOrder = 0;

	liveStreamLayoute.regionCount = 4;
	liveStreamLayoute.regions = canvasRegion;

	if (m_lpRtcEngine){

		m_lpRtcEngine->setVideoCompositingLayout(liveStreamLayoute);
	}
}

void CLiveStreamingDlg::initCtrl()
{
	m_btJoinRoom.SetWindowTextW(_T("JoinChannel"));
	m_strRoomID = s2cs(gLiveStreamConfig.getChannelName());
	m_EditRoomID.SetWindowTextW(m_strRoomID);

	m_strRtmpURL = s2cs(gLiveStreamConfig.getRtmpUrl());
	m_EditRtmpUrl.SetWindowTextW(m_strRtmpURL);

	m_btnSignleScreen.EnableWindow(FALSE);
	m_btnDouble_1.EnableWindow(FALSE);
	m_btnDouble_2.EnableWindow(FALSE);
	m_btnThree_1.EnableWindow(FALSE);
	m_btnThree_2.EnableWindow(FALSE);
	m_btnThree_3.EnableWindow(FALSE);
	m_btnFour_1.EnableWindow(FALSE);
	m_btnFour_2.EnableWindow(FALSE);

	m_wndVideo[0] = &m_PicCtlRemote1;
	m_wndVideo[1] = &m_PicCtlRemote2;
	m_wndVideo[2] = &m_PicCtlRemote3;
}

void CLiveStreamingDlg::uninitCtrl()
{
	m_btJoinRoom.SetWindowTextW(_T("LeaveRoom"));
	
	m_EditRoomID.SetWindowTextW(_T(""));
	m_EditRtmpUrl.SetWindowTextW(_T(""));
	m_strAppId = "";

	m_bStartRtmp = false;
}

void CLiveStreamingDlg::initAgoraMeida()
{
	if ("" == m_strAppId){
		return;
	}
	m_lpAgoraObject = CAgoraObject::GetAgoraObject(s2cs(m_strAppId));
	ASSERT(m_lpAgoraObject);
	m_lpAgoraObject->SetMsgHandlerWnd(m_hWnd);

	m_lpRtcEngine = CAgoraObject::GetEngine();
	ASSERT(m_lpRtcEngine);

	CString strSdkLogFilePath = s2cs(getMediaSdkLogPath());
	m_lpAgoraObject->SetLogFilePath(strSdkLogFilePath);
	m_lpAgoraObject->EnableLastmileTest(TRUE);
	m_lpAgoraObject->EnableLocalMirrorImage(FALSE);
	m_lpAgoraObject->EnableLoopBack(TRUE);

	m_lpAgoraObject->EnableVideo(TRUE);
}

void CLiveStreamingDlg::uninitAgoraMedia()
{
	if (nullptr == m_lpAgoraObject){
		return;
	}

	m_lpAgoraObject->EnableVideo(FALSE);
	m_lpAgoraObject->EnableLastmileTest(FALSE);
	if (m_lpAgoraObject){
		CAgoraObject::CloseAgoraObject();
		m_lpAgoraObject = nullptr;
		m_lpRtcEngine = nullptr;
	}
}

void CLiveStreamingDlg::initDeviceManager()
{
	BOOL bRes = m_AgoraCameraManager.Create(m_lpRtcEngine);
	if (!bRes){
		OutputDebugStringA("createCameraManager failed..\n");
		return;
	}

	int nCountCamera = m_AgoraCameraManager.GetDeviceCount();
	CString csDeviceName, csDeviceComID;
	int nCurCameraIndex = CB_ERR + 1;
	for (int nIndex = 0; nCountCamera > nIndex; nIndex++)
	{
		bRes = m_AgoraCameraManager.GetDevice(nIndex, csDeviceName, csDeviceComID);
		if (!bRes){

			char logMsg[512] = { '\0' };
			sprintf_s(logMsg, "CameraManager GetDevice nIndex : %d failed..\n", nIndex);
			OutputDebugStringA(logMsg);
			break;
		}

		m_comCameraList.AddString(csDeviceName);
		if (gLiveStreamConfig.getCameraDeviceName() == cs2s(csDeviceName)){

			nCurCameraIndex = nIndex;
		}
	}
	m_comCameraList.SetCurSel(nCurCameraIndex);

	int nCurMIcIndex = CB_ERR + 1;
	bRes = m_AgoraInputManager.Create(m_lpRtcEngine);
	if (!bRes){
		OutputDebugStringA("createInputMicManager failed.\n");
		return;
	}

	int nCountMic = m_AgoraInputManager.GetDeviceCount();
	for (int nIndexMic = 0; nCountMic > nIndexMic; nIndexMic++){

		bRes = m_AgoraInputManager.GetDevice(nIndexMic, csDeviceName, csDeviceComID);
		if (!bRes){
			char logMsg[512] = { '\0' };
			sprintf_s(logMsg, "InputManager GetDevice nIndex : %d failed..\n");
			OutputDebugStringA(logMsg);
			break;;
		}

		m_comIMicList.AddString(csDeviceName);
	}
	m_comIMicList.SetCurSel(nCurMIcIndex);
}

void CLiveStreamingDlg::uninitDeviceManager()
{
	if (m_lpRtcEngine && m_lpAgoraObject){

		m_AgoraCameraManager.Close();
		m_AgoraInputManager.Close();
	}
}

void CLiveStreamingDlg::RebindVideoWnd()
{
	if (NULL == m_wndVideo[0]->GetSafeHwnd() || nullptr == m_PicCtlLocal.GetSafeHwnd())
		return;
	
	VideoCanvas canvas;
	canvas.renderMode = RENDER_MODE_FIT;

	POSITION pos = m_ListRemoteWnd.GetHeadPosition();
	for (int nIndex = 0; 3 > nIndex; nIndex++){
		if (NULL != pos){
			AGVIDEO_WNDINFO &agvWndInfo = m_ListRemoteWnd.GetNext(pos);
			
			canvas.uid = agvWndInfo.uid;
			canvas.view = m_wndVideo[nIndex]->GetSafeHwnd();
			agvWndInfo.nIndex = nIndex;
			m_mapWndUser[m_wndVideo[nIndex]] = agvWndInfo.uid;

			m_lpRtcEngine->setupRemoteVideo(canvas);
		}
		else{
			m_wndVideo[nIndex]->Invalidate(TRUE);
		}
	}
}

void CLiveStreamingDlg::ReSetLayOut()
{
	m_btnSignleScreen.EnableWindow(FALSE);
	m_btnDouble_1.EnableWindow(FALSE);
	m_btnDouble_2.EnableWindow(FALSE);
	m_btnThree_1.EnableWindow(FALSE);
	m_btnThree_2.EnableWindow(FALSE);
	m_btnThree_3.EnableWindow(FALSE);
	m_btnFour_1.EnableWindow(FALSE);
	m_btnFour_2.EnableWindow(FALSE);

	int nRemoteCount = m_ListRemoteWnd.GetCount();
	char logMsg[512] = { '\0' };
	sprintf_s(logMsg, "ReSetLayout nCount: %d\n", nRemoteCount);
	OutputDebugStringA(logMsg);

	if (1 == nRemoteCount){
		m_btnSignleScreen.EnableWindow(TRUE);
		m_btnDouble_1.EnableWindow(TRUE);
		m_btnDouble_2.EnableWindow(TRUE);
	}
	else if (2 == nRemoteCount){
		m_btnSignleScreen.EnableWindow(TRUE);
		m_btnDouble_1.EnableWindow(TRUE);
		m_btnDouble_2.EnableWindow(TRUE);
		m_btnThree_1.EnableWindow(TRUE);
		m_btnThree_2.EnableWindow(TRUE);
		m_btnThree_3.EnableWindow(TRUE);
	}
	else if (3 == nRemoteCount){
		m_btnSignleScreen.EnableWindow(TRUE);
		m_btnDouble_1.EnableWindow(TRUE);
		m_btnDouble_2.EnableWindow(TRUE);
		m_btnThree_1.EnableWindow(TRUE);
		m_btnThree_2.EnableWindow(TRUE);
		m_btnThree_3.EnableWindow(TRUE);
		m_btnFour_1.EnableWindow(TRUE);
		m_btnFour_2.EnableWindow(TRUE);
	}
}

LRESULT CLiveStreamingDlg::onJoinChannelSuccess(WPARAM wParam, LPARAM lParam)
{
	LPAGE_JOINCHANNEL_SUCCESS lpData = (LPAGE_JOINCHANNEL_SUCCESS)wParam;

	m_lpAgoraObject->SetSelfUID(lpData->uid);

	//fix title
	CString titleVideo;
	GetWindowText(titleVideo);
	CString newTitle;
	newTitle.Format(_T("[%s] [uid: %ld] %s"), _T("LiveStream_Windows"), lpData->uid, titleVideo);
	SetWindowText(newTitle);
	Invalidate();

	delete lpData;

	m_btnSignleScreen.EnableWindow(TRUE);//only for myslef

	CString lpStrSdkVersion = m_lpAgoraObject->GetSDKVersionEx();
	m_stCtlVersion.SetWindowTextW(lpStrSdkVersion);

	m_btJoinRoom.SetWindowTextW(_T("LeaveChannel"));

	OutputDebugStringA(__FUNCTION__);
	OutputDebugStringA("\n");

	return true;
}

LRESULT CLiveStreamingDlg::onWarning(WPARAM wParam, LPARAM lParam)
{
	return true;
}

LRESULT CLiveStreamingDlg::onError(WPARAM wParam, LPARAM lParam)
{
	LPAGE_ERROR lpData = (LPAGE_ERROR)wParam;
	if (lpData){

		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onLeaveChannel(WPARAM wParam, LPARAM lParam)
{
	LPAGE_LEAVE_CHANNEL lpData = (LPAGE_LEAVE_CHANNEL)wParam;
	if (lpData){
		
		m_btJoinRoom.SetWindowTextW(_T("JoinChannel"));
		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onRequestChannelKey(WPARAM wParam, LPARAM lParam)
{
	if (m_lpRtcEngine){
		CString strChannelName = m_lpAgoraObject->GetChanelName();
		CStringA strNewMediaChannelKey = m_lpAgoraObject->getDynamicMediaChannelKey(strChannelName);
		m_lpRtcEngine->renewChannelKey(strNewMediaChannelKey);
	}

	return true;
}

LRESULT CLiveStreamingDlg::onLastMileQuality(WPARAM wParam, LPARAM lParam)
{
	LPAGE_LASTMILE_QUALITY lpData = (LPAGE_LASTMILE_QUALITY)wParam;
	if (lpData){

		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onFirstLocalVideoFrame(WPARAM wParam, LPARAM lParam)
{
	LPAGE_FIRST_LOCAL_VIDEO_FRAME lpData = (LPAGE_FIRST_LOCAL_VIDEO_FRAME)wParam;
	if (lpData){

		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onFirstRemoteVideoDecoded(WPARAM wParam, LPARAM lParam)
{
	LPAGE_FIRST_REMOTE_VIDEO_DECODED lpData = (LPAGE_FIRST_REMOTE_VIDEO_DECODED)wParam;
	if (lpData){
				
		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onFirstRmoteVideoFrame(WPARAM wParam, LPARAM lParam)
{
	LPAGE_FIRST_REMOTE_VIDEO_FRAME lpData = (LPAGE_FIRST_REMOTE_VIDEO_FRAME)wParam;
	if (lpData){

		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onUserJoined(WPARAM wParam, LPARAM lParam)
{
	LPAGE_USER_JOINED lpData = (LPAGE_USER_JOINED)wParam; 
	BOOL bFound = FALSE;
	if (lpData){

		char logMsg[512] = { '\0' };
		sprintf_s(logMsg, "UserJoin: %u\n", lpData->uid);
		OutputDebugStringA(logMsg);

		POSITION pos = m_ListRemoteWnd.GetHeadPosition();
		while (NULL != pos){
			AGVIDEO_WNDINFO &agvWndInfo = m_ListRemoteWnd.GetNext(pos);
			if (agvWndInfo.uid == lpData->uid){

				bFound = TRUE; break;
			}
		}

		if (!bFound){
			AGVIDEO_WNDINFO agvWndInfo;
			memset(&agvWndInfo, 0, sizeof(agvWndInfo));
			agvWndInfo.uid = lpData->uid;
			m_ListRemoteWnd.AddTail(agvWndInfo);
		}

		RebindVideoWnd();
		ReSetLayOut();

		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onUserOff(WPARAM wParam, LPARAM lParam)
{
	LPAGE_USER_OFFLINE lpData = (LPAGE_USER_OFFLINE)wParam;
	if (lpData){

		char logMsg[512] = { '\0' };
		sprintf_s(logMsg, "UserOff : %u\n", lpData->uid);
		OutputDebugStringA(logMsg);

		POSITION pos = m_ListRemoteWnd.GetHeadPosition();
		while (nullptr != pos){
			AGVIDEO_WNDINFO &agWndInfo = m_ListRemoteWnd.GetAt(pos);
			if (agWndInfo.uid == lpData->uid){

				VideoCanvas videocanvas;
				videocanvas.renderMode = RENDER_MODE_FIT;
				videocanvas.uid = lpData->uid;
				videocanvas.view = nullptr;
				m_lpRtcEngine->setupRemoteVideo(videocanvas);
				m_wndVideo[agWndInfo.nIndex]->Invalidate(TRUE);

				m_ListRemoteWnd.RemoveAt(pos);
				RebindVideoWnd();
				ReSetLayOut();
				break;;
			}

			m_ListRemoteWnd.GetNext(pos);
		}

		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onUserMuteVideo(WPARAM wParam, LPARAM lParam)
{
	LPAGE_USER_MUTE_VIDEO lpData = (LPAGE_USER_MUTE_VIDEO)wParam;
	if (lpData){
		char logMsg[512] = { '\0' };
		sprintf_s(logMsg, "UserMuteVideo: %u %d\n", lpData->uid, lpData->muted);
		OutputDebugStringA(logMsg);

		if (lpData->muted){

			BOOL bFound = FALSE;
			POSITION pos = m_ListRemoteWnd.GetHeadPosition();
			while (NULL != pos){
				AGVIDEO_WNDINFO &agvWndInfo = m_ListRemoteWnd.GetNext(pos);
				if (agvWndInfo.uid == lpData->uid){

					bFound = TRUE; break;
				}
			}

			if (!bFound){
				AGVIDEO_WNDINFO agvWndInfo;
				memset(&agvWndInfo, 0, sizeof(agvWndInfo));
				agvWndInfo.uid = lpData->uid;
				m_ListRemoteWnd.AddTail(agvWndInfo);
			}
		}
		else{

			POSITION pos = m_ListRemoteWnd.GetHeadPosition();
			while (nullptr != pos){
				AGVIDEO_WNDINFO &agWndInfo = m_ListRemoteWnd.GetNext(pos);
				if (m_ListRemoteWnd.GetAt(pos).uid == lpData->uid){

					m_ListRemoteWnd.RemoveAt(pos);
					break;;
				}

				m_ListRemoteWnd.GetNext(pos);
			}
		}

		RebindVideoWnd();
		ReSetLayOut();

		delete lpData; lpData = nullptr;
	}

	return true;
}

LRESULT CLiveStreamingDlg::onConnectionLost(WPARAM wParam, LPARAM lParam)
{
	return true;
}

void CLiveStreamingDlg::OnDestroy()
{
	OutputDebugStringA(__FUNCTION__);
	OutputDebugStringA("\n");
}

void CLiveStreamingDlg::OnClose()
{
	//TO DO
	if (m_lpAgoraObject){

		m_lpAgoraObject->LeaveCahnnel();
	}
	if (m_lpRtcEngine){

		m_lpRtcEngine->stopPreview();
	}

	uninitDeviceManager();
	uninitAgoraMedia();
	uninitCtrl();

	return CDialogEx::OnCancel();
}

void CLiveStreamingDlg::OnBnClickedButtonJoinroom()
{
	
	CString strParam;
	m_btJoinRoom.GetWindowTextW(strParam);
	if (_T("JoinChannel") == strParam){

		m_lpAgoraObject->EnableLastmileTest(FALSE);
		m_lpAgoraObject->SetClientRole(CLIENT_ROLE_TYPE::CLIENT_ROLE_BROADCASTER);
		m_lpAgoraObject->SetChannelProfile(TRUE);
		
		m_uId = str2int(gLiveStreamConfig.getLoginUid());
		std::string strAppcertificatId = gLiveStreamConfig.getAppCertificateId();
		m_lpAgoraObject->SetSelfUID(m_uId);
		m_lpAgoraObject->SetAppCert(s2cs(strAppcertificatId));

		VideoCanvas vc;
		vc.renderMode = RENDER_MODE_FIT;
		vc.uid = m_uId;
		vc.view = m_PicCtlLocal;
		m_lpRtcEngine->setupLocalVideo(vc);

		int nVideoIndex = str2int(gLiveStreamConfig.getVideoSolutinIndex());
		m_lpAgoraObject->SetVideoProfile(nVideoIndex,FALSE);

		AGE_PUBLISH_PARAM publishParam;
		publishParam.bitrate = 500;
		publishParam.fps = 15;
		publishParam.height = 480;
		publishParam.width = 640;
		publishParam.rtmpUrl = cs2s(m_strRtmpURL);
		m_lpAgoraObject->setPublishParam(publishParam);
		m_lpAgoraObject->enablePublish(TRUE);

		m_lpRtcEngine->startPreview();

		bool bAppCertEnalbe = str2int(gLiveStreamConfig.getAppCertEnable());
		if (bAppCertEnalbe){

			CStringA strMediaChannelKey = m_lpAgoraObject->getDynamicMediaChannelKey(m_strRoomID);
			m_lpAgoraObject->JoinChannel(m_strRoomID, m_uId, strMediaChannelKey);
		}
		else{

			m_lpAgoraObject->JoinChannel(m_strRoomID, m_uId);
		}
	}
	else if (_T("LeaveChannel") == strParam){

		m_lpAgoraObject->LeaveCahnnel();
		m_lpRtcEngine->stopPreview();
	}
}


void CLiveStreamingDlg::OnCbnSelchangeComboCameralist()
{
	
	int nCurCameraIndex = m_comCameraList.GetCurSel();
	if (CB_ERR != nCurCameraIndex){

		CString csCameraName, csCameraComID;
		BOOL bRes = m_AgoraCameraManager.GetDevice(nCurCameraIndex, csCameraName, csCameraComID);
		if (bRes){

			bRes = m_AgoraCameraManager.SetCurDevice(csCameraComID);
			if (!bRes){
				
				char logMsg[512] = { '\0' };
				sprintf_s(logMsg, "SetCurDevice csCameraComID: %s failed \n", cs2s(csCameraComID));
				OutputDebugStringA(logMsg);
			}
		}
	}
}


void CLiveStreamingDlg::OnCbnSelchangeComboMicinlist()
{
	
}
