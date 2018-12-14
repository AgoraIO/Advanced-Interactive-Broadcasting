// PublisherDlg.cpp : implement file
//

#include "stdafx.h"
#include "Openlive.h"
#include "PublisherDlg.h"
#include "afxdialogex.h"


// CPublisherDlg Dialog

IMPLEMENT_DYNAMIC(CPublisherDlg, CDialogEx)

CPublisherDlg::CPublisherDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CPublisherDlg::IDD, pParent)
	, m_nWidth(640)
	, m_nHeight(360)
	, m_nFramerate(15)
	, m_nBitrate(500)
	, m_nLifeCycle(1)
	, m_nAudioSampleRate(32000)
	, m_nAudioBitrate(52)
	, m_nAudioChannel(1)
{

}

CPublisherDlg::~CPublisherDlg()
{
}

void CPublisherDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDPUBSTRING_PUB, m_edbPbuString);
	DDX_Control(pDX, IDC_EDWIDTH_PUB, m_edbWidth);
	DDX_Control(pDX, IDC_EDHEIGHT_PUB, m_edbHeight);
	DDX_Control(pDX, IDC_EDFR_PUB, m_edbFramerate);
	DDX_Control(pDX, IDC_EDBR_PUB, m_edbBitrate);

	DDX_Control(pDX, IDC_EDAUDBITRATE_PUB, m_edbAudBitrate);
	DDX_Control(pDX, IDC_BTNCANCEL_PUB, m_btnCancel);
	DDX_Control(pDX, IDC_BTNCONFIRM_PUB, m_btnConfirm);

	DDX_Control(pDX, IDC_EDWTMRX_PUB, m_edbWaterMarkX);
	DDX_Control(pDX, IDC_EDWTMRY_PUB, m_edbWaterMarkY);
	DDX_Control(pDX, IDC_EDWTMRWIDTH_PUB, m_edbWaterMarkWidth);
	DDX_Control(pDX, IDC_EDWTMRHEIGHT_PUB, m_edbWaterMarkHeight);
	DDX_Control(pDX, IDC_EDWTMRPATH_PUB, m_edbWaterMarkPath);
	DDX_Control(pDX, IDC_BTNBROWSE_PUB, m_btnBrowse);
	DDX_Control(pDX, IDC_TRANSCODING_USER, m_staTranscodingUser);
	DDX_Control(pDX, IDC_CHECK_TRANSCODING, m_chkTranscoding);
	DDX_Control(pDX, IDC_EDT_GOP, m_edtGOP);
	DDX_Control(pDX, IDC_COMBO_VIDEO_CODEVC_PROFILE, m_cmbVideoCodecProfile);
	DDX_Control(pDX, IDC_CMB_AUDIO_CHANNELS, m_cmbAudioChannels);
	DDX_Control(pDX, IDC_CMB_AUDIO_SAMPLERATE, m_cmbAudioSampleRate);
	DDX_Control(pDX, IDC_COMBO_WATERMARK, m_cmbWaterMark);
}


BEGIN_MESSAGE_MAP(CPublisherDlg, CDialogEx)
	ON_BN_CLICKED(IDC_BTNCONFIRM_PUB, &CPublisherDlg::OnBnClickedBtnconfirmPub)
	ON_WM_PAINT()
	ON_BN_CLICKED(IDC_BTNBROWSE_PUB, &CPublisherDlg::OnBnClickedBtnbrowsePub)
	ON_BN_CLICKED(IDC_BTNCANCEL_PUB, &CPublisherDlg::OnBnClickedBtncancelPub)
END_MESSAGE_MAP()


// CPublisherDlg Message Handler


