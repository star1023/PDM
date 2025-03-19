package kr.co.aspn.vo;

import java.util.*;

import lombok.Data;
import netscape.javascript.JSObject;
import org.json.simple.JSONObject;

@Data
public class MfgProcessDoc {
	private String dNo;
	private String dpNo;
	private String docNo;
	private String docVersion;
	private String docType;
	private String calcType;
	private String apprNo;
	private String companyCode;
	private String state;
	private String stateText;
	private String ErrorMessage;
	private String memo;
	private String plantCode;
	private String plantName;
	private String stdAmount;
	private String divWeight;
	private String lineCode;
	private String lineName;
	private String mixWeight;
	private String bagAmout;
	private String bomRate;
	private String numBong;
	private String numBox;
	private String totWeight;
	private String docProdName;
	private String loss;
	private String compWeight;
	private String compWeightUnit;
	private String compWeightText;
	private String manufacturingNo;
	private String regGubun;
	private String adminWeight;
	private String distPeriDoc;
	private String dispWeight;
	private String dispWeightUnit;
	private String dispWeightText;
	private String distPeriSite;
	private String prodStandard;
	private String ingredient;
	private String usage;
	private String packMaterial;
	private String keepCondition;
	private String keepConditionCode;
	private String packUnit;
	private String childHarm;
	private String note;
	private String noteText;
	private String menuProcess;
	private String standard;
	private String docHtml;
	private String stlal;
	private String isAutoDisp;
	private String lineProcessType;
	private String regDate;
	private String regUserId;
	private String modDate;
	private String modUserId;
	private String adminWeightFrom;
	private String adminWeightUnitFrom;
	private String adminWeightTo;
	private String adminWeightUnitTo;
	private String regNum;
	private String isOld;
	private String qns; // S201109-00014
	private String isQnsReviewTarget;
	private String sellDate;
	
	private List<MfgProcessDocSubProd> sub;
	private List<MfgProcessDocItem> pkg;
	private List<MfgProcessDocItem> cons;
	private List<MfgProcessDocDisp> disp;
	private MfgProcessDocProdSpec spec;
	private MfgProcessDocProdSpecMD specMD;
	private List<FileVO> file;
	
	private List<MfgProcessDocStoreMethod> storeMethod; // 23.11.02 ���ъ�� ��議곌났���� ��議곕갑踰� 
	private List<ImageFileForStores> imageFileStores;	// 23.11.07 ���ъ�� ��議곌났���� ��議곗���� �대�몄�
	
	public List<HashMap<String,Object>> getDispByHashMap(){
		if(disp == null) return null;
		List<HashMap<String,Object>> list = new ArrayList<HashMap<String,Object>>();
		for (MfgProcessDocDisp d : disp) {
			HashMap<String,Object> dispItem = new HashMap<String,Object>();
			dispItem.put("DPNO",d.getDpNo());
			dispItem.put("DNO",d.getDNo());
			dispItem.put("DOCNO",d.getDocNo());
			dispItem.put("DOCVERSION",d.getDocVersion());
			dispItem.put("MATNAME",d.getMatName());
			dispItem.put("EXCRATE",d.getExcRate());
			dispItem.put("INCRATE",d.getIncRate());
			dispItem.put("REGDATE",d.getRegDate());
			dispItem.put("REGUSERID",d.getRegUserId());
			dispItem.put("MODDATE",d.getModDate());
			dispItem.put("MODUSERID",d.getModUserId());
			dispItem.put("ETC",d.getEtc());
			list.add(dispItem);
		}
		return list;
	}
	
	public String getDispByJsonString(){
		if(disp == null) return null;
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		boolean s = true;
		for (MfgProcessDocDisp d : disp){
			sb.append(s?"":",");
			s = false;
			Map<String,Object> dispItem = new HashMap<String,Object>();
			dispItem.put("DPNO",d.getDpNo());
			dispItem.put("DNO",d.getDNo());
			dispItem.put("DOCNO",d.getDocNo());
			dispItem.put("DOCVERSION",d.getDocVersion());
			dispItem.put("MATNAME",d.getMatName());
			dispItem.put("EXCRATE",d.getExcRate());
			dispItem.put("INCRATE",d.getIncRate());
			dispItem.put("REGDATE",d.getRegDate());
			dispItem.put("REGUSERID",d.getRegUserId());
			dispItem.put("MODDATE",d.getModDate());
			dispItem.put("MODUSERID",d.getModUserId());
			dispItem.put("ETC",d.getEtc());
			sb.append(JSONObject.toJSONString(dispItem));
		}
		sb.append("]");
		return sb.toString();
	}
	
	// ���ъ�� ��議곌났���� ��議곕갑踰�JSON
	public String getStoreMethodByJsonString(){
		if(storeMethod == null) return null;
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		boolean s = true;
		for (MfgProcessDocStoreMethod sm : storeMethod){
			sb.append(s?"":",");
			s = false;
			Map<String,Object> storeMethodItem = new HashMap<String,Object>();

			storeMethodItem.put("DSMNO",sm.getDSMNo());
			storeMethodItem.put("DNO",sm.getDNo());
			storeMethodItem.put("DOCNO",sm.getDocNo());
			storeMethodItem.put("DOCVERSION",sm.getDocVersion());
			
			storeMethodItem.put("METHODNAME",sm.getMethodName());
			storeMethodItem.put("METHODEXPLAIN",sm.getMethodExplain());
			
			storeMethodItem.put("REGDATE",sm.getRegDate());
			storeMethodItem.put("REGUSERID",sm.getRegUserId());
			storeMethodItem.put("MODDATE",sm.getModDate());
			storeMethodItem.put("MODUSERID",sm.getModUserId());
			storeMethodItem.put("ETC",sm.getEtc());
			
			sb.append(JSONObject.toJSONString(storeMethodItem));
		}
		sb.append("]");
		return sb.toString();	}
}
