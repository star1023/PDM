package kr.co.aspn.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.BatchDao;
import kr.co.aspn.service.BatchService;

@Service
public class BatchServiceImpl implements BatchService {

	@Autowired 
	BatchDao batchDao;
	
	@Override
	public List<Map<String, String>> getStroage(String companyCode) throws Exception {
		// TODO Auto-generated method stub
		return batchDao.getStroage( companyCode );
	}

	@Override
	public int setStroage(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return batchDao.setStroage(map);
	}

	@Override
	public List<Map<String, String>> getLine(String companyCode) throws Exception {
		// TODO Auto-generated method stub
		return batchDao.getLine( companyCode );
	}

	@Override
	public List<Map<String, String>> getVendor(String companyCode, String startDate, String endDate) throws Exception {
		// TODO Auto-generated method stub
		return batchDao.getVendor( companyCode, startDate, endDate );
	}

	@Override
	public List<Map<String, String>> getMaterial(String companyCode, String startDate, String endDate)
			throws Exception {
		// TODO Auto-generated method stub
		return batchDao.getMaterial( companyCode, startDate, endDate );
	}

	@Override
	public int setLine(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return  batchDao.setLine(map);
	}

	@Override
	public int setVendor(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return  batchDao.setVendor(map);
	}

	@Override
	public int setMaterial(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return batchDao.setMaterial(map);
	}

	@Override
	public void insertBatchLog(Map<String, String> logMap) throws Exception {
		// TODO Auto-generated method stub
		batchDao.insertBatchLog(logMap);
	}

	@Override
	public List<Map<String, String>> getMaterialSample() throws Exception {
		// TODO Auto-generated method stub
		return batchDao.getMaterialSample();
	}

	@Override
	public int deleteMaterialSample() throws Exception {
		// TODO Auto-generated method stub
		return batchDao.deleteMaterialSample();
	}

	@Override
	public List<Map<String, String>> getStroage2(String companyCode) throws Exception {
		// TODO Auto-generated method stub
		return batchDao.getStroage2( companyCode );
	}

	@Override
	public List<Map<String, String>> sellingMasterData() throws Exception {
		// TODO Auto-generated method stub
		return batchDao.sellingMasterData();
	}

	@Override
	public List<Map<String, String>> sellingData(String date, List<Map<String, String>> sellingMasterData) throws Exception {
		// TODO Auto-generated method stub
		return batchDao.sellingData(date, sellingMasterData);
	}

	@Override
	public void updateProductName(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		batchDao.updateProductName(map);
	}
	
	@Override
	public void batchUserLock() {
		batchDao.batchUserLock();
	}
}
