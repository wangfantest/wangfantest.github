## YY逆向分析

账号

2910828889----jf121121----16217435942--封

2910699550----jf121121----16217436058-封
2910825704----jf121121----16217436101-封
2910497760----jf121121----16217436045
2910812781----jf121121----16217436029
2910481366----jf121121----16217436012
2910630046----jf121121----16217435884
2910805973----jf121121----16217436054
2910762356----jf121121----16217436038



1459261448

YYID = 2910353707，UID = 2911777559，0xAD8E3317，1号

YYID = 2910828889，UID = 2911879942，0xAD8FC306，2号



# YY频道相关

频道主界面左侧的频道列表树YYChannelTreeMenuReactor



## YY频道封入黑名单

YYChannelTreeMenuReactor::onSigBanUser



## 获取频道用户信息

YYChannelTreeMenuReactor::on_personalInfo_triggered

## 获取接待频道

CChannelManagerOp::asyncChangeJiedaiSid



## 新用户监控

SInfoUserMgr::onPushChannelUser

CBizChannelDataBase::slotOnFullUserListViewAdd

YYChannelUserTreeWidget::onUserTableNotify

row dump: table=%s, ptr=0x%08X(%u), ref=%d, %s



DuiHPTreeModel::batchUpdateItems

## 设置用户马甲

YYChannelTreeMenuReactor::on_addTempVIP_triggered

YYChannelTreeMenuReactor::makeUserAs

YYChannelManageWrapper::makeUserAs

似乎有一个权限检查CChannelRulerChecker::_canDo，直接调用无效

## 发送频道消息

控件为YYChannelPage

yychannel.dll中的YYChannelSendPanelWidget::on_sendButtonClicked

yycefchannel.dll中的YYChannelMessage::sendPublicMessage ->

channellogic.dll中的YYChannelMessageLogicWrapper::sendMessage3 ->

yychannel.dll中的YYChannelMessageEdit::addCommand ->

widgetchannel.dll中的YYChannelMessageEdit::on_commandAppend

## 登录

YYLoginWidget::on_loginButton_clicked，点击登录按钮

yymainframe.dll中的YYLoginWrapper::on_updateLoginCredit函数，这里能拿到yyid。

appmain.dll中的AppWindowManager::realLogin，完成登录，这里能分析清楚账号是存哪里了。



## YY频道的设置页面

位于yycommon.dll中的YYChannelInfoSettingPage类中



## 获取当前用户账号真实ID

appmain.dll -> bizcore.dll -> LoginWrapper.dll

通过yycommon.dll中的yyim::getImId公开函数获取即可

## 获取当前账户的YYID

YYLoginWrapper::on_login_opened，此时登录完毕，关键字符串是strAccountYYid

## 获取当前频道ID

通过yycommon.dll中的yychannel::currentChannelId公开函数获取即可

## 获取当前子频道ID

通过yycommon.dll中的yychannel::currentSubChannelId公开函数获取即可

或者CChannel::getCurSubSid

## 获取当前子频道短位ID

核心位于bizchannel.dll中的CChannel::getAsid函数。

## 修改个性签名

核心是appmain.dll中的YYInfoPanel类，找到YYInfoPanel类的metacall即可。

YYInfoPanel::on_signEditLabel_clicked -> YYInfoPanel::on_signEditLabel_editLeft -> YYInfoPanel::on_signEditLabel_submit

## 修改昵称

和修改个性签名一样。

## 修改频道字体

yychannel.dll中的YYChannelSendPanelWidget::on_FontChanged函数。

yycommon.dll中的YYChannelSmileWrapper::on_fontChanged函数。

## 修改频道字体颜色

yychannel.dll中的YYChannelSendPanelWidget::on_FontColorChanged函数。

## 发送频道广播消息

yychannel.dll中的YYChannelBroadcastDlg::on_sendButton_clicked函数。

## 屏蔽频道广播消息

channellogic.dll中的YYChannelMessageLogicWrapper::onMessageArrived函数

YYChannelMsgReceiver::on_broadCastMessageArrived2

## 发送多张图片消息

widgetchannel.dll，Only can send one picture



## 获取频道列表

频道信息界面，yycommon.dll中的YYChannelInfoSettingPage

YYChannelUserTreeWidget::onChannelAdd

## 删除子频道

YYChannelMgrPwd::on_deleteSubChannelInformationDlg_buttonClicked

CChannelManagerOp::asyncDestroySubChannel

## 修改接待频道

CChannelManagerOp::asyncChangeJiedaiSid

## 创建子频道

YYCreateSubChannel::on_channelName_editingFinished

## 监控频道消息

各种各样的动作

YYChannelEchoMessageReceiver::onUserJoinByModified

[[U]%1[/U]] joined [%2]channel

顺序是

YYChannelEchoMessageReceiver::echoMessage ->

YYChannelMsgReceiver::onEchoMessageArrived ->

YYChannelMessageLogicWrapper::onMessageArrived和YYChannelMessageLogicWrapper::on_myselfMessageArrived ->

YYChannelMessageExWrapper::onMessageArrived



监控自己发的消息，关键点GetSendMessageInfo

## 新建子频道

yychannel.dll中的YYCreateSubChannel类 ->

bizchannel.dll中的CChannelManagerOp::asyncCreateSubChannel

# 麦序功能

## 设置自由模式

YYMicrophonePannel::on_freeStyle_triggered

CChannelManagerOp::asyncChangeChannelStyle

## 获取麦序用户列表

YYChannelAudioPannel::_dealwithUpdateSpeakState

这个函数会获取用户列表



YYMicrophonePannel::init，虚函数，关键字符串labelMicphoneStyle上方

## 和1号连麦

YYChannelTreeMenuReactor::on_push2MutiMai_triggered(bool checked)

## 和2号连麦

YYChannelTreeMenuReactor::on_push2MutiMai_triggered(bool checked)

## 从麦序中移除

YYChannelTreeMenuReactor::on_removeFromMaixu_triggered

## 将用户麦序上移

YYChannelTreeMenuReactor::on_moveUp

## 将用户调整到2号麦序

YYChannelTreeMenuReactor::on_move2Top_triggered

## 发送麦序提醒

YYChannelTreeMenuReactor::on_notifySecondMaixu_triggered

## 添加到麦序

YYChannelTreeMenuReactor::addMicOrderList

## 发言模式

YYChannelAudioPannel::on_speakStyleButton_clicked

YYChannelAudioPannel::updateSpeakStyleButton



speakStyleButton



## 放麦和控麦

YYMicrophonePannel::on_micControlButton_clicked

## 禁麦和开麦

YYMicrophonePannel::on_queueControlButton_clicked

YYChannelMaiXuListWrapper::forbidMaixu

## 抢麦和下麦

YYChannelMaiXuListWrapper::joinMaixu

# YY群

## 获取群消息

yycommon.dll中的ChatInformation类

bizim.dll中的CGroupText::OnGChatMsgArrive





## 真群号转文本群号

SIG_ON_GROUP_DETAILINFO

protocol::gprops::CGProperty::GetGroupProps

CGroupList::_asyncGetGroupAliasNumber

CGroupSetting::_bizsyncFetGroupDetailInfo



## 关于界面

DuiXmlUI::createFromFile

