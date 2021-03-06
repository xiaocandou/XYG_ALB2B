package com.xinyiglass.springSample.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.socket.TextMessage;

import xygdev.commons.entity.PlsqlRetValue;
import xygdev.commons.util.TypeConvert;

import com.xinyiglass.springSample.service.MailService;
import com.xinyiglass.springSample.service.UserVOService;
import com.xinyiglass.springSample.websocket.SystemWebSocketHandler;

@Controller
@RequestMapping("/mail")
@Scope("prototype")
public class MailController {
	
	@Autowired
	MailService ms;
	@Autowired
	UserVOService uvs;
	
	protected HttpServletRequest req; 
    protected HttpServletResponse res; 
    protected HttpSession sess; 
    protected Long loginId; 
    
    @ModelAttribute 
    public void setReqAndRes(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{ 
        this.req = request; 
        this.res = response; 
        this.sess = request.getSession(); 
        req.setCharacterEncoding("utf-8");
		res.setCharacterEncoding("utf-8");
		res.setContentType("text/html;charset=utf-8");  
	    loginId=(Long)sess.getAttribute("LOGIN_ID");
    } 
    
    @Bean
    public SystemWebSocketHandler systemWebSocketHandler() {
        return new SystemWebSocketHandler();
    }
    
    @RequestMapping("/RecMail.do")
	public String RecMailBox(){
		return "mail/receive";
	}
    
    @RequestMapping("/SendMail.do")
	public String SendMailBox(){
		return "mail/send";
	}
    
    @RequestMapping(value = "/getRecMail.do", method = RequestMethod.POST)
	public void getRecMail() throws Exception
	{   	
		int pageSize = Integer.parseInt(req.getParameter("pageSize"));
		int pageNo = Integer.parseInt(req.getParameter("pageNo"));
		boolean goLastPage = Boolean.parseBoolean(req.getParameter("goLastPage"));
   		Map<String,Object> conditionMap=new HashMap<String,Object>();
   		conditionMap.put("orderBy", req.getParameter("orderby"));
   		conditionMap.put("userId", (Long)sess.getAttribute("USER_ID"));
   		conditionMap.put("sendUserId", TypeConvert.str2Long(req.getParameter("SEND_USER_ID")));
   		conditionMap.put("sendId", TypeConvert.str2Long(req.getParameter("SEND_ID")));
   		conditionMap.put("mailTitle", req.getParameter("MAIL_TITLE"));
   		conditionMap.put("sendDate_F", TypeConvert.str2uDate(req.getParameter("SEND_DATE_F")));
   		conditionMap.put("sendDate_T", TypeConvert.str2uDate(req.getParameter("SEND_DATE_T")));
   		conditionMap.put("readDate_F", TypeConvert.str2uDate(req.getParameter("READ_DATE_F")));
   		conditionMap.put("readDate_T", TypeConvert.str2uDate(req.getParameter("READ_DATE_T")));
		res.getWriter().print(ms.findForRecMail(pageSize, pageNo, goLastPage, conditionMap,loginId));
	}
    
    @RequestMapping(value = "/getSendMail.do", method = RequestMethod.POST)
	public void getSendMail() throws Exception
	{   	
		int pageSize=Integer.parseInt(req.getParameter("pageSize"));
		int pageNo=Integer.parseInt(req.getParameter("pageNo"));
		boolean goLastPage=Boolean.parseBoolean(req.getParameter("goLastPage"));
   		Map<String,Object> conditionMap=new HashMap<String,Object>();
   		conditionMap.put("orderBy", req.getParameter("orderby"));
   		conditionMap.put("userId", (Long)sess.getAttribute("USER_ID"));
   		conditionMap.put("sendTitle", req.getParameter("SEND_TITLE"));
   		conditionMap.put("sendDate_F", TypeConvert.str2uDate(req.getParameter("SEND_DATE_F")));
   		conditionMap.put("sendDate_T", TypeConvert.str2uDate(req.getParameter("SEND_DATE_T")));
		res.getWriter().print(ms.findForSendMail(pageSize, pageNo, goLastPage, conditionMap,loginId));
	}
    
    @RequestMapping(value = "/getRecMailDetail.do", method = RequestMethod.POST)
    public void getRecMailDetail() throws Exception
    {
    	Long sendid=TypeConvert.str2Long(req.getParameter("SEND_ID"));
    	res.getWriter().print(ms.findRecMailByIdForJson(sendid,loginId));
    }
    
    @RequestMapping(value = "/getSendMailDetail.do", method = RequestMethod.POST)
    public void getSendMailDetail() throws Exception
    {
    	Long sendid=TypeConvert.str2Long(req.getParameter("SEND_ID"));
    	res.getWriter().print(ms.findSendMailByIdForJson(sendid,loginId));
    }
    
    @RequestMapping(value = "/delRecMail.do", method = RequestMethod.POST)
	public void delRecMail() throws Exception
	{   	
		Long recid = Long.parseLong(req.getParameter("RECEIVE_ID"));
		res.getWriter().print(ms.delRecMail(recid,loginId).toJsonStr());
	}
    
    @RequestMapping(value = "/updateRecMail.do", method = RequestMethod.POST)
	public void updateRecMail() throws Exception
	{ 
    	Long recid = Long.parseLong(req.getParameter("RECEIVE_ID"));
    	res.getWriter().print(ms.updateRecMail(recid,loginId).toJsonStr());
	}
    
    @RequestMapping(value = "/insertSendMail.do", method = RequestMethod.POST)
	public void insertSendMail() throws Exception
	{ 
    	Long sendUserId = (Long)sess.getAttribute("USER_ID");
    	String title=req.getParameter("SEND_TITLE");
    	String content=req.getParameter("SEND_CONTENT");
    	String allUserFlag=req.getParameter("ALLUSER_FLAG");
    	String sendType=null;
    	if(allUserFlag!=null&&allUserFlag.equals("on")){
    		sendType="ALL_USERS";
    	}else{
    		sendType="USERS";
    	}
    	String recUser=req.getParameter("REC_USER");
    	System.out.println("Ruser:"+recUser);
    	PlsqlRetValue  ret=ms.insertSendMail(sendUserId, title, content, sendType, recUser,loginId);
    	if(ret.getRetcode()==0){
    		if(sendType.equals("ALL_USERS")){
    			recUser = uvs.findOtherUsers(sendUserId,loginId);
    		}
    		ArrayList<Long> userIdList=new ArrayList<Long>();
			for(String userIdStr:recUser.split(",")){
				userIdList.add(Long.parseLong(userIdStr));
				//System.out.println("user_id:"+Long.parseLong(userIdStr));
			}
			String message="您有新邮件:"+title;
			systemWebSocketHandler().sendMessageToUsers(userIdList, new TextMessage(message));
    	}
    	res.getWriter().print(ret.toJsonStr());
	}
    
    @RequestMapping(value = "/countUnReadMail.do", method = RequestMethod.POST)
   	public void countUnReadMail() throws Exception
   	{ 
       	Long recid = (Long)sess.getAttribute("USER_ID");
       	res.getWriter().print(ms.countUnReadMail(recid,loginId));
   	}
    
    @RequestMapping(value = "/findUnReadMail.do", method = RequestMethod.POST)
   	public void findUnReadMail() throws Exception
   	{ 
       	Long recid = (Long)sess.getAttribute("USER_ID");
       	res.getWriter().print(ms.findUnReadMailForJson(recid,loginId));
   	}
    
    @RequestMapping(value = "/findSendUser.do", method = RequestMethod.GET)
   	public void findSendUser() throws Exception
   	{ 
    	String username=req.getParameter("query");
    	Long sendUserId = (Long)sess.getAttribute("USER_ID");
       	res.getWriter().print(uvs.findUserForLOV(sendUserId, username,loginId));
   	}
    

}
