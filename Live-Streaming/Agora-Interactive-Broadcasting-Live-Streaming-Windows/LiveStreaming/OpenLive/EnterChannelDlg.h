#pragma once
#include "AGButton.h"
#include "AGEdit.h"
#include "AGComboBox.h"
#include "DeviceDlg.h"
#include "afxwin.h"
#include "afxlistctrl.h"

// CEnterChannelDlg Dialog

class CEnterChannelDlg : public CDialogEx
{
	DECLARE_DYNAMIC(CEnterChannelDlg)

public:
	CEnterChannelDlg(CWnd* pParent = NULL);
	virtual ~CEnterChannelDlg();

	CString GetChannelName();

	void SetVideoString(LPCTSTR lpVideoString);
// Dialog Data
	enum { IDD = IDD_ENTERCHANNEL_DIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV Support
	virtual BOOL OnInitDialog();
	virtual BOOL PreTranslateMessage(MSG* pMsg);

	afx_msg void OnPaint();
	afx_msg void OnBnClickedBtntestChannel();
	afx_msg void OnBnClickedBtnjoinChannel();
	afx_msg void OnBnClickedBtnsetChannel();
	afx_msg void OnCbnSelchangeCmbRole();
	DECLARE_MESSAGE_MAP()

protected:
	void InitCtrls();
	void DrawClient(CDC *lpDC);

private:
	CAGEdit			m_ctrChannel;
    CAGEdit         m_ctrPassword;
    CAGButton		m_btnTest;
	CAGButton		m_btnJoin;
	CAGButton		m_btnSetup;
	CAGButton       m_btnRTMP;

	CFont			m_ftChannel;
	CFont			m_ftHead;
	CFont			m_ftDesc;
	CFont			m_ftBtn;

	CPen            m_penFrame;
	CDeviceDlg		m_dlgDevice;

	CAGComboBox		m_ctrRole;

public:
	afx_msg void OnBnClickedBtnRtmp();
};
