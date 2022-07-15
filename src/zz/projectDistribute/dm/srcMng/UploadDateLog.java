package zz.projectDistribute.dm.srcMng;

import java.io.File;
import java.util.Calendar;
import java.util.Date;

import zz.projectDistribute.config.Config;
import zz.projectDistribute.util.StoredMap;
import zz.projectDistribute.util.eclipse.ProjectFile;

public class UploadDateLog{

	static final private StoredMap storedMap;
	static {
		// 최근 100일 내용만 남김 
		storedMap = new StoredMap(Config.MYWEB_LOG_PRE_PATH+"uploadDate.log");
		Calendar c = Calendar.getInstance();
		c.add(Calendar.DATE,-100);
		long limitTime = c.getTime().getTime();
		for(Object key : storedMap.keySet().toArray()){
			long time = Long.parseLong((String)storedMap.get((String)key));
			if(time < limitTime) {
				System.out.println("UploadDateLog remove : " + storedMap.remove((String)key));
			}
		}
		storedMap.store();
	}
	
	static public Object getDate(ProjectFile projectFile) {
		return storedMap.get(projectFile.getPath());
	}
	
	static public Object getDate(File file) {
		return storedMap.get(file.getPath().substring(Config.LOCAL_PROJECT_PRE_PATH.length()).replaceAll("\\\\","/"));
	}
	
	static public void put(String path) {
		storedMap.put(path,new Date().getTime());
		storedMap.store();
	}
}
