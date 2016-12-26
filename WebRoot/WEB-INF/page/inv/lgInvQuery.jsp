<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"
	      import="java.util.*" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>
<html>
  <head>
    <title>大板玻璃库存查询</title>
    <base href="<%=basePath%>"> 
    <meta http-equiv="content-type" content="text/html;charset=gb2312">
	<link rel="stylesheet" href="plugin/css/font-awesome.min.css">
	<link rel="stylesheet" href="plugin/css/jquery-ui.min.css">
	<link rel="stylesheet" type="text/css" href="plugin/css/public.css">
	<link rel="stylesheet" type="text/css" href="plugin/css/inv/inv.css">
	<script type="text/javascript" src="plugin/jQuery/jQuery-2.1.4.min.js"></script>
	<script src="plugin/jQuery/jquery-ui.min.js"></script>	
  </head> 
  <body>
    <div id="container">
      <!-- 数据加载动画 start -->
  	  <div class="ajax_loading">
        <i class="fa fa-spinner fa-pulse fa-4x" style="color:white"></i>
      </div>
      <!-- 数据加载动画 end -->
    
      <!-- 主表格区域 start -->
      <div class="table">
        <table id="tb" data-table="LgInv">
          <tr>
            <th class="ORGANIZATION_NAME" data-column="db">库存组织</th>
            <th class="ITEM_NUMBER" data-column="db">物料编码</th>
     	    <th class="ITEM_DESC" data-column="db">物料描述</th>
     	    <th class="LONG_DESC" data-column="db">详细描述</th>
     	    <th class="ONHAND_UOM_CODE" data-column="db">主单位</th>
     	    <th class="THICKNESS" data-column="db">厚度</th>
     	    <th class="SPEC" data-column="db">规格</th>
     	    <th class="COATING_TYPE" data-column="db">膜系</th>
     	    <th class="PIE_QTY" data-column="db">片/箱</th>
     	    <th class="DISPLAY_TON_QTY" data-column="db">总吨数</th>
     	    <th class="DISPLAY_ONHAND_QTY" data-column="db">可用量</th>
     	    <th class="DISPLAY_SQM_QTY" data-column="db">总平米数</th>
     	    <th class="DISPLAY_BOX_QTY" data-column="db">总箱数</th>
     	    <th class="ORGANIZATION_ID" style="display:none" data-column="hidden">&nbsp;</th>
     	    <th class="INVENTORY_ITEM_ID" style="display:none" data-column="hidden">&nbsp;</th>
     	  </tr>
     	  <tr>
     	    <td class="ORGANIZATION_NAME" data-column="db"></td>
            <td class="ITEM_NUMBER" data-column="db"></td>
     	    <td class="ITEM_DESC" data-column="db"></td>
     	    <td class="LONG_DESC" data-column="db"></td>
     	    <td class="ONHAND_UOM_CODE" data-column="db"></td>
     	    <td class="THICKNESS" data-column="db"></td>
     	    <td class="SPEC" data-column="db"></td>
     	    <td class="COATING_TYPE" data-column="db"></td>
     	    <td class="PIE_QTY" data-column="db"></td>
     	    <td class="DISPLAY_TON_QTY" data-column="db"></td>
     	    <td class="DISPLAY_ONHAND_QTY" data-column="db"></td>
     	    <td class="DISPLAY_SQM_QTY" data-column="db"></td>
     	    <td class="DISPLAY_BOX_QTY" data-column="db"></td>
     	    <td class="ORGANIZATION_ID" style="display:none" data-column="hidden">&nbsp;</td>
     	    <td class="INVENTORY_ITEM_ID" style="display:none" data-column="hidden">&nbsp;</td>
     	  </tr>
        </table>
      </div>
      <!-- 主表格区域 end -->
   
      <!-- 主表格按钮区域 start -->
      <div class="table_button" id="table" data-table="LgInv">
        <div class="setting">
          <i class="fa fa-cog pointer" data-reveal-id="setting" data-dismissmodalclass="close-setting"></i>
        </div>
        <div class="setting">
          <i class="fa fa-search pointer" data-reveal-id="query" data-key="true" data-dismissmodalclass="close-query-frame"></i>
        </div>
        <div class="setting">
          <i id='refresh' class="fa fa-refresh pointer" data-pagetype='refresh' data-pageframe="table" data-func="$().validateOrgan()"></i>
        </div>
        <div id="setting">
          <!-- 设置菜单区域 start -->
          <jsp:include page="../public/setting.jsp" >
			<jsp:param name="rdtable" value="#tb" />
			<jsp:param name="odtable" value="#tb" />
			<jsp:param name="pageframe" value="table" />
		  </jsp:include>
          <!-- 设置菜单区域 end -->    
        </div>
        <div>
          <!-- 分页按钮区域 start -->
          <jsp:include page="../public/pageArrow.jsp" >
			<jsp:param name="pageframe" value="table" />
		  </jsp:include>
          <!-- 分页按钮区域 end -->
          <input type="hidden" data-type="size" id="page_size" value="10"/>
          <input type="hidden" data-type="number" id="page_no" value="1"/>
          <input type="hidden" data-type="orderby" id="ORDER_BY" value="INVENTORY_ITEM_ID DESC"/> 
          <input type="hidden" data-type="cond"/>
          <input type="hidden" data-type="autoquery" value="N"/>
          <input type="hidden" data-type="url" value="inv/getLgInvPage.do"/>
          <input type="hidden" data-type="jsontype" value="table"/> 
        </div>
      </div>
      <!-- 主表格按钮区域 end --> 
   
      <!-- 定义列区域 start --> 
      <jsp:include page="../public/rowdefine.jsp"></jsp:include>
      <!-- 定义列区域 end -->
    
      <!-- 多维排序区域 start -->
      <jsp:include page="../public/orderby.jsp"></jsp:include>
      <!-- 多维排序区域 end -->
   
      <!-- 个人配置区域 start -->
      <jsp:include page="../public/config.jsp"></jsp:include>
      <!-- 个人配置区域 end -->
     
      <!-- lov区域 start -->
      <jsp:include page="../public/lov.jsp"></jsp:include>
      <!-- lov区域 end -->
     
      <!-- 条件查询区域 start -->
      <div id='query' class='query_frame'>     
        <div class='title'>      
          <span><i class="fa fa-cubes"></i>&nbsp;查询条件</span>
        </div>
        <a class="close-query-frame" data-type="close">&#215;</a>
        <div class='line'></div>
        <div class='content'>
          <form>
            <label for='ORGANIZATION_CODE' class='left mid'>库存编码</label> 
            <input type='text' id='ORGANIZATION_CODE' name='ORGANIZATION_CODE' class='left short' required="required" readonly="readonly"/>          
            <input type='hidden' id='ORGANIZATION_ID' name='ORGANIZATION_ID'/>
            <input type='button' id="ORGANIZATION_LOV" class='left button pointer' data-pageframe="lov" data-reveal-id="lov" data-key="true" data-callback="query" data-bg="lov-modal-bg" data-dismissmodalclass='close-lov' data-lovname="库存组织查询" data-queryurl="lov/getJbUserOrganPage.do" data-jsontype="organ" data-defaultquery="true" data-th=["库存id","库存编码","库存组织"] data-td=["ORGANIZATION_ID","ORGANIZATION_CODE","ORGANIZATION_NAME"] data-selectname=["库存编码","库存组织"] data-selectvalue=["ORGANIZATION_CODE","ORGANIZATION_NAME"] data-choose=[".ORGANIZATION_ID",".ORGANIZATION_CODE",".ORGANIZATION_NAME"] data-recid=["#ORGANIZATION_ID","#ORGANIZATION_CODE","#ORGANIZATION_NAME"] value="···"/>
            <label for='ORGANIZATION_NAME' class='left mid'>库存组织</label>
            <input type='text' id='ORGANIZATION_NAME' name='ORGANIZATION_NAME' required='required' class='left long' readonly="readonly"/>
            <label for='COATING_NAME' class='left mid'>膜系</label> 
            <input type='text' id='COATING_NAME' name='COATING_NAME' class='left short' data-modify="true" data-pageframe="query" data-validurl="lov/validCoating.do" data-queryurl="lov/getCoatingCode.do" data-lovbtn="COATING_LOV" data-hiddenid=["COATING_CODE"] data-hiddenval=["LOOKUP_CODE"] data-param="meaning"/>          
            <input type='hidden' id='COATING_CODE' name='COATING_TYPE'/>
            <input type='button' id="COATING_LOV" class='left button pointer' data-pageframe="lov" data-reveal-id="lov" data-key="true" data-callback="query" data-bg="lov-modal-bg" data-dismissmodalclass='close-lov' data-lovname="膜系查询" data-queryurl="lov/getCoatingPage.do" data-jsontype="coating" data-defaultquery="true" data-th=["膜系编码","膜系名称","描述"] data-td=["COATING_CODE","COATING_NAME","COATING_DESC"] data-selectname=["膜系编码","膜系名称"] data-selectvalue=["LOOKUP_CODE","MEANING"] data-choose=[".COATING_CODE",".COATING_NAME"] data-recid=["#COATING_NAME","#COATING_CODE"] value="···"/>    
            <label for='THICKNESS' class='left mid'>厚度</label> 
            <input type='text' id='THICKNESS' name='THICKNESS' class='left long'/>
            <label for='WIDTH' class='left mid'>宽度</label> 
            <input type='text' id='WIDTH' name='WIDTH' class='left long'/>
            <label for='HEIGHT' class='left mid'>高度</label> 
            <input type='text' id='HEIGHT' name='HEIGHT' class='left long'/>
          </form>
        </div>
        <div class='foot'>             
          <button class="right pointer"  data-buttonframe="table" data-keyup="enter" data-crudtype="query" data-pageframe="query">查询</button>
        </div> 
      </div>
      <!-- 条件查询区域 end -->    
      
      <!-- 用户信息存放区域 start -->
      <input type="hidden" id="USER_ID" value="${USER_ID}"/>  
      <input type="hidden" id="INTERACT_CODE" value="LG_INV"/> 
      <input type="hidden" id="HEADER_ID" value=""/> 
      <!-- 用户信息存放区域 end -->  
    </div>   
    <script>       
        $(function() {
            //设置拖拽
    		$("#query").draggable({ handle: ".title" });
    		
    		$().crudListener();	
    		
    		$.fn.validateOrgan = function(){
    		   organizationId = $('#ORGANIZATION_ID').val();
    		   if(organizationId==null||organizationId==''){
    		       $('.ajax_loading').hide();
    		       layer.alert('必须选择库存组织才能查询库存！',{skin:'layui-layer-lan',title:'警告',offset:[150]});
    		       throw new error('必须选择库存组织才能查询库存！');
    		   }  
    		} 		
        });
        
        jQuery.json={
        	getContent:function(data,JSONtype){  
        	    if(JSONtype=='table'){
        	        for(i=0;i<(pageMaxRow-pageMinRow+1);i++){
                    	$('.ORGANIZATION_NAME',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].ORGANIZATION_NAME); 
                   	 	$('.ITEM_NUMBER',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].ITEM_NUMBER); 
                    	$('.ITEM_DESC',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].ITEM_DESC);
                    	$('.LONG_DESC',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].LONG_DESC); 
                    	$('.ONHAND_UOM_CODE',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].ONHAND_UOM_CODE);   
                    	$('.THICKNESS',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].THICKNESS);   
                    	$('.SPEC',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].SPEC); 
                    	$('.COATING_TYPE',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].COATING_TYPE); 
                    	$('.PIE_QTY',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].BOX_PIE_QTY); 
                    	$('.DISPLAY_TON_QTY',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].DISPLAY_TON_QTY); 
                    	$('.DISPLAY_ONHAND_QTY',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].DISPLAY_ONHAND_QTY); 
                    	$('.DISPLAY_SQM_QTY',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].DISPLAY_SQM_QTY); 
                    	$('.DISPLAY_BOX_QTY',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].DISPLAY_BOX_QTY); 
                    	$('.ORGANIZATION_ID',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].ORGANIZATION_ID); 
                    	$('.INVENTORY_ITEM_ID',$('#tb tr:eq('+(i+1)+')')).html(data.rows[i].INVENTORY_ITEM_ID); 
                	}
                	$().crudListener();
                	$().revealListener(); 
        	    }else if(JSONtype=='organ'){
        	        if(pageMaxRow==0&&pageMinRow==0){
        	            console.log('no data');
        	        }else{
        	            for(i=0;i<(pageMaxRow-pageMinRow+1);i++){
       	            	    $('td:eq(0)',$('.contentbox tr:eq('+(i+1)+')')).html(data.rows[i].ORGANIZATION_ID);  
       	            	    $('td:eq(1)',$('.contentbox tr:eq('+(i+1)+')')).html(data.rows[i].ORGANIZATION_CODE);     	                    
       	            	    $('td:eq(2)',$('.contentbox tr:eq('+(i+1)+')')).html(data.rows[i].ORGANIZATION_NAME);    	               	        
       	            	} 
        	        }       	            	    
        	    }else if(JSONtype=='coating'){
        	        if(pageMaxRow==0&&pageMinRow==0){
        	            console.log('no data');
        	        }else{
        	            for(i=0;i<(pageMaxRow-pageMinRow+1);i++){
       	            	    $('td:eq(0)',$('.contentbox tr:eq('+(i+1)+')')).html(data.rows[i].LOOKUP_CODE);  
       	            	    $('td:eq(1)',$('.contentbox tr:eq('+(i+1)+')')).html(data.rows[i].MEANING);     	                    
       	            	    $('td:eq(2)',$('.contentbox tr:eq('+(i+1)+')')).html(data.rows[i].DESCRIPTION);    	               	        
       	            	} 
        	        }       	            	    
        	    }      	            	   	
       	    },	
       	    getMSG:function(data){
       	        pageMinRow=parseInt(data.pageMinRow);
        	    pageMaxRow=parseInt(data.pageMaxRow);
        	    firstPageFlag=data.firstPageFlag;
        	    lastPageFlag=data.lastPageFlag;
        	   	totalPages=data.totalPages;
       	    }
       	}
    </script>
    <script type="text/javascript" src="plugin/layer/layer.js"></script>
    <script type="text/javascript" src="plugin/js/jQuery.reveal.js"></script> 
    <script type="text/javascript" src="plugin/js/jQuery.page.js"></script>
    <script type="text/javascript" src="plugin/js/jQuery.lov.js"></script> 
    <script type="text/javascript" src="plugin/js/jQuery.crud.js"></script> 
    <script type="text/javascript" src="plugin/js/jQuery.mail.js"></script> 
    <script type="text/javascript" src="plugin/js/jQuery.rowdefine.js"></script>
    <script type="text/javascript" src="plugin/js/jQuery.irr.orderby.js"></script>	
    <script type="text/javascript" src="plugin/js/jQuery.irr.init.js"></script>	    
  </body>
</html>