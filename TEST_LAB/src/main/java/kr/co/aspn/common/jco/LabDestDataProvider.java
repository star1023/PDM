package kr.co.aspn.common.jco;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;

import org.springframework.core.io.DefaultResourceLoader;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.ext.DataProviderException;
import com.sap.conn.jco.ext.DestinationDataEventListener;
import com.sap.conn.jco.ext.DestinationDataProvider;

public class LabDestDataProvider implements DestinationDataProvider {
	DefaultResourceLoader defaultResourceLoader = new DefaultResourceLoader();

	/* 기본 JCo 커넥션 정보 저장객체 */
	private HashMap<String, Properties> secureDBStorage = new HashMap<String, Properties>();
	private DestinationDataEventListener el;
	
	private JCoDestination destination = null;

	/* JCo 커넥션별 네이밍에 따른 텍스트 저장 */
	public String[] destNames = null;

	public Properties getDestinationProperties(String destName) {
		// CompanyName => destName
		String destName_lowerCase = destName.toLowerCase();
		try {
			// read the destination from DB
			Properties p = secureDBStorage.get(destName_lowerCase);

			if (p != null) {
				// check if all is correct, for example
				if (p.isEmpty())
					throw new DataProviderException(DataProviderException.Reason.INVALID_CONFIGURATION,
							"destination configuration is incorrect", null);
				return p;
			}
			return null;
		} catch (RuntimeException re) {
			throw new DataProviderException(DataProviderException.Reason.INTERNAL_ERROR, re);
		}
	}

	public boolean supportsEvents() {
		return true;
	}

	public void setDestinationDataEventListener(DestinationDataEventListener eventListener) {
		this.el = eventListener;
	}

	/* 해당 클래스의 인스턴스 초기화 시 각 JCoConnection을 설정하고 ping 테스트 진행 */
	public LabDestDataProvider() {
		try {
			if (!com.sap.conn.jco.ext.Environment.isDestinationDataProviderRegistered()) {
				com.sap.conn.jco.ext.Environment.registerDestinationDataProvider(this);
				this.setDestinationProperty();
			}
		} catch (IllegalStateException providerAlreadyRegisteredException) {
			/* SapJCo3의 경우 provider 를 runtime 당 1개만 등록이 가능하여 추가 등록 시 에러가 발생 */
			throw new Error(providerAlreadyRegisteredException);
		}
	}

	/* 기본설정된 properties 파일의 커넥션 정보 셋팅 및 ping 테스트 */
	private void setDestinationProperty() {
		String ahost = DestinationDataProvider.JCO_ASHOST;
		String r3name = DestinationDataProvider.JCO_R3NAME;
		String sysrn = DestinationDataProvider.JCO_SYSNR;
		String client = DestinationDataProvider.JCO_CLIENT;
		String lang = DestinationDataProvider.JCO_LANG;
		String user = DestinationDataProvider.JCO_USER;
		String passwd = DestinationDataProvider.JCO_PASSWD;
		String peak_limit = DestinationDataProvider.JCO_PEAK_LIMIT;
		String pool_capacity = DestinationDataProvider.JCO_POOL_CAPACITY;
		
		Properties sapConnectionInfo = new Properties();
		
		try {
			// TODO 경로에 대한 설정 필요
			String path = defaultResourceLoader.getResource("prop/sap_connection.properties").getURI().getPath();
			System.out.println(path);
			sapConnectionInfo.load(new FileInputStream(path));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		/*
		*  각 회사코드를 설정된 properties key 중 가장 앞글자를 기준으로 셋팅
		*  여러개의 property가 존재해도 중복은 허용하지 않으므로 1개의 회사로 처리
		*  ex) sl.jco.client = 'xxx'    =>   destName = sl
		*/
		Iterator<String> propIteratror = sapConnectionInfo.stringPropertyNames().iterator();
		HashSet<String> keySet = new HashSet<String>(); 
		while(propIteratror.hasNext()){
			String key = propIteratror.next();
			String companyCode = key.split("\\.")[0];
			keySet.add(companyCode);
		}
		
		if(destNames == null){
			destNames = new String[keySet.size()];
			int index = 0;
			for (String string : keySet) {
				destNames[index] = string;
				index++;
			}
		}

		for (String destnationName : destNames) {
			Properties props = new Properties();

			props.setProperty(ahost, sapConnectionInfo.getProperty(destnationName + "." + ahost));
			props.setProperty(r3name, sapConnectionInfo.getProperty(destnationName + "." + r3name));
			props.setProperty(sysrn, sapConnectionInfo.getProperty(destnationName + "." + sysrn));
			props.setProperty(client, sapConnectionInfo.getProperty(destnationName + "." + client));
			props.setProperty(lang, sapConnectionInfo.getProperty(destnationName + "." + lang));
			props.setProperty(user, sapConnectionInfo.getProperty(destnationName + "." + user));
			props.setProperty(passwd, sapConnectionInfo.getProperty(destnationName + "." + passwd));
			props.setProperty(peak_limit, sapConnectionInfo.getProperty(destnationName + "." + peak_limit));
			props.setProperty(pool_capacity, sapConnectionInfo.getProperty(destnationName + "." + pool_capacity));

			secureDBStorage.put(destnationName, props);
		}

		for (String destnationName : destNames) {
			getMyDestination(destnationName);
		}
		
		if(destNames != null) {
			if(Arrays.asList(destNames).contains("sl")){
				setLabDestination("sl");
			} else {
				//setLabDestination(destNames[0]);
			}
			
		}
	}

	public JCoDestination getMyDestination(String destName) {
		JCoDestination dest;
		
		try {
			dest = JCoDestinationManager.getDestination(destName);
			dest.ping();
			System.err.println("Destination " + destName + " works");
			return dest;
		} catch (JCoException e) {
			e.printStackTrace();
			System.err.println("Execution on destination " + destName + " failed");
			return null;
		}
	}
	
	/* 이미 등록된 Destination 중 원하는 연결로 Destination을 설정 */
	public void setLabDestination(String destName) {
		
		System.out.println("destName parmameter is : " + destName + "(" + Arrays.asList(destNames).toString() + ")");
		System.out.println("Arrays.asList(destNames).contains(destName): " + Arrays.asList(destNames).contains(destName.toLowerCase()));
		if (Arrays.asList(destNames).contains(destName.toLowerCase())) {
			el.updated(destName);
			try {
				destination = JCoDestinationManager.getDestination(destName);
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			System.out.println("setDestName is set : " + destination.getDestinationName());
		} else {

		}

	}
	
	/* 함수 호출을 위한 JCoDestination return 메소드 */
	public JCoDestination getLabDestnation(){
		try {
			return JCoDestinationManager.getDestination(destination.getDestinationName());
		} catch (JCoException e) {
			e.printStackTrace();
			System.out.println("Execution on destination " + destination.getDestinationName() + " failed");
			return null;
		}
	}
	
	public String getDestinationName(){
		return destination.getDestinationName();
	}
}