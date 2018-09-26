#pragma once
#include "AGEdit.h"
#include "AGButton.h"
#include "AGComboBox.h"
#include "afxwin.h"
#include <string>
#include <vector>
// CPublisherDlg Dialog

class CPublisherDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CPublisherDlg)

public:
	CPublisherDlg(CWnd* pParent = NULL);
	virtual ~CPublisherDlg();

// Dialog Data
	enum { IDD = IDD_PUBLISHER_DIALOG };

	int GetWidth() { return m_nWidth; };
	int GetHeight() { return m_nHeight; };
	int GetFramerate() { return m_nFramerate; };
	int GetBitrate() { return m_nBitrate; };
	int GetLifecycle() { return m_nLifeCycle; };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV Support
	virtual BOOL OnInitDialog();

	afx_msg void OnPaint();

	afx_msg void OnBnClickedBtnconfirmPub();
	afx_msg void OnBnClickedBtnbrowsePub();
	afx_msg void OnBnClickedBtncancelPub();

	DECLARE_MESSAGE_MAP()

protected:
	void InitCtrls();
	void DrawClient(CDC *lpDC);

public:
	bool bTranscoding;
	std::string publish_rtmp_url;
	
	int m_watertype;
	LiveTranscoding liveTranscoding;
	CRect		rcWaterMark;
	CString		waterFilePath;
private:
	CString	m_strPubParam;
	CString	m_strPubInject;
	std::string injectStreamUrl;
	bool lowLatency;
	
	int		m_nLifeCycle;
	int		m_nWidth;
	int		m_nHeight;
	int		m_nFramerate;
	int		m_nBitrate;
	int		m_nAudioSampleRate;
	int		m_nAudioBitrate;
	int		m_nAudioChannel;

	int     videoGop;
	int     bgColor;
	VIDEO_CODEC_PROFILE_TYPE videoCodecProfile;
private:
	CAGButton		m_btnCancel;
	CAGButton		m_btnConfirm;

	CAGEdit			m_edbPbuString;

	CAGEdit			m_edbWidth;
	CAGEdit			m_edbHeight;
	CAGEdit			m_edbFramerate;
	CAGEdit			m_edbBitrate;

	CAGEdit			m_edbAudBitrate;
//	CAGEdit			m_edbAudChannel;

	CAGEdit			m_edbWaterMarkX;
	CAGEdit			m_edbWaterMarkY;
	CAGEdit			m_edbWaterMarkWidth;
	CAGEdit			m_edbWaterMarkHeight;
	CAGEdit			m_edbWaterMarkPath;
	CButton			m_btnBrowse;

	CFont			m_ftHead;
	CFont			m_ftDesc;
	CFont			m_ftBtn;
	CPen			m_penFrame;
	

public:
	CStatic m_staTranscodingUser;
	CButton m_chkTranscoding;
	CAGEdit m_edtGOP;
	CComboBox m_cmbVideoCodecProfile;

	std::vector<VIDEO_CODEC_PROFILE_TYPE> m_vecVideoCodecProfile;
	std::vector<CString> m_vecVideoCodecProfileString;
	std::vector<AUDIO_SAMPLE_RATE_TYPE> m_vecAudioSampleRate;
	std::vector<CString> m_vecAudioSampleRateString;
	CComboBox m_cmbAudioChannels;
	CComboBox m_cmbAudioSampleRate;
	CComboBox m_cmbWaterMark;
};
