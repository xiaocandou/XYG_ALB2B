package com.xinyiglass.springSample.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.xinyiglass.springSample.dao.RespVODao;
import com.xinyiglass.springSample.entity.RespVO;

import xygdev.commons.entity.PlsqlRetValue;
import xygdev.commons.page.PagePub;
import xygdev.commons.springjdbc.DevJdbcSubProcess;
import xygdev.commons.sqlStmt.SqlStmtPub;
import xygdev.commons.util.TypeConvert;

@Service
@Transactional(rollbackFor=Exception.class)//指定checked的异常Exception也要回滚！
public class RespVOService {
	@Autowired
	RespVODao respDao;
	@Autowired
	PagePub pagePub;
	
	public PlsqlRetValue insert(RespVO r,Long loginId) throws Exception{
		PlsqlRetValue ret=respDao.insert(r);
		if(ret.getRetcode()!=0){
			DevJdbcSubProcess.setRollbackOnly();//该事务必须要回滚！
		}
		return ret;
	}
	
	public PlsqlRetValue update(RespVO lockRespVO,RespVO updateRespVO,Long loginId) throws Exception
	{ 
		PlsqlRetValue ret=respDao.lock(lockRespVO);
		if(ret.getRetcode()==0){
			ret=respDao.update(updateRespVO);
		}else{
			DevJdbcSubProcess.setRollbackOnly();//该事务必须要回滚！
		}
		return ret;
	}
	
	@Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true)
	public String findForPage(int pageSize,int pageNo,boolean goLastPage,Map<String,Object> conditionMap,Long loginId) throws Exception{
		Map<String,Object> paramMap=new HashMap<String,Object>();
		StringBuffer sqlBuff = new StringBuffer();
		sqlBuff.append("SELECT * FROM XYG_ALB2B_RESPONSIBILITY_V A WHERE 1=1");
		sqlBuff.append(SqlStmtPub.getAndStmt("MENU_ID",conditionMap.get("menuId"),paramMap));
		sqlBuff.append(SqlStmtPub.getAndStmt("RESP_ID",conditionMap.get("respId"),paramMap));
		sqlBuff.append(SqlStmtPub.getAndStmt("START_DATE",conditionMap.get("startDate_F"),conditionMap.get("startDate_T"),paramMap));
		sqlBuff.append(" ORDER BY "+conditionMap.get("orderBy"));
		return pagePub.qPageForJson(sqlBuff.toString(), paramMap, pageSize, pageNo, goLastPage);
	}
	
	@Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true)
	public RespVO findForRespVOById(Long respId,Long loginId) throws Exception{
		return respDao.findByRespId(respId);
	}
	
	@Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true)
	public String findRespByIdForJSON(Long respId,Long loginId) throws Exception{
		return "{\"rows\":"+respDao.findByIdForJSON(respId).toJsonStr()+"}";
	}
	
	@Transactional(propagation=Propagation.NOT_SUPPORTED,readOnly=true)
	public Long findMenuId(Long respId,Long loginId) throws Exception{
		return TypeConvert.str2Long(respDao.findMenuId(respId));
	}
}
