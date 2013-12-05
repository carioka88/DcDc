#!/usr/bin/python
# -*- coding: utf-8 -*-
import wx
import sys

def create(parent):
    return Frame1(parent)

[wxID_FRAME1, wxID_FRAME1BUTTON1, wxID_FRAME1PANEL1, wxID_FRAME1TEXT1, wxID_FRAME1EXIT, wxID_FRAME1COMMENT
] = [wx.NewId() for _init_ctrls in range(6)]

class Frame1(wx.Frame):
    def _init_ctrls(self, prnt):
        # generated method, don't edit
        wx.Frame.__init__(self, id=wxID_FRAME1, name='', parent=prnt,
              pos=wx.Point(249, 224), size=wx.Size(683, 445),
              style=wx.DEFAULT_FRAME_STYLE, title='Scanner Info')

        self.SetClientSize(wx.Size(350, 200))

        self.panel1 = wx.Panel(id=wxID_FRAME1PANEL1, name='panel1', parent=self,
              pos=wx.Point(0, 0), size=wx.Size(200, 100),
              style=wx.TAB_TRAVERSAL)

        self.panel1.SetBackgroundColour('#D9EDC5')
        self.textInput = wx.TextCtrl(id=wxID_FRAME1TEXT1, name=u'textInput',
              parent=self.panel1, pos=wx.Point(20, 10), size=wx.Size(203, 25),
              style=0, value=u'scan')

        self.comment1 = wx.StaticText(self.panel1, label ="1) CONNECT THE CONVERTER", pos = wx.Point(20,50))
        
        if len(sys.argv) > 1:

            message = sys.argv[1]

        else:
            message = ""

        self.comment = wx.StaticText(self.panel1, label ="2) SCAN THE CONVERTER", pos = wx.Point(20,75))
        
        self.comment2 = wx.StaticText(self.panel1, label =message, pos = wx.Point(20,100), size=wx.Size(203, 25))

        font = wx.Font(12,wx.ROMAN, wx.NORMAL, wx.BOLD)
        self.comment1.SetFont(font)
        self.comment.SetFont(font)
        font2 = wx.Font(12,wx.ROMAN, wx.NORMAL, wx.BOLD)
        self.comment2.SetFont(font2)
        self.comment2.SetForegroundColour(wx.RED)

        self.button1 = wx.Button(id=wxID_FRAME1BUTTON1, label=u'ACCEPT',
              name='button1', parent=self.panel1, pos=wx.Point(20, 145),
              size=wx.Size(85, 27), style=0)
        self.button1.Bind(wx.EVT_BUTTON, self.OnButton1Button,
              id=wxID_FRAME1BUTTON1)
        
        self.button1.SetBackgroundColour('#9BCF7A')

        self.button2 = wx.Button(id=wxID_FRAME1EXIT, label=u'EXIT',
              name='button2', parent=self.panel1, pos=wx.Point(160, 145),
              size=wx.Size(85, 27), style=0)
        self.button2.Bind(wx.EVT_BUTTON, self.OnButton2Button,
              id=wxID_FRAME1EXIT)

        self.button2.SetBackgroundColour('#9BCF7A')

    def __init__(self, parent):
        self._init_ctrls(parent)

    def OnButton1Button(self, event):
        print(self.textInput.GetValue())
        self.Close()

    def OnButton2Button(self, event):
        print("Exit")
        self.Close()


if __name__ == '__main__':
    app = wx.PySimpleApp()
    frame = create(None)
    frame.Show()

    app.MainLoop()