BOOL CPublisherDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	m_ftHead.CreateFont(15, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
	m_ftDesc.CreateFont(15, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
	m_ftBtn.CreateFont(16, 0, 0, 0, FW_NORMAL, FALSE, FALSE, 0, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, _T("Arial"));
	m_penFrame.CreatePen(PS_SOLID, 1, RGB(0xD8, 0xD8, 0xD8));

	SetBackgroundColor(RGB(0xFE, 0xFE, 0xFE));
	m_vecVideoCodecProfile.push_back(VIDEO_CODEC_PROFILE_BASELINE);
	m_vecVideoCodecProfile.push_back(VIDEO_CODEC_PROFILE_MAIN);
	m_vecVideoCodecProfile.push_back(VIDEO_CODEC_PROFILE_HIGH);

	m_vecVideoCodecProfileString.push_back(_T("VIDEO_CODEC_PROFILE_BASELINE"));
	m_vecVideoCodecProfileString.push_back(_T("VIDEO_CODEC_PROFILE_MAIN"));
	m_vecVideoCodecProfileString.push_back(_T("VIDEO_CODEC_PROFILE_HIGH"));

	m_vecAudioSampleRate.push_back(AUDIO_SAMPLE_RATE_32000);
	m_vecAudioSampleRate.push_back(AUDIO_SAMPLE_RATE_44100);
	m_vecAudioSampleRate.push_back(AUDIO_SAMPLE_RATE_48000);

	m_vecAudioSampleRateString.push_back(_T("AUDIO_SAMPLE_RATE_32000"));
	m_vecAudioSampleRateString.push_back(_T("AUDIO_SAMPLE_RATE_44100"));
	m_vecAudioSampleRateString.push_back(_T("AUDIO_SAMPLE_RATE_48000"));

	InitCtrls();
	return TRUE;  // return TRUE unless you set the focus to a control
}

void CPublisherDlg::InitCtrls()
{
	CRect ClientRect;

	GetClientRect(&ClientRect);
	
	m_edbPbuString.MoveWindow(80, 56, 326, 24, TRUE);
	m_chkTranscoding.MoveWindow(80, 90, 140, 24);
	m_edbPbuString.SetFont(&m_ftHead);
	m_edbPbuString.SetCaretPos(CPoint(12, 148));
	m_edbPbuString.ShowCaret();
	m_edbPbuString.SetTip(LANG_STR("IDS_PUB_STRINGTIP"));

	m_edbWidth.MoveWindow(80, 128, 80, 24, TRUE);
	m_edbWidth.SetFont(&m_ftHead);
	m_edbWidth.SetCaretPos(CPoint(12, 148));
	m_edbWidth.ShowCaret();
	m_edbWidth.SetTip(LANG_STR("IDS_PUB_WIDTHTIP"));

	m_edbHeight.MoveWindow(162, 128, 80, 24, TRUE);
	m_edbHeight.SetFont(&m_ftHead);
	m_edbHeight.SetCaretPos(CPoint(12, 148));
	m_edbHeight.ShowCaret();
	m_edbHeight.SetTip(LANG_STR("IDS_PUB_HEIGHTTIP"));

	m_edbFramerate.MoveWindow(244, 128, 80, 24, TRUE);
	m_edbFramerate.SetFont(&m_ftHead);
	m_edbFramerate.SetCaretPos(CPoint(12, 148));
	m_edbFramerate.ShowCaret();
	m_edbFramerate.SetTip(LANG_STR("IDS_PUB_FRAMERATETIP"));

	m_edbBitrate.MoveWindow(326, 128, 80, 24, TRUE);
	m_edbBitrate.SetFont(&m_ftHead);
	m_edbBitrate.SetCaretPos(CPoint(12, 148));
	m_edbBitrate.ShowCaret();
	m_edbBitrate.SetTip(LANG_STR("IDS_PUB_BITRATETIP"));

	m_edtGOP.MoveWindow(80, 170, 80, 24, TRUE);
	m_edtGOP.SetFont(&m_ftHead);
	m_edtGOP.SetCaretPos(CPoint(12, 148));
	m_edtGOP.ShowCaret();
	m_edtGOP.SetTip(_T("GOP"));

	m_cmbVideoCodecProfile.MoveWindow(165, 170, 245, 24, TRUE);
	m_cmbVideoCodecProfile.SetFont(&m_ftHead);
	m_cmbVideoCodecProfile.SetCaretPos(CPoint(12, 148));
	m_cmbVideoCodecProfile.ShowCaret();
	for (int i = 0; i < m_vecVideoCodecProfileString.size(); ++i){
		m_cmbVideoCodecProfile.InsertString(i, m_vecVideoCodecProfileString[i]);
	}
	m_cmbVideoCodecProfile.SetCurSel(2);

	m_cmbAudioSampleRate.MoveWindow(80, 214, 195, 24, TRUE);
	m_cmbAudioSampleRate.SetFont(&m_ftHead);
	m_cmbAudioSampleRate.SetCaretPos(CPoint(12, 148));
	m_cmbAudioSampleRate.ShowCaret();
	for (int i = 0; i < m_vecAudioSampleRateString.size(); ++i){
		m_cmbAudioSampleRate.InsertString(i, m_vecAudioSampleRateString[i]);
	}
	m_cmbAudioSampleRate.SetCurSel(1);

	m_edbAudBitrate.MoveWindow(283, 214, 70, 24, TRUE);
	m_edbAudBitrate.SetFont(&m_ftHead);
	m_edbAudBitrate.SetCaretPos(CPoint(12, 148));
	m_edbAudBitrate.ShowCaret();
	m_edbAudBitrate.SetTip(LANG_STR("IDS_PUB_AUDBITERATETIP"));

	m_cmbAudioChannels.MoveWindow(366, 214, 40, 24, TRUE);
	m_cmbAudioChannels.SetFont(&m_ftHead);
	m_cmbAudioChannels.SetCaretPos(CPoint(12, 148));
	m_cmbAudioChannels.ShowCaret();
	for (int i = 0; i < 5; ++i){
		CString index;
		index.Format(_T("%d"), i+1);
		m_cmbAudioChannels.InsertString(i, index);
	}
	m_cmbAudioChannels.SetCurSel(1);

	m_staTranscodingUser.MoveWindow(80, 295, 130, 24, TRUE);
	m_cmbWaterMark.MoveWindow(170, 295, 100, 24, TRUE);
	m_cmbWaterMark.InsertString(0, _T("None"));
	m_cmbWaterMark.InsertString(1, _T("Locale File"));
	m_cmbWaterMark.InsertString(2, _T("Image http url"));
	m_cmbWaterMark.SetCurSel(2);

	m_edbWaterMarkX.MoveWindow(80, 330, 80, 24, TRUE);
	m_edbWaterMarkX.SetFont(&m_ftHead);
	m_edbWaterMarkX.SetCaretPos(CPoint(12, 148));
	m_edbWaterMarkX.ShowCaret();
	m_edbWaterMarkX.SetTip(_T("X"));

	m_edbWaterMarkY.MoveWindow(162, 330, 80, 24, TRUE);
	m_edbWaterMarkY.SetFont(&m_ftHead);
	m_edbWaterMarkY.SetCaretPos(CPoint(12, 148));
	m_edbWaterMarkY.ShowCaret();
	m_edbWaterMarkY.SetTip(_T("Y"));

	m_edbWaterMarkWidth.MoveWindow(244, 330, 80, 24, TRUE);
	m_edbWaterMarkWidth.SetFont(&m_ftHead);
	m_edbWaterMarkWidth.SetCaretPos(CPoint(12, 148));
	m_edbWaterMarkWidth.ShowCaret();
	m_edbWaterMarkWidth.SetTip(_T("Width"));

	m_edbWaterMarkHeight.MoveWindow(326, 330, 80, 24, TRUE);
	m_edbWaterMarkHeight.SetFont(&m_ftHead);
	m_edbWaterMarkHeight.SetCaretPos(CPoint(12, 148));
	m_edbWaterMarkHeight.ShowCaret();
	m_edbWaterMarkHeight.SetTip(_T("Height"));

	m_edbWaterMarkPath.SetTip(_T("Local File/Image http url"));
	m_edbWaterMarkPath.MoveWindow(80, 362, 290, 24, TRUE);
	m_btnBrowse.MoveWindow(396, 362, 30, 24);

	m_chkTranscoding.SetCheck(1);
}

void CPublisherDlg::OnBnClickedBtnconfirmPub()
{
	
	CAgoraObject *lpAgoraObject = CAgoraObject::GetAgoraObject();
	GetDlgItemText(IDC_EDPUBSTRING_PUB, m_strPubParam);
	GetDlgItemText(IDC_EDINJECT_PUB, m_strPubInject);

	m_nWidth = GetDlgItemInt(IDC_EDWIDTH_PUB, NULL, FALSE);
	m_nHeight = GetDlgItemInt(IDC_EDHEIGHT_PUB, NULL, FALSE);
	m_nFramerate = GetDlgItemInt(IDC_EDFR_PUB, NULL, FALSE);
	m_nBitrate = GetDlgItemInt(IDC_EDBR_PUB, NULL, FALSE);
	videoGop = GetDlgItemInt(IDC_EDT_GOP, NULL, FALSE);
	//m_nAudioSampleRate = GetDlgItemInt(IDC_EDAUDSAPRATE_PUB, NULL, FALSE);
	m_nAudioBitrate = GetDlgItemInt(IDC_EDAUDBITRATE_PUB, NULL, FALSE);
	//m_nAudioChannel = GetDlgItemInt(IDC_EDAUDCHANNEL_PUB, NULL, FALSE);
	
	CHAR	szPubURL[256];
	CHAR	szPubInject[256];

#ifdef UNICODE
	CHAR	szParam[256];

	memset(szParam, 0, 256);
	::WideCharToMultiByte(CP_UTF8, 0, m_strPubParam, -1, szParam, 256, NULL, NULL);
	::WideCharToMultiByte(CP_UTF8, 0, m_strPubInject, -1, szPubInject, 256, NULL, NULL);
	strcpy_s(szPubURL, 256, szParam);

#else
	strcpy_s(szPubURL, 256, m_strPubParam);
	strcpy_s(szPubInject, 256, m_strPubInject);
	
#endif
	publish_rtmp_url = szPubURL;
	bTranscoding = m_chkTranscoding.GetCheck();

	liveTranscoding.lowLatency = true;
	if (m_nWidth > 0) liveTranscoding.width  = m_nWidth;
	if (m_nHeight > 0) liveTranscoding.height = m_nHeight;

	if (m_nFramerate > 0) liveTranscoding.videoFramerate = m_nFramerate;
	if (m_nBitrate > 0) liveTranscoding.videoBitrate = m_nBitrate;
	if (videoGop > 0)liveTranscoding.videoGop = videoGop;
	
	liveTranscoding.videoCodecProfile = m_vecVideoCodecProfile[m_cmbVideoCodecProfile.GetCurSel()];
	liveTranscoding.audioBitrate = m_vecAudioSampleRate[m_cmbAudioSampleRate.GetCurSel()];
	liveTranscoding.audioChannels = m_cmbAudioSampleRate.GetCurSel() + 1;
	
	m_watertype = m_cmbWaterMark.GetCurSel();
	GetDlgItemText(IDC_EDWTMRPATH_PUB, waterFilePath);
	rcWaterMark.left = static_cast<int>(GetDlgItemInt(IDC_EDWTMRX_PUB, NULL, TRUE));
	rcWaterMark.right = rcWaterMark.left + static_cast<int>(GetDlgItemInt(IDC_EDWTMRWIDTH_PUB, NULL, TRUE));
	rcWaterMark.top = static_cast<int>(GetDlgItemInt(IDC_EDWTMRY_PUB, NULL, TRUE));
	rcWaterMark.bottom = rcWaterMark.top + static_cast<int>(GetDlgItemInt(IDC_EDWTMRHEIGHT_PUB, NULL, TRUE));

	CDialogEx::OnOK();
}


void CPublisherDlg::OnPaint()
{
	CPaintDC dc(this); // device context for painting
	DrawClient(&dc);
}

void CPublisherDlg::DrawClient(CDC *lpDC)
{
	CRect	rcText;
	CRect	rcClient;
	LPCTSTR lpString = NULL;

	GetClientRect(&rcClient);

	lpDC->FillSolidRect(0, 0, rcClient.Width(), 16, RGB(0x00, 0x9E, 0xEB));
}

void CPublisherDlg::OnBnClickedBtnbrowsePub()
{
	
	CFileDialog dlg(TRUE, NULL, NULL, 6, _T("PNG Files(*.png)|*.png|BMP Files(*.bmp)|*.bmp|JPEG Files(jpeg)|*.jpeg|All Files(*.*)|*.*||"), this);

	if (dlg.DoModal() != IDOK)
		return;

	SetDlgItemText(IDC_EDWTMRPATH_PUB, dlg.GetPathName());
}


void CPublisherDlg::OnBnClickedBtncancelPub()
{
	
	CDialogEx::OnCancel();
}
