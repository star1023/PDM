package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;

import kr.co.aspn.common.jco.LabDestDataProvider;
import kr.co.aspn.common.jco.LabRfcManager;
import kr.co.aspn.dao.BatchDao;
import kr.co.aspn.schedule.SllabSchedule;
import kr.co.aspn.util.StringUtil;

@Repository
public class BatchDaoImpl implements BatchDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	private Logger logger = LoggerFactory.getLogger(BatchDaoImpl.class);
	
	@Override
	public List<Map<String, String>> getStroage(String companyCode) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			/*LabDestDataProvider provider = new LabDestDataProvider();
			logger.error("companyCode {} "+companyCode);
			logger.error("provider {} "+provider);
			JCoDestination dest = provider.getMyDestination(companyCode.toLowerCase());
			logger.error("dest {} "+dest);
			logger.error("dest.getDestinationName() {} "+dest.getDestinationName());
			LabRfcManager rfcManager = new LabRfcManager();
			logger.error("rfcManager {} "+rfcManager);
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_LGORT_RFC");*/
			LabDestDataProvider provider = new LabDestDataProvider();
			JCoDestination dest = provider.getMyDestination(companyCode.toLowerCase());
			dest.ping();
			LabRfcManager rfcManager = new LabRfcManager();
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_ARBPL_RFC");
			HashMap<String, String> importParams = new HashMap<String, String>();
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function,importParams);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");
			returnList = tableData.get("IT_LGORT");
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}

	@Override
	public int setStroage(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("batch.setStroage",map);
	}

	@Override
	public List<Map<String, String>> getLine(String companyCode) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			LabDestDataProvider provider = new LabDestDataProvider();
			JCoDestination dest = provider.getMyDestination(companyCode.toLowerCase());
			//JCoDestination dest = provider.getMyDestination("sl");
			LabRfcManager rfcManager = new LabRfcManager();
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_ARBPL_RFC");
			HashMap<String, String> importParams = new HashMap<String, String>();
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function,importParams);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");
			returnList = tableData.get("IT_MAT");
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}

	@Override
	public List<Map<String, String>> getVendor(String companyCode, String startDate, String endDate) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			LabDestDataProvider provider = new LabDestDataProvider();
			JCoDestination dest = provider.getMyDestination(companyCode.toLowerCase());
			LabRfcManager rfcManager = new LabRfcManager();
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_INFO_RFC");
			HashMap<String, String> importParams = new HashMap<String, String>();
			importParams.put("S_DATE", startDate);
			importParams.put("E_DATE", endDate);
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function,importParams);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");
			returnList = tableData.get("I_ITAB");
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}

	@Override
	public List<Map<String, String>> getMaterial(String companyCode, String startDate, String endDate)
			throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			LabDestDataProvider provider = new LabDestDataProvider();
			JCoDestination dest = provider.getMyDestination(companyCode.toLowerCase());
			LabRfcManager rfcManager = new LabRfcManager();
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_MAT_RFC");
			
			HashMap<String, String> importParams = new HashMap<String, String>();
			importParams.put("FDATE", startDate);
			importParams.put("LDATE", endDate);
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function,importParams);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");
			returnList = tableData.get("IT_MAT");
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}

	@Override
	public int setLine(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("batch.setLine",map);
	}

	@Override
	public int setVendor(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("batch.setVendor",map);
	}

	@Override
	public int setMaterial(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("batch.setMaterial",map);
	}

	@Override
	public void insertBatchLog(Map<String, String> logMap) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("batch.insertBatchLog",logMap);
	}

	@Override
	public List<Map<String, String>> getMaterialSample() throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("batch.materialSample");
	}

	@Override
	public int deleteMaterialSample() throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.delete("batch.deleteMaterialSample");
	}

	@Override
	public List<Map<String, String>> getStroage2(String companyCode) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			LabDestDataProvider provider = new LabDestDataProvider();
			JCoDestination dest = provider.getMyDestination(companyCode.toLowerCase());
			LabRfcManager rfcManager = new LabRfcManager();
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_LGORT_RFC");
			
			HashMap<String, String> importParams = new HashMap<String, String>();
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function,importParams);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");
			returnList = tableData.get("IT_LGORT");
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}

	@Override
	public List<Map<String, String>> sellingMasterData() throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("batch.sellingMasterData");
	}

	@Override
	public List<Map<String, String>> sellingData(String date, List<Map<String, String>> sellingMasterData) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			String year = date.substring(0,4);
			LabDestDataProvider provider = new LabDestDataProvider();
			JCoDestination dest = provider.getMyDestination("sl");
			LabRfcManager rfcManager = new LabRfcManager();
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "Y_MATNR_MM_MECHUL");
			
			
			function.getImportParameterList().setValue("I_DATE", date);
			JCoTable importTable = function.getTableParameterList().getTable("I_MATNR");
			
			importTable.appendRows(sellingMasterData.size());
			for( int i = 0 ; i < sellingMasterData.size() ; i++ ) {
				Map<String, String> sellingData = sellingMasterData.get(i);
				if( i != 0 ) {
					importTable.nextRow();
				}
				importTable.setValue("MATNR1", sellingData.get("erpProductCode"));
			}
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");			
			returnList = tableData.get("M_DATA");
			for( int i = 0 ; i < returnList.size() ; i++ ) {
				/*Map<String, String> returnData = returnList.get(i);
				System.err.println("WERKS : "+returnData.get("WERKS"));
				System.err.println("MATNR : "+returnData.get("MATNR"));
				System.err.println("MAKTX : "+returnData.get("MAKTX"));
				System.err.println("AMT_01 : "+returnData.get("AMT_01"));
				System.err.println("AMT_02 : "+returnData.get("AMT_02"));
				System.err.println("AMT_03 : "+returnData.get("AMT_03"));
				System.err.println("AMT_04 : "+returnData.get("AMT_04"));
				System.err.println("AMT_05 : "+returnData.get("AMT_05"));
				System.err.println("AMT_06 : "+returnData.get("AMT_06"));
				System.err.println("AMT_07 : "+returnData.get("AMT_07"));
				System.err.println("AMT_08 : "+returnData.get("AMT_08"));
				System.err.println("AMT_09 : "+returnData.get("AMT_09"));
				System.err.println("AMT_10 : "+returnData.get("AMT_10"));
				System.err.println("AMT_11 : "+returnData.get("AMT_11"));
				System.err.println("AMT_12 : "+returnData.get("AMT_12"));*/
				Map<String, String> returnData = returnList.get(i);
				List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();
				
				String MATNR = StringUtil.delZero(returnData.get("MATNR"));
				int master_seq = sqlSessionTemplate.selectOne("batch.masterSeq",MATNR);
				for( int j = 1 ; j <= 12 ; j++ ) {
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("master_seq",master_seq);
					param.put("year",year);
					param.put("month",StringUtil.n2c(j));
					double selling = 0;
					try {
						selling = Double.parseDouble(returnData.get("AMT_"+StringUtil.n2c(j)));
					} catch( Exception e ) {
						selling = 0;
					}
					param.put("selling",selling);
					paramList.add(param);
				}
				
				sqlSessionTemplate.insert("batch.insertSellingData",paramList);
			}
			
			
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}

	@Override
	public void updateProductName(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("batch.updateProductName", map);
	}
	
	@Override
	public void batchUserLock() {
		sqlSessionTemplate.update("batch.batchUserLock");
	}
}